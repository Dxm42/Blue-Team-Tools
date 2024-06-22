#!/bin/bash
# by - Dxmostacero
# Confira meus repositórios onde estarei postando mais scripts. 
# -> github.com/Dxm42
# Programa criado para fins educacionais, utilize com cautela o desenvolvedor não se responsabiliza por uso indevido de terceiros.
# Criei esse Script no momento em que estava sem Internet, utilizei alguns programas para realizar teste como se fosse um atacante na vida real, programas que utilizei para simular ataques entre eles "nmap, nikto, ffuf, dirb, dirbuster"
# Programa utilizado para realizar uma filtragem rápida dos logs do servidor apache, que encontra se no diretório "/var/log/apache2/access.log".

if [ "$1" == "" ]; then
	echo "Modo de uso $0"
	exit
else
	echo ""
	echo -e "\033[1;32m      _/_/                        _/"
	echo "   _/    _/  _/_/_/      _/_/_/  _/  _/    _/  _/_/_/_/    _/_/    _/  _/_/       "
	echo "  _/_/_/_/  _/    _/  _/    _/  _/  _/    _/      _/    _/_/_/_/  _/_/            "
	echo " _/    _/  _/    _/  _/    _/  _/  _/    _/    _/      _/        _/               "
	echo "_/    _/  _/    _/    _/_/_/  _/    _/_/_/  _/_/_/_/    _/_/_/  _/                "
	echo "                                       _/                                         "
	echo -e "                                   _/_/  \033[0m  v1.7 \n\t\t\t\t\t\t By - Dxmostacero"

	declare -r STEPS=('step1' 'step2' 'step3' 'step4' 'step5')
	declare -r MAX_STEPS=${#STEPS[@]}
	declare -r BAR_SIZE="##########################################################################"
	declare -r MAX_BAR_SIZE=${#BAR_SIZE}

	echo -e "\n\n"
	for step in "${!STEPS[@]}"; do
        	perc=$(((step + 1) * 100 / MAX_STEPS))
       		percBar=$((perc * MAX_BAR_SIZE / 100))
        
	        sleep 1
        	echo -ne "\033[0;35m \\r[${BAR_SIZE:0:percBar}] $perc % \033[0m"

	done

	cat "$1"  >> analyzer.log

	access=$(cat analyzer.log | wc -l)

	echo -e " \033[0;32m \n\n Quantidade de Requisições que o Host Recebeu: \033[0m  $access "
	sleep 3

	echo -e " \033[0;32m \n\n Serviços que Acessaram a Aplicação: \033[0m "
	servicos=$(cat analyzer.log | cut -d " " -f 13-18 | uniq -c | sort -u)
	echo " "
	echo "$servicos"

	sleep 3

	$(cat analyzer.log | cut -d " " -f7-8 | cut -d " " -f1 | sort -u | grep -v http >> payloads.txt)
	echo " "
	echo -e " \033[0;32m \n\n Foi Criado Lista com o Total de  Payloads Utilizados no Ataque com: \033[0m $(cat payloads.txt | wc -l)"
	echo " "

	userAgent=$(cat analyzer.log | head -10 | cut -d " " -f12-18 | sort -u);

	echo -e " \033[0;32m \n\n Top 10 UsersAgentes Utilizados: \n \033[0m "

	echo " $userAgent"
	echo " "

	sleep 3

	echo -e " \033[0;32m    \n\n  IP - Data - Hora ->  Dos 20 Maiores Acessos a Aplicação: \n  \033[0m"
	topAccess=$(cat analyzer.log | cut -d " " -f1-5 | uniq -c | sort -u | tail -20);
	echo "$topAccess"

	echo -e " \033[0;32m \n\n Todos os IPs que Acessaram a Aplicação: \n\n  \033[0m "
	acces_ips=$(cat analyzer.log | cut -d " " -f1 | uniq -c | sort -u)
	echo "$acces_ips"

	echo -e " \033[1;33m \n\n Digite o IP para Verificar Qual foi o Primeiro e Ultimo Acesso no Host \n  \033[0m"
	#echo -e " \033[0;32m  Digite o IP: \n  \033[0m"
	read ip

	cat analyzer.log | cut -d " " -f1 | sort -u >> ipList

	for i in $(cat ipList)
	do
	if [ "$ip" == "$i" ]; then
		
		echo -e " \033[0;32m \n Primeiro Acesso:  \033[0m $i \n"
		cat analyzer.log | grep $i | head -n1
		echo -e " \033[0;32m \n Ultimo Acesso:  \033[0m $i \n"
		cat analyzer.log | grep $i | tail -n1
	
		echo -e " \033[0;32m \n Todas as Requisiçoes Unicas Acessadas pelo IP:   \033[0m $i \n"
		
		sleep 4
		echo -e "\033[0;32m Salvo no Arquivo:\033[0m reqUniq"
		cat analyzer.log | grep $i | cut -d '"' -f2 | sort -u | uniq -c > reqUniq

		echo -e " \033[0;32m \n\n Verificando as Requisições com o Status 200 do IP: \033[0m $i \n"


		echo -e "\033[0;32m Salvo no Arquivo:\033[0m req200"
		cat analyzer.log | grep $i | cut -d "]" -f2 | grep " 200" > req200
	
		echo -e " \033[1;33m \n\n Quer Verificar o Acesso por um Determinado Programa Digite\033[0m s/n"
		read resp
	
		case $resp in
	
		"s")
			apps=$(cat analyzer.log | cut -d ";" -f2 | cut -d " " -f2 | sort -u > app.log)
			
			echo -e " \033[1;33m \n\n Digite o Nome do Programa que você Deseja Verificar\033[0m \n"
			read respApp

			for j in $(cat app.log)
			do
				if [ "$respApp" == "$j" ];
				then
					echo ""

					head -10 analyzer.log | grep $i  | grep $j
					echo -e " \033[0;32m \n\n Primeira Ocorrencia \033[0m $j\n"
					cat analyzer.log | grep $i | grep $j | head -n1
					echo -e " \033[0;32m \n\n Ultima Ocorrencia \033[0m $j\n"
					cat analyzer.log | grep $i | grep $j | tail -n1

					sleep 5
					break
				fi
			done
			echo -e " \033[1;31m \n\n Caso o Nome do Programa Digitado não Apareça foi criado uma Lista com o Nome 'app.log' Contendo Todos os Nomes de Programas Utilizados\033[0m \n"

		;;
		"n")
			break
		;;
		esac

		break
	else

		echo -e " \033[1;31m \n O IP digitado não  contsta no arquivo de log: \033[0m $ip"
		break
	fi
	done

rm ipList
rm analyzer.log
fi

exit 0 
