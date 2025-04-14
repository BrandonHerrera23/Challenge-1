#!/bin/bash

# Nombres y valores predefinidos para la creación automática
NOMBRE_VM="LinuxAuto2025"
TIPO_SO="Ubuntu_64"
CPUS=1
RAM_MB=1024        # 1 GB RAM
VRAM_MB=8          # 8 MB de Video RAM
DISCO_MB=5120      # 5 GB Disco duro
NOMBRE_SATA="ControladorSATA2025"
NOMBRE_IDE="ControladorIDE2025"

# Ruta del disco duro virtual
DISCO_VDI="$HOME/VirtualBox VMs/$NOMBRE_VM/$NOMBRE_VM.vdi"

echo "=============================="
echo " Iniciando creación automática"
echo "=============================="

# Crear la máquina virtual
echo "[+] Creando la máquina virtual: $NOMBRE_VM"
VBoxManage createvm --name "$NOMBRE_VM" --ostype "$TIPO_SO" --register

# Configurar CPU, RAM y VRAM
echo "[+] Configurando CPU ($CPUS), RAM (${RAM_MB}MB), VRAM (${VRAM_MB}MB)"
VBoxManage modifyvm "$NOMBRE_VM" --cpus "$CPUS" --memory "$RAM_MB" --vram "$VRAM_MB"

# Crear disco duro virtual
echo "[+] Creando disco duro virtual de $DISCO_MB MB"
VBoxManage createhd --filename "$DISCO_VDI" --size "$DISCO_MB" --variant Standard

# Crear y asociar el controlador SATA
echo "[+] Añadiendo controlador SATA: $NOMBRE_SATA"
VBoxManage storagectl "$NOMBRE_VM" --name "$NOMBRE_SATA" --add sata --bootable on
VBoxManage storageattach "$NOMBRE_VM" --storagectl "$NOMBRE_SATA" --port 0 --device 0 --type hdd --medium "$DISCO_VDI"

# Crear el controlador IDE
echo "[+] Añadiendo controlador IDE: $NOMBRE_IDE"
VBoxManage storagectl "$NOMBRE_VM" --name "$NOMBRE_IDE" --add ide

# Mostrar información de la máquina virtual creada
echo "=============================="
echo " Información de la VM creada:"
echo "=============================="
VBoxManage showvminfo "$NOMBRE_VM"

