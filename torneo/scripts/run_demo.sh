#!/bin/bash

# Script de ejecución automática del Torneo One Piece
# Maneja compilación, ejecución y servidor web automáticamente

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
WEB_DIR="$PROJECT_DIR/web"
SERVER_PID=""

echo -e "${BLUE}🏴‍☠️ Torneo One Piece - Ejecución Automática${NC}"
echo -e "${BLUE}=============================================${NC}"

# Función de limpieza al salir
cleanup() {
    if [ ! -z "$SERVER_PID" ]; then
        echo -e "${YELLOW}🛑 Deteniendo servidor web...${NC}"
        kill $SERVER_PID 2>/dev/null || true
    fi
    echo -e "${BLUE}👋 ¡Hasta la próxima aventura!${NC}"
}

# Configurar trap para limpieza
trap cleanup EXIT INT TERM

# Verificar dependencias
check_dependencies() {
    echo -e "${BLUE}🔍 Verificando dependencias...${NC}"
    
    if ! command -v mpicc >/dev/null 2>&1; then
        echo -e "${RED}❌ mpicc no encontrado${NC}"
        echo -e "${YELLOW}💡 Ejecuta: ./scripts/install_dependencies.sh${NC}"
        exit 1
    fi
    
    if ! command -v python3 >/dev/null 2>&1; then
        echo -e "${RED}❌ python3 no encontrado${NC}"
        echo -e "${YELLOW}💡 Ejecuta: ./scripts/install_dependencies.sh${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Dependencias verificadas${NC}"
}

# Compilar el proyecto
compile_project() {
    echo -e "${BLUE}🔨 Compilando proyecto...${NC}"
    cd "$PROJECT_DIR"
    
    if make clean && make; then
        echo -e "${GREEN}✅ Compilación exitosa${NC}"
    else
        echo -e "${RED}❌ Error en compilación${NC}"
        exit 1
    fi
}

# Verificar configuración
check_config() {
    echo -e "${BLUE}📋 Verificando configuración...${NC}"
    
    if [ ! -f "$PROJECT_DIR/config/config.json" ]; then
        echo -e "${YELLOW}⚠️  config.json no encontrado, creando por defecto...${NC}"
        # El Makefile se encarga de esto
    fi
    
    echo -e "${GREEN}✅ Configuración lista${NC}"
}

# Ejecutar torneo
run_torneo() {
    local num_processes=${1:-4}
    
    echo -e "${BLUE}🚀 Ejecutando torneo con $num_processes procesos MPI...${NC}"
    cd "$PROJECT_DIR"
    
    echo -e "${YELLOW}⚡ Iniciando batalla épica...${NC}"
    
    if mpirun -np $num_processes ./src/torneo_onepiece; then
        echo -e "${GREEN}✅ Torneo completado exitosamente${NC}"
        
        if [ -f "output/resultado.json" ]; then
            echo -e "${BLUE}🏆 Resultado del torneo:${NC}"
            cat output/resultado.json | python3 -m json.tool
        fi
    else
        echo -e "${RED}❌ Error ejecutando el torneo${NC}"
        exit 1
    fi
}

# Iniciar servidor web
start_web_server() {
    echo -e "${BLUE}🌐 Iniciando servidor web...${NC}"
    
    cd "$WEB_DIR"
    python3 -m http.server 8000 > /dev/null 2>&1 &
    SERVER_PID=$!
    
    # Esperar un momento para que el servidor inicie
    sleep 2
    
    # Verificar que el servidor esté corriendo
    if kill -0 $SERVER_PID 2>/dev/null; then
        echo -e "${GREEN}✅ Servidor web iniciado en http://localhost:8000${NC}"
        return 0
    else
        echo -e "${RED}❌ Error iniciando servidor web${NC}"
        return 1
    fi
}

