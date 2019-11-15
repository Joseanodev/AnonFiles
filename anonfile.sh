#!/usr/bin/env bash
#
# Script: anonfile.sh
#
#---------------------------------------------------------------------------------
#
# Descrição
#
#	Sobe arquivo para AnonFiles.com e gera URL para download
#	Podendo subir arquivo de até 5GB.
#
#
# Informações do Desenvolvedor
#
#	Desenvolvedor:		Joseano Sousa <joseanodev@gmail.com>
#	Telegram:		@joseanodev(https://t.me/joseanodev)
#	GitHub:			https://github.com/Joseanodev/AnonFiles
#
#
#---------------------------------------------------------------------------------

function upload_file_url_info { # Obtém informações de URL do arquivo
	file="$OPTARG" # Atribui e armazena argumento da opção
	if [ -a "$file" ]; then # Executa se arquivo existir
		path_temp=$(mktemp -d) # Cria e armazena diretório temporário
		# Sobe arquivo para AnonFiles e grava retorno JSON em arquivo
		curl --form "file=@$file" http://api.anonfile.com/upload -o $path_temp/info.json 1> /dev/null
		cd $path_temp # Altera para diretório temporário
		url=$(jq -r '.data.file.url.short' info.json) # Atribui e armazena URL para download
		file_size=$(jq -r '.data.file.metadata.size.readable' info.json) # Atribui e armazena tamanho do arquivo
		echo "Arquivo: [ ${file##*/} ]" # Ecoa nome do arquivo
		echo "Tamanho: $file_size" # Ecoa tamanho do arquivo
		echo "URL para download: $url" # Ecoa URL para download
		rm -r $path_temp && return 0 # Deleta diretório temporário e retorna status 0
	else # Executa se arquivo não existir
		echo "Erro: o arquivo '${file##*/}' não existe!" && return 1 # Ecoa mensagem de erro e retorna status 1
	fi
}

function upload_file_url { # Obtém URL do arquivo
	file="$OPTARG" # Atribui e armazena argumento da opção
	if [ -a "$file" ]; then # Executa se arquivo existir
		path_temp=$(mktemp -d) # Cria e armazena diretório temporário
		# Sobe arquivo para AnonFiles e grava retorno JSON em arquivo
		curl --form "file=@$file" http://api.anonfile.com/upload -o $path_temp/info.json &> /dev/null
		cd $path_temp # Altera para diretório temporário
		url=$(jq -r '.data.file.url.short' info.json) # Atribui e armazena URL para download
		echo "$url" # Ecoa URL para download
		rm -r $path_temp && return 0 # Deleta diretório temporário e retorna status 0
	else # Executa se arquivo não existir
		echo "Erro: o arquivo '${file##*/}' não existe!" && return 1 # Exibe mensagem de erro e retorna status 1
	fi
}

# Mensagem de argumento
function argument_message { echo -e "bash: -$OPTARG: requer argumento\nTente \"anonfile -h\" para mais informações." && return 1; }

# Mensagem de opção
function option_message { echo -e "bash: -$OPTARG: opção inválida\nTente \"anonfile -h\" para mais informações." && return 1; }

# Analisando opções
while getopts :f:u:hv options; do
	case "$options" in
		f) upload_file_url_info ;; # Sobe arquivo para AnonFiles e retorna informações do URL do arquivo
		u) upload_file_url ;; # Sobe arquivo para AnonFiles e retorna URL
		h) # Ajuda
			echo 'Uso: anonfile [-f] [ARQUIVO]'
			echo -e '\tSobe arquivo para AnonFiles e gera URL para download'
			echo -e '\tpodendo subir arquivo de até 5GB.'
			echo -e '\n\tOpções:'
			echo -e '\t-f [ARQUIVO]\tSobe arquivo para AnonFiles e gera informações do URL para download'
			echo -e '\t-u [ARQUIVO]\tSobe arquivo para AnonFiles e gera URL para download'
			echo -e '\t-h\t\tmostra esta ajuda e sai'
			echo -e '\t-v\t\tinforma a versão e sai'
			echo -e '\n\tStatus de saída:'
			echo -e '\tRetorna sucesso, se o ARQUIVO for encontrado; falha, se não for encontrado.'
		;;
		v) # Versão
			echo -e "anonfile (GPLv3) v1.0"
			echo -e 'Copyright (C) 2019 Free Software Foundation, Inc.'
			echo -e 'Licença GPLv3+: GNU GPL versão 3 ou posterior <http://gnu.org/licenses/gpl.html>.\n'
			echo -e 'GitHub:\t\thttps://github.com/Joseanodev/AnonFiles'
			echo -e 'Telegram:\t@joseanodev(https://t.me/joseanodev)'
			echo -e 'Desenvolvedor:\tJoseano Sousa <joseanodev@gmail.com>'
			echo -e '\nEste é um software livre; você é livre para alterar e redistribuí-lo.'
			echo -e 'Há NENHUMA GARANTIA, na extensão permitida pela lei.'
		;;
		:) argument_message ;; # Mensagem de requerimento de argumento
		*) option_message ;; # Mensagem de opções inválidas
	esac
done
# FIM