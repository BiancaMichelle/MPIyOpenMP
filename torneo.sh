#!/bin/bash
# Script helper para ejecutar comandos desde cualquier directorio
# Uso: ./torneo.sh [comando]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TORNEO_DIR="$SCRIPT_DIR/torneo"

echo "🏴‍☠️ Torneo One Piece - Helper Script"
echo "📂 Directorio: $TORNEO_DIR"
echo ""

if [ ! -d "$TORNEO_DIR" ]; then
    echo "❌ Error: Directorio torneo no encontrado"
    exit 1
fi

cd "$TORNEO_DIR"

if [ $# -eq 0 ]; then
    echo "📋 Comandos disponibles:"
    echo "  ./torneo.sh build    - Compilar proyecto"
    echo "  ./torneo.sh run      - Ejecutar torneo"
    echo "  ./torneo.sh demo     - Demo completa con web"
    echo "  ./torneo.sh test     - Tests básicos"
    echo "  ./torneo.sh clean    - Limpiar archivos"
    echo "  ./torneo.sh help     - Ayuda del Makefile"
    echo ""
    echo "🎯 Ejemplo: ./torneo.sh run"
    exit 0
fi

case "$1" in
    "build")
        make
        ;;
    "run")
        make run
        ;;
    "demo")
        echo "🌐 Iniciando demo completa..."
        echo "📱 Después abre: http://localhost:8000/templates/resultados.html"
        make demo
        ;;
    "test")
        make test
        ;;
    "clean")
        make clean
        ;;
    "help")
        make help
        ;;
    *)
        echo "❌ Comando desconocido: $1"
        echo "Use './torneo.sh' para ver comandos disponibles"
        exit 1
        ;;
esac