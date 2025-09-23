#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <mpi.h>
#include <omp.h>
#include <cjson/cJSON.h>  // Usar librería cJSON del sistema

#define MAX 100

typedef struct {
    char nombre[50];
    int activo;
} Personaje;

typedef struct {
    char tripulacion[50];
    Personaje personajes[10];
    int num_personajes;
    int activo;
} Tripulacion;

Tripulacion tripulaciones[MAX];
int total_tripulaciones = 0;

void cargar_config(const char* filename) {
    FILE* f = fopen(filename, "r");
    if (!f) { printf("No se encontró %s\n", filename); exit(1); }
    fseek(f, 0, SEEK_END);
    long len = ftell(f);
    fseek(f, 0, SEEK_SET);
    char* data = malloc(len + 1);
    fread(data, 1, len, f);
    data[len] = '\0';
    fclose(f);

    cJSON* root = cJSON_Parse(data);
    cJSON* trips = cJSON_GetObjectItem(root, "tripulaciones");
    total_tripulaciones = cJSON_GetArraySize(trips);

    for (int i = 0; i < total_tripulaciones; i++) {
        cJSON* t = cJSON_GetArrayItem(trips, i);
        strcpy(tripulaciones[i].tripulacion, cJSON_GetObjectItem(t, "nombre")->valuestring);
        tripulaciones[i].activo = cJSON_GetObjectItem(t, "activo")->valueint;

        cJSON* pers = cJSON_GetObjectItem(t, "personajes");
        int num = cJSON_GetArraySize(pers);
        tripulaciones[i].num_personajes = num;
        for (int j = 0; j < num; j++) {
            cJSON* p = cJSON_GetArrayItem(pers, j);
            strcpy(tripulaciones[i].personajes[j].nombre, cJSON_GetObjectItem(p, "nombre")->valuestring);
            tripulaciones[i].personajes[j].activo = cJSON_GetObjectItem(p, "activo")->valueint;
        }
    }
    cJSON_Delete(root);
    free(data);
}

int main(int argc, char* argv[]) {
    int rank, size;
    int ganador_local = -1, poder_local = -1;
    char nombre_local[50];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    srand(time(NULL) + rank);

    if (rank == 0) {
        cargar_config("config/config.json");
    }
    MPI_Bcast(&total_tripulaciones, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(tripulaciones, sizeof(tripulaciones), MPI_BYTE, 0, MPI_COMM_WORLD);

    if (rank < total_tripulaciones && tripulaciones[rank].activo) {
        Tripulacion t = tripulaciones[rank];
        #pragma omp parallel
        {
            unsigned int seed = time(NULL) ^ omp_get_thread_num() ^ rank;
            for (int j = 0; j < t.num_personajes; j++) {
                if (t.personajes[j].activo) {
                    int poder = rand_r(&seed) % 100;
                    #pragma omp critical
                    {
                        if (poder > poder_local) {
                            poder_local = poder;
                            ganador_local = j;
                            strcpy(nombre_local, t.personajes[j].nombre);
                        }
                    }
                }
            }
        }
        printf("🏴‍☠️ %s en Universo %d → Ganador local: %s con poder %d\n",
               t.tripulacion, rank, nombre_local, poder_local);
    }

    struct {
        int poder;
        int rank;
    } in, out;

    in.poder = poder_local;
    in.rank = rank;

    MPI_Reduce(&in, &out, 1, MPI_2INT, MPI_MAXLOC, 0, MPI_COMM_WORLD);

    if (rank == out.rank) {
        MPI_Send(nombre_local, 50, MPI_CHAR, 0, 0, MPI_COMM_WORLD);
    }

    if (rank == 0) {
        char nombre_ganador[50];
        MPI_Recv(nombre_ganador, 50, MPI_CHAR, out.rank, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        FILE* f = fopen("output/resultado.json", "w");
        fprintf(f, "{\n");
        fprintf(f, "  \"campeon\": {\n");
        fprintf(f, "    \"universo\": %d,\n", out.rank);
        fprintf(f, "    \"pirata\": \"%s\",\n", nombre_ganador);
        fprintf(f, "    \"poder\": %d\n", out.poder);
        fprintf(f, "  }\n}\n");
        fclose(f);
        printf("✅ Campeón global: %s (poder %d)\n", nombre_ganador, out.poder);
    }

    MPI_Finalize();
    return 0;
}
