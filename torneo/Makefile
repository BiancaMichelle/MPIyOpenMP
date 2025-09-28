# Makefile simple para Torneo One Piece
CC = mpicc
CFLAGS = -fopenmp -Wall -std=c99
LIBS = -lcjson -lm
TARGET = src/torneo_onepiece
SOURCE = src/torneo_onepiece.c

# Colores para output
GREEN = \033[0;32m
YELLOW = \033[1;33m
NC = \033[0m

.PHONY: all compile clean run web help

all: $(TARGET)

compile: $(TARGET)

$(TARGET): $(SOURCE)
	@echo "$(YELLOW)🔨 Compilando...$(NC)"
	$(CC) $(CFLAGS) -o $(TARGET) $(SOURCE) $(LIBS)
	@echo "$(GREEN)✅ Compilación exitosa!$(NC)"

clean:
	@echo "$(YELLOW)🧹 Limpiando...$(NC)"
	rm -f $(TARGET)
	@echo "$(GREEN)✅ Limpieza completa!$(NC)"

run: $(TARGET)
	@echo "$(YELLOW)🚀 Ejecutando simulación...$(NC)"
	mpirun -np 4 ./$(TARGET)

web:
	@echo "$(YELLOW)� Iniciando servidor web...$(NC)"
	@echo "$(GREEN)📱 Abrir: http://localhost:8000/templates/demo.html$(NC)"
	cd web && python3 -m http.server 8000

help:
	@echo "$(GREEN)🏴‍☠️ Torneo One Piece - Comandos$(NC)"
	@echo ""
	@echo "$(YELLOW)Comandos disponibles:$(NC)"
	@echo "  make compile  - Compilar el programa"
	@echo "  make run      - Ejecutar simulación"
	@echo "  make web      - Iniciar servidor web"
	@echo "  make clean    - Limpiar archivos"
	@echo "  make help     - Mostrar esta ayuda"