!/bin/bash
#  AO PREENCHER(MOS) ESSE CABEÇALHO COM O(S) MEU(NOSSOS) NOME(S) E
#  O(S) MEU(NOSSOS) NÚMERO(S) USP, DECLARO(AMOS) QUE SOU(MOS) O(S)
#  ÚNICO(S) AUTOR(ES) E RESPONSÁVEL(IS) POR ESSE PROGRAMA. TODAS AS
#  PARTES ORIGINAIS DESSE EXERCÍCIO PROGRAMA (EP) FORAM DESENVOLVIDAS
#  E IMPLEMENTADAS POR MIM(NÓS) SEGUINDO AS INSTRUÇÕES DESSE EP E QUE
#  PORTANTO NÃO CONSTITUEM DESONESTIDADE ACADÊMICA OU PLÁGIO. DECLARO
#  TAMBÉM QUE SOU(MOS) RESPONSÁVEL(IS) POR TODAS AS CÓPIAS DESSE
#  PROGRAMA E QUE EU(NÓS) NÃO DISTRIBUÍ(MOS) OU FACILITEI(AMOS) A SUA
#  DISTRIBUIÇÃO. ESTOU(AMOS) CIENTE(S) QUE OS CASOS DE PLÁGIO E
#  DESONESTIDADE ACADÊMICA SERÃO TRATADOS SEGUNDO OS CRITÉRIOS
#  DIVULGADOS NA PÁGINA DA DISCIPLINA. ENTENDO(EMOS) QUE EPS SEM
#  ASSINATURA NÃO SERÃO CORRIGIDOS E, AINDA ASSIM, PODERÃO SER PUNIDOS
#  POR DESONESTIDADE ACADÊMICA.
#
#  Nome(s) : Débora D'Angelo Reina de Araujo
#	     Eike Souza da Silva
#  NUSP(s) : 11221668
#	     4618653
#
#  Referências: Com exceção das rotinas fornecidas no enunciado e em
#  sala de aula, caso você(s) tenha(m) utilizado alguma referência,
#  liste(m) abaixo para que o programa não seja considerado plágio ou
#  irregular.
# 
#  Exemplo:
#  - O algoritmo Quicksort foi baseado em
#  http://www.ime.usp.br/~pf/algoritmos/aulas/quick.html

# $1 = Usuario
# $2 = Senha
function cria_user {
	POSSO='TRUE'

	SENHA=$(echo "$2" | tr 'A-Za-z' 'N-ZA-Mn-za-m')

	# verifica se o usuário já existe
	for estado in .offline .online; do 
		for user in $(ls /tmp/server/$estado); do
			if [ $1 = $user ]; then
				POSSO='FALSE'
				break
			fi
		done
		if [ $POSSO = 'FALSE' ]; then
			break
		fi
	done

	if [ $POSSO = 'TRUE' ]; then
		echo $SENHA > /tmp/server/.offline/$1
	else
		echo "ERRO"
	fi
}

# $1 = Usuario
# $2 = Senha Antiga
# $3 = Senha Nova
function muda_senha {
	EXISTE='FALSE'
	ESTADO=''
	# verifica se o usuario existe
	for estado in .offline .online; do
		for user in $(ls /tmp/server/$estado); do
			if [ $1 = $user ]; then
				EXISTE='TRUE'
				ESTADO=$estado
				break
			fi
		done
		if [ $EXISTE = 'TRUE' ]; then
			break
		fi
	done
	
	# encripta
	ANTIGA=$(echo $2 | tr 'A-Za-z' 'N-ZA-Mn-za-m')
	NOVA=$(echo $3 | tr 'A-Za-z' 'N-ZA-Mn-za-m')

	# se o usuario existe, verifica se senha antiga está correta
	if [ $EXISTE = 'TRUE' ]; then
		i=0
		dado[0]=''
		dado[1]=''
		while read linha; do
			dado[i]=$linha
			let "i=i+1"
		done < /tmp/server/$ESTADO/$1
		if [ $ANTIGA = ${dado[0]} ]; then
			echo $NOVA > /tmp/server/$ESTADO/$1
			echo ${dado[1]} >> /tmp/server/$ESTADO/$1
		else
			echo "ERRO"
		fi
	else
		echo "ERRO"
	fi 
}

