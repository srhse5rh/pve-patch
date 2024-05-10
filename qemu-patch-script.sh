#!/bin/bash
# https://github.com/kevoreilly/CAPEv2/blob/fa94c917659a24a412ae793a54e2be48e5f15ec7/installer/kvm-qemu.sh


#replace all occurances of CPU's in qemu with our fake one
cpuid="Intel(R) Core(TM) i3-4130 CPU"
#cpuid="AMD FX(tm)-4300 Quad-Core Processor"

#KVMKVMKVM\\0\\0\\0 replacement
hypervisor_string_replacemnt="GenuineIntel"
#hypervisor_string_replacemnt="AuthenticAMD"

#QEMU HARDDISK
#qemu_hd_replacement="SanDisk SDSSD"
qemu_hd_replacement="SAMSUNG MZ76E120"
#QEMU DVD-ROM
#qemu_dvd_replacement="HL-DT-ST WH1"
#qemu_dvd_replacement="HL-PV-SG WB4"
qemu_dvd_replacement="HL-PQ-SV WB8"

#BOCHSCPU
#bochs_cpu_replacement="INTELCPU"
bochs_cpu_replacement="AMDCPU"

#QEMU\/Bochs
#qemu_bochs_cpu='INTEL\/INTEL'
qemu_bochs_cpu='AMD\/AMD'

#qemu
#qemu_space_replacement="intel "
qemu_space_replacement="amd "

#06\/23\/99
src_misc_bios_table="07\/02\/18"

#04\/01\/2014
src_bios_table_date2="11\/03\/2018"

#01\/01\/2011
src_fw_smbios_date="11\/03\/2018"

# what to use as a replacement for QEMU in the tablet info
PEN_REPLACER='<WOOT>'

# what to use as a replacement for QEMU in the scsi disk info
SCSI_REPLACER='<WOOT>'

# what to use as a replacement for QEMU in the atapi disk info
ATAPI_REPLACER='<WOOT>'

# what to use as a replacement for QEMU in the microdrive info
MICRODRIVE_REPLACER='<WOOT>'

# what to use as a replacement for QEMU in bochs in drive info
BOCHS_BLOCK_REPLACER='<WOOT>'
BOCHS_BLOCK_REPLACER2='<WOOT>'
BOCHS_BLOCK_REPLACER3='<WOOT>'

# what to use as a replacement for BXPC in bochs in ACPI info
BXPC_REPLACER='<WOOT>'


function _sed_aux(){
    # pattern path error_msg
    if [ -f "$2" ] && ! sed -i "$1" "$2"; then
        echo "$3"
    fi
}

function replace_qemu_clues_public() {
    echo '[+] Patching QEMU clues'
    _sed_aux "s/QEMU HARDDISK/$qemu_hd_replacement/g" qemu*/hw/ide/core.c 'QEMU HARDDISK was not replaced in core.c'
    _sed_aux "s/QEMU HARDDISK/$qemu_hd_replacement/g" qemu*/hw/scsi/scsi-disk.c 'QEMU HARDDISK was not replaced in scsi-disk.c'
    _sed_aux "s/QEMU DVD-ROM/$qemu_dvd_replacement/g" qemu*/hw/ide/core.c 'QEMU DVD-ROM was not replaced in core.c'
    _sed_aux "s/QEMU DVD-ROM/$qemu_dvd_replacement/g" qemu*/hw/ide/atapi.c 'QEMU DVD-ROM was not replaced in atapi.c'
    _sed_aux "s/QEMU PenPartner tablet/$PEN_REPLACER PenPartner tablet/g" qemu*/hw/usb/dev-wacom.c 'QEMU PenPartner tablet'
    _sed_aux 's/s->vendor = g_strdup("QEMU");/s->vendor = g_strdup("'"$SCSI_REPLACER"'");/g' qemu*/hw/scsi/scsi-disk.c 'Vendor string was not replaced in scsi-disk.c'
    _sed_aux "s/QEMU CD-ROM/$qemu_dvd_replacement/g" qemu*/hw/scsi/scsi-disk.c 'Vendor string was not replaced in scsi-disk.c'
    _sed_aux 's/padstr8(buf + 8, 8, "QEMU");/padstr8(buf + 8, 8, "'"$ATAPI_REPLACER"'");/g'  qemu*/hw/ide/atapi.c 'padstr was not replaced in atapi.c'
    _sed_aux 's/QEMU MICRODRIVE/'"$MICRODRIVE_REPLACER"' MICRODRIVE/g' qemu*/hw/ide/core.c 'QEMU MICRODRIVE was not replaced in core.c'
    _sed_aux "s/KVMKVMKVM\\0\\0\\0/$hypervisor_string_replacemnt/g" qemu*/target/i386/kvm.c 'KVMKVMKVM was not replaced in kvm.c'
    _sed_aux 's/"bochs"/"'"$BOCHS_BLOCK_REPLACER"'"/g' qemu*/block/bochs.c 'BOCHS was not replaced in block/bochs.c'
    _sed_aux 's/"BOCHS "/"ALASKA"/g' qemu*/include/hw/acpi/aml-build.h 'BOCHS was not replaced in block/bochs.c'
    _sed_aux 's/Bochs Pseudo/Intel RealTime/g' qemu*/roms/ipxe/src/drivers/net/pnic.c 'Bochs Pseudo was not replaced in roms/ipxe/src/drivers/net/pnic.c'
}

function replace_seabios_clues_public() {
    echo "[+] Generating SeaBios Kconfig"
    echo "[+] Fixing SeaBios antivms"
    _sed_aux 's/Bochs/DELL/g' src/config.h 'Bochs was not replaced in src/config.h'
    _sed_aux "s/BOCHSCPU/$bochs_cpu_replacement/g" src/config.h 'BOCHSCPU was not replaced in src/config.h'
    _sed_aux 's/"BOCHS "/"DELL"/g' src/config.h 'BOCHS was not replaced in src/config.h'
    _sed_aux 's/BXPC/DELL/g' src/config.h 'BXPC was not replaced in src/config.h'
    _sed_aux "s/QEMU\/Bochs/$qemu_bochs_cpu/g" vgasrc/Kconfig 'QEMU\/Bochs was not replaced in vgasrc/Kconfig'
    _sed_aux "s/qemu /$qemu_space_replacement/g" vgasrc/Kconfig 'qemu was not replaced in vgasrc/Kconfig'
    _sed_aux "s/06\/23\/99/$src_misc_bios_table/g" src/misc.c 'change seabios date 1'
    _sed_aux "s/04\/01\/2014/$src_bios_table_date2/g" src/fw/biostables.c 'change seabios date 2'
    _sed_aux "s/01\/01\/2011/$src_fw_smbios_date/g" src/fw/smbios.c 'change seabios date 3'
    _sed_aux 's/"SeaBios"/"AMIBios"/g' src/fw/biostables.c 'change seabios to amibios'

    FILES=(
        src/hw/blockcmd.c
        #src/fw/paravirt.c
    )
    for file in "${FILES[@]}"; do
        _sed_aux 's/"QEMU"/"'"$BOCHS_BLOCK_REPLACER2"'"/g' "$file" "QEMU was not replaced in $file"
    done

    _sed_aux 's/"QEMU"/"'"$BOCHS_BLOCK_REPLACER3"'"/g' src/hw/blockcmd.c '"QEMU" was not replaced in  src/hw/blockcmd.c'

    FILES=(
        "src/fw/acpi-dsdt.dsl"
        "src/fw/q35-acpi-dsdt.dsl"
    )
    for file in "${FILES[@]}"; do
        _sed_aux 's/"BXPC"/"'"$BXPC_REPLACER"'"/g' "$file" "BXPC was not replaced in $file"
    done
    _sed_aux 's/"BXPC"/"AMPC"/g' "src/fw/ssdt-pcihp.dsl" 'BXPC was not replaced in src/fw/ssdt-pcihp.dsl'
    _sed_aux 's/"BXDSDT"/"AMDSDT"/g' "src/fw/ssdt-pcihp.dsl" 'BXDSDT was not replaced in src/fw/ssdt-pcihp.dsl'
    _sed_aux 's/"BXPC"/"AMPC"/g' "src/fw/ssdt-proc.dsl" 'BXPC was not replaced in "src/fw/ssdt-proc.dsl"'
    _sed_aux 's/"BXSSDT"/"AMSSDT"/g' "src/fw/ssdt-proc.dsl" 'BXSSDT was not replaced in src/fw/ssdt-proc.dsl'
    _sed_aux 's/"BXPC"/"AMPC"/g' "src/fw/ssdt-misc.dsl" 'BXPC was not replaced in src/fw/ssdt-misc.dsl'
    _sed_aux 's/"BXSSDTSU"/"AMSSDTSU"/g' "src/fw/ssdt-misc.dsl" 'BXDSDT was not replaced in src/fw/ssdt-misc.dsl'
    _sed_aux 's/"BXSSDTSUSP"/"AMSSDTSUSP"/g' src/fw/ssdt-misc.dsl 'BXSSDTSUSP was not replaced in src/fw/ssdt-misc.dsl'
    _sed_aux 's/"BXSSDT"/"AMSSDT"/g' src/fw/ssdt-proc.dsl 'BXSSDT was not replaced in src/fw/ssdt-proc.dsl'
    _sed_aux 's/"BXSSDTPCIHP"/"AMSSDTPCIHP"/g' src/fw/ssdt-pcihp.dsl 'BXPC was not replaced in src/fw/ssdt-pcihp.dsl'

    FILES=(
        src/fw/q35-acpi-dsdt.dsl
        src/fw/acpi-dsdt.dsl
        src/fw/ssdt-misc.dsl
        src/fw/ssdt-proc.dsl
        src/fw/ssdt-pcihp.dsl
        src/config.h
    )
    for file in "${FILES[@]}"; do
        _sed_aux 's/"BXPC"/"A M I"/g' "$file" "BXPC was not replaced in $file"
    done
}