# Abrir navegador
open_browser() {
    local url="http://localhost:8000/templates/resultados.html"
    
    echo -e "${BLUE}🌍 Abriendo resultados en navegador...${NC}"
    
    # Detectar sistema operativo y abrir navegador
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v xdg-open >/dev/null 2>&1; then
            xdg-open "$url" 2>/dev/null &
        else
            echo -e "${YELLOW}📱 Abrir manualmente: $url${NC}"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        open "$url" 2>/dev/null &
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
        start "$url" 2>/dev/null &
    else
        echo -e "${YELLOW}📱 Abrir manualmente: $url${NC}"
    fi
}

# Mostrar estadísticas
show_stats() {
    echo -e "${BLUE}📊 Estadísticas del torneo:${NC}"
    
    if [ -f "$PROJECT_DIR/output/resultado.json" ]; then
        local resultado=$(cat "$PROJECT_DIR/output/resultado.json")
        local pirata=$(echo "$resultado" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data['campeon']['pirata'])")
        local poder=$(echo "$resultado" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data['campeon']['poder'])")
        local universo=$(echo "$resultado" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data['campeon']['universo'])")
        
        echo -e "${GREEN}🏆 Campeón: $pirata${NC}"
        echo -e "${GREEN}⚡ Poder: $poder${NC}"
        echo -e "${GREEN}🌍 Universo: $universo${NC}"
    fi
    
    # Mostrar información del sistema
    echo -e "${BLUE}💻 Sistema:${NC}"
    echo -e "  Procesos MPI: $(mpirun --version | head -n1)"
    echo -e "  Hilos OpenMP: $OMP_NUM_THREADS (por defecto del sistema)"
    echo -e "  Servidor web: http://localhost:8000"
}

# Función principal
main() {
    local mode=${1:-"demo"}
    local processes=${2:-4}
    
    case $mode in
        "demo")
            echo -e "${GREEN}🎬 Modo Demo Completo${NC}"
            check_dependencies
            compile_project
            check_config
            run_torneo $processes
            start_web_server
            show_stats
            open_browser
            
            echo -e "${GREEN}🎉 ¡Demo completa ejecutándose!${NC}"
            echo -e "${BLUE}Presiona Ctrl+C para terminar${NC}"
            
            # Mantener el script corriendo
            while true; do
                sleep 5
                # Verificar si el servidor sigue corriendo
                if ! kill -0 $SERVER_PID 2>/dev/null; then
                    echo -e "${YELLOW}⚠️  Servidor web detenido, reiniciando...${NC}"
                    start_web_server
                fi
            done
            ;;
            
        "run")
            echo -e "${GREEN}🚀 Solo Ejecutar Torneo${NC}"
            check_dependencies
            compile_project
            check_config
            run_torneo $processes
            show_stats
            ;;
            
        "web")
            echo -e "${GREEN}🌐 Solo Servidor Web${NC}"
            start_web_server
            echo -e "${GREEN}Servidor web corriendo en http://localhost:8000${NC}"
            echo -e "${BLUE}Presiona Ctrl+C para terminar${NC}"
            wait $SERVER_PID
            ;;
            
        "help")
            echo -e "${BLUE}Uso: $0 [modo] [procesos]${NC}"
            echo ""
            echo -e "${YELLOW}Modos disponibles:${NC}"
            echo "  demo [n]    - Demo completa con n procesos (defecto: 4)"
            echo "  run [n]     - Solo ejecutar torneo con n procesos"
            echo "  web         - Solo iniciar servidor web"
            echo "  help        - Mostrar esta ayuda"
            echo ""
            echo -e "${YELLOW}Ejemplos:${NC}"
            echo "  $0                # Demo completa con 4 procesos"
            echo "  $0 demo 8         # Demo con 8 procesos"
            echo "  $0 run 2          # Solo torneo con 2 procesos"
            echo "  $0 web            # Solo servidor web"
            ;;
            
        *)
            echo -e "${RED}❌ Modo desconocido: $mode${NC}"
            echo -e "${YELLOW}Usa '$0 help' para ver opciones disponibles${NC}"
            exit 1
            ;;
    esac
}

# Ejecutar función principal con argumentos
main "$@"