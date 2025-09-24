# Guía de instalación de herramientas de desarrollo para Windows

## 🔧 **Opciones para usar make en Windows:**

### **Opción A: Chocolatey (Recomendado)**
```powershell
# 1. Instalar Chocolatey (como administrador)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 2. Instalar make
choco install make

# 3. Reiniciar terminal y probar
make --version
```

### **Opción B: MSYS2 (Más completo)**
```powershell
# 1. Descargar MSYS2 desde: https://www.msys2.org/
# 2. Instalar y ejecutar MSYS2
# 3. En terminal MSYS2:
pacman -S make
pacman -S mingw-w64-x86_64-gcc
```

### **Opción C: Visual Studio Code + WSL**
```powershell
# 1. Instalar WSL (Windows Subsystem for Linux)
wsl --install

# 2. En WSL Ubuntu:
sudo apt update
sudo apt install build-essential
```

### **Opción D: Git Bash (Incluye make básico)**
- Descargar Git para Windows: https://git-scm.com/download/win
- Incluye un make básico en Git Bash

## 🚀 **Scripts alternativos creados:**

### **PowerShell Script (Recomendado para Windows)**
```powershell
# Usar en lugar de make
.\build.ps1 help      # Ver ayuda
.\build.ps1           # Compilar
.\build.ps1 run       # Ejecutar
.\build.ps1 demo      # Demo completa
.\build.ps1 clean     # Limpiar
```

### **Scripts Batch (Más simple)**
```cmd
build.bat             # Compilar
run.bat               # Ejecutar con 4 procesos
web.bat               # Servidor web
demo.bat              # Demo completa
```

## 📋 **Dependencias requeridas:**

### **1. Microsoft MPI**
- Descargar: https://www.microsoft.com/en-us/download/details.aspx?id=57467
- Instalar tanto MSMpiSetup.exe como msmpisdk.msi

### **2. Python 3**
- Descargar: https://www.python.org/downloads/
- Marcar "Add Python to PATH" durante instalación

### **3. Visual Studio Build Tools**
- Descargar: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
- Seleccionar "C++ build tools"

### **4. cJSON (Opcional)**
```powershell
# Con vcpkg (recomendado)
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg install cjson:x64-windows
```

## ✅ **Verificar instalación:**
```powershell
# Verificar MPI
mpiexec --version

# Verificar Python
python --version

# Verificar compilador C
gcc --version
# o
cl.exe
```

## 🎯 **Uso inmediato:**
Si quieres empezar ahora sin instalar make:
```powershell
# Usar script PowerShell
.\build.ps1 demo

# O scripts batch
demo.bat
```