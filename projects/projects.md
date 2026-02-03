# 🚀 Projects

Projects and infrastructure we maintain, host, or contribute to.

---

## 🥝 Kiwi Network {#kiwi-network}

A modular, federated privacy infrastructure platform.

**Website:** [kiwi-network.eu](https://kiwi-network.eu)

Kiwi Network transforms Docker-based privacy services into a turnkey appliance with:

- **Modular architecture** — Mix and match services (cloud, VPN, downloads, etc.)
- **Split-horizon DNS** — Local LAN IPs + VPN mesh IPs
- **Federation support** — Securely connect multiple kiwi networks
- **Easy deployment** — Pre-built ISOs or manual setup

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    KIWI MASTER                          │
│  km-vpn-server (WireGuard) ─┬─ km-pihole (DNS)         │
│  km-vpn-client (Gluetun)    ├─ km-tor (SOCKS5)         │
│  km-control (API + WebUI)   └─ km-ca (Certificates)    │
└─────────────────────────────────────────────────────────┘
                         │ WireGuard Mesh
         ┌───────────────┼───────────────┐
         ▼               ▼               ▼
   ┌───────────┐   ┌───────────┐   ┌───────────┐
   │ Node: GW  │   │Node: Cloud│   │Node: Both │
   └───────────┘   └───────────┘   └───────────┘
```

### Available Modules

| Module | Category | Description |
|--------|----------|-------------|
| vpn-client | core | Gluetun VPN client (Mullvad, etc.) |
| vpn-server | core | WireGuard server (wg-easy) |
| dns | core | Pi-hole DNS + ad-blocking |
| cloud | productivity | Nextcloud AIO |
| vault | security | Vaultwarden password manager |
| gateway | network | LAN gateway with PBR |
| downloader | storage | Transmission + JDownloader |

---

## 🌿 Genetica Regis {#genetica-regis}

A cannabis breeding documentation project.

**Website:** [genetica-regis.github.io](https://genetica-regis.github.io/)

Genetica Regis is dedicated to developing exceptional cannabis genetics through careful selection, stabilization, and documentation.

**Focus areas:**
- 🧬 **Genetic Selection** — Pheno-hunting for exceptional traits
- 🌱 **Breeding Projects** — Creating new stable crosses
- 🫘 **Seed Production** — Maintaining seed stock
- 📝 **Documentation** — Recording lineages and grow data

---

## 🌱 HerbHub {#herbhub}

A decentralized, community-driven social platform for cannabis growers.

**Status:** In Development

HerbHub is an Instagram alternative built specifically for the cannabis community, with privacy and decentralization at its core.

### Features

- **Decentralized** — No central server, runs on Gun.js + IPFS
- **E2E Encrypted Chat** — Private messaging with full encryption
- **Encrypted Marketplace** — Secure trading between growers
- **Review System** — Community-driven reputation
- **Media Sharing** — Photos and grow logs stored on IPFS

### Technology Stack

| Layer | Technology |
|-------|------------|
| Data Sync | Gun.js (decentralized database) |
| File Storage | IPFS (distributed file system) |
| Encryption | SEA (Security, Encryption, Authorization) |
| Frontend | Progressive Web App |

---

## 🖧 Infrastructure {#infrastructure}

Decentralized nodes operated by Kiwi Network to support HerbHub and other projects.

### Gun.js Relay Nodes

We operate **2 Gun.js relay nodes** that help synchronize data across the decentralized network:

- `gun1.kiwi-network.eu`
- `gun2.kiwi-network.eu`

These relays ensure data availability and faster sync times for HerbHub users.

### IPFS Nodes

We operate **2 IPFS nodes** for distributed file storage:

- `ipfs1.kiwi-network.eu`
- `ipfs2.kiwi-network.eu`

These nodes pin and serve content for HerbHub, ensuring media remains accessible even when original uploaders are offline.

---

## 📧 Contact

Interested in any of these projects?

- **Email:** info@derlocke.net
- **GitHub:** [github.com/derlocke-ng](https://github.com/derlocke-ng)

All projects are open source and contributions are welcome!
