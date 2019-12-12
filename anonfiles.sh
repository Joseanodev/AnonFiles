#!/usr/bin/env bash
#
#
# Autor:	Joseano Sousa
#
# Versão:	v1.0
#
# Data:		01-12-2019
#
#
# Descrição:	Sobe arquivo para AnonFiles.com e gera URL para download
#		Podendo subir arquivo de até 5GB.
#
# Uso:		anonfiles [-fu] [ARQUIVO]

readonly _AUTHOR="Joseano Sousa"
readonly _VERSION=1.0

upload_file_url() {
	file=$OPTARG
	if [[ -a $file ]]; then
		temp_path=$(mktemp -d)
		curl --silent --form "file=@$file" http://api.anonfile.com/upload --output ${temp_path}/info.json
		url=$(jq --raw-output '.data.file.url.short' ${temp_path}/info.json)	
	else
		echo "Erro: o arquivo '${file##*/}' não existe!" && false
	fi
}

while getopts :f:u:Uhv options; do
	case "$options" in
		f)
			if upload_file_url; then
				file_name=$(jq --raw-output '.data.file.metadata.name' ${temp_path}/info.json)
				file_size=$(jq  --raw-output '.data.file.metadata.size.readable' ${temp_path}/info.json)
				echo "Arquivo: [ $file_name ]"
					echo "Tamanho: $file_size"
				echo "URL: $url"
				rm -fr $temp_path
			fi ;;
		u) upload_file_url && echo "$url"; rm -fr $temp_path ;;
		U)
			[[ "$USER" != "root" ]] && echo "Erro: $0 -U deve ser executado como superusuário"; exit 1
			temp_path=$(mktemp -d) && cd $temp_path
			wget --quiet https://raw.githubusercontent.com/Joseanodev/AnonFiles/master/anonfile.sh
			source anonfiles.sh
			if [[ ${_VERSION} != 1.0 ]]; then
				echo "Nova versão disponível..."
				echo "Atualizando..."
				sudo wget --quiet https://raw.githubusercontent.com/Joseanodev/AnonFiles/master/anonfile.sh -O /usr/local/bin/anonfiles
				sudo chmod a+rx /usr/local/bin/anonfiles
				rm $temp_path
			else
				echo "$0 atualizado - v${_VERSION}"
				rm -rf $temp_path
			fi ;;
		h) # Ajuda
			echo "Uso: $0 [-fu] [ARQUIVO]"
			echo -e "\tSobe arquivo para AnonFiles e gera URL para download"
			echo -e "\tPodendo subir arquivo de até 5GB."
			echo -e "\n\tOpções:"
			echo -e "\t-f [ARQUIVO]\tSobe arquivo para AnonFiles e gera informações do URL para download"
			echo -e "\t-u [ARQUIVO]\tSobe arquivo para AnonFiles e gera URL para download"
			echo -e "\t-h\t\tMostra esta ajuda e sai"
			echo -e "\t-v\t\tInforma a versão e sai"
			echo -e "\n\tStatus de saída:"
			echo -e "\tRetorna sucesso, se o ARQUIVO existir; falha, se não existir." ;;
		v) # Versão
			echo "$0 (GPLv3) v${_VERSION}"
			echo "Copyright (C) 2019 - ${AUTHOR}"
			echo "Licença GPLv3+: GNU GPL versão 3 ou posterior <http://gnu.org/licenses/gpl.html>."
			echo -e "\nGitHub:\t\thttps://github.com/Joseanodev/AnonFiles"
			echo -e "Telegram:\t@joseanodev(https://t.me/joseanodev)"
			echo -e "Desenvolvedor:\t${AUTHOR} <joseanodev@gmail.com>"
			echo -e "\nEste é um software livre; você é livre para alterar e redistribuí-lo."
			echo -e "Há NENHUMA GARANTIA, na extensão permitida pela lei." ;;
		':') echo -e "$0: -$OPTARG: requer argumento\nTente \"$0 -h\" para mais informações." && false ;;
		'?') echo -e "$0: -$OPTARG: opção não reconhecida\nTente \"$0 -h\" para mais informações." && false ;;
	esac
done
