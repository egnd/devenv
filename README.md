# devenv

ubuntu-based working environment

## Requierements:
1. ubuntu (22.04)
2. [ansible](https://docs.ansible.com/ansible/latest/)

## Quick start:
1. Install requirements
```bash
sudo apt install -y make ansible
```
1. Download [latest build](https://gitlab.com/egnd/workspace/-/archive/master/workspace-master.zip), or [specific version](https://gitlab.com/egnd/workspace/-/releases)
2. Install required software:
```bash
sudo make deploy
```
