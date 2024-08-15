#!/bin/bash

# | Script de Instalação do Ubuntu no Termux |
# | Créditos: ©juliorebuna |
# | GitHub: https://github.com/Juliorebuna |
# | Versão: 1.1.0 |
# | Linguagem: PT-BR  |

# | Este script instala pacotes no Termux e configura o Ubuntu

R="\033[01;31m"
G="\033[01;32m"
Y="\033[01;33m"
B="\033[01;34m"
M="\033[01;35m"
C="\033[01;36m"
W="\033[00;00m"

Stats_Info="$W[$B⌕$W]"
Stats_Upload="$W[$M*$W]"
Stats_Warn="$W[$R!$W]"

set -e

check_status() {
    if [ $? -eq 0 ]; then
        echo -e "$Stats_Upload |$G $1"
    else
        echo -e "$Stats_Warn |$R $2"
        exit 1
    fi
}

check_sudo() {
    if ! command -v sudo &> /dev/null; then
        echo -e "$Stats_Warn |$R O comando 'sudo' não está instalado. Instale-o e tente novamente."
        exit 1
    fi
}

check_proot_distro() {
    if ! command -v proot-distro &> /dev/null; then
        echo -e "$Stats_Warn |$R O comando 'proot-distro' não está instalado. Instale-o e tente novamente."
        exit 1
    fi
}

enable_accelerator() {
    echo -e "\033[01;37mAtivando acelerador..." $W
    # Substitua o comando abaixo pelo comando real para ativar o acelerador
    # Exemplo:
    # accelerador --enable
    check_status "Acelerador ativado com sucesso!" "Houve um problema ao ativar o acelerador."
}

create_user() {
    echo -e "\033[01;37m[\033[01;35m12/13\033[01;37m] ⟩$R Criando um novo usuário no Ubuntu..." $W
    read -p "Digite o nome do novo usuário: " username
    echo "Criando o usuário $username no Ubuntu..."
    proot-distro login ubuntu -- bash -c "sudo adduser $username"
    check_status "Usuário $username criado com sucesso!" "Houve um problema ao criar o usuário $username."
}

configure_ubuntu() {
    echo -e "\033[01;37mConfigurando o Ubuntu..." $W
    local username=$1

    # Adicionar configuração para login automático no usuário padrão
    proot-distro login ubuntu -- bash -c "echo 'export USER=$username' >> ~/.bashrc"

    # Adicionar banner de boas-vindas ao ~/.bashrc
    proot-distro login ubuntu -- bash -c "cat >> ~/.bashrc <<'EOF'
echo -e \"$C┎━─━─━──━──━─━─━─━──━─━──━─━──━─━─━─━─━──━─━──━─━─━──━─━─━┒\"
echo -e \"$Y        BEM-VINDO \"
echo -e \"$W     $R Créditos$W ⟩ juliorebuna\"
echo -e \"$W     $R Versão $W ⟩ v1.1.0 $W\"
echo -e \"$W     $R GitHub$W  ⟩ https://github.com/Juliorebuna\"
echo -e \"$C┖━─━─━──━──━─━─━─━──━─━─━──━─━──━─━─━─━─━──━──━─━──━─━─━─━┚\"
sleep 2
echo
EOF"
    check_status "Configuração do Ubuntu concluída!" "Houve um problema ao configurar o Ubuntu."
}

