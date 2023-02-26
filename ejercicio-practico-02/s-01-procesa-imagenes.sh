#!/bin/bash
# @Autor Francine Ochoa Fernández
# @Fecha 26/2023
# @Descripcion Ejercicio práctico 02 - tema 01

achivoImagenes="${1}"
numImagenes="${2}"
archivoZip="${3}"

#funcion ayuda
function ayuda(){
  status="${1}"
  cat s-02-ayuda.sh
  exit "${status}"
}

#Validando parámetros

#validando parámetro 1
if [ -z "${archivoImagenes}" ]; then
  echo "ERROR: Archivo de Imágenes es requerido"
  ayuda 100
else
  #validar si el archivo existe
  if ! [ -f "${archivoImagenes}" ]; then
    echo "ERROR El archivo proporcionado ${archivoImagenes} no existe"
    ayuda 101
  fi;
fi;

#validar parámetro 2
if [[ "${numImagenes}" =~ [0-9]+ &&
      "${numImagenes}" -gt 0 &&
      "${numImagenes}" -le 90 ]]; then
      echo "Numero de imagenes ${numImagenes} correcto."
else
    echo "Numero de imagenes ${numImagenes} incorrecto."
    ayuda 102
fi;

#validar parámetro 3 (opcional), verifica que no sea nulo
if [ -n "${archivoZip}" ]; then
  dirSalida=$(dirname,"${archivoZip}")
  nombreZip=$(basename,"${archivoZip}")

  if ! [ -d "${dirSalida}" ]; then
    echo "ERROR: El directorio de salida ${dirSalida} no existe"
    ayuda 103 
  fi;
else
  dirSalida="/tmp/${USER}/imagenes"
  mkdir -p "${dirSalida}"
  nombreZip="imagenes-$(date '+%Y-%m-%d-%H-%M-%S').zip"
fi;

#Parámetros válidos, Obtener imágenes
#Limpiar el directorio de salida
echo "Limpiando directorio de salida"
rm -rf "${dirSalida}"/*

#Leer el archivo de rutas, y extraer los primeros N renglones
count=0
while read -r linea
do
   if [ "${count}" -ge "${numImagenes}" ]; then
    echo "...."
    break;
   fi;
   wget -q -P "${dirSalida}" "${linea}"
   status=$?
   if ! [ ${status} -eq 0 ]; then
       echo "Imagen $count no pudo ser descargada."
       ayuda 104
  else
    count=$((count+1))
    echo "Imagen $count obtenida con exito"
   fi;
done < "${archivoImagenes}"

#generar archivo zip
export IMG_ZIP_FILE="${dirSalida}/${nombreZip}"

#-j significa quitar la ruta donde se encuentra la img.
zip -j "${IMG_ZIP_FILE}" "${dirSalida}"/*

#cambiar permisos al archivo zip
chmod 600 "${IMG_ZIP_FILE}"

#echo generando archivo txt con la lista de imagenes
unzip -Z1 "${IMG_ZIP_FILE}" > "${dirSalida}"/s-00-lista-archivos.txt











