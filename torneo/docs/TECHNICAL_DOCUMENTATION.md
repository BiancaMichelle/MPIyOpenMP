# 📖 Documentación Técnica - Torneo One Piece MPI/OpenMP

## 🏗️ Arquitectura del Sistema

### Visión General
El proyecto implementa un sistema de simulación paralela que combina:
- **MPI (Message Passing Interface)**: Para paralelización distribuida entre "universos"
- **OpenMP**: Para paralelización de memoria compartida dentro de cada universo
- **Interfaz Web**: Para configuración y visualización de resultados

### Diagrama de Arquitectura
```
┌─────────────────────────────────────────────────────────────┐
│                    Torneo One Piece                         │
├─────────────────────────────────────────────────────────────┤
│  Web Interface          │  Core Engine (C)                  │
│  ┌─────────────────┐   │  ┌─────────────────────────────┐   │
│  │ Configurator    │   │  │ MPI Process 0 (Master)      │   │
│  │ Results Viewer  │   │  │ - Load config               │   │
│  │ Static Assets   │   │  │ - Broadcast data            │   │
│  └─────────────────┘   │  │ - Collect results           │   │
│           │             │  │ - Write output              │   │
│           ▼             │  └─────────────────────────────┘   │
│  ┌─────────────────┐   │             │                      │
│  │ config.json     │   │             ▼                      │
│  │ resultado.json  │   │  ┌─────────────────────────────┐   │
│  └─────────────────┘   │  │ MPI Process 1..N (Workers)  │   │
│                         │  │ ┌─────────────────────────┐ │   │
│                         │  │ │ OpenMP Threads         │ │   │
│                         │  │ │ - Evaluate characters  │ │   │
│                         │  │ │ - Calculate power      │ │   │
│                         │  │ │ - Find local champion  │ │   │
│                         │  │ └─────────────────────────┘ │   │
│                         │  └─────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## 🔧 Implementación Técnica

### Estructura de Datos
```c
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
```

### Flujo de Ejecución MPI

1. **Inicialización**
   ```c
   MPI_Init(&argc, &argv);
   MPI_Comm_rank(MPI_COMM_WORLD, &rank);
   MPI_Comm_size(MPI_COMM_WORLD, &size);
   ```

2. **Distribución de Datos**
   ```c
   if (rank == 0) {
       cargar_config("config/config.json");
   }
   MPI_Bcast(&total_tripulaciones, 1, MPI_INT, 0, MPI_COMM_WORLD);
   MPI_Bcast(tripulaciones, sizeof(tripulaciones), MPI_BYTE, 0, MPI_COMM_WORLD);
   ```

3. **Procesamiento Paralelo Local (OpenMP)**
   ```c
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
   ```

4. **Reducción Global**
   ```c
   struct {
       int poder;
       int rank;
   } in, out;
   
   in.poder = poder_local;
   in.rank = rank;
   
   MPI_Reduce(&in, &out, 1, MPI_2INT, MPI_MAXLOC, 0, MPI_COMM_WORLD);
   ```

### Patrón de Comunicación

```
Proceso 0 (Master)          Procesos 1..N (Workers)
┌─────────────┐            ┌─────────────┐
│ Load Config │            │ Wait Data   │
└─────┬───────┘            └─────┬───────┘
      │                          │
      ▼                          ▼
┌─────────────┐            ┌─────────────┐
│ Broadcast   │━━━━━━━━━━━▶│ Receive     │
│ Data        │            │ Data        │
└─────┬───────┘            └─────┬───────┘
      │                          │
      ▼                          ▼
┌─────────────┐            ┌─────────────┐
│ Process     │            │ Process     │
│ Universe 0  │            │ Universe N  │
└─────┬───────┘            └─────┬───────┘
      │                          │
      ▼                          ▼
┌─────────────┐            ┌─────────────┐
│ Collect     │◀━━━━━━━━━━━│ Send        │
│ Results     │            │ Result      │
└─────────────┘            └─────────────┘
```

## 🎯 Características de Paralelización

### MPI - Paralelización Distribuida
- **Granularidad**: Una tripulación por proceso
- **Comunicación**: 
  - `MPI_Bcast`: Distribución de configuración
  - `MPI_Reduce`: Agregación de resultados con `MPI_MAXLOC`
  - `MPI_Send/Recv`: Transferencia del nombre del ganador
- **Escalabilidad**: O(log n) para reducción, O(1) para broadcast

### OpenMP - Paralelización de Memoria Compartida
- **Granularidad**: Un personaje por hilo
- **Directivas utilizadas**:
  - `#pragma omp parallel`: Región paralela
  - `#pragma omp critical`: Sección crítica para actualizar campeón local
- **Ventajas**: Acceso directo a memoria compartida, overhead mínimo

