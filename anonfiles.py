#!/usr/bin/env python3  
#
#   Program:        anonfiles.py
#
#   Author:         Joseano Sousa
#
#   Version:        v1.0
#
#   Date:           19-12-2019
#
#   Description:    Sobe arquivo para AnonFiles.com e gera URL para download
#                   Podendo subir arquivo de até 5GB.
#

import argparse
from sys import exit, version_info
from os.path import expanduser

# Verifica versão do Python
if version_info[:2] < (3, 6):
    exit("Erro: requer versão 'Python 3.6+' instalada.")

# Verifica dependências
try:
    from requests import post
except:
    exit("Erro: requer biblioteca 'requests' instalada.")

# Sobe arquivo
def upload_file():
    global json_info, url
    upload_file = post('https://api.anonfiles.com/upload', files={'file': args.file})
    json_info = upload_file.json()
    url = json_info['data']['file']['url']['full']

# Analisando argumentos
parser = argparse.ArgumentParser(prog='anonfiles', description='Sobe arquivo para AnonFiles.com e gera URL para download\nPodendo subir arquivo de até 5GB.', epilog='Status de saída:\nRetorna sucesso, se o ARQUIVO existir; falha, se não existir.', formatter_class=argparse.RawDescriptionHelpFormatter)

# Adicionando argumentos
parser.add_argument(expanduser('file'), type=argparse.FileType(), help='Sobe arquivo para AnonFiles e gera URL para download', metavar='ARQUIVO')
parser.add_argument('-V', '--verbosity', action='store_true', help='Sobe arquivo para AnonFiles e gera informações do URL')
parser.add_argument('-v', '--version', help='Informa a versão e sai', action='version', version='%(prog)s 1.0.0')

# Argumentos analisados
args = parser.parse_args()

# Trata os argumentos
if args.verbosity:
    upload_file()
    file_name = json_info['data']['file']['metadata']['name']
    file_size = json_info['data']['file']['metadata']['size']['readable']
    print(f'Arquivo: [ {file_name} ]\nTamanho: [ {file_size} ]\nURL: {url}')
else:
    upload_file()
    print(url)
