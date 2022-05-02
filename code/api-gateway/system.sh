#!/bin/bash

Green="\033[32m"
Red="\033[31m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

OK="${Green}[OK]${Font}"
Error="${Red}[error]${Font}"

check_screen() {
    screen -v &> /dev/null
    if [ $? -ne  0 ]; then
        echo -e "${Error} ${RedBG} screen is not installed ! ${Font}"
        exit 1
    fi
}

check_screen

if [ $# -gt 0 ]; then
    if [[ "$1" == "init" ]] || [[ "$1" == "install" ]]; then
        go mod tidy
        swag init
    elif [[ "$1" == "start" ]]; then
        shift 1
        cmd="cd service/$2/$1 && go run $2.go -f etc/$2.yaml\n"
        screen -S $1$2 -X quit
        screen -dmS $1$2
        screen -S $1$2 -p 0 -X stuff "$cmd"
        screen -ls
        echo -e "${OK} ${GreenBG} $2 $1 service start!  ${Font}"
    elif [[ "$1" == "stop" ]]; then
        shift 1
        screen -S $1$2 -X quit
        screen -ls
        echo -e "${OK} ${GreenBG} $2 $1 service stop!  ${Font}"
    elif [[ "$1" == "info" ]]; then
        shift 1
        screen -r $1$2
    elif [[ "$1" == "ls" ]]; then
        screen -ls
    fi
fi