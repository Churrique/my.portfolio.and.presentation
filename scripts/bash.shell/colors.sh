#!/usr/bin/env bash

# ---------- Capacidades ----------
supports_truecolor() { [[ "$COLORTERM" =~ (truecolor|24bit) ]]; }
supports_256() { [[ "$TERM" =~ 256color ]]; }

# ---------- Paleta ----------
declare -A COLORS=(
  [black]="0,0,0"         [white]="255,255,255"
  [red]="255,0,0"         [green]="0,255,0"
  [blue]="0,0,255"        [yellow]="255,255,0"
  [cyan]="0,255,255"      [magenta]="255,0,255"
  [orange]="255,165,0"    [purple]="128,0,128"
  [skyblue]="135,206,235" [gray]="128,128,128"
  [pink]="255,192,203"    [lime]="50,205,50"
  [brown]="165,42,42"     [gold]="255,215,0"
  [teal]="0,128,128"      [navy]="0,0,128"
)

# ---------- Estilos ----------
declare -A STYLES=(
  [bold]=1
  [dim]=2
  [underline]=4
  [blink]=5
  [reverse]=7
  [strike]=9
)

# ---------- Reset y cursor ----------
reset(){ echo -ne "\e[0m"; }
hide_cursor(){ tput civis; }
show_cursor(){ tput cnorm; }

cleanup() {
  show_cursor
  reset
}
trap cleanup EXIT

rgb_to_256(){ echo $((16 + (36*($1/51)) + (6*($2/51)) + ($3/51) )); }

# ---------- Foreground con color y estilo ----------
fg_rgb(){
  local r=$1 g=$2 b=$3 style_seq=$4
  local prefix=""
  [[ -n "$style_seq" ]] && prefix="${style_seq};"

  if supports_truecolor; then
    echo -ne "\e[${prefix}38;2;${r};${g};${b}m"
  elif supports_256; then
    echo -ne "\e[${prefix}38;5;$(rgb_to_256 $r $g $b)m"
  else
    echo -ne "\e[${prefix}37m"
  fi
}

# ---------- Función fg ----------
fg(){
  local color=$1
  shift
  local style_seq=""
  for s in "$@"; do
    [[ -n "${STYLES[$s]}" ]] && style_seq+="${STYLES[$s]};"
  done
  style_seq=${style_seq%;}

  IFS=',' read -r r g b <<< "${COLORS[$color]}"
  fg_rgb "$r" "$g" "$b" "$style_seq"
}

# ---------- Gradiente ----------
gradient(){
  local text="$1" c1="$2" c2="$3"
  shift 3
  local style_seq=""
  for s in "$@"; do
    [[ -n "${STYLES[$s]}" ]] && style_seq+="${STYLES[$s]};"
  done
  style_seq=${style_seq%;}

  IFS=',' read -r r1 g1 b1 <<< "${COLORS[$c1]}"
  IFS=',' read -r r2 g2 b2 <<< "${COLORS[$c2]}"
  local len=${#text}

  for ((i=0;i<len;i++)); do
    r=$(( (r1*(len-i) + r2*i) / len ))
    g=$(( (g1*(len-i) + g2*i) / len ))
    b=$(( (b1*(len-i) + b2*i) / len ))
    fg_rgb "$r" "$g" "$b" "$style_seq"
    printf "%s" "${text:i:1}"
  done
  reset
  echo
}

# ---------- Función line_colors (ORIGINAL) ----------
line_colors() {
  local -n col_arr=$1
  local -n txt_arr=$2
  local -n style_arr=$3

  for i in "${!txt_arr[@]}"; do
    local style="${style_arr[i]}"
    local color="${col_arr[i]}"
    if [[ -n "$style" ]]; then
      fg "$color" "$style"
    else
      fg "$color"
    fi
    printf "%s " "${txt_arr[i]}"
  done
  reset
  echo
}

# ---------- Función line_colors_advanced (LA QUE FALTABA) ----------
# line_colors_advanced colors_array words_array [styles_array]
# colors_array: array con nombres de colores
# words_array: array con palabras/textos a imprimir
# styles_array (opcional): array con estilos por palabra (bold, underline, strike)
line_colors_advanced() {
  local -n col_arr=$1
  local -n txt_arr=$2
  local -n style_arr=$3

  for i in "${!txt_arr[@]}"; do
    local styles=""
    [[ -n "${style_arr[i]}" ]] && styles="${style_arr[i]}"
    fg "${col_arr[i]}" $styles
    printf "%s " "${txt_arr[i]}"
  done
  reset
  echo
}

# ---------- Animación tipo OLA (Anti-Parpadeo y Cancelable) ----------
gradient_wave() {
    local text="$1" c1="$2" c2="$3" speed="${4:-0.1}" loops="${5:-0}" style_name="$6"
    local style_seq=${STYLES[$style_name]}

    IFS=',' read -r r1 g1 b1 <<< "${COLORS[$c1]}"
    IFS=',' read -r r2 g2 b2 <<< "${COLORS[$c2]}"

    hide_cursor

    # Manejo local de la interrupción
    local stop_wave=0
    trap 'stop_wave=1' INT

    local t=0
    local len=${#text}

    # El bucle ahora depende de la señal
    while [[ $stop_wave -eq 0 ]]; do
        local output=""
        for ((i=0; i<len; i++)); do
            local wave_factor=$(( (i + t) % len ))

            local r=$(( (r1*(len-wave_factor) + r2*wave_factor) / len ))
            local g=$(( (g1*(len-wave_factor) + g2*wave_factor) / len ))
            local b=$(( (b1*(len-wave_factor) + b2*wave_factor) / len ))

            local prefix=""
            [[ -n "$style_seq" ]] && prefix="${style_seq};"
            output+="\e[${prefix}38;2;${r};${g};${b}m${text:i:1}"
        done

        printf "\r%b\e[0m\e[K" "$output"

        # Dormir un poco y chequear si se debe salir
        sleep "$speed" || break
        ((t++))

        [[ "$loops" -gt 0 && "$t" -ge "$loops" ]] && break
    done

    # Limpieza al salir
    reset
    show_cursor
    echo
    trap - INT # Devolver el control del trap al sistema
}
