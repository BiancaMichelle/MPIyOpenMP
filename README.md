# 🏴‍☠️ Torneo One Piece - Simulador MPI/OpenMP

## 📑 Índice

### 🚀 Parte I: Guía de Usuario
- [Descripción y Características](#descripción)
- [Estructura del Proyecto](#estructura)
- [Inicio Rápido](#-inicio-rápido)
- [Cómo Usar la Aplicación](#-cómo-usar)
- [Comandos Disponibles](#-comandos-disponibles)
- [Ejemplo Completo de Uso](#-ejemplo-completo-de-uso)
- [Solución de Problemas](#-solución-de-problemas)
- [Características Técnicas](#-características-técnicas)

### 📚 Parte II: Informe Técnico
- [Conceptos Demostrados](#-conceptos-demostrados)
- [Teoría: MPI (Message Passing Interface)](#-teoría-mpi-message-passing-interface)
- [Teoría: OpenMP (Open Multi-Processing)](#-teoría-openmp-open-multi-processing)
- [Arquitectura Híbrida del Proyecto](#-arquitectura-híbrida-del-proyecto)
- [Análisis de Rendimiento](#-análisis-de-rendimiento)

---

## Descripción
Una **aplicación web interactiva** que demuestra conceptos de programación paralela a través de una simulación de torneo de personajes de One Piece. 

### ✨ Características:
- 🌐 **Interfaz Web Moderna**: Totalmente visual, sin comandos
- ⚡ **MPI**: Simulación de procesos distribuidos  
- 🔄 **OpenMP**: Simulación de memoria compartida
- 📱 **Responsive**: Funciona en móviles y escritorio
- 🎮 **Interactivo**: Selecciona tripulaciones y ve resultados en tiempo real

## Estructura
```
torneo/
├── web/
│   ├── templates/demo.html   # 🎮 Aplicación principal
│   ├── static/               # 🎨 Estilos y recursos
│   └── server.py            # 🌐 Servidor web simple
├── src/torneo_onepiece.c     # ⚙️ Motor de simulación C
├── config/config.json        # ⚙️ Configuración
└── Makefile                  # 🔧 Sistema de construcción
```

## 🚀 Inicio Rápido

### Para Windows

#### 1. Instalar WSL
```powershell
# En PowerShell como administrador
wsl --install -d Ubuntu-22.04
```

#### 2. Instalar Dependencias
```bash
# Entrar a WSL
wsl

# Navegar al proyecto
cd /mnt/c/Users/[TU_USUARIO]/Desktop/MPIyOpenMP/torneo

# Instalar dependencias
sudo apt update && sudo apt install -y libopenmpi-dev libcjson-dev python3 make gcc
```

#### 3. Compilar y Ejecutar
```bash
# Compilar motor de simulación
make compile

# Iniciar aplicación web
make web
```

#### 4. Usar la Aplicación
Abre tu navegador en: **http://localhost:8000/templates/demo.html**
(o el enlace que te salga por consola)

## 🎮 Cómo Usar

1. **Seleccionar Tripulaciones**: Haz clic en las tarjetas de tripulaciones
2. **Configurar Torneo**: Elige las tripulaciones que participarán  
3. **Iniciar Simulación**: Presiona "Iniciar Simulación"
4. **Ver Resultados**: Los resultados aparecen en un modal

## 🔧 Comandos Disponibles

| Comando | Descripción |
|---------|-------------|
| `make compile` | Compila el motor de simulación |
| `make web` | Inicia la aplicación web |
| `make run` | Ejecuta simulación en terminal |
| `make clean` | Limpia archivos compilados |
| `make help` | Muestra ayuda |

## ⚡ Conceptos Demostrados

### MPI (Message Passing Interface)
- **Procesos Distribuidos**: Cada tripulación se simula en un proceso independiente
- **Comunicación**: Los procesos intercambian resultados para determinar el ganador

### OpenMP (Open Multi-Processing)  
- **Paralelización**: Los combates dentro de cada tripulación se procesan en paralelo
- **Memoria Compartida**: Los hilos trabajan sobre los mismos datos


## 📝 Ejemplo Completo de Uso

### Primera vez (instalación completa)
```bash
# 1. Desde PowerShell como administrador
wsl --install -d Ubuntu-22.04
# [Reiniciar computadora]

# 2. Abrir PowerShell normal y entrar a WSL
wsl

# 3. Navegar al proyecto
cd /mnt/c/Users/[TU_USUARIO]/Desktop/MPIyOpenMP/torneo

# 4. Instalar dependencias
sudo apt update && sudo apt install -y libopenmpi-dev libcjson-dev python3 make gcc

# 5. Compilar y ejecutar
make compile
make web
```

### Uso diario (ya instalado)
```bash
# 1. Abrir PowerShell y entrar a WSL
wsl

# 2. Ir al proyecto
cd /mnt/c/Users/[TU_USUARIO]/Desktop/MPIyOpenMP/torneo

# 3. Iniciar aplicación web
make web

# 4. Abrir navegador en: http://localhost:8000/templates/demo.html

# o colocar en un solo comando:
wsl -e bash -c "cd /mnt/c/Users/Usuario/Desktop/MPIyOpenMP/torneo && make web"
```

## 🔧 Solución de Problemas

### Error: "wsl: command not found"
```powershell
# En PowerShell como administrador:
wsl --install -d Ubuntu-22.04
```

### Error: "mpicc no encontrado"
```bash
sudo apt update
sudo apt install libopenmpi-dev openmpi-bin
```

### Error: "cJSON library not found"  
```bash
sudo apt install libcjson-dev
```

### Error: "make: command not found"
```bash
sudo apt install build-essential
```

### La aplicación web no carga
```bash
# Verificar que el servidor esté corriendo
make web

# O manualmente:
cd web && python3 -m http.server 8000
```

### Error: WSL no encuentra el directorio
```bash
# Verificar que estás en la ruta correcta, reemplazar "Usuario" por tu nombre:
ls /mnt/c/Users/Usuario/Desktop/MPIyOpenMP/

# Si no existe, verificar tu nombre de usuario en Windows:
ls /mnt/c/Users/
```

## 🌟 Características Técnicas

- **Frontend**: HTML5 + CSS3 + JavaScript ES6
- **Backend**: Python HTTP Server (simple)
- **Motor de Simulación**: C con MPI + OpenMP
- **Diseño**: Mobile-first responsive
- **Efectos**: CSS animations + glassmorphism
- **Compatibilidad**: Todos los navegadores modernos

---

# 📚 **PARTE II: INFORME TÉCNICO**

## 📖 Teoría: MPI (Message Passing Interface)

### ¿Qué es MPI?

**MPI (Message Passing Interface)** es un estándar que define la sintaxis y semántica de funciones de biblioteca para escribir programas paralelos portátiles usando el paradigma de paso de mensajes.

### Conceptos Fundamentales

#### 🔄 **Modelo de Programación**
- **Procesos Independientes**: Cada proceso tiene su propio espacio de memoria
- **Comunicación Explícita**: Los procesos intercambian datos mediante mensajes
- **Escalabilidad**: Puede ejecutarse desde una máquina hasta miles de nodos

#### 📡 **Tipos de Comunicación**

**1. Comunicación Punto a Punto**
```c
MPI_Send(data, count, datatype, dest, tag, comm);    // Envío
MPI_Recv(data, count, datatype, source, tag, comm, status); // Recepción
```

**2. Comunicación Colectiva**
```c
MPI_Bcast(data, count, datatype, root, comm);       // Difusión
MPI_Reduce(sendbuf, recvbuf, count, datatype, op, root, comm); // Reducción
```

### Ventajas de MPI
- ✅ **Escalabilidad**: Desde 2 hasta miles de procesos
- ✅ **Portabilidad**: Funciona en cualquier arquitectura
- ✅ **Flexibilidad**: Control total sobre la comunicación
- ✅ **Rendimiento**: Optimizado para alta performance

### Desventajas de MPI
- ❌ **Complejidad**: Requiere gestión manual de comunicación
- ❌ **Debugging**: Difícil depurar programas distribuidos
- ❌ **Overhead**: Costo de comunicación entre procesos

---

## ⚡ Teoría: OpenMP (Open Multi-Processing)

### ¿Qué es OpenMP?

**OpenMP** es una API que soporta programación paralela de memoria compartida en múltiples plataformas. Utiliza un modelo de programación fork-join.

### Conceptos Fundamentales

#### 🧵 **Modelo Fork-Join**
1. **Fork**: El hilo maestro crea un equipo de hilos paralelos
2. **Parallel Work**: Los hilos ejecutan trabajo en paralelo
3. **Join**: Los hilos se sincronizan y terminan, solo queda el maestro

#### 🔧 **Directivas Principales**

**1. Creación de Regiones Paralelas**
```c
#pragma omp parallel
{
    // Código ejecutado por todos los hilos
}
```

**2. Distribución de Trabajo**
```c
#pragma omp for
for(int i = 0; i < n; i++) {
    // Iteraciones distribuidas entre hilos
}
```

**3. Secciones Críticas**
```c
#pragma omp critical
{
    // Solo un hilo a la vez puede ejecutar esto
}
```

### Ventajas de OpenMP
- ✅ **Simplicidad**: Directivas pragmas fáciles de usar
- ✅ **Incremental**: Se puede paralelizar código existente gradualmente
- ✅ **Memoria Compartida**: Acceso directo a variables globales
- ✅ **Portable**: Estándar soportado por múltiples compiladores

### Desventajas de OpenMP
- ❌ **Limitado a SMP**: Solo memoria compartida (una máquina)
- ❌ **Race Conditions**: Riesgo de condiciones de carrera
- ❌ **Escalabilidad**: Limitado por el número de cores disponibles

---

## 🏗️ Arquitectura Híbrida del Proyecto

### Diseño de Dos Niveles

![Arquitectura MPI/OpenMP](/torneo/web/static/img/arquitectura.jpg)

Nuestro proyecto implementa un **modelo híbrido** que combina las fortalezas de ambas tecnologías:

#### 🌐 **Nivel 1: Distribución MPI**
```
Proceso 0: Tripulación Mugiwaras
Proceso 1: Tripulación Barbanegra  
Proceso 2: Tripulación Bestias
Proceso N: Tripulación N...
```

**Función**: Cada proceso MPI maneja **una tripulación completa**

#### ⚡ **Nivel 2: Paralelización OpenMP**
```
Dentro de cada proceso MPI:
├── Hilo 0: Combate Luffy
├── Hilo 1: Combate Zoro
├── Hilo 2: Combate Sanji
└── Hilo N: Combate N...
```

**Función**: Cada hilo OpenMP simula **un combate individual**

### Flujo de Ejecución

#### 1. **Inicialización (MPI)**
```c
MPI_Init(&argc, &argv);                    // Configurar entorno MPI
MPI_Comm_rank(MPI_COMM_WORLD, &rank);     // Obtener ID del proceso
```

#### 2. **Distribución de Datos (MPI)**
```c
MPI_Bcast(tripulaciones, sizeof(tripulaciones), MPI_BYTE, 0, MPI_COMM_WORLD);
```

#### 3. **Procesamiento Paralelo (OpenMP)**
```c
#pragma omp parallel
{
    // Cada hilo simula combates en paralelo
    unsigned int seed = time(NULL) ^ omp_get_thread_num() ^ rank;
    // ...simulación de combate...
}
```

#### 4. **Sincronización Local (OpenMP)**
```c
#pragma omp critical
{
    if (poder > poder_local) {
        poder_local = poder;
        ganador_local = j;
    }
}
```

#### 5. **Agregación Global (MPI)**
```c
MPI_Reduce(&in, &out, 1, MPI_2INT, MPI_MAXLOC, 0, MPI_COMM_WORLD);
```

### Ventajas de la Arquitectura Híbrida

#### 🚀 **Escalabilidad Dual**
- **Horizontal (MPI)**: Agregar más nodos/máquinas
- **Vertical (OpenMP)**: Utilizar todos los cores por nodo

#### ⚙️ **Eficiencia Optimizada**
- **MPI**: Minimiza comunicación entre procesos
- **OpenMP**: Maximiza uso de memoria compartida local


---

## 📊 Análisis de Rendimiento

### Métricas de Paralelización

#### **Speedup Teórico**
```
Speedup = T_secuencial / T_paralelo
```

#### **Eficiencia**
```
Eficiencia = Speedup / Número_de_Procesadores
```

### Casos de Uso Óptimos

#### 🎯 **MPI es Ideal Para**:
- Problemas distribuibles por tripulaciones
- Sistemas con múltiples nodos
- Aplicaciones que requieren escalabilidad masiva

#### 🎯 **OpenMP es Ideal Para**:
- Combates simultáneos dentro de tripulaciones
- Sistemas multi-core
- Paralelización rápida de loops

### Limitaciones y Consideraciones

#### 🚧 **Bottlenecks Potenciales**:
1. **Comunicación MPI**: Overhead en `MPI_Reduce`
2. **Sincronización OpenMP**: Contención en secciones críticas
3. **Balanceado de Carga**: Diferencias en número de personajes por tripulación

#### 💡 **Optimizaciones Implementadas**:
- Semillas de aleatoriedad únicas por hilo
- Minimización de comunicación MPI
- Uso eficiente de secciones críticas

---

## 🎓 Conclusiones

Este proyecto demuestra exitosamente:

1. **Integración MPI/OpenMP**: Modelo híbrido funcional
2. **Aplicación Práctica**: Conceptos teóricos en contexto divertido
3. **Escalabilidad**: Desde laboratorio hasta clusters HPC
4. **Portabilidad**: Funciona en Windows, Linux, macOS

---