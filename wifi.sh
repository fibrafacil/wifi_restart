#!/usr/bin/bash
exec >>/storage/scripts/wifi.log

data=$(date "+%A %d/%m/%Y %H:%M:%S")
echo "${data} : Checando estado da conexao"
rede=$(connmanctl services | grep "*" | awk '{print $2}')

if ! ping -c2 8.8.8.8 > /dev/null && ! ping -c2 8.8.4.4 > /dev/null; then

	echo "${data} : Sem acesso a internet"
	ifconfig wlan0 down
	echo "${data} : Desativou wlan0"
	sleep 10
	echo "${data} : Aguardou 10 segundos"
	ifconfig wlan0 up
	echo "${data} : Ativou wlan0"
	sleep 30
	echo "${data} : Aguardou 30 segundos"
	wlan=$(connmanctl state | grep State | awk '{print $3}' | sed 's/ //g')
	echo "${data} : Estado da conexao: ${wlan}"

	if [[ "${wlan}" != "online" ]]
	then
		redes_disponiveis=$(connmanctl services | awk '{print $1" "$2}')
		echo "${data} : Redes disponiveis => ${redes_disponiveis}"

		echo "${data} : Reconectando a rede ${rede}..."
		connmanctl connect wifi_d83addc8e2a8_534550502d50524f46_managed_psk
		wlan=$(connmanctl state | grep State | awk '{print $3}' | sed 's/ //g')
		
		if [[ "${wlan}" == "online" ]]
		then
			echo "${data} : Rede ${rede}: ${wlan}"
			echo "${data} : Executou $0"
			exit 0
		else
			echo "${data} : Rede ${rede}: ${wlan}"
			echo "${data} : Executou $0"
			exit 0
		fi
	fi
fi

wlan=$(connmanctl state | grep State | awk '{print $3}' | sed 's/ //g')
echo "${data} : Rede ${rede}: ${wlan}"
echo "${data} : Executou $0"

exit 0
