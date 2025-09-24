# Demostración MPI y OpenMP - Torneo One Piece

## Descripción
Este proyecto demuestra el uso de **MPI** (Message Passing Interface) y **OpenMP** para programación paralela a través de una simulación de torneo de personajes de One Piece. El sistema utiliza:

- **MPI**: Para paralelización distribuida entre múltiples procesos
- **OpenMP**: Para paralelización de memoria compartida dentro de cada proceso
- **Interfaz Web**: Para visualización interactiva de los resultados

## Estructura del Proyecto
```
torneo/
├── src/                      # Código fuente principal
│   └── torneo_onepiece.c     # Simulación del torneo con MPI/OpenMP
├── config/                   # Configuración
│   └── config.json          # Tripulaciones y personajes
├── web/                     # Interfaz web
│   ├── templates/
│   │   └── demo.html        # Página de demostración
│   └── static/              # CSS y JavaScript
├── output/                  # Resultados de ejecución
├── scripts/                 # Scripts de instalación
├── docs/                    # Documentación técnica
├── Makefile                 # Sistema de construcción
└── iniciar_servidor.sh      # Script de inicio completo
```

## Requisitos del Sistema

### Para Windows (Recomendado)
- **WSL 2** (Windows Subsystem for Linux)
- **Ubuntu 22.04** o superior en WSL

### Dependencias en Linux/WSL
- `gcc`
- `make`
- `libopenmpi-dev`
- `openmpi-bin`
- `libcjson-dev`
- `python3`

## Instalación

### Paso 1: Instalar WSL (Solo Windows)
```bash
# En PowerShell como administrador
wsl --install -d Ubuntu-22.04
```
Reinicia tu computadora cuando se te solicite.

### Paso 2: Acceder a WSL
Una vez instalado WSL, desde cualquier terminal de Windows (PowerShell o CMD):
```bash
# Para entrar a WSL Ubuntu
wsl

# O directamente ejecutar comandos en WSL
wsl -e bash -c "comando_aquí"
```

### Paso 3: Navegar al Proyecto en WSL
```bash
# Una vez dentro de WSL, navegar al proyecto
cd /mnt/c/Users/[TU_USUARIO]/Desktop/MPIyOpenMP/torneo

# Por ejemplo, si tu usuario es "Juan":
cd /mnt/c/Users/Juan/Desktop/MPIyOpenMP/torneo
```

### Paso 4: Instalar Dependencias
```bash
# Hacer el script ejecutable e instalar dependencias
chmod +x scripts/install_dependencies.sh
./scripts/install_dependencies.sh
```

### Paso 5: Compilar el Proyecto
```bash
make compile
```

## 🚀 Comandos Rápidos de Referencia

### Desde Windows (PowerShell/CMD)
```bash
# Entrar a WSL
wsl

# Ejecutar comando directo en WSL
wsl -e bash -c "cd /mnt/c/Users/Usuario/Desktop/MPIyOpenMP/torneo && make run"

# Iniciar servidor web desde Windows
wsl -e bash -c "cd /mnt/c/Users/Usuario/Desktop/MPIyOpenMP/torneo/web && python3 -m http.server 8000"
```

### Una vez dentro de WSL
```bash
# Navegar al proyecto (cambiar "Usuario" por tu nombre de usuario)
cd /mnt/c/Users/Usuario/Desktop/MPIyOpenMP/torneo

# Compilar
make compile

# Ejecutar torneo
make run

# Ver ayuda
make help
```

## Ejecución

### Método 1: Ejecución Automática (Recomendado)
```bash
# Ejecuta el torneo y abre la interfaz web automáticamente
chmod +x iniciar_servidor.sh
./iniciar_servidor.sh
```

### Método 2: Ejecución Manual

#### 1. Ejecutar el Torneo
```bash
# Ejecuta la simulación con 4 procesos MPI
make run
```

#### 2. Ver Interfaz Web
```bash
# En otra terminal
cd web
python3 -m http.server 8000
```
Luego abre tu navegador en: http://localhost:8000/templates/demo.html

## Comandos Disponibles

| Comando | Descripción |
|---------|-------------|
| `make compile` | Compila el proyecto |
| `make run` | Ejecuta el torneo con 4 procesos MPI |
| `make demo` | Ejecuta y muestra resultados formateados |
| `make clean` | Limpia archivos compilados |
| `make help` | Muestra ayuda de comandos |

## Cómo Funciona la Demostración

### MPI (Message Passing Interface)
- **4 procesos distribuidos**: Cada proceso maneja diferentes tripulaciones
- **Comunicación entre procesos**: Los resultados se comunican usando MPI_Gather
- **Proceso maestro (rank 0)**: Coordina y determina el campeón global

