# 🪽 Aqtive
LXQt on Arch made effortless.
## 📜 System Requirements
| Component | Minimum | Recommended |
| :--- | :--- | :--- |
| **Processor** | 64-bit x86-64 | Dual Core or better |
| **RAM** | 1GB | ≥2GB |
| **Storage** | 4GB | ≥8GB |
| **Architecture** | Arch Linux | Post-Archinstall |

---

## 🚀 Installation
Run this command post-archinstall as a user with `sudo` privileges. 

```bash
curl -fsSL https://is.gd/aqtive | sh
```

---

## How it works

```mermaid
sequenceDiagram
    autonumber
    participant U as User/Sudo
    participant M as main.sh
    participant S as /src/ (Remote/Local)
    participant Sys as Linux System

    Note over U, Sys: Execution Starts
    U->>M: Execute main.sh
    activate M
    M->>U: Request Sudo Privileges
    M->>M: Detect LXQt Session

    alt if LXQt is present (Update Mode)
        M->>S: Call install.sh
        activate S
        S->>Sys: Install Drivers & Core Packages
        deactivate S

        M->>S: Call clean.sh
        activate S
        S->>Sys: Vacuum Logs & Remove Unused Firmware
        deactivate S

    else if LXQt is absent (Full Install Mode)
        M->>S: Call install.sh
        activate S
        S->>Sys: S-Syu & Install Full LXQt + Drivers
        deactivate S

        M->>S: Call config.sh
        activate S
        S->>Sys: Setup zRAM, Services (BT, NM, Pipewire)
        deactivate S

        M->>S: Call clean.sh
        activate S
        S->>Sys: Clear Cache & Orphaned Packages
        deactivate S
    end

    M->>Sys: sync (Flush Filesystem)
    M->>U: Prompt: "Reboot now? [Y/n]"
    
    opt if Y
        M->>Sys: reboot
    end
    deactivate M
    Note over U, Sys: Process Finished
```

---

## 📜 License

&copy; Aqtive 2026. Code released under the [MIT license](https://github.com/Kaiserrrrrr/aqtive/blob/master/LICENSE).
