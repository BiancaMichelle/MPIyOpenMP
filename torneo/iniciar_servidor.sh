#!/bin/bash
# Script para ejecutar el servidor web interactivo del Torneo One Piece

echo "🏴‍☠️ Iniciando Servidor Torneo One Piece MPI/OpenMP"
echo "=" * 60

# Verificar que estamos en el directorio correcto
if [ ! -f "Makefile" ] || [ ! -d "web" ]; then
    echo "❌ Error: Ejecutar desde el directorio torneo/"
    exit 1
fi

# Verificar dependencias
echo "🔍 Verificando dependencias..."

# Verificar Python3
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 no encontrado"
    exit 1
fi

# Verificar MPI
if ! command -v mpicc &> /dev/null; then
    echo "❌ MPI no encontrado"
    exit 1
fi

echo "✅ Dependencias verificadas"

# Compilar proyecto si es necesario
if [ ! -f "src/torneo_onepiece" ] || [ "src/torneo_onepiece.c" -nt "src/torneo_onepiece" ]; then
    echo "🔨 Compilando proyecto..."
    make clean && make
    if [ $? -ne 0 ]; then
        echo "❌ Error compilando proyecto"
        exit 1
    fi
fi

echo "✅ Proyecto compilado"

# Crear directorio output si no existe
mkdir -p output

echo ""
echo "🌐 Iniciando servidor web..."
echo ""
echo "📱 URLs disponibles:"
echo "   • Configurador: http://localhost:8000/templates/config.html"
echo "   • Resultados:   http://localhost:8000/templates/resultados.html"
echo "   • Principal:    http://localhost:8000/templates/index.html"
echo ""
echo "⚠️  Presiona Ctrl+C para detener el servidor"
echo ""

# Ejecutar servidor
python3 servidor.py