### OpenMP (Open Multi-Processing)
- **Paralelización de memoria compartida**: Cada proceso MPI usa múltiples hilos
- **Regiones paralelas**: Los combates se procesan en paralelo usando `#pragma omp parallel`
- **Sincronización**: Los hilos se sincronizan para actualizar resultados

### Flujo de Ejecución
1. **Inicialización MPI**: Se crean 4 procesos distribuidos
2. **Distribución de datos**: El proceso maestro distribuye las tripulaciones
3. **Combates paralelos**: Cada proceso ejecuta combates usando OpenMP
4. **Recolección de resultados**: Los resultados se reúnen en el proceso maestro
5. **Determinación del campeón**: Se selecciona el personaje con mayor poder

## Visualización de Resultados

### Terminal
Los resultados se muestran directamente en la consola con:
- Ganadores por proceso MPI
- Campeón global final
- Estadísticas de poder

### Interfaz Web
La página web muestra:
- Configuración actual del torneo
- Botones para ejecutar diferentes demostraciones
- Visualización de resultados en tiempo real
- Información técnica sobre MPI/OpenMP

## 📝 Ejemplo Completo de Uso

### Primera vez (instalación completa)
```bash
# 1. Desde PowerShell como administrador
wsl --install -d Ubuntu-22.04
# [Reiniciar computadora]

# 2. Abrir PowerShell normal y entrar a WSL
wsl

# 3. Navegar al proyecto (cambiar "Usuario" por tu nombre)
cd /mnt/c/Users/Usuario/Desktop/MPIyOpenMP/torneo

# 4. Instalar dependencias
chmod +x scripts/install_dependencies.sh
./scripts/install_dependencies.sh

# 5. Compilar
make compile

# 6. Ejecutar
make run
```

### Uso diario (ya tienes todo instalado)
```bash
# Opción A: Desde PowerShell, comando directo
wsl -e bash -c "cd /mnt/c/Users/Usuario/Desktop/MPIyOpenMP/torneo && make run"

# Opción B: Entrar a WSL y trabajar desde ahí
wsl
cd /mnt/c/Users/Usuario/Desktop/MPIyOpenMP/torneo
make run

# Para ver la interfaz web
# En otra ventana de PowerShell:
wsl -e bash -c "cd /mnt/c/Users/Usuario/Desktop/MPIyOpenMP/torneo/web && python3 -m http.server 8000"
# Luego abrir: http://localhost:8000/templates/demo.html
```

## Configuración Personalizada

Puedes modificar `config/config.json` para:
- Agregar nuevas tripulaciones
- Cambiar personajes y sus poderes
- Ajustar parámetros del torneo

## Solución de Problemas

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

### Problemas de permisos en scripts
```bash
chmod +x scripts/*.sh
chmod +x *.sh
```

### Error: "wsl: command not found" (Windows)
```bash
# WSL no está instalado, ejecutar como administrador:
wsl --install -d Ubuntu-22.04
```

### Error: WSL no encuentra el directorio
```bash
# Verificar que estás en la ruta correcta, reemplazar "Usuario" por tu nombre:
ls /mnt/c/Users/Usuario/Desktop/MPIyOpenMP/

# Si no existe, verificar tu nombre de usuario en Windows:
ls /mnt/c/Users/
```

### Error: "No se puede acceder a WSL"
```bash
# En PowerShell como administrador:
wsl --update
wsl --shutdown
# Luego reiniciar y probar: wsl
```

## Autor
Proyecto educativo para demostración de conceptos de programación paralela con MPI y OpenMP.

## Licencia
Este proyecto es de uso educativo y demostrativo.

### Error: "libcjson not found"
```bash
# Ubuntu/Debian
sudo apt-get install libcjson-dev

# CentOS/RHEL
sudo yum install cjson-devel
```

### Error: "mpirun not found"
```bash
# Ubuntu/Debian
sudo apt-get install libopenmpi-dev

# CentOS/RHEL
sudo yum install openmpi-devel
```

## 📚 Referencias

- [OpenMPI Documentation](https://www.open-mpi.org/doc/)
- [OpenMP API Specification](https://www.openmp.org/specifications/)
- [cJSON Library](https://github.com/DaveGamble/cJSON)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 👥 Autores

- **Tu Nombre** - *Desarrollador Principal* - [@BiancaMichelle](https://github.com/BiancaMichelle)

## 🙏 Agradecimientos

- Eiichiro Oda por crear One Piece
- La comunidad de MPI y OpenMP
- Todos los que contribuyen al proyecto

---

