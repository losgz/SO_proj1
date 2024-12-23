#!/bin/bash

source ./utils.sh

CHECKING="0"
WORKDIR=""
BACKUP="" 

#Verificação das opções selecionadas
while getopts ":c" opt; do
    case $opt in
        c)
            CHECKING="1"
            ;;
        \?)
            echo "ERROR: -$OPTARG is an invalid option"
            exit 1
            ;;
    esac
done

# Move a posição dos parâmetros da linha de comando após o uso do getopts
shift $((OPTIND - 1))


if [[ ! $# -eq 2 ]]; then
    echo "ERROR: The function has two arguments"
    exit 1
elif [[ ! -d "$1" ]]; then
    echo "ERROR: "$1" not a directory"
    exit 1;
fi
WORKDIR="$(realpath "$1")"

mkdirprint "$2" "$2";

BACKUP="$(realpath "$2")"
if [[ "$BACKUP" == "$WORKDIR" ]]; then
    echo "ERROR: The arguments are equal"
    exit 1
fi

if [[ ! -r "$1" ]]; then
    echo "ERROR: "$(basename "$WORKDIR")" doesnt have read permissions"
    exit 1
fi

if [[ -d "$2" ]] && [[ ! -w "$2" ]]; then
    echo "ERROR: "$(basename "$BACKUP")" doesnt have write permissions"
    exit 1
fi

# Calcula o espaço total de todos os ficheiros no diretório de trabalho (em KB)
WorkDirSize=$(du -sk "$WORKDIR" 2>/dev/null | awk '{print $1}')

dirToCheck="$BACKUP"
if [[ ! -d "$2" ]]; then
    dirToCheck="$(dirname "$BackupPath")" 
fi

# Calcula o espaço disponível para se fazer a cópia (em KB)
AvailableSpace=$(df -k "$dirToCheck" | awk 'NR==2 {print $4}')

if (( AvailableSpace < WorkDirSize )); then
    echo "ERROR: Not enough space in destination directory."
    exit 1
fi


shopt -s nullglob dotglob
for file in "$2"/*; do
    if [[ -d "$file" ]]; then
        continue;
    fi
    if [[ -f "$1/$(basename "$file")" ]]; then
        continue;
    fi
    if [[ ! -w $file_copy ]]; then
        echo "ERROR: "$(basename "$WORKDIR")/$(basename "$file") doesnt have writing permissions""
        continue;
    fi
    if [[ $CHECKING -eq "0" ]]; then
        rm "$file"
    fi
done

for file in "$WORKDIR"/*; do
    if [[ -d "$file" ]]; then
        continue;
    fi
    file_copy="$BACKUP/$(basename "$file")"
    cpprint "$file" "$file_copy"
done

exit 0