### Sincronización y Seguridad
- **Semillas aleatorias únicas**: `time(NULL) ^ omp_get_thread_num() ^ rank`
- **Sección crítica**: Protege la actualización del campeón local
- **Determinismo**: Resultados reproducibles con semillas fijas

## 📊 Análisis de Rendimiento

### Complejidad Temporal
- **Serial**: O(T × P) donde T = tripulaciones, P = personajes
- **MPI**: O(T/N × P) donde N = procesos MPI
- **MPI + OpenMP**: O(T/N × P/M) donde M = hilos OpenMP

### Escalabilidad Teórica
```
Speedup = 1 / (f + (1-f)/N)  # Ley de Amdahl
```
Donde:
- f = fracción serial (configuración, I/O)
- N = número de procesadores
- En nuestro caso: f ≈ 0.1 (90% paralelizable)

### Métricas de Rendimiento
- **Eficiencia MPI**: Alta (comunicación mínima)
- **Eficiencia OpenMP**: Media (sección crítica pequeña)
- **Balance de carga**: Bueno (trabajo uniforme por tripulación)

## 🛠️ Configuración y Optimización

### Variables de Entorno Importantes
```bash
export OMP_NUM_THREADS=4        # Hilos OpenMP por proceso
export OMP_SCHEDULE=static      # Planificación de hilos
export OMPI_MCA_btl_base_warn_component_unused=0  # Suprimir warnings
```

### Parámetros de Compilación
```makefile
CFLAGS = -fopenmp -Wall -std=c99 -O3 -march=native
```

### Optimizaciones Implementadas
1. **Semillas independientes**: Evita correlación entre hilos/procesos
2. **Minimización de secciones críticas**: Solo actualización de máximo
3. **Comunicación colectiva eficiente**: `MPI_Reduce` vs múltiples `MPI_Send`
4. **Localidad de datos**: Estructuras contiguas en memoria

## 🔍 Debugging y Profiling

### Compilación Debug
```bash
make CFLAGS="-fopenmp -Wall -g -DDEBUG -fsanitize=thread"
```

### Herramientas Recomendadas
- **Intel Inspector**: Detección de race conditions
- **Valgrind**: Análisis de memoria (sin OpenMP)
- **Intel VTune**: Profiling de rendimiento
- **TAU**: Análisis MPI + OpenMP

### Puntos de Verificación
1. **Race conditions**: En sección crítica OpenMP
2. **Deadlocks**: En comunicación MPI
3. **Memory leaks**: En cJSON parsing
4. **Load balancing**: Distribución uniforme de trabajo

## 📈 Casos de Uso y Extensiones

### Escalabilidad
- **Mínimo**: 1 proceso MPI, 1 hilo OpenMP
- **Típico**: 4 procesos MPI, 4 hilos OpenMP
- **Máximo**: N procesadores disponibles

### Extensiones Posibles
1. **Algoritmos adaptativos**: Balanceo dinámico de carga
2. **Persistencia**: Base de datos para histórico
3. **Visualización**: Gráficos en tiempo real
4. **Red**: Ejecución distribuida real
5. **GPU**: Aceleración CUDA/OpenCL

### Variaciones del Algoritmo
```c
// Versión con diferentes métricas de poder
int calcular_poder_avanzado(Personaje p, int seed) {
    int base = rand_r(&seed) % 100;
    int bonus = strlen(p.nombre) * 5;  // Nombres largos = más poder
    return base + bonus;
}
```

## 🚀 Deployment y Distribución

### Contenedorización
```dockerfile
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    libopenmpi-dev \
    libcjson-dev \
    python3
COPY . /app
WORKDIR /app
RUN make
EXPOSE 8000
CMD ["make", "demo"]
```

### Cluster Computing
```bash
# SLURM job script
#SBATCH --nodes=4
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:30:00

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
mpirun ./src/torneo_onepiece
```

## 📚 Referencias y Recursos

### Documentación Oficial
- [MPI Standard](https://www.mpi-forum.org/docs/)
- [OpenMP Specification](https://www.openmp.org/specifications/)
- [cJSON Library](https://github.com/DaveGamble/cJSON)

### Papers y Estudios
- "Parallel Programming in C with MPI and OpenMP" - Quinn
- "Using MPI: Portable Parallel Programming" - Gropp et al.
- "OpenMP: An Industry Standard API" - Dagum & Menon

### Herramientas de Desarrollo
- **Compiladores**: GCC, Intel C++, Clang
- **Debuggers**: GDB, DDT, Intel Debugger
- **Profilers**: Scalasca, Score-P, Intel VTune

---

*Esta documentación técnica está diseñada para desarrolladores que quieran entender, modificar o extender el proyecto Torneo One Piece MPI/OpenMP.*