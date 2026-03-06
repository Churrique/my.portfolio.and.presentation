#!/usr/bin/env bash
# Script personal portátil
# y
# Script para otros usuarios

# ------- Colores Existentes --------- #
# black, white, red, green, blue, yellow, cyan,
# magenta, orange, purple, skyblue, gray, pink,
# lime, brown, gold, teal, navy
# ------- Estilos Existentes --------- #
# bold, dim, underline,
# blink, reverse, strike
# ------- Empleo de Colores --------- #
# fg white; echo "Texto blanco normal"; reset
# fg orange bold; echo "Texto naranja en negrita"; reset
# ------- COMBINADO {1} Empleo de Colores --------- #
# fg lime; echo -n "lime "; fg brown; echo -n "brown "; fg magenta; echo "magenta "; reset
# ------- GRADIENTE Empleo de Colores --------- #
# gradient "Gradiente rojo → azul" red blue
# gradient "Gradiente skyblue → purple" skyblue purple bold
# ------- COMBINADO {2} Empleo de Colores --------- #
# words=(blanco rojo verde gris rosa marron)
# colors=(white red green gray pink brown)
# styles=(bold underline strike "" blink reverse)
# line_colors_advanced colors words styles

#<Comandos aquí>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Importamos la librería
if [[ -f "$SCRIPT_DIR/colors.sh" ]]; then
    source "$SCRIPT_DIR/colors.sh"
else
    echo "Error: No se encontró colors.sh en $SCRIPT_DIR"
    exit 1
fi

# --- Configuración ---
ORIGEN="$HOME/Desarrollo/GIT.local/my.portfolio.and.presentation/"
DESTINO="$HOME/Desarrollo/html/jesusacosta.info/"
EXCLUDE_FILE="$SCRIPT_DIR/exclude-list.txt"

# Verificamos si el archivo de exclusiones existe
if [[ ! -f "$EXCLUDE_FILE" ]]; then
    fg "red" "bold"; echo "Error: No se encuentra $EXCLUDE_FILE"; reset
    exit 1
fi

# Definimos los flags como un Array (es la forma más segura en Bash para evitar errores de espacios)
FLAGS=(-av --delete --exclude-from="$EXCLUDE_FILE")

clear
gradient "=== RÉPLICA PARA EL SITE (en HTML) ===" "skyblue" "navy" "bold"
echo
fg "orange" "bold"; printf "ORIGEN:  "; reset; echo "$ORIGEN"
fg "orange" "bold"; printf "DESTINO: "; reset; echo "$DESTINO"
echo "-----------------------------------------------------------"

fg "yellow" "bold"; echo "FASE 1: Muestreo de cambios (Simulación)"
reset; echo "Analizando diferencias..."
echo

# Simulación (fíjate en "${FLAGS[@]}" con comillas y @)
fg "gray"
rsync -n "${FLAGS[@]}" -i "$ORIGEN" "$DESTINO"
reset

echo "-----------------------------------------------------------"
echo
fg "cyan" "bold"; printf "¿Deseas aplicar estos cambios de forma REAL? "
fg "white" "dim"; printf "(s/n): "
reset
read -r respuesta

if [[ "$respuesta" =~ ^[Ss]$ ]]; then
    echo
    gradient "EJECUTANDO SINCRONIZACIÓN..." "lime" "green" "bold"
    
    # Ejecución Real
    rsync "${FLAGS[@]}" "$ORIGEN" "$DESTINO"
    
    echo
    fg "green" "bold"; echo "✔ Proceso finalizado con éxito."
    reset
else
    echo
    fg "red" "bold"; echo "✘ Sincronización cancelada."
    reset
fi

#<Fín de comandos>
