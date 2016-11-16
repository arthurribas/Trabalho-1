#!/bin/bash

#Arthur Ribas
#Orientador: Diego Tumelero
#Escola Alcides Maya

usuario=`id -u`

HEIGHT=15
WIDTH=60
CHOICE_HEIGHT=40
BACKTITLE="Seja bem vindo"
TITLE="Configurar SSH"
MENU="Escolha uma das opcoes:"

while true
do

#Menu de opcoes
	OPTIONS=(1 "Instalar SSH"
       		 2 "Conectar a outra maquina"
        	3 "Sair")

	CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" --stdout\
                )

	clear
	case $CHOICE in
        	
#opcao 1 instala servidor SSH
		1)
			if [ $usuario -eq 0 ]
			then
				apt-get update 2>&1 | tee -a /tmp/temp.txt
				nome=$( dialog --stdout --inputbox 'Digite o nome do pacote debian do ssh server:' 10 60 )
				if [ -n "$nome" ]
				then
					apg-get -y install $nome 2>&1 | tee -a /tmp/temp.txt
					sed -i "s/Port 22/Port 10000/g" /etc/ssh/sshd_config 2>&1 >> /tmp/temp.txt
					service sshd restart 2>&1 | tee -a /tmp/temp.txt
				else
					dialog --title 'Saida dos comandos' --msgbox "Voce nao digitou o IP..." 10 60
				fi
			else
				sudo apt-get update 2>&1 | tee -a /tmp/temp.txt
				nome=$( dialog --stdout --inputbox 'Digite o nome do pacote debian do ssh server:' 10 60 )
				if [ -n "$nome" ]
				then
					sudo apt-get -y install $nome 2>&1 | tee -a /tmp/temp.txt
					sudo sed -i "s/Port 22/Port 10000/g" /etc/ssh/sshd_config 2>&1 >> /tmp/temp.txt
					sudo service sshd restart 2>&1 | tee -a /tmp/temp.txt
				else
					dialog --title 'Saida dos comandos' --msgbox "Voce nao digitou o nome do pacote..." 10 60	
				fi
			fi
			clear
			dialog --title 'Saida dos comandos' --textbox /tmp/temp.txt 20 60
			rm -f /tmp/temp/txt
            		;;

#Opcao 2 conecta em uma outra maquina 
        	2)
			nome=$( dialog --stdout --inputbox 'Digite o nome do usuario da maquina do colega:' 10 60 )
			if [ -n "$nome" ]
			then
				ip=$( dialog --stdout --inputbox 'Digite o IP da maquina do colega:' 10 60 )
				if [ -n "$ip" ]
				then
					ssh $nome@$ip
				else
					dialog --title 'Saida dos comandos' --msgbox "Voce nao digitou o IP..." 10 60
				fi
			else
				dialog --title 'Saida dos comandos' --msgbox "Voce nao digitou o nome..." 10 60
			fi
            		;;

#Sai do menu de opcoes e encerra script
        	3)
			break
            		;;
        	*)
			break
            		;;
	esac
done

exit 0
