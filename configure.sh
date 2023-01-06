#!/bin/bash

blue=$'\033[0;34m'
red=$'\033[0;31m'
reset=$'\033[0;39m'

[ -z "${USER}" ] && export USER=$(whoami)

goinfre_dir="/goinfre/${USER}/goinfre/"

#!/bin/zsh

if [ ! -x "$(command -v brew)" ]; then
		git clone --depth=1 https://github.com/Homebrew/brew $HOME/goinfre/.brew
fi

function configure_brew() {

	echo "${blue}Configuring brew...${reset}"

	if [ -x $(command -v brew) ]
		then
		echo "${blue}Brew already installed, doing nothing.${reset}"
		return
	fi

	rm -rf $HOME/.brew
	rm -rf $HOME/goinfre/.brew

	local brew_dir="${goinfre_dir}/.brew"

	echo "${blue}Installing Brew in ${brew_dir}${reset}"
	git clone --depth=1 https://github.com/Homebrew/brew ${brew_dir}

	local brew_bin_dir="${brew_dir}/bin"

	if ! [[ "$PATH" =~ "${brew_bin_dir}:" ]]
		then
		PATH="${brew_bin_dir}:${PATH}"
	fi
	export PATH

	echo "${blue}Please add${reset}\'export PATH=${brew_bin_dir}:'${PATH}'\'${blue} to .zshrc${reset}"

}

configure_brew

function update_brew() {
	echo "${blue}Updating Brew${reset}"
	brew update
	echo "${blue}Upgrading Brew${reset}"
	brew upgrade
}

update_brew

function configure_docker() {

	echo "${blue}Configuring Docker...${reset}"

	pkill Docker

	docker_destination="${goinfre_dir}/docker"

	echo "${blue}Uninstalling Docker, if installed with brew${reset}"
	brew uninstall -f docker docker-compose docker-machine

	if [ ! -d "/Applications/Docker.app" ] && [ ! -d "~/Applications/Docker.app" ]; then
		echo "${red}Warning: Docker is not installed${reset}"
		echo "${red}Please install Docker, the process will wait until you close Managed Software Center.${reset}"
		osascript -e 'display notification "Please install Docker, the process will wait until you close Managed Software Center." with title "Docker is not installed"'
		open -W -a "Managed Software Center"
	fi

	pkill Docker

	echo "${blue}Unlinking old non-goinfre System Links${reset}"
	unlink ~/Library/Containers/com.docker.docker &>/dev/null ;:
	unlink ~/Library/Containers/com.docker.helper &>/dev/null ;:
	unlink ~/.docker &>/dev/null ;:

	rm -rf ~/Library/Containers/com.docker.{docker,helper} ~/.docker &>/dev/null ;:

	echo "${blue}Linking Docker to goinfre${reset}"
	mkdir -p "$docker_destination"/{com.docker.{docker,helper},.docker}

	ln -sf "$docker_destination"/com.docker.docker ~/Library/Containers/com.docker.docker
	ln -sf "$docker_destination"/com.docker.helper ~/Library/Containers/com.docker.helper
	ln -sf "$docker_destination"/.docker ~/.docker

}

configure_docker

function start_docker() {
	if ( docker stats --no-stream >/dev/null 2>&1 )
		then
		echo "${blue}Docker is up and running...${reset}"
		return
	fi

	echo "${blue}Starting Docker...${reset}"
	open -g -a Docker

	echo "${blue}Waiting for Docker Deamon to start...${reset}"
	while (! docker stats --no-stream >/dev/null 2>&1 )
		do
		echo -n "${blue}.${reset}"
		sleep 1
	done
}

start_docker