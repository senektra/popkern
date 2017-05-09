# ````````````````````````````````````````````````````````````````````````````````
#                                  popkern                             
#                          "Its like popping popcorn"
#                                  v0.1.0                                        
# ................................................................................
#
# Description:
#
#   This is Rodolfo's personal bootstrap script for setting up his user workspace 
#   on new personal installations of linux (including servers). It handles the 
#   creation of folders, downloads pacakages/utils and even sets up a desktop
#   environment. 
#    Max was here. Dammit Max.
#
# Dependencies:
#   At a minimum it is required that zsh be installed. Any other dependencies that
#   are needed, the script will prompt the user for installation (if the package
#   exists in the package manager for the platform). 
#
# Flags:
#
#   -b
#       Install bumblebee.
#   -d
#       Install a desktop environment.
#   -f
#       Do a full installation (equivalent to running with -dgo)
#   -g
#       Install graphical applications specified in gdeps.
#   -i
#       We're on a fresh install, do extra stuff (will be prompted).
#   -n
#       Install nvidia drivers.
#   -o
#       Pull in optional dependencies specified in odeps.
#

# ````````````````````````````````````````````````````````````````````````````````
#                              Script variables
# ................................................................................
test=false # Are we testing the script?
tmp=bstmp  # Directory to hold temporary files/folders

#
# Machine vars (used for packaging)
#
platform="unknown"
pkgmgr="unknown"

# Directories in home.
home=( bin     # bin, duh
       desktop # Desktop space
       m       # 'main'
       public  # Public files
       tmp     # Temporary files 
     )

# Directories in home (for servers)
shome=( bin    # Its just a regular bin
        s      # like 'main' with s to denote we're on a server
        public # Public files
        tmp    # Temporary files
      )

# Directories in m
m=( arc   # Archives 
    art   # Art
    dev   # Development 
    dl    # Downloads
    doc   # Documents
    ebk   # Ebooks
    vemu  # Emulation/Virtualization
    gam   # Games
    music # Music
    pic   # Pictures
    sec   # Security related things
    snd   # Sound snippets
    sw    # Software
    tmpl  # Template files
    ucsc  # UCSC related files
    vid   # Videos/movies
  )

# Directories in s
# These have the same purpose as those in m
s=( arc
    dev
    dl
    vemu
    sec
    sw
    ucsc
  )

# Directories to remove on fresh installs.
rm_dirs=( Desktop
          Public
          Templates
          Pictures
          Documents
          Downloads
          Videos
        )

# ````````````````````````````````````````````````````````````````````````````````
#                              Helper Commands                                   
# ................................................................................

# editcmd calls vared on a command to be ran.
# Args:
#   command (text)
# Return:
#   None
editcmd () { 
    local temp=$1
    vared temp
    eval ${temp}
}

newline () {
    echo '\n'
}

go_home () {
    if [[ $test = "false" ]]; then cd ~; fi
}

go_back () {
    if [[ $test = "false" ]]; then cd -; fi
}

get_platform () {
    platform=`uname`
    echo $platform
    case $platform in
        "Linux") 
            hash apt 2>/dev/null && pkgmgr="apt"
            hash pacman 2>/dev/null && pkgmgr="pacman"
            ;;
        "FreeBSD")
            hash pkg 2>/dev/null && pkgmgr="pkg"
            ;;
        *)
            echo "Unsupported OS detected, gotta go, bye bye."
            exit 1
            ;;
    esac
    if [[ pkgmgr = "unknown" ]]; then
        echo "It seems we couldn't find a package manager for you :("
        exit 1
    else
        echo "Found ${platform} as platform"
        echo "Found ${pkgmgr} as package manager"
    fi
}

get_antigen () {
    echo "Downloading antigen."
    curl -L git.io/antigen > $tmp/antigen.zsh
    go_home; mkdir .antigen; go_back
    [ $test = "false" ] && mv $tmp/antigen.zsh ~/.antigen
    echo "antigen moved to ~/.antigen"
}

get_goenv () {
    echo "Downloading goenv"
    go_home
    git clone https://github.com/syndbg/goenv.git .goenv
    mkdir .gowksp
    go_back
    echo "Goenv downloaded"
}

source_zshrc () {
    source .zshrc
    echo ".zshrc is sourced"
}

gen_file_struct () {
    # Get rid of old folders.
    for dir in $rm_dirs; do
        [ -d $dir ] && rm -ir $dir
    done

    # Create home folders
    for dir in $home; do mkdir $dir; done
}

run_bootstrap () {
    if [[ $EUID == 0 || $UID == 0 ]]; then
        echo "No need to run this as root, we don't want to break stuff."
        echo "Exiting..."
        exit 1
    fi

    if [[ $1 == "test" ]]; then
        test=true
        for dir in $home;    do rm -ir $dir ; done
        for dir in $rm_dirs; do mkdir $dir  ; done
    fi

    if [[ $1 == "bin" ]]; then
        echo "Moving bootstrap to ~/bin"; mov_to_bin
    fi

    if [[ $1 == "zshrc" ]]; then
        echo "Updating .zshrc, but you'll have to do the git'ing"; udpate_zsh
    fi

    mkdir $tmp

    echo "Figuring out the platform... " ; get_platform    ; newline
    echo "Getting antigen ready... "     ; get_antigen     ; newline
    echo "Installing go and nexus... "   ; get_go          ; newline
    echo "Sourcing zshrc... "            ; source_zshrc    ; newline
    echo "Generating home folders... "   ; gen_file_struct ; newline

    rm -rf $tmp
}

run_bootstrap $1