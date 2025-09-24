@echo off
REM Script batch para compilar el proyecto
REM Uso: build.bat

echo [92m🔨 Compilando proyecto torneo One Piece...[0m

REM Verificar si existe el directorio src
if not exist "src" (
    echo [91m❌ Directorio src no encontrado[0m
    exit /b 1
)

REM Compilar con mpicc
echo [93mEjecutando: mpicc -fopenmp -Wall -std=c99 -o src\torneo_onepiece.exe src\torneo_onepiece.c -lcjson -lm[0m

mpicc -fopenmp -Wall -std=c99 -o src\torneo_onepiece.exe src\torneo_onepiece.c -lcjson -lm

if %ERRORLEVEL% EQU 0 (
    echo [92m✅ Compilación exitosa![0m
    echo [96m💡 Usa 'run.bat' para ejecutar el programa[0m
) else (
    echo [91m❌ Error en compilación[0m
    echo [93m💡 Verifica que MPI y cJSON estén instalados[0m
    exit /b 1
)

pause