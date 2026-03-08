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


# Función para mostrar encabezados con gradiente
show_header() {
    local text="$1"
    local color1="$2"
    local color2="$3"
    local width=60
    local padding=$(( (width - ${#text}) / 2 ))
    
    echo
    gradient "$(printf '%*s' $width | tr ' ' '~')" "$color1" "$color2" bold
    gradient "$(printf '%*s' $padding) $text $(printf '%*s' $padding)" "$color2" "$color1" bold
    gradient "$(printf '%*s' $width | tr ' ' '~')" "$color1" "$color2" bold
    echo
}

# Script de automatización Git para Bash/Shell con captura de mensaje

clear
gradient_wave "=== GIT AUTOMATION SCRIPT ===" skyblue purple 0.05 1 bold
echo

# INICIO
show_header "INICIO" orange gold

# GIT STATUS
echo "$(fg green bold)▶ GIT STATUS$(reset)"
git status
echo "$(fg white)────────────────────────────────────────────────────────$(reset)"

# GIT ADD
echo "$(fg green bold)▶ GIT ADD$(reset)"
git add * --verbose
echo "$(fg white)────────────────────────────────────────────────────────$(reset)"

# Solicitar mensaje para el commit
echo "$(fg green bold)▶ GIT COMMIT$(reset)"
echo "$(fg yellow bold)╰─➤ Ingrese el mensaje para el commit:$(reset)"
read commit_message

# Verificar que se ingresó un mensaje
if [ -z "$commit_message" ]; then
    echo "$(fg red bold)╳ Error: No se ingresó ningún mensaje para el commit$(reset)"
    echo "$(fg red)╳ Saliendo del script...$(reset)"
    exit 1
fi

git commit --message="$commit_message" --verbose -a
echo "$(fg white)────────────────────────────────────────────────────────$(reset)"

# GIT LOG
echo "$(fg green bold)▶ GIT LOG$(reset)"
git log --oneline --since="30 minutes ago" --shortstat main
echo "$(fg white)────────────────────────────────────────────────────────$(reset)"

# GIT PUSH
echo "$(fg green bold)▶ GIT PUSH$(reset)"
git push --verbose
echo "$(fg white)────────────────────────────────────────────────────────$(reset)"

# GIT STATUS
echo "$(fg green bold)▶ GIT STATUS$(reset)"
git status

# FIN
echo
gradient "════════════════════════════════════════════════════════════════════════" purple blue bold
gradient "$(printf '%*s' 30)FIN$(printf '%*s' 30)" blue purple bold
gradient "════════════════════════════════════════════════════════════════════════" purple blue bold
echo

#<Fín de comandos>
