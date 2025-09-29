/*
 * TORNEO ONE PIECE - SIMULADOR MPI/OpenMP
 * 
 * ARQUITECTURA HÍBRIDA:
 * - MPI: Maneja la distribución de tripulaciones entre procesos (paralelismo distribuido)
 * - OpenMP: Maneja los combates dentro de cada tripulación (paralelismo compartido)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <mpi.h>    // *** MPI: Para comunicación entre procesos distribuidos ***
#include <omp.h>    // *** OpenMP: Para paralelización en memoria compartida ***
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

/*
 * FUNCIÓN SECUENCIAL: Carga configuración desde JSON
 * Solo la ejecuta el proceso maestro (rank 0) para evitar acceso concurrente al archivo
 */
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
    // *** VARIABLES PARA MPI: Control de procesos distribuidos ***
    int rank, size;           // rank = ID del proceso, size = total de procesos
    int ganador_local = -1, poder_local = -1;
    char nombre_local[50];

    // *** INICIALIZACIÓN MPI: Configurar el entorno de comunicación distribuida ***
    MPI_Init(&argc, &argv);                    // Inicializar MPI
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);     // Obtener ID de este proceso
    MPI_Comm_size(MPI_COMM_WORLD, &size);     // Obtener número total de procesos

    srand(time(NULL) + rank);  // Semilla única por proceso

    // *** MPI BROADCAST: El proceso maestro (rank 0) lee y distribuye datos ***
    if (rank == 0) {
        cargar_config("config/config.json");  // Solo el maestro lee el archivo
    }
    // Enviar datos a todos los procesos (comunicación colectiva MPI)
    MPI_Bcast(&total_tripulaciones, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(tripulaciones, sizeof(tripulaciones), MPI_BYTE, 0, MPI_COMM_WORLD);

    // *** DISTRIBUCIÓN MPI: Cada proceso maneja una tripulación diferente ***
    // Proceso 0 = Tripulación 0, Proceso 1 = Tripulación 1, etc.
    if (rank < total_tripulaciones && tripulaciones[rank].activo) {
        Tripulacion t = tripulaciones[rank];
        
        // *** INICIO OPENMP: Paralelización de combates dentro de la tripulación ***
        // Cada hilo OpenMP simula combates de diferentes personajes simultáneamente
        #pragma omp parallel
        {
            // Semilla única por hilo OpenMP (evita resultados idénticos)
            unsigned int seed = time(NULL) ^ omp_get_thread_num() ^ rank;
            
            // *** LOOP PARALELO: Cada personaje combate en paralelo ***
            for (int j = 0; j < t.num_personajes; j++) {
                if (t.personajes[j].activo) {
                    int poder = rand_r(&seed) % 100;  // Simular combate
                    
                    // *** SECCIÓN CRÍTICA OpenMP: Actualizar ganador thread-safe ***
                    // Solo un hilo puede modificar las variables compartidas a la vez
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
        } // *** FIN OpenMP: Sincronización implícita de todos los hilos ***
        
        printf("🏴‍☠️ %s en Proceso MPI %d → Ganador local: %s con poder %d\n",
               t.tripulacion, rank, nombre_local, poder_local);
    }

    // *** ESTRUCTURA PARA MPI_REDUCE: Combinar datos de todos los procesos ***
    struct {
        int poder;   // Valor a comparar
        int rank;    // Identificador del proceso
    } in, out;

    in.poder = poder_local;  // Poder del ganador local de este proceso
    in.rank = rank;          // ID de este proceso

    // *** MPI_REDUCE: Operación colectiva para encontrar el máximo global ***
    // Combina resultados de todos los procesos y encuentra el ganador absoluto
    // MPI_MAXLOC: Encuentra el valor máximo y el proceso que lo tiene
    MPI_Reduce(&in, &out, 1, MPI_2INT, MPI_MAXLOC, 0, MPI_COMM_WORLD);

    // *** COMUNICACIÓN PUNTO A PUNTO MPI ***
    // El proceso ganador envía el nombre del campeón al proceso maestro
    if (rank == out.rank) {
        MPI_Send(nombre_local, 50, MPI_CHAR, 0, 0, MPI_COMM_WORLD);
    }

    // *** PROCESO MAESTRO: Recibe resultado y genera salida ***
    if (rank == 0) {
        char nombre_ganador[50];
        MPI_Recv(nombre_ganador, 50, MPI_CHAR, out.rank, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        
        // Generar archivo de resultados
        FILE* f = fopen("output/resultado.json", "w");
        fprintf(f, "{\n");
        fprintf(f, "  \"campeon\": {\n");
        fprintf(f, "    \"proceso_mpi\": %d,\n", out.rank);
        fprintf(f, "    \"pirata\": \"%s\",\n", nombre_ganador);
        fprintf(f, "    \"poder\": %d\n", out.poder);
        fprintf(f, "  }\n}\n");
        fclose(f);
        printf("✅ Campeón global: %s (poder %d)\n", nombre_ganador, out.poder);
    }

    // *** FINALIZACIÓN MPI: Limpiar recursos y sincronizar ***
    MPI_Finalize();
    return 0;
}

/*
 * ===============================================================================
 * RESUMEN DE LA ARQUITECTURA HÍBRIDA MPI/OpenMP:
 * ===============================================================================
 * 
 * 🔄 MPI (Message Passing Interface) - PARALELISMO DISTRIBUIDO:
 *   • Función: Distribuir tripulaciones entre diferentes procesos
 *   • Uso: Cada proceso MPI maneja UNA tripulación completa
 *   • Comunicación: Los procesos intercambian datos vía mensajes
 *   • Ventaja: Escalabilidad en múltiples máquinas/cores
 *   • Operaciones clave:
 *     - MPI_Bcast(): Distribuir configuración a todos los procesos
 *     - MPI_Reduce(): Combinar resultados locales en resultado global
 *     - MPI_Send/Recv(): Transferir el nombre del ganador
 * 
 * ⚡ OpenMP (Open Multi-Processing) - PARALELISMO COMPARTIDO:
 *   • Función: Paralelizar combates DENTRO de cada tripulación
 *   • Uso: Múltiples hilos simulan combates de personajes simultáneamente
 *   • Memoria: Todos los hilos comparten la misma memoria
 *   • Ventaja: Eficiencia en procesadores multi-core
 *   • Directivas clave:
 *     - #pragma omp parallel: Crear equipo de hilos
 *     - #pragma omp critical: Sección crítica thread-safe
 *     - omp_get_thread_num(): Identificador único por hilo
 * 
 * 🏗️ ARQUITECTURA FINAL:
 *   Proceso 0 (Mugiwaras)     Proceso 1 (Barbanegra)    Proceso N...
 *        |                         |                         |
 *   ┌────▼────┐               ┌────▼────┐               ┌────▼────┐
 *   │ Hilo 0  │               │ Hilo 0  │               │ Hilo 0  │
 *   │ Hilo 1  │ ← OpenMP →    │ Hilo 1  │ ← OpenMP →    │ Hilo 1  │ 
 *   │ Hilo N  │               │ Hilo N  │               │ Hilo N  │
 *   └────┬────┘               └────┬────┘               └────┬────┘
 *        │                         │                         │
 *        └─────────── MPI_Reduce ──┴─────────────────────────┘
 *                           |
 *                    🏆 CAMPEÓN GLOBAL
 * ===============================================================================
 */