start_install() {
    clear
    echo -e "$C┎━─━─━──━──━─━─━─━──━─━──━─━──━─━─━─━─━──━─━──━─━─━──━─━─━┒"
    echo -e "$Y        Script de Instalação do Ubuntu no Termux"
    echo -e "$W     $R Créditos$W ⟩ juliorebuna"
    echo -e "$W     $R Versão $W ⟩ v1.1.0 $W"
    echo -e "$W     $R GitHub$W  ⟩ https://github.com/Juliorebuna"
    echo -e "$C┖━─━─━──━──━─━─━─━──━─━─━──━─━──━─━─━─━─━──━──━─━──━─━─━─━┚"
    sleep 2
    echo

    # Verificar se o sudo e proot-distro estão instalados
    check_sudo
    check_proot_distro

    # Ativar o acelerador
    enable_accelerator

    echo -e "\033[01;37m[\033[01;35m1/13\033[01;37m] ⟩$W Checando e$M Atualizando pacotes..." $W
    sleep 1

    pkg update -y
    pkg install x11-repo termux-x11-nightly pulseaudio proot-distro -y
    check_status "Pacotes do Termux foram atualizados!" "Houve um problema ao atualizar os pacotes do Termux."
    sleep 2
    clear

    echo -e "\033[01;37m[\033[01;35m2/13\033[01;37m] ⟩$R Instalando e configurando o Ubuntu..." $W
    proot-distro install ubuntu
    check_status "Ubuntu instalado!" "Houve um problema ao instalar o Ubuntu."

    echo -e "\033[01;37m[\033[01;35m2.1/13\033[01;37m] ⟩$R Verificando a instalação do Ubuntu..." $W
    if ! proot-distro list | grep -q ubuntu; then
        echo -e "$Stats_Warn |$R Ubuntu não foi instalado corretamente."
        exit 1
    fi
    proot-distro login ubuntu -- bash -c 'echo "Ubuntu está instalado e logado!"'
    check_status "Login no Ubuntu realizado!" "Houve um problema ao fazer login no Ubuntu."
    sleep 2
    clear

    echo -e "\033[01;37m[\033[01;35m3/13\033[01;37m] ⟩$R Instalando Nerd Fonts..." $W
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"
    check_status "Nerd Fonts instaladas com sucesso!" "Houve um problema ao instalar o Nerd Fonts."
    sleep 2
    clear

    echo -e "\033[01;37m[\033[01;35m4/13\033[01;37m] ⟩$R Atualizando pacotes do Ubuntu..." $W
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install sudo nano adduser -y
    check_status "Pacotes do Ubuntu foram atualizados!" "Houve um problema ao atualizar os pacotes do Ubuntu."
    sleep 2
    clear

    echo -e "\033[01;37m[\033[01;35m5/13\033[01;37m] ⟩$R Iniciando instalação do XFCE e Programas..." $W
    sudo apt install xfce4 xfce4-goodies pulseaudio wget tigervnc xfce4-session -y &
    sudo apt install otter-browser audacious vim-gtk python-tkinter mtpaint aterm -y &
    wait
    check_status "XFCE e programas básicos instalados!" "Houve um problema ao instalar XFCE e programas básicos."
    sleep 2
    clear

    echo -e "\033[01;37m[\033[01;35m6/13\033[01;37m] ⟩$R Instalando Whisker Menu e Mugshot..." $W
    sudo apt install xfce4-whiskermenu-plugin mugshot -y
    check_status "Whisker Menu e Mugshot instalados com sucesso!" "Houve um problema ao instalar Whisker Menu e Mugshot."
    sleep 2
    clear

    echo -e "\033[01;37m[\033[01;35m7/13\033[01;37m] ⟩$R Instalando temas de ícones..." $W
    sudo apt install papirus-icon-theme moka-icon-theme -y
    check_status "Temas de ícones instalados com sucesso!" "Houve um problema ao instalar temas de ícones."
    sleep 2
    clear

    echo -e "\033[01;37m[\033[01;35m8/13\033[01;37m] ⟩$R Instalando temas GTK e outros..." $W
    sudo apt install numix-gtk-theme greybird-gtk-theme plank conky-all -y
    check_status "Temas GTK, dock e Conky instalados com sucesso!" "Houve um problema ao instalar temas GTK, dock e Conky."
    sleep 2
    clear

    echo -e "\033[01;37m[\033[01;35m9/13\033[01;37m] ⟩$R Instalando cliente de e-mail..." $W
    sudo apt install evolution thunderbird -y
    check_status "Cliente de e-mail instalado com sucesso!" "Houve um problema ao instalar o cliente de e-mail."
    sleep 2
    clear

    echo -e "\033[01;37m[\033[01;35m10/13\033[01;37m] ⟩$R Instalando navegadores..." $W
    sudo apt install firefox chromium-browser -y
    check_status "Navegadores instalados com sucesso!" "Houve um problema ao instalar os navegadores."
    sleep 2
    clear

    echo -e "\033[01;37m[\033[01;35m11/13\033[01;37m] ⟩$R Instalando editores de texto e IDEs..." $W
    wget https://go.microsoft.com/fwlink/?LinkID=760868 -O code_latest_amd64.deb
    sudo apt install ./code_latest_amd64.deb -y
    sudo apt install sublime-text -y
    check_status "Editores de texto e IDEs instalados com sucesso!" "Houve um problema ao instalar editores de texto e IDEs."
    sleep 2
    clear

    echo -e "\033[01;37m[\033[01;35m12/13\033[01;37m] ⟩$R Limpando pacotes não necessários..." $W
    sudo apt autoremove -y
    check_status "Pacotes desnecessários removidos com sucesso!" "Houve um problema ao remover pacotes desnecessários."
    sleep 2
    clear

    # Criar um novo usuário no Ubuntu
    create_user

    # Configurar o Ubuntu para logar automaticamente no novo usuário e adicionar o banner
    configure_ubuntu $username

    echo -e "\033[01;37m[\033[01;35m13/13\033[01;37m] ⟩$G Instalação concluída com sucesso!" $W
}

start_install
