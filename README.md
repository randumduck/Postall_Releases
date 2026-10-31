# Postall Sovereign Enterprise Edition — Official Release Manifest

[![Release Version](https://img.shields.io/badge/version-4.1.0-blue.svg)](./version.json)
[![Docker Hub](https://img.shields.io/badge/docker-4%20production%20images-2496ed.svg)](https://hub.docker.com/u/randumduck69)
[![License](https://img.shields.io/badge/license-Enterprise%20Proprietary-red.svg)](./LICENSE)
[![Security Architecture](https://img.shields.io/badge/security-Zero--Trust%20Air--Gapped-emerald.svg)](./version.json)

Official release repository and distribution channel for **Postall Sovereign Enterprise Edition** — a self-hosted, air-gapped social media automation and curriculum publishing platform powered by local AI.

---

## 🏛️ System Architecture & Microservice Topology

Postall deploys as an isolated multi-container mesh network (`postall_mesh`), completely decoupling core business logic from cloud networks and isolating local AI operations inside container layers:

```
                          ┌─────────────────────────────────────┐
                          │    Browser / Customer Web Client    │
                          └──────────────────┬──────────────────┘
                                             │ HTTP :8000
                                             ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│ Postall Mesh Network (postall_mesh)                                             │
│                                                                                 │
│   ┌───────────────────────────┐                ┌────────────────────────────┐   │
│   │       postall_engine      │ ── HTTP:11434 ─▶│        postall_llm         │   │
│   │    (Core Platform:8000)   │                │   (Sovereign AI Engine)    │   │
│   └─────────────┬─────────────┘                └────────────────────────────┘   │
│                 │                                                               │
│                 │ HTTP:8080                    HTTP:8081                        │
│                 ▼                              ▼                                │
│   ┌───────────────────────────┐   ┌─────────────────────────────┐               │
│   │      postall_gateway      │   │    postall_license_forge    │               │
│   │   (Zero-Trust Proxy:8080) │   │  (Cryptographic Node Lic.)  │               │
│   └───────────────────────────┘   └─────────────────────────────┘               │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 📦 Container Registry Inventory (Docker Hub)

All container images are pre-compiled with Ahead-of-Time (AOT) Cython translation and baked AI model weights:

| Container Service | Docker Hub Image Tag | Port Mapping | Memory Allocation | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Core Platform Engine** | `randumduck69/postall_engine:latest` | `8000:8000` | 4 GB Res / 6 GB Burst | 28-tab UI, scheduler daemon, syllabus ingest |
| **Sovereign Local AI** | `randumduck69/postall_ai:latest` | `11434:11434` | GPU / 4 GB CPU | Air-gapped Qwen 2.5 1.5B local LLM runtime |
| **Zero-Trust Gateway** | `randumduck69/postall_gateway:latest` | `8080:8080` | 2 GB Res / 4 GB Burst | Stateless OAuth 2.0 broker & media passthrough |
| **License Forge** | `randumduck69/postall_license_forge:latest` | `8081:8001` | 1 GB Res / 2 GB Burst | Ed25519 cryptographic HWID node verification |

---

## 🚀 1-Click Turnkey Deployment

### Option A: Automated PowerShell Deployment (Recommended)
Run the turnkey installer directly on any Windows workstation or server with Docker Desktop installed:

```powershell
powershell -ExecutionPolicy Bypass -File ./setup_postall.ps1
```

The script automatically:
1. Validates Docker daemon connectivity and permissions.
2. Initializes the `postall_mesh` bridge network.
3. Pulls the latest production images from Docker Hub.
4. Spins up all 4 microservices with memory reservations and GPU passthrough.
5. Launches the enterprise dashboard at `http://localhost:8000/dashboard`.

### Option B: Docker Compose
```bash
docker compose pull
docker compose up -d
```

---

## 📋 Version Ledger & Release History

- **[`version.json`](./version.json)**: Machine-readable active release manifest consumed by the Postall OTA updater.
- **[`releases.json`](./releases.json)**: Historical release ledger tracking changelogs and container tag digests across versions.

### Latest Release: v4.1.0 (2026-10-31)
- **White-Label Sovereign AI Container**: Baked Qwen weights directly into Docker image (`postall_ai`), resolving host firewall drops.
- **Studio Live Social Previews**: Instant zero-latency media preview via client-side blob URLs and mounted `/data/assets` static delivery.
- **Express Pipeline Infographic Toggle**: Configurable AI infographic generation allowing one-click text-only drafting.
- **Multi-Post Daily Cadence**: Configurable posts per day with automatic hourly interval scheduling and draft redistribution.
- **Custom Persona Builder**: Full synchronization of database-managed brand personas with the local AI synthesis engine.
- **Gemini 1.5 Architecture**: Modernized public fallback models to Google Gemini 1.5 Flash and Pro.

---

## 💻 Hardware Requirements

- **CPU**: 4 Cores minimum (8 Cores recommended)
- **System Memory**: 8 GB minimum (16 GB recommended)
- **Storage**: 15 GB available SSD storage
- **GPU (Optional)**: NVIDIA GPU with CUDA 12.0+ support (`--gpus=all`). CPU fallback is automatically supported.
- **OS**: Windows 10/11 Enterprise / Server 2022, Ubuntu 22.04 LTS, or macOS (Apple Silicon).
