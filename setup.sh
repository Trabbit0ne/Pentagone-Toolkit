#!/usr/bin/env bash

# clear the screen
clear

###########################
#            __           #
#   ___ ___ / /___ _____  #
#  (_-</ -_) __/ // / _ \ #
# /___/\__/\__/\_,_/ .__/ #
#                 /_/     #
###########################
# Pentagone-Toolkit Setup #
###########################

# VARIABLES
fuzzing_wordlist_url="https://raw.githubusercontent.com/six2dez/OneListForAll/refs/heads/main/onelistforallmicro.txt"
fuzzing_wordlist_file="onelistforallmicro.txt"

# GITHUB REPOSITORIES TO CLONE
REPOS=(
    "https://github.com/Trabbit0ne/SSHash"
    "https://github.com/TrabbitOne/XSStrike"
    "https://github.com/Trabbit0ne/grs"
    "https://github.com/C4ssif3r/admin-panel-finder"
    "https://github.com/Trabbit0ne/loctrac_textonly"
    "https://github.com/Trabbit0ne/IPF"
    "https://github.com/Trabbit0ne/WPenum"
    "https://github.com/Trabbit0ne/DDoSer"
    "https://github.com/Trabbit0ne/Sshot"
    "https://github.com/Trabbit0ne/PToolkit_Others"
    "https://github.com/Trabbit0ne/crosstracer"
    "https://github.com/Trabbit0ne/corsica"
    "https://github.com/devanshbatham/paramspider"
)

# PIP3 TOOLS TO INSTALL
TOOLS=(
    "sqlmap"
    "arjun"
)

# APT TOOLS TO INSTALL
APT_TOOLS=(
    "ffuf"
    "nmap"
)

# FUNCTIONS

Banner() {
cat << EOF
     _______ _______ _______ ___ ___ _______
    |   _   |   _   |       |   Y   |   _   |
    |   1___|.  1___|.|   | |.  |   |.  1   |
    |____   |.  __)_'-|.  |-|.  |   |.  ____|
    |: 1   |:  1   | |:  | |:  1   |:  |
    |::.. . |::.. . | |::.| |::.. . |::.|
    '-------'-------' '---' '-------'---'
      Pentagone Toolkit Setup - @Trabbit0ne
       -----------------------------------

EOF
}

# Clone GitHub repositories
clone_repos() {
    for repo in "${REPOS[@]}"; do
        repo_name=$(basename "$repo" .git)
        if [ -d "$repo_name" ]; then
            echo "Repository $repo_name already exists, skipping..."
        else
            git clone "$repo" || { echo "Failed to clone $repo"; exit 1; }
        fi
    done
}

# Install pip tools and download fuzzing wordlist
install_tools() {
    if [ ! -f "$fuzzing_wordlist_file" ]; then
        wget "$fuzzing_wordlist_url" || { echo "Failed to download $fuzzing_wordlist_url"; exit 1; }
    else
        echo "Wordlist $fuzzing_wordlist_file already exists, skipping..."
    fi

    # Install Python tools
    for tool in "${TOOLS[@]}"; do
        if pip3 show "$tool" > /dev/null 2>&1; then
            echo "Python tool $tool is already installed, skipping..."
        else
            pip3 install "$tool" > /dev/null 2>&1 || { echo "Failed to install $tool"; }
        fi
    done

    # Update package list and install APT tools
    apt update || { echo "Failed to update package list"; exit 1; }
    for apt_tool in "${APT_TOOLS[@]}"; do
        if apt -l | grep -q "$apt_tool"; then
            echo "System tool $apt_tool is already installed, skipping..."
        else
            apt install "$apt_tool" -y || { echo "Failed to install $apt_tool"; }
        fi
    done
}

# Main execution function
main() {
    Banner
    clone_repos
    cp admin-panel-finder/.link.txt . || { echo "Failed to copy .link.txt"; exit 1; }
    install_tools
    python3 paramspider/setup.py install

    # Install GO Packages

    # Download and set up subfinder
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    echo export PATH=$PATH:$HOME/go/bin >> $home/.bashrc
    source $home/.bashrc

    # Download and set up Katana
    CGO_ENABLED=1 go install github.com/projectdiscovery/katana/cmd/katana@latest
}

# EXECUTE
main
