# Makefile para Torneo One Piece MPI/OpenMP
CC = mpicc
CFLAGS = -fopenmp -Wall -std=c99
LIBS = -lcjson -lm
TARGET = src/torneo_onepiece
SOURCE = src/torneo_onepiece.c
CONFIG_FILE = config/config.json
OUTPUT_FILE = output/resultado.json

# Colores para output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

.PHONY: all compile clean run demo install-deps help

all: $(TARGET)

compile: $(TARGET)

$(TARGET): $(SOURCE)
	@echo "$(YELLOW)🔨 Compilando $(TARGET)...$(NC)"
	$(CC) $(CFLAGS) -o $(TARGET) $(SOURCE) $(LIBS)
	@echo "$(GREEN)✅ Compilación exitosa!$(NC)"

clean:
	@echo "$(YELLOW)🧹 Limpiando archivos...$(NC)"
	rm -f $(TARGET) $(OUTPUT_FILE)
	@echo "$(GREEN)✅ Limpieza completa!$(NC)"

run: $(TARGET)
	@echo "$(YELLOW)🚀 Ejecutando torneo con 4 procesos MPI...$(NC)"
	mpirun -np 4 ./$(TARGET)

demo: $(TARGET) setup-config
	@echo "$(GREEN)🎬 Iniciando demo completa...$(NC)"
	@echo "$(YELLOW)1️⃣ Ejecutando torneo...$(NC)"
	mpirun -np 4 ./$(TARGET)
	@echo "$(YELLOW)2️⃣ Abriendo resultados en navegador...$(NC)"
	@if command -v python3 >/dev/null 2>&1; then \
		cd web && python3 -m http.server 8000 & \
		sleep 2 && \
		if command -v start >/dev/null 2>&1; then \
			start http://localhost:8000/templates/resultados.html; \
		else \
			echo "$(GREEN)📱 Abrir: http://localhost:8000/templates/resultados.html$(NC)"; \
		fi \
	else \
		echo "$(RED)❌ Python3 necesario para servidor web$(NC)"; \
	fi

setup-config:
	@if [ ! -f $(CONFIG_FILE) ]; then \
		echo "$(YELLOW)📝 Copiando configuración por defecto...$(NC)"; \
		cp $(CONFIG_FILE) config.json; \
	fi

install-deps:
	@echo "$(YELLOW)📦 Verificando dependencias...$(NC)"
	@echo "$(GREEN)Necesitas instalar:$(NC)"
	@echo "  - 🔧 MPI (OpenMPI o MPICH)"
	@echo "  - 📚 libcjson-dev"
	@echo "  - 🐍 Python3 (para servidor web)"
	@echo ""
	@echo "$(YELLOW)Ubuntu/Debian:$(NC)"
	@echo "  sudo apt-get install libopenmpi-dev libcjson-dev python3"
	@echo ""
	@echo "$(YELLOW)Windows (MSYS2):$(NC)"
	@echo "  pacman -S mingw-w64-x86_64-msmpi mingw-w64-x86_64-cjson python3"

test: $(TARGET)
	@echo "$(YELLOW)🧪 Ejecutando tests...$(NC)"
	@if [ -f config.json ]; then \
		echo "$(GREEN)✅ config.json encontrado$(NC)"; \
	else \
		echo "$(RED)❌ config.json faltante$(NC)"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Probando con 2 procesos...$(NC)"
	mpirun -np 2 ./$(TARGET)

help:
	@echo "$(GREEN)🏴‍☠️ Torneo One Piece - MPI/OpenMP Demo$(NC)"
	@echo ""
	@echo "$(YELLOW)Comandos disponibles:$(NC)"
	@echo "  make          - Compilar el programa"
	@echo "  make run      - Ejecutar con 4 procesos MPI"
	@echo "  make demo     - Demo completa con interfaz web"
	@echo "  make test     - Ejecutar tests básicos"
	@echo "  make clean    - Limpiar archivos generados"
	@echo "  make install-deps - Mostrar cómo instalar dependencias"
	@echo "  make help     - Mostrar esta ayuda"
	@echo ""
	@echo "$(GREEN)📖 Ejemplo de uso:$(NC)"
	@echo "  make && make demo"