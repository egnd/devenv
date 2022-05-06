# devenv

[![Pipeline](https://github.com/egnd/devenv/actions/workflows/pipeline.yml/badge.svg)](https://github.com/egnd/devenv/actions?query=workflow%3ATesting)

ubuntu-based working environment

## Requierements:
1. ubuntu (20.04, 22.04)
2. [ansible](https://docs.ansible.com/ansible/latest/)

## Quick start:
1. Install requirements
```bash
sudo apt install -y make ansible
```
1. Download and extract [latest release](https://github.com/egnd/devenv/releases/latest)
2. Install required software:
```bash
sudo make deploy
```
