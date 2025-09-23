#!/bin/bash

# Script de instalación de dependencias para Torneo One Piece MPI/OpenMP
# Detecta automáticamente el sistema operativo e instala las dependencias necesarias

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏴‍☠️ Instalador de Dependencias - Torneo One Piece${NC}"
echo -e "${BLUE}=================================================${NC}"

# Función para detectar el sistema operativo
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get >/dev/null 2>&1; then
            OS="ubuntu"
        elif command -v yum >/dev/null 2>&1; then
            OS="centos"
        elif command -v pacman >/dev/null 2>&1; then
            OS="arch"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    elif [[ "$OSTYPE" == "msys" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
}

# Función para instalar en Ubuntu/Debian
install_ubuntu() {
    echo -e "${YELLOW}📦 Instalando dependencias en Ubuntu/Debian...${NC}"
    
    sudo apt-get update
    
    echo -e "${BLUE}🔧 Instalando herramientas de compilación...${NC}"
    sudo apt-get install -y build-essential
    
    echo -e "${BLUE}🌐 Instalando MPI...${NC}"
    sudo apt-get install -y libopenmpi-dev openmpi-bin
    
    echo -e "${BLUE}📚 Instalando cJSON...${NC}"
    sudo apt-get install -y libcjson-dev
    
    echo -e "${BLUE}🐍 Instalando Python3...${NC}"
    sudo apt-get install -y python3
    
    echo -e "${GREEN}✅ Instalación completa en Ubuntu/Debian${NC}"
}

# Función para instalar en CentOS/RHEL
install_centos() {
    echo -e "${YELLOW}📦 Instalando dependencias en CentOS/RHEL...${NC}"
    
    echo -e "${BLUE}🔧 Instalando herramientas de compilación...${NC}"
    sudo yum groupinstall -y "Development Tools"
    
    echo -e "${BLUE}🌐 Instalando MPI...${NC}"
    sudo yum install -y openmpi-devel
    
    echo -e "${BLUE}📚 Instalando cJSON...${NC}"
    sudo yum install -y cjson-devel
    
    echo -e "${BLUE}🐍 Instalando Python3...${NC}"
    sudo yum install -y python3
    
    echo -e "${GREEN}✅ Instalación completa en CentOS/RHEL${NC}"
}

# Función para instalar en macOS
install_macos() {
    echo -e "${YELLOW}📦 Instalando dependencias en macOS...${NC}"
    
    if ! command -v brew >/dev/null 2>&1; then
        echo -e "${RED}❌ Homebrew no encontrado. Instalando...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    echo -e "${BLUE}🌐 Instalando MPI...${NC}"
    brew install open-mpi
    
    echo -e "${BLUE}📚 Instalando cJSON...${NC}"
    brew install cjson
    
    echo -e "${BLUE}🐍 Verificando Python3...${NC}"
    if ! command -v python3 >/dev/null 2>&1; then
        brew install python3
    fi
    
    echo -e "${GREEN}✅ Instalación completa en macOS${NC}"
}

# Función para Windows (MSYS2)
install_windows() {
    echo -e "${YELLOW}📦 Instalando dependencias en Windows (MSYS2)...${NC}"
    
    if ! command -v pacman >/dev/null 2>&1; then
        echo -e "${RED}❌ MSYS2 no encontrado. Por favor instala MSYS2 primero.${NC}"
        echo -e "${BLUE}💡 Descarga desde: https://www.msys2.org/${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}🔧 Actualizando sistema...${NC}"
    pacman -Syu --noconfirm
    
    echo -e "${BLUE}🔧 Instalando herramientas de compilación...${NC}"
    pacman -S --noconfirm mingw-w64-x86_64-gcc
    
    echo -e "${BLUE}🌐 Instalando MPI...${NC}"
    pacman -S --noconfirm mingw-w64-x86_64-msmpi
    
    echo -e "${BLUE}📚 Instalando cJSON...${NC}"
    pacman -S --noconfirm mingw-w64-x86_64-cjson
    
    echo -e "${BLUE}🐍 Instalando Python3...${NC}"
    pacman -S --noconfirm python3
    
    echo -e "${GREEN}✅ Instalación completa en Windows (MSYS2)${NC}"
}

# Función para verificar instalación
verify_installation() {
    echo -e "${BLUE}🔍 Verificando instalación...${NC}"
    
    # Verificar compilador C
    if command -v gcc >/dev/null 2>&1; then
        echo -e "${GREEN}✅ GCC encontrado: $(gcc --version | head -n1)${NC}"
    else
        echo -e "${RED}❌ GCC no encontrado${NC}"
        return 1
    fi
    
    # Verificar MPI
    if command -v mpicc >/dev/null 2>&1; then
        echo -e "${GREEN}✅ MPI encontrado: $(mpicc --version | head -n1)${NC}"
    else
        echo -e "${RED}❌ MPI no encontrado${NC}"
        return 1
    fi
    
    # Verificar OpenMP (intentar compilar un programa simple)
    echo "int main(){return 0;}" > /tmp/test_openmp.c
    if mpicc -fopenmp /tmp/test_openmp.c -o /tmp/test_openmp 2>/dev/null; then
        echo -e "${GREEN}✅ OpenMP soportado${NC}"
        rm -f /tmp/test_openmp.c /tmp/test_openmp
    else
        echo -e "${RED}❌ OpenMP no soportado${NC}"
        rm -f /tmp/test_openmp.c /tmp/test_openmp
        return 1
    fi
    
    # Verificar Python3
    if command -v python3 >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Python3 encontrado: $(python3 --version)${NC}"
    else
        echo -e "${RED}❌ Python3 no encontrado${NC}"
        return 1
    fi
    
    echo -e "${GREEN}🎉 ¡Todas las dependencias están instaladas correctamente!${NC}"
    return 0
}

# Función principal
main() {
    detect_os
    
    echo -e "${BLUE}🖥️  Sistema detectado: $OS${NC}"
    echo ""
    
    case $OS in
        "ubuntu")
            install_ubuntu
            ;;
        "centos")
            install_centos
            ;;
        "macos")
            install_macos
            ;;
        "windows")
            install_windows
            ;;
        *)
            echo -e "${RED}❌ Sistema operativo no soportado: $OS${NC}"
            echo -e "${YELLOW}💡 Instalación manual requerida:${NC}"
            echo "  - Compilador C con soporte OpenMP"
            echo "  - MPI (OpenMPI o MPICH)"
            echo "  - Biblioteca cJSON"
            echo "  - Python3 (para servidor web)"
            exit 1
            ;;
    esac
    
    echo ""
    verify_installation
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}🚀 ¡Listo para ejecutar el torneo!${NC}"
        echo -e "${BLUE}Comandos disponibles:${NC}"
        echo "  make          - Compilar"
        echo "  make demo     - Ejecutar demo completa"
        echo "  make help     - Ver ayuda completa"
    else
        echo -e "${RED}❌ Hay problemas con la instalación. Revisa los errores arriba.${NC}"
        exit 1
    fi
}

# Verificar si se ejecuta con --check para solo verificar
if [ "$1" = "--check" ]; then
    echo -e "${BLUE}🔍 Solo verificando dependencias existentes...${NC}"
    verify_installation
    exit $?
fi

# Ejecutar instalación
main