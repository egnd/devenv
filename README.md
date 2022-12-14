# devenv

[![Pipeline](https://github.com/egnd/devenv/actions/workflows/pipeline.yml/badge.svg)](https://github.com/egnd/devenv/actions?query=workflow%3ATesting)

ubuntu-based working environment

## Requierements:
1. [ubuntu](https://ubuntu.com/download/desktop) (20.04, 22.04)
2. [git](https://git-scm.com/)
2. [make](https://www.gnu.org/software/make/)
2. [ansible](https://docs.ansible.com/ansible/latest/)

## Quick start:
1. Install requirements
```bash
sudo apt install -y git make ansible
```
2. Download this repo:
```bash
git clone https://github.com/egnd/devenv.git
```
3. Run make to see the list of available options:
```bash
cd devenv

# list of available presets
make

# list of available recipes
make run
```
