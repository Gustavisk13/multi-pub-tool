#!/bin/bash

#By Gustavisk

envSelec=("Flutter Pub Get" "Flutter Clean e Pub get")
appSelec=("Novomundo App" "Megamoda App")
dirname=$(pwd)

dirname="${dirname%/}"

subdir="${dirname##*/}"

greenEcho() {
    echo -e "\e[32m$1\e[0m"
}
yellowEcho() {
    echo -e "\e[33m$1\e[0m"
}
redEcho() {
    echo -e "\e[31m$1\e[0m"
}

pub_exec() {

    files=$(find $dirname -maxdepth 2 -type f -name "*pubspec.yaml*" -print | sed 's|\(.*\)/.*|\1|')
    readarray -t array <<<"$files"

    if [[ $1 -eq 1 ]]; then

        for i in "${array[@]}"; do
            local dir=$(echo $i | tr -d '.')
            cd $i
            yellowEcho "Executando flutter pub get em $dir ..."
            flutter pub get >>/dev/null
            if [[ $? -eq 0 ]]; then
                greenEcho "Executado com sucesso !"
                echo ""
            else
                redEcho "Erro no flutter pub get em $dir"
                echo ""
            fi
        done
    else
        for i in "${array[@]}"; do
            local dir=$(echo $i | tr -d '.')
            cd $i
            yellowEcho "Executando flutter clean em $dir ..."
            flutter clean >>/dev/null
            if [[ $? -eq 0 ]]; then
                greenEcho "Executado com sucesso !"
                echo ""
            else
                redEcho "Erro no flutter clean em $dir"
                echo ""
            fi
            yellowEcho "Executando flutter pub get em $dir ..."
            flutter pub get >>/dev/null
            if [[ $? -eq 0 ]]; then
                greenEcho "Executado com sucesso !"
            else
                redEcho "Erro no flutter pub get em $dir"
            fi

        done
    fi
}

while true; do
    if [[ ! "$subdir" == "app-megamoda" || "$subdir" == "app-novo-mundo" ]]; then
        redEcho "Obrigatorio estar na pasta raiz do projeto!!!"
        exit
    else
        break
    fi
done

select opt in "${envSelec[@]}"; do
    case $opt in
    "Flutter Pub Get")
        env=1
        break
        ;;
    "Flutter Clean e Pub get")
        env=2
        break
        ;;
    "Sair")
        echo "Usuário saiu"
        exit
        ;;
    *)
        redEcho "Opção invalida $REPLY"
        ;;
    esac
done

pub_exec $env