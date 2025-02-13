#! /bin/bash
#    __                           __       _____           _       __
#   / /   ____ ___  ______  _____/ /_     / ___/__________(_)___  / /_
#  / /   / __ `/ / / / __ \/ ___/ __ \    \__ \/ ___/ ___/ / __ \/ __/
# / /___/ /_/ / /_/ / / / / /__/ / / /   ___/ / /__/ /  / / /_/ / /_
#/_____/\__,_/\__,_/_/ /_/\___/_/ /_/   /____/\___/_/  /_/ .___/\__/
#                                                       /_/
#

#Matar cualquier instancia de Redshift y esperar a que termine
#pkill redshift-gtk && sleep 1
#while pgrep -u $UID -x redshift-gtk >/dev/null; do sleep 1; done
# Lanzar Redshift
#redshift-gtk &
#echo "Redshift ha comenzado..."

# Matar cualquier instancia de Polybar y esperar a que termine
pkill polybar && sleep 1
# Esperar a que Polybar termine si está corriendo (opcional)
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
# Lanzar Polybar con la configuración personalizada
polybar --config=~/.config/polybar/config.ini
echo "Polybar ha comenzado..."

# Ejecutar plank.sh desde launch.sh
~/.config/bspwm/scripts/plank.sh &

# Descomentar la siguiente línea si usas Plank y quieres que siempre esté al frente
xdotool search --name Plank windowraise &
