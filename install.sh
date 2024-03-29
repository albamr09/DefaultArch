#!/bin/bash

instalar_dependencias(){
	
	echo "---------------------------------------------------"
	echo "-------------- Instalar dependencias --------------"
	echo "---------------------------------------------------"

	yay -S i3-wm i3-gaps picom alacritty neovim nitrogen rofi ttf-font-awesome awesome-terminal-fonts pamixer ranger scrot zsh nodejs npm qutebrowser playerctl python3 python-pip xss-lock zathura i3lock-color acpi dunst llvm clang cmake ripgrep lldb tmux
	pip3 install dbus-python pipewire pipewire-pulse pipewire-jack pipewire-alsa pipewire-audio bluez bluez-utils

	echo "----------------------------------------------"
	echo " + Intalar oh-my-zsh"
	echo "----------------------------------------------"

	sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	
	# Hacer predeterminado
	chsh -s /bin/zsh
}

eliminar_wallpapers(){

	echo "---------------------------------------------------"
	echo "----------------- Copiar dotfiles -----------------"
	echo "---------------------------------------------------"

	rm -rf $HOME/.config/wallpapers
}

copiar_dotfiles(){
	
	echo "---------------------------------------------------"
	echo "----------------- Copiar dotfiles -----------------"
	echo "---------------------------------------------------"

	# Delete qutebrowser config
	rm -r /home/$USER/.config/qutebrowser /home/$USER/.config/rofi

	# Normal dotfiles
	cp -r home/.??* /home/$USER
	# Lightdm dotfiles
	sudo cp -r etc/* /etc
}

copiar_fuentes(){
	
	echo "---------------------------------------------------"
	echo "----------------- Copiar fuentes -----------------"
	echo "---------------------------------------------------"

	sudo cp -r fonts/* /usr/share/fonts
}

copiar_servicios(){

	echo "---------------------------------------------------"
	echo "-------- Copiar y configurar servicios ------------"
	echo "---------------------------------------------------"

	sudo cp services/* /etc/systemd/system
	sudo systemctl enable suspend@alba
	# Servicio de notificación de batería
  	systemctl --user enable check-battery-user.timer
  	# Servicio de notificación de batería
  	systemctl --user start check-battery-user.service
	#Actualizar
	sudo systemctl daemon-reload
}

instalar_caffeine(){

	echo "---------------------------------------------------"
	echo "-------- Copiar y configurar servicios ------------"
	echo "---------------------------------------------------"

	# Instalar
	yay -S libappindicator-gtk3 pulseaduio caffeine-ng
}

configurar_nvim(){
	
	echo "---------------------------------------------------"
	echo "----------------- Configurar nvim -----------------"
	echo "---------------------------------------------------"

	# Virtual environments for python
    wd=$(pwd)
    mkdir -p /home/$USER/.virtualenvs && cd /home/$USER/.virtualenvs
    python -m venv debugpy
	/home/$USER/.virtualenvs/debugpy/bin/pip3 install debugpy
    cd $wd

	curl -fLo /home/$USER/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim -c 'PlugInstall|q|q'
	nvim -c 'so ~/.config/nvim/init.vim|q'
	nvim -c 'PlugInstall|q|q'
	pip3 install neovim cpplint pynvim
}

configurar_tmux() {

    echo "----------------------------------------------"
    echo "------------ Configurar tmux -----------------"
    echo "----------------------------------------------"

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

configurar_dunst(){

  echo "---------------------------------------------------"
	echo "----------------- Configurar dunst ----------------"
	echo "---------------------------------------------------"

  # Eliminar proceso
  killall dunst
  # Establecer/actualizar fichero de configuracion
  dunst -config ~/.config/dunst/dunstrc &
}



instalar_dependencias
eliminar_wallpapers
configurar_nvim
configurar_tmux
copiar_dotfiles
copiar_fuentes
copiar_servicios
instalar_caffeine
configurar_dunst
