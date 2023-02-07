#!/bin/bash
# LIMITADOR AUTO
find /etc/SCRIPT-ELEMENT/temp/RegTimeT -mmin +1440 -type f -delete >/dev/null 2>&1
[[ -e /etc/SCRIPT-ELEMENT/temp/RegTimeT ]] || {
    check_keyoficial() {
        IP=$(wget -qO- ifconfig.me)
        IP2="$IP"
        permited=$(curl -sSL "https://www.dropbox.com/s/a7551062y9ge8bd/RegKeyID")
        [[ $(echo $permited | grep "$IP2") = "" ]] && {
            NOM=$(less /etc/SCRIPT-ELEMENT/temp/idtelegram) >/dev/null 2>&1
            ID=$(echo $NOM) >/dev/null 2>&1
            NOMG=$(less /etc/SCRIPT-ELEMENT/temp/idgrupo) >/dev/null 2>&1
            IDG=$(echo $NOMG) >/dev/null 2>&1
            NOM2=$(less /etc/SCRIPT-ELEMENT/temp/vpstelegram) >/dev/null 2>&1
            VPS=$(echo $NOM2) >/dev/null 2>&1
            KEY="5179637690:AAExt2gHMurxUmuJBdKJ6BCHg-D0Uzlt0rM"
            TIMEOUT="10"
            URL="https://api.telegram.org/bot$KEY/sendMessage"
            SONIDO="0"
            TEXTO="❗═════ *-REGISTRO-* ═════ ❗\n▫️ *>* VPS: *$VPS* \n⚠️ ══ _ KEY BANEADA _ ══ ⚠️"
            #PV
            curl -s --max-time $TIMEOUT -d "parse_mode=Markdown&disable_notification=$SONIDO&chat_id=$ID&disable_web_page_preview=1&text=$(echo -e "$TEXTO")" $URL
            echo "" &>/dev/null
        } || {
            echo "Actulizacion OFF" >/etc/SCRIPT-ELEMENT/temp/RegTimeT
        }
    }
    check_keyoficial &
}

