<div align="center">

<img src="assets/wheezy_logo.png" align="center"  height="250px"/>

# 🚧 Home-Ops using Infrastructure as Code 🚧

[![Kubernetes](https://img.shields.io/badge/Kubernetes-gray?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)&nbsp;&nbsp;
[![Proxmox](https://img.shields.io/badge/Proxmox-gray?style=for-the-badge&logo=proxmox&logoColor=white)](https://www.proxmox.com/)&nbsp;&nbsp;
[![Terraform](https://img.shields.io/badge/Terraform-gray?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)&nbsp;&nbsp;
[![Talos](https://img.shields.io/badge/Talos-gray?style=for-the-badge&logo=talos&logoColor=white)](https://www.talos.dev/)&nbsp;&nbsp;
[![Flux](https://img.shields.io/badge/Flux-gray?style=for-the-badge&logo=flux&logoColor=white)](https://fluxcd.io)&nbsp;&nbsp;

</div>

## Overview

This repository is my home Kubernetes cluster in a declarative state. [Terraform](https://www.terraform.io/) provisions VM's on [Proxmox](https://www.proxmox.com/) for [Talos](https://www.talos.dev/) control plane and worker nodes. [Flux](https://github.com/fluxcd/flux2) watches the [kubernetes](./kubernetes/) folder and will make the changes to the cluster based on the YAML manifests.

## Infrastructure

### 1. Cluster Hardware

| Name      | OS        | Processor | Memory    | OS Storage | Other Storage |
| --------- | --------- | --------- | --------- | --------- | --------- |
| pve-dev-1  | Proxmox | Intel Xeon E5-2620     | 128 GB | 480 GB   | -               |
| pve-prod-1 | Proxmox | Intel Core i9-12900K   | 64 GB  | 2 x 1 TB | Longhorn - 1 TB |
| pve-prod-2 | Proxmox | Intel Core i7-8700K    | 48 GB  | 500 GB   | Longhorn - 1 TB |
| pve-prod-3 | Proxmox | Intel Core i5-14600K   | 64 GB  | 2 TB     | Longhorn - 1 TB |

### 2. Compute Layer

| Name        | Description | Processor Allocation | Memory Allocation | Storage Allocation |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| talos-controller-01 | Kubernetes Control Plane Node | 2 Cores  | 6 GB  | 20 GB  |
| talos-controller-02 | Kubernetes Control Plane Node | 2 Cores  | 6 GB  | 20 GB  |
| talos-controller-03 | Kubernetes Control Plane Node | 2 Cores  | 6 GB  | 20 GB  |
| talos-worker-01     | Kubernetes Worker Node        | 12 Cores | 24 GB | 200 GB |
| talos-worker-02     | Kubernetes Worker Node        | 12 Cores | 24 GB | 200 GB |
| talos-worker-03     | Kubernetes Worker Node        | 12 Cores | 24 GB | 200 GB |

### 🚧 3. Storage 🚧

### 🚧 4. Network 🚧

## 🚧 Software 🚧

### 1. Core Components

- [Longhorn]() - Cluster storage
- [Cert Manager]() - Issue certificates via Let's Encrypt
- [Flux]() - Watch git for repo changes
- [Node Feature Discovery]() - Detect node hardware features
- [SOPS]() - Secret handling

### 2. Services

#### Networking

- [traefik]()
- [wg-easy]() - Wireguard VPN
- [Blocky]() - DNS level ad-blocker
- [Cloudflare DDNS]()

#### Media

- [Jellyfin]() - Movie & TV Show streaming
- [Jellyseerr]() - Movie & TV Show requester
- [Sonarr]() - TV Show management
- [Radarr]() - Movie management
- [Lidarr]() - Audio management
- [Prowlarr]() - Index management
- [Huntarr]() - Media updater
- [Navidrome]() - Audio streaming

#### Home

- [Home Assistant]() - Home automation dashboard
- [Frigate]() - Security camera NVR
- [Mosquitto]() - MQTT broker
- [NodeRed]() - Automation builder
- [Z-Wave-JS-UI]() - Z-Wave device management

#### Monitoring

- [Grafana]() - Metrics and logging

#### AI

- [Openwebui]() - AI Frontend

#### Misc

- [nzbGet]() - Usenet download client
- [Homepage]() - Home lab dashboard