# $1 = Usuario
# $2 = Senha
function login {
	POSSO='FALSE'
	for user in $(ls /tmp/server/.offline); do
		if [ $1 = $user ]; then
			POSSO='TRUE'
		fi
	done
	
	SENHA=$(echo $2 | tr 'A-Za-z' 'N-ZA-Mn-za-m')

	if [ $POSSO = 'TRUE' ]; then
		read dado < /tmp/server/.offline/$1
		if [ $SENHA = $dado ]; then
			mv /tmp/server/.offline/$1 /tmp/server/.online/$1
			echo $SENHA > /tmp/server/.online/$1
			ENDERECO=$(echo $(tty) | tr 'A-Za-z0-9' 'N-ZA-Mn-za-m3-90-2')
			echo $ENDERECO >> /tmp/server/.online/$1
			return 1
		else
			echo "ERRO"
			return 0
		fi
	else
		echo "ERRO"
		return 0
	fi
}

function listar {
	ls /tmp/server/.online | sort > /tmp/server/.clientes.txt
	cat /tmp/server/.clientes.txt
}

USUARIO='VAZIO'
ON='FALSE'
function sair {
	read dado < /tmp/server/.online/$USUARIO
	mv /tmp/server/.online/$USUARIO /tmp/server/.offline/$USUARIO
	echo $dado > /tmp/server/.offline/$USUARIO
	USUARIO='VAZIO'
	ON='FALSE'
}

function cria_server {
	mkdir /tmp/server
	mkdir /tmp/server/.online
	mkdir /tmp/server/.offline
	touch /tmp/server/.clientes.txt
}

if [ $1 = 'servidor' ]; then
	DATAINICIAL=$(date +%s)
	cria_server
fi
while [ $1 = 'servidor' ]; do
	echo -n "servidor> "
	read comando
	if [ $comando = 'time' ]; then
		DATAFINAL=$(date +%s)
		expr $DATAFINAL - $DATAINICIAL
	elif [ $comando = 'quit' ]; then
		rm -r /tmp/server
		break
	elif [ $comando = 'list' ]; then
		listar
	elif [ $comando = 'reset' ]; then
		rm -r /tmp/server
		cria_server
	fi
done
POSSO='FALSE'
while [ $1 = 'cliente' ]; do
		
	echo -n "cliente> "
	read -a comando	
	
	if [ ${comando[0]} = 'quit' ]; then
		if [ $ON = 'TRUE' ]; then
			sair
		fi
		break
	elif [ ${comando[0]} == 'create' ]; then
		cria_user ${comando[1]} ${comando[2]}
	elif [ ${comando[0]} = 'passwd' ]; then
		muda_senha ${comando[1]} ${comando[2]} ${comando[3]}
	elif [ ${comando[0]} = 'login' ]; then
		if [ $ON = 'TRUE' ]; then
			echo "ERRO"
		else
			login ${comando[1]} ${comando[2]}
			if [ $? = 1 ]; then
				ON='TRUE'
				USUARIO=${comando[1]}
			fi
		fi
	elif [ $ON = 'TRUE' ]; then
		if [ ${comando[0]} = 'list' ]; then
			listar
		elif [ ${comando[0]} = 'logout' ]; then
			sair
		elif [ ${comando[0]} = 'msg' ]; then
			POSSO='FALSE'
			for user in $(ls /tmp/server/.online); do
				if [ ${comando[1]} = $user ]; then
					POSSO='TRUE'
					i=0	
					while read linha; do
						dado[i]=$linha;
						let "i=i+1"
					done < /tmp/server/.online/$user
					ENDERECO=$(echo -n ${dado[1]} | tr 'N-ZA-Mn-za-m3-90-2' 'A-Za-z0-9') # decripta tty
					echo -n "[Mensagem de $USUARIO]: " | tr 'A-Za-z' 'N-ZA-Mn-za-m' > /tmp/server/.menssagem # encripta msg
					i=0
					for info in ${comando[@]};  do
						if [ $i -gt 1 ]; then
							echo -n $info | tr 'A-Za-z' 'N-ZA-Mn-za-m' >> /tmp/server/.menssagem # encripta msg
							echo -n " " >> /tmp/server/.menssagem
						fi
						let "i=i+1"
					done
					echo ""  >> /tmp/server/.menssagem
					#ROT13
					cat /tmp/server/.menssagem | tr 'A-Za-z' 'N-ZA-Mn-za-m' >  $ENDERECO #envia a msg decriptada
					rm /tmp/server/.menssagem
					echo -n "cliente> " > $ENDERECO
					break
				fi
			done
			if [ $POSSO = 'FALSE' ]; then
				echo "ERRO"
			fi
		fi
	elif [ $ON = 'FALSE' ]; then
		if [ ${comando[0]} = 'list' ]; then
			echo "ERRO"
		elif [ ${comando[0]} = 'logout' ]; then
			echo "ERRO"
		elif [ ${comando[0]} = 'msg' ]; then
			echo "ERRO"
		fi
	fi
done