#BACKUP BASE DE USER
backupbase_fun() {
    find /etc/SCRIPT-ELEMENT/backuplog -mtime +7 -type f -delete
    Fecha=$(date +%d-%m-%y-%R)
    rm -rf /etc/SCRIPT-ELEMENT/backuplog/principal/*
    mkdir -p /etc/SCRIPT-ELEMENT/backuplog/principal
    cp /etc/SCRIPT-ELEMENT/cuentassh /etc/SCRIPT-ELEMENT/backuplog/principal/cuentassh
    cp /etc/SCRIPT-ELEMENT/cuentahwid /etc/SCRIPT-ELEMENT/backuplog/principal/cuentahwid
    cp /etc/SCRIPT-ELEMENT/cuentatoken /etc/SCRIPT-ELEMENT/backuplog/principal/cuentatoken
    cd /etc/SCRIPT-ELEMENT/backuplog
    tar -czvf ./Backup-$Fecha.tar.gz principal >/dev/null 2>&1
    cd
}
if [[ "$1" = "backbaseu" ]]; then
    backupbase_fun >/dev/null 2>&1
    exit
fi

msg_reboot() {
    sudo ufw disable >/dev/null 2>&1
    NOM=$(less /etc/SCRIPT-ELEMENT/temp/idtelegram) >/dev/null 2>&1
    ID=$(echo $NOM) >/dev/null 2>&1
    NOMG=$(less /etc/SCRIPT-ELEMENT/temp/idgrupo) >/dev/null 2>&1
    IDG=$(echo $NOMG) >/dev/null 2>&1
    NOM2=$(less /etc/SCRIPT-ELEMENT/temp/vpstelegram) >/dev/null 2>&1
    VPS=$(echo $NOM2) >/dev/null 2>&1
    KEY="5179637690:AAExt2gHMurxUmuJBdKJ6BCHg-D0Uzlt0rM"
    TIMEOUT="10"
    URL="https://api.telegram.org/bot$KEY/sendMessage"
    SONIDO="0"
    TEXTO="❗═════ *-REGISTRO-* ═════ ❗\n▫️ *>* VPS: *$VPS* \n🟢 ═ _ REINICIADA CON EXITO_ ═ 🟢"
    #PV
    curl -s --max-time $TIMEOUT -d "parse_mode=Markdown&disable_notification=$SONIDO&chat_id=$ID&disable_web_page_preview=1&text=$(echo -e "$TEXTO")" $URL
    echo "" &>/dev/null
    #GP
    curl -s --max-time $TIMEOUT -d "parse_mode=Markdown&disable_notification=$SONIDO&chat_id=$IDG &disable_web_page_preview=1&text=$(echo -e "$TEXTO")" $URL
    echo "" &>/dev/null
}
if [[ "$1" = "reboot" ]]; then
    msg_reboot >/dev/null 2>&1
    exit
fi

# LIMITADOR AUTO
msg_login() {
    NOM=$(less /etc/SCRIPT-ELEMENT/temp/idtelegram) >/dev/null 2>&1
    ID=$(echo $NOM) >/dev/null 2>&1
    NOMG=$(less /etc/SCRIPT-ELEMENT/temp/idgrupo) >/dev/null 2>&1
    IDG=$(echo $NOMG) >/dev/null 2>&1
    NOM2=$(less /etc/SCRIPT-ELEMENT/temp/vpstelegram) >/dev/null 2>&1
    VPS=$(echo $NOM2) >/dev/null 2>&1
    KEY="5179637690:AAExt2gHMurxUmuJBdKJ6BCHg-D0Uzlt0rM"
    TIMEOUT="10"
    URL="https://api.telegram.org/bot$KEY/sendMessage"
    SONIDO="0"
    TEXTO="❗═════ *-REGISTRO-* ═════ ❗\n▫️ *>* VPS: *$VPS* \n▫️ *>* EN IP: $(echo $SSH_CLIENT | awk '{ print $1}')\n⚠️ ═ _ LOGIN ROOT DETECTADO_ ═ ⚠️"
    curl -s --max-time $TIMEOUT -d "parse_mode=Markdown&disable_notification=$SONIDO&chat_id=$ID&disable_web_page_preview=1&text=$(echo -e "$TEXTO")" $URL
    echo "" &>/dev/null
    #GP
    curl -s --max-time $TIMEOUT -d "parse_mode=Markdown&disable_notification=$SONIDO&chat_id=$IDG &disable_web_page_preview=1&text=$(echo -e "$TEXTO")" $URL
    echo "" &>/dev/null
}
if [[ "$1" = "login" ]]; then
    msg_login >/dev/null 2>&1
    exit
fi

# REINICIO DE SERVICE
reset_service() {
    service dropbear stop &>/dev/null
    service ssh restart &>/dev/null
    service dropbear restart &>/dev/null
}
if [[ "$1" = "service" ]]; then
    reset_service >/dev/null 2>&1
    exit
fi

#---------------------------AUTO INICIO---------------------------#
# REINICIO DE BADVPN
reset_badvpn() {
    portasx=$(cat /etc/SCRIPT-ELEMENT/PortM/Badvpn.log)
    totalporta=($portasx)
    for ((i = 0; i < ${#totalporta[@]}; i++)); do
        screen -dmS badvpn /bin/badvpn-udpgw --listen-addr 127.0.0.1:${totalporta[$i]} --max-clients 1000 --max-connections-for-client 10
    done
}
if [[ "$1" = "resetbadvpn" ]]; then
    reset_badvpn >/dev/null 2>&1
    exit
fi

# AUTO WEBSOKET
reset_psoket() {
    for portdic in $(cat /etc/SCRIPT-ELEMENT/PortM/PDirect.log); do
        screen -dmS pydic-"$portdic" python /etc/SCRIPT-ELEMENT/filespy/PDirect-$portdic.py
    done
}
if [[ "$1" = "resetwebsocket" ]]; then
    reset_psoket >/dev/null 2>&1
    exit
fi

# AUTO MONITOR PROTO
resetprotos_fun() {
    tiemmoni=$(cat /etc/SCRIPT-ELEMENT/temp/T-Mon)
    screen -dmS monitorproto watch -n $tiemmoni /etc/SCRIPT-ELEMENT/menu.sh "monitorservi"
}
if [[ "$1" = "resetprotos" ]]; then
    resetprotos_fun >/dev/null 2>&1
    exit
fi

# AUTO LIMITADOR
resetlimitador_fun() {
    tiemlim=$(cat /etc/SCRIPT-ELEMENT/temp/T-Lim)
    screen -dmS limitador watch -n $tiemlim /etc/SCRIPT-ELEMENT/menu.sh "verificar"
}
if [[ "$1" = "resetlimitador" ]]; then
    resetlimitador_fun >/dev/null 2>&1
    exit
fi

# AUTO DESBLOQUEO
resetdesbloqueador_fun() {
    tiemdes=$(cat /etc/SCRIPT-ELEMENT/temp/T-Des)
    screen -dmS desbloqueador watch -n $tiemdes /etc/SCRIPT-ELEMENT/menu.sh "desbloqueo"
}
if [[ "$1" = "resetdesbloqueador" ]]; then
    resetdesbloqueador_fun >/dev/null 2>&1
    exit
fi

#---------------------------MONITOR DE PROTOCOLOS---------------------------#
#--AVISO DE SERVIDOR

msg_service() {
    NOM=$(less /etc/SCRIPT-ELEMENT/temp/idtelegram) >/dev/null 2>&1
    ID=$(echo $NOM) >/dev/null 2>&1
    NOMG=$(less /etc/SCRIPT-ELEMENT/temp/idgrupo) >/dev/null 2>&1
    IDG=$(echo $NOMG) >/dev/null 2>&1
    NOM2=$(less /etc/SCRIPT-ELEMENT/temp/vpstelegram) >/dev/null 2>&1
    VPS=$(echo $NOM2) >/dev/null 2>&1
    KEY="5179637690:AAExt2gHMurxUmuJBdKJ6BCHg-D0Uzlt0rM"
    TIMEOUT="10"
    URL="https://api.telegram.org/bot$KEY/sendMessage"
    SONIDO="0"
    TEXTO="❗═ *- FALLA DETECTADA -*═ ❗\n⚙️ _ -- $1 REINICIADO --_ ⚙️ \n▫️ *>* EN VPS: *$VPS* "
    curl -s --max-time $TIMEOUT -d "parse_mode=Markdown&disable_notification=$SONIDO&chat_id=$ID&disable_web_page_preview=1&text=$(echo -e "$TEXTO")" $URL
    echo "" &>/dev/null
    #GP
    curl -s --max-time $TIMEOUT -d "parse_mode=Markdown&disable_notification=$SONIDO&chat_id=$IDG &disable_web_page_preview=1&text=$(echo -e "$TEXTO")" $URL
    echo "" &>/dev/null
}

#--- REINICIAR SSH
reset_ssh() {

    # BACKUP DIARIO
    find /etc/SCRIPT-ELEMENT/temp/BackTotal -mmin +1440 -type f -delete >/dev/null 2>&1
    [[ -e /etc/SCRIPT-ELEMENT/temp/BackTotal ]] || {

        rm -rf /root/Backup-element.tar.gz >/dev/null 2>&1
        mkdir /root/backup-element/
        export UGIDLIMIT=1000
        awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/passwd >/root/backup-element/passwd.mig
        awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/group >/root/backup-element/group.mig
        awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534) {print $1}' /etc/passwd | tee - | egrep -f - /etc/shadow >/root/backup-element/shadow.mig
        cp /etc/gshadow /root/backup-element/gshadow.mig >/dev/null 2>&1
        cp /etc/SCRIPT-ELEMENT/cuentassh /root/backup-element/cuentassh >/dev/null 2>&1
        cp /etc/SCRIPT-ELEMENT/cuentahwid /root/backup-element/cuentahwid >/dev/null 2>&1
        cp /etc/SCRIPT-ELEMENT/cuentatoken /root/backup-element/cuentatoken >/dev/null 2>&1
        cp /etc/SCRIPT-ELEMENT/temp/.passw /root/backup-element/.passw >/dev/null 2>&1
        tar -zcvpf /root/backup-element/home.tar.gz /home >/dev/null 2>&1
        cd /root
        tar -czvf Backup-element.tar.gz backup-element >/dev/null 2>&1

        NOM=$(less /etc/SCRIPT-ELEMENT/temp/idtelegram) >/dev/null 2>&1
        ID=$(echo $NOM) >/dev/null 2>&1
        NOMG=$(less /etc/SCRIPT-ELEMENT/temp/idgrupo) >/dev/null 2>&1
        IDG=$(echo $NOMG) >/dev/null 2>&1
        NOM2=$(less /etc/SCRIPT-ELEMENT/temp/vpstelegram) >/dev/null 2>&1
        VPS=$(echo $NOM2) >/dev/null 2>&1
        KEY="5179637690:AAExt2gHMurxUmuJBdKJ6BCHg-D0Uzlt0rM"
        TIMEOUT="10"
        URL="https://api.telegram.org/bot$KEY/sendMessage"
        SONIDO="0"
        TEXTO="❗═════ *-REGISTRO-* ═════ ❗\n▫️ *>* VPS: *$VPS* \n⚠️ ══ _ BACKUP DIARIO _ ══ ⚠️"
        #DOCL
        Fecha=$(date +%d-%m-%y)
        URL2="https://api.telegram.org/bot$KEY/sendDocument"
        FILE="/root/backup-element/Backup-Element.tar.gz"
        curl --fail -F chat_id="$ID" -F caption="$VPS | Fecha: $Fecha" -F document=@"$FILE" $URL2 --connect-timeout 0
        echo "" &>/dev/null
        echo "Backup Diario Activo | $Fecha " >/etc/SCRIPT-ELEMENT/temp/BackTotal
    } &>/dev/null

    SSH=$(ps x | grep "/usr/sbin/sshd" | grep -v "grep" | awk -F "pts" '{print $1}')
    if [[ ! $SSH ]]; then
        service ssh restart
        msg_service SSH
    else
        echo "ok"
    fi
}
if [[ "$1" = "resetssh" ]]; then
    reset_ssh >/dev/null 2>&1
    exit
fi

#--- REINICIAR SSL
reset_ssl() {
    SSL=$(ps x | grep "stunnel4" | grep -v "grep" | awk -F "pts" '{print $1}')
    if [[ ! $SSL ]]; then
        service stunnel4 restart
        msg_service SSL
    else
        echo "ok"
    fi
}
if [[ "$1" = "resetssl" ]]; then
    reset_ssl >/dev/null 2>&1
    exit
fi

#--- REINICIAR DROPBEAR
reset_drop() {
    DROPBEAR=$(ps x | grep "/usr/sbin/dropbear" | grep -v "grep" | awk -F "pts" '{print $1}')
    if [[ ! $DROPBEAR ]]; then
        sed -i "s/=1/=0/g" /etc/default/dropbear
        service dropbear restart
        sed -i "s/=0/=1/g" /etc/default/dropbear
        #msg_service DROPBEAR
    else
        echo "ok"
    fi
}
if [[ "$1" = "resetdropbear" ]]; then
    reset_drop >/dev/null 2>&1
    exit
fi

#--- REINICIAR SQUID
reset_squid() {
    SQUID=$(ps x | grep "/usr/sbin/squid" | grep -v "grep" | awk -F "pts" '{print $1}')
    if [[ ! $SQUID ]]; then
        service squid restart
        msg_service SQUID
    else
        echo "ok"
    fi
}
if [[ "$1" = "resetsquid" ]]; then
    reset_squid >/dev/null 2>&1
    exit
fi

#--- REINICIAR APACHE
reset_apache() {
    APACHE=$(ps x | grep "apache" | grep -v "grep" | awk -F "pts" '{print $1}')
    if [[ ! $APACHE ]]; then
        service apache2 restart
        msg_service APACHE
    else
        echo "ok"
    fi
}
if [[ "$1" = "resetapache" ]]; then
    reset_apache >/dev/null 2>&1
    exit
fi

#--- REINICIAR V2RAY
reset_v2ray() {
    V2RAY=$(ps x | grep "v2ray" | grep -v "grep" | awk -F "pts" '{print $1}')
    if [[ ! $V2RAY ]]; then
        service v2ray restart
        msg_service V2RAY
    else
        echo "ok"
    fi
}
if [[ "$1" = "resetv2ray" ]]; then
    reset_v2ray >/dev/null 2>&1
    exit
fi

#--- REINICIAR WEBSOCKET
reset_websocket() {
    for portdic in $(cat /etc/SCRIPT-ELEMENT/PortM/PDirect.log); do

        WEBSOCKET=$(ps x | grep "pydic-$portdic" | grep -v "grep" | awk -F "pts" '{print $1}')
        if [[ ! $WEBSOCKET ]]; then
            screen -dmS pydic-"$portdic" python /etc/SCRIPT-ELEMENT/filespy/PDirect-$portdic.py
            msg_service WEBSOCKET-$portdic
        else

            echo "ok"
        fi

    done
}
if [[ "$1" = "resetwebp" ]]; then
    reset_websocket >/dev/null 2>&1
    exit
fi

#--- CONTADOR DE SSH TOTAL
ssh_total() {
    mostrar_usuariossh() {
        for u in $(cat /etc/SCRIPT-ELEMENT/cuentassh | cut -d'|' -f1); do
            echo "$u"
        done
    }
    mostrar_usuariohwid() {
        for u in $(cat /etc/SCRIPT-ELEMENT/cuentahwid | cut -d'|' -f1); do
            echo "$u"
        done
    }
    mostrar_usuariotoken() {
        for u in $(cat /etc/SCRIPT-ELEMENT/cuentatoken | cut -d'|' -f1); do
            echo "$u"
        done
    }
    [[ -e "/etc/SCRIPT-ELEMENT/cuentassh" ]] && usuarios_ativos1=($(mostrar_usuariossh))
    [[ -e "/etc/SCRIPT-ELEMENT/cuentahwid" ]] && usuarios_ativos2=($(mostrar_usuariohwid))
    [[ -e "/etc/SCRIPT-ELEMENT/cuentatoken" ]] && usuarios_ativos3=($(mostrar_usuariotoken))
    for us in $(echo ${usuarios_ativos1[@]}); do
        echo "${us}"
    done >/etc/SCRIPT-ELEMENT/cuentasactivast
    for us in $(echo ${usuarios_ativos2[@]}); do
        echo "${us}"
    done >>/etc/SCRIPT-ELEMENT/cuentasactivast
    for us in $(echo ${usuarios_ativos3[@]}); do
        echo "${us}"
    done >>/etc/SCRIPT-ELEMENT/cuentasactivast
    mostrar_totales() {
        for u in $(cat /etc/SCRIPT-ELEMENT/cuentasactivast | cut -d'|' -f1); do
            echo "$u"
        done
    }
    SSH="$(wc -l /etc/SCRIPT-ELEMENT/cuentasactivast | awk '{print $1}')"
    SSH2="$(echo ${SSH} | bc)0"
    SSH3="/10"
    echo "${SSH2}${SSH3}" | bc >/etc/SCRIPT-ELEMENT/temp/sshtotal
}
if [[ "$1" = "totallssh" ]]; then
    ssh_total >/dev/null 2>&1
    exit
fi

#---CONTADOR ONLINE
contador_online() {

    mostrar_totales() {
        for u in $(cat /etc/SCRIPT-ELEMENT/cuentasactivast | cut -d'|' -f1); do
            echo "$u"
        done
    }
    dropbear_pids() {
        local pids
        local portasVAR=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep "LISTEN")
        local NOREPEAT
        local reQ
        local Port
        while read port; do
            reQ=$(echo ${port} | awk '{print $1}')
            Port=$(echo {$port} | awk '{print $9}' | awk -F ":" '{print $2}')
            [[ $(echo -e $NOREPEAT | grep -w "$Port") ]] && continue
            NOREPEAT+="$Port\n"
            case ${reQ} in
            dropbear)
                [[ -z $DPB ]] && local DPB=""
                DPB+="$Port "
                ;;
            esac
        done <<<"${portasVAR}"
        [[ ! -z $DPB ]] && echo -e $DPB
        #local port_dropbear="$DPB"
        local port_dropbear=$(ps aux | grep dropbear | awk NR==1 | awk '{print $17;}')
        cat /var/log/auth.log | grep -a -i dropbear | grep -a -i "Password auth succeeded" >/var/log/authday.log
        #cat /var/log/auth.log|grep "$(date|cut -d' ' -f2,3)" > /var/log/authday.log
        #cat /var/log/auth.log | tail -1000 >/var/log/authday.log
        local log=/var/log/authday.log
        local loginsukses='Password auth succeeded'
        [[ -z $port_dropbear ]] && return 1
        for port in $(echo $port_dropbear); do
            for pidx in $(ps ax | grep dropbear | grep "$port" | awk -F" " '{print $1}'); do
                pids="${pids}$pidx\n"
            done
        done
        for pid in $(echo -e "$pids"); do
            pidlogs=$(grep $pid $log | grep "$loginsukses" | awk -F" " '{print $3}')
            i=0
            for pidend in $pidlogs; do
                let i++
            done
            if [[ $pidend ]]; then
                login=$(grep $pid $log | grep "$pidend" | grep "$loginsukses")
                PID=$pid
                user=$(echo $login | awk -F" " '{print $10}' | sed -r "s/'//g")
                waktu=$(echo $login | awk -F" " '{print $2"-"$1,$3}')
                [[ -z $user ]] && continue
                echo "$user|$PID|$waktu"
            fi
        done
    }
    openvpn_pids() {
        mostrar_usuariossh() {
            for u in $(cat /etc/SCRIPT-ELEMENT/cuentassh | cut -d'|' -f1); do
                echo "$u"
            done
        }
        byte() {
            while read B dummy; do
                [[ "$B" -lt 1024 ]] && echo "${B} bytes" && break
                KB=$(((B + 512) / 1024))
                [[ "$KB" -lt 1024 ]] && echo "${KB} Kb" && break
                MB=$(((KB + 512) / 1024))
                [[ "$MB" -lt 1024 ]] && echo "${MB} Mb" && break
                GB=$(((MB + 512) / 1024))
                [[ "$GB" -lt 1024 ]] && echo "${GB} Gb" && break
                echo $(((GB + 512) / 1024)) terabytes
            done
        }
        for user in $(mostrar_usuariossh); do
            user="$(echo $user | sed -e 's/[^a-z0-9 -]//ig')"
            [[ ! $(sed -n "/^${user},/p" /etc/openvpn/openvpn-status.log) ]] && continue
            i=0
            unset RECIVED
            unset SEND
            unset HOUR
            while read line; do
                IDLOCAL=$(echo ${line} | cut -d',' -f2)
                RECIVED+="$(echo ${line} | cut -d',' -f3)+"
                SEND+="$(echo ${line} | cut -d',' -f4)+"
                DATESEC=$(date +%s --date="$(echo ${line} | cut -d',' -f5 | cut -d' ' -f1,2,3,4)")
                TIMEON="$(($(date +%s) - ${DATESEC}))"
                MIN=$(($TIMEON / 60)) && SEC=$(($TIMEON - $MIN * 60)) && HOR=$(($MIN / 60)) && MIN=$(($MIN - $HOR * 60))
                HOUR+="${HOR}h:${MIN}m:${SEC}s\n"
                let i++
            done <<<"$(sed -n "/^${user},/p" /etc/openvpn/openvpn-status.log)"
            RECIVED=$(echo $(echo ${RECIVED}0 | bc) | byte)
            SEND=$(echo $(echo ${SEND}0 | bc) | byte)
            HOUR=$(echo -e $HOUR | sort -n | tail -1)
            echo -e "$user|$i|$RECIVED|$SEND|$HOUR"
        done
    }

    [[ $(dpkg --get-selections | grep -w "openssh" | head -1) ]] && SSH=ON || SSH=OFF
    [[ $(dpkg --get-selections | grep -w "dropbear" | head -1) ]] && DROP=ON || DROP=OFF
    [[ $(dpkg --get-selections | grep -w "openvpn" | head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && OPEN=ON || OPEN=OFF
    while read user; do

        #----CONTADOR DE ONLINES
        PID="0+"
        [[ $SSH = ON ]] && PID+="$(ps aux | grep -v grep | grep sshd | grep -w "$user" | grep -v root | wc -l 2>/dev/null)+"
        [[ $DROP = ON ]] && PID+="$(dropbear_pids | grep -w "$user" | wc -l 2>/dev/null)+"
        [[ $OPEN = ON ]] && [[ $(openvpn_pids | grep -w "$user" | cut -d'|' -f2) ]] && PID+="$(openvpn_pids | grep -w "$user" | cut -d'|' -f2)+"
        ONLINES+="$(echo ${PID}0 | bc)+"
        echo "${ONLINES}0" | bc >/etc/SCRIPT-ELEMENT/temp/Tonli
    done <<<"$(mostrar_totales)"
}
if [[ "$1" = "contadortotal" ]]; then
    contador_online >/dev/null 2>&1
    exit
fi
reset_drop() {
    sed -i "s/=1/=0/g" /etc/default/dropbear
    service dropbear restart
    sed -i "s/=0/=1/g" /etc/default/dropbear

}
if [[ "$1" = "rd" ]]; then
    fun_bar "reset_drop" "FIX BANNER DROPBEAR"
fi

selec_lag() {
    sudo apt-get -y install language-pack-en-base
    export LANGUAGE=en_US.UTF-8 && export LANG=en_US.UTF-8 && export LC_ALL=en_US.UTF-8 && export LC_CTYPE="en_US.UTF-8" &&
        locale-gen en_US.UTF-8
}
if [[ "$1" = "es" ]]; then
    fun_bar "selec_lag" "FIX LEGUAGE"
    sudo dpkg-reconfigure locales
fi