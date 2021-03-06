# Table of Contents

- [Table of Contents](#table-of-contents)
- [Productivity-Tools-and-Scripts](#productivity-tools-and-scripts)
  - [Linux](#linux)
    - [Linux > scripts](#linux--scripts)
    - [Linux > RHEL > nginx](#linux--rhel--nginx)
    - [Build nginx from source](#build-nginx-from-source)
    - [Work Station configuration](#work-station-configuration)
  - [Python](#python)
    - [Python > GitLab](#python--gitlab)
    - [Python > Threads](#python--threads)
  - [VSCode](#vscode)

# Productivity-Tools-and-Scripts

## Linux

1. **SSH Tunnel** - Setup SSH Tunnel to remote server and use that for proxying

### Linux > scripts

1. **ssh-login-with-passwd.sh** - Copy public key to hosts(file passed as argument)
1. **connect_multiple_hosts.sh** - TMUX - Connect to multiple hosts

### Linux > RHEL > nginx

### Build nginx from source

-   Compile nginx from source to include 3rd party module for AD integration

### Work Station configuration

1. Below is the usage (for onetime setup)

```bash
$ ssh <server_name_here>
$ mkdir -p ${HOME}/src/ && cd $_
$ git clone https://github.com/ampythondeveloper/Productivity-Tools-and-Scripts.git
$ cd Productivity-Tools-and-Scripts
$ mv ${HOME}/.vimrc ${HOME}/.vimrc_old
$ ln -s ${PWD}/Linux/.vimrc ${HOME}/.vimrc
$ mv ${HOME}/.bashrc ${HOME}/.bashrc_old
$ ln -s ${PWD}/Linux/.bashrc ${HOME}/.bashrc
```

## Python

### Python > GitLab

1. **ListBuildRepos.py** - Clone all repositories from GitLab (should be renamed to reflect)
1. **LevelUp.pl** - Moving files from one location to another without losing history (Seems, i missed another script which generates `.sh` files

### Python > Threads

1. Example usage of thread pool(Copied from internet. Needs to update for efficient usage)

## VSCode

1. **Remote VSCode** - Edit remote files on local vscode using **Remote VSCode**
