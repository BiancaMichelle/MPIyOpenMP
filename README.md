# 🏴‍☠️ Torneo One Piece - Simulador MPI/OpenMP

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
