#!/bin/bash

# Validación de argumentos
if [ "$#" -ne 8 ]; then
    echo "Uso: $0 <nombre_VM> <tipo_SO> <CPUs> <RAM_GB> <VRAM_MB> <Tamaño_Disco_GB> <nombre_SATA> <nombre_IDE>"
    echo "Ejemplo: $0 UbuntuTest Ubuntu_64 2 4 16 20 SATAController IDEController"
    exit 1
fi

# Asignar argumentos
NOMBRE_VM=$1
TIPO_SO=$2
CPUS=$3
RAM_GB=$4
VRAM_MB=$5
DISCO_GB=$6
NOMBRE_SATA=$7
NOMBRE_IDE=$8

# Conversión a MB
RAM_MB=$((RAM_GB * 1024))
DISCO_MB=$((DISCO_GB * 1024))

# Ruta del disco duro
DISCO_VDI="$HOME/VirtualBox VMs/$NOMBRE_VM/$NOMBRE_VM.vdi"

# Crear la máquina virtual
VBoxManage createvm --name "$NOMBRE_VM" --ostype "$TIPO_SO" --register

# Configurar CPU, RAM y VRAM
VBoxManage modifyvm "$NOMBRE_VM" --cpus "$CPUS" --memory "$RAM_MB" --vram "$VRAM_MB"

# Crear disco duro virtual
VBoxManage createhd --filename "$DISCO_VDI" --size "$DISCO_MB" --variant Standard

# Crear y asociar el controlador SATA
VBoxManage storagectl "$NOMBRE_VM" --name "$NOMBRE_SATA" --add sata --bootable on
VBoxManage storageattach "$NOMBRE_VM" --storagectl "$NOMBRE_SATA" --port 0 --device 0 --type hdd --medium "$DISCO_VDI"

# Crear el controlador IDE
VBoxManage storagectl "$NOMBRE_VM" --name "$NOMBRE_IDE" --add ide

# Mostrar información de la máquina virtual
VBoxManage showvminfo "$NOMBRE_VM"
