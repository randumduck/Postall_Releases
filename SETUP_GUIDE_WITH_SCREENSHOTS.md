# Postall Sovereign Enterprise Edition — Turnkey Setup Guide & Visual Walkthrough

**Architecture:** Zero-Trust Mesh · Air-Gapped Sovereign AI · Multi-Tenant Vault  
**Platform Version:** 4.2.0 Sovereign Enterprise Edition  
**Target Environment:** Docker Engine 24.0+ · Linux / Windows / macOS  

---

## Executive Quick Start (1-Click Deployment)

Postall is delivered as an air-gapped containerized ecosystem that deploys in under 2 minutes.

### Windows (PowerShell Administrator)
```powershell
# Run the 1-Click Turnkey Installer
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/randumduck/Postall_Releases/main/setup_postall.ps1" -OutFile "setup_postall.ps1"
powershell -ExecutionPolicy Bypass -File .\setup_postall.ps1
```

### Linux / macOS (Bash Shell)
```bash
# Run the 1-Click Turnkey Shell Installer
curl -sSL https://raw.githubusercontent.com/randumduck/Postall_Releases/main/setup_postall.sh -o setup_postall.sh
chmod +x setup_postall.sh && ./setup_postall.sh
```

### Docker Compose Turnkey Stack
```bash
docker compose up -d
```

Once started, open your web browser to:
$$\mathbf{http://localhost:8000/}$$

You will be automatically redirected to the **Pristine Vanilla Setup Wizard (`/setup`)**.

---

## Visual Setup Walkthrough (Step-by-Step)

```
+===================================================================================+
|  POSTALL COMMAND CENTER  ::  ENTERPRISE INSTALLATION WIZARD                       |
+===================================================================================+
|                                                                                   |
|  [ Step 1: Volume ] -> [ Step 2: Admin ] -> [ Step 3: Vault ] -> [ Step 4: Done ] |
|                                                                                   |
|  +-----------------------------------------------------------------------------+  |
|  |  STEP 1: STORAGE VOLUME & HARDWARE PERSISTENCE VERIFICATION                 |  |
|  |                                                                             |  |
|  |  [*] Persistence Check : /app/data mounted to Docker volume 'postall_data'  |  |
|  |  [*] Encryption Salt   : Generated at rest (AES-256 Fernet Engine active)   |  |
|  |  [*] Sovereign Engine  : Ollama daemon reachable on postall_llm:11434       |  |
|  |  [*] Status            : ALL HARDWARE BOUNDARIES VERIFIED                   |  |
|  +-----------------------------------------------------------------------------+  |
|                                                               [ NEXT: SECURITY -> ]|
+===================================================================================+
```

### Step 1: Storage Volume & Hardware Persistence Verification
- **Purpose**: Verifies that your container is mounted to persistent external storage (`postall_data`). When Docker containers are updated or restarted, your databases, generated media, and cryptographic keys remain safely persisted on host disk.
- **Action**: The installer automatically confirms file write permissions in `/app/data`. Click **Next: Security**.

---

```
+===================================================================================+
|  STEP 2: ROOT ADMINISTRATOR IDENTITY & SOX COMPLIANCE                             |
+===================================================================================+
|                                                                                   |
|  Administrator Username  : [ admin                                            ]   |
|  Secure Password         : [ *********************************                ]   |
|  Confirm Password        : [ *********************************                ]   |
|  Admin Notification Email: [ security-team@company.internal                   ]   |
|                                                                                   |
|  [x] Enable SOX Maker-Checker (4-Eyes Rule: Authors cannot self-approve posts)    |
|  [x] Enable Real-Time GDPR PII Scrubbing (Auto-quarantine sensitive tokens)       |
|                                                                                   |
|  [<- BACK ]                                           [ NEXT: AI CONFIGURATION -> ]|
+===================================================================================+
```

### Step 2: Root Administrator & SOX Compliance Initialization
- **Purpose**: Establishes the primary operator account and cryptographically seeds PBKDF2-SHA256 password hashes with unique 210,000-iteration salts.
- **Enterprise Controls**:
  - **SOX 4-Eyes Governance**: Ensures that junior content creators cannot publish directly to live enterprise social feeds without managerial review.
  - **GDPR PII Scrubbing**: Real-time redaction of credit cards, passwords, and employee identities before content leaves the generation engine.

---

```
+===================================================================================+
|  STEP 3: SOVEREIGN AI COCKPIT & VAULT BYO-KEY ORCHESTRATION                      |
+===================================================================================+
|                                                                                   |
|  Primary AI Engine : (o) Local Sovereign AI (Air-Gapped Qwen 1.5B / $0 Tokens)     |
|                      ( ) Frontier Cloud AI Only (Gemini / OpenAI / Anthropic)     |
|                      ( ) Hybrid Air-Gapped (Local First + Cloud Fallback)         |
|                                                                                   |
|  Cloud BYO-Key Vault (Optional - Encrypted with Fernet AES-256 at Rest):          |
|  +-----------------------------------------------------------------------------+  |
|  | Google Gemini API Key : [ AQ.Ab8RN6KBTiZdScKgdFu47eg5HiL_jKEm9RLT...    ]   |  |
|  | OpenAI API Key        : [ sk-proj-Optional-BYO-Key......................    ]   |  |
|  | Anthropic API Key     : [ sk-ant-Optional-BYO-Key.......................    ]   |  |
|  +-----------------------------------------------------------------------------+  |
|                                                                                   |
|  [<- BACK ]                                            [ NEXT: BRAND IDENTITY -> ]|
+===================================================================================+
```

### Step 3: Sovereign AI Cockpit & Multi-Tenant BYO-Key Vault
- **Purpose**: Configures your default artificial intelligence pipelines.
- **Zero Token Cost**: By selecting **Local Sovereign AI**, all post generation, technical analysis, and SVG diagrams run at **$0 per token** entirely inside your private container perimeter.
- **Cloud Escalation**: If you provide a Google Gemini or OpenAI key, the system encrypts it with AES-256 and only calls cloud APIs when explicitly requested (such as 4K visual art generation).

---

```
+===================================================================================+
|  STEP 4: BRAND IDENTITY & DYNAMIC WORKSPACE THEME                                |
+===================================================================================+
|                                                                                   |
|  Organization / Brand Name : [ Postall Enterprise Cloud                     ]     |
|  Primary Accent Color      : [ #38BDF8 (Sky Cyan)   ]                             |
|  Default Visual Theme      : [ Obsidian (Soothing Dark)            v ]            |
|  Default Content Persona   : [ Tech Academy & Education (Deep Dive) v ]           |
|                                                                                   |
|  [ ] Seed Enterprise Demo Blueprints & Case Studies                               |
|                                                                                   |
|  [<- BACK ]                                                 [ COMPLETE SETUP (✓) ]|
+===================================================================================+
```

### Step 4: Brand Identity & Default Workspace
- **Purpose**: Personalizes generated infographics, carousels, and visual headers with your company's official typography and color palette.
- **Clicking Complete Setup**: Writes the verified configuration to `postall.db`, locks the setup wizard, and immediately transitions into the **Postall Command Center Dashboard**.

---

## Day-to-Day Operations & Feature Usage

### 1. Unified Content Studio (3-Click Idea-to-Live)

```
+-----------------------------------------------------------------------------------+
| UNIFIED CONTENT STUDIO                                                            |
| +-------------------------------------------------------------------------------+ |
| | Content Synthesis Brief (Topic, Headline, or Article URL)                     | |
| | [ eBPF Kernel Probes for Real-Time Threat Detection in Cloud Kubernetes      ] | |
| +-------------------------------------------------------------------------------+ |
|  Platform: [ LinkedIn (3,000 chars) v ]   Tone: [ Authoritative & Technical v ]  |
|  Visual Aspect: [ 4:5 Portrait      v ]   Archetype: [ Cartoon Tech Explainer v]  |
|                                                                                   |
|  [+] Attach Custom Media Canvas (Optional - Overlays your branding on photo)     |
|                                                                                   |
|                       [ ⚡ GENERATE POST & Branded Media ]                         |
+-----------------------------------------------------------------------------------+
```

- **How to Use**:
  1. Enter your concept or paste an engineering blog post URL.
  2. Select your platform and desired visual format (**Infographic Blueprint**, **Cartoon Tech Explainer**, or **LinkedIn PDF Carousel**).
  3. Click **Generate Post & Branded Media**.
  4. The Sovereign AI writes a comprehensive 4-part breakdown (>2,000 characters), generates branded vector artwork, scrubs PII, and registers the post into the Editorial Queue.

---

### 2. Editorial Approvals & 4-Eyes Governance

```
+-----------------------------------------------------------------------------------+
| EDITORIAL QUEUE :: DRAFT #60 (PENDING SOX APPROVAL)                               |
+-----------------------------------------------------------------------------------+
| [ LinkedIn Post Copy Preview ]            | [ Visual Media Preview (1080x1350) ]  |
|                                           |                                       |
| Bold Headline & Executive Hook:           |  +---------------------------------+  |
| "How eBPF Kernel Probes Intercept..."     |  | POSTALL BRIEFING   🛡️ SECURITY   |  |
|                                           |  | Zero-Trust Kubernetes Security  |  |
| Technical Analysis & Architecture:        |  | ------------------------------- |  |
| 1. Control Plane Isolation                |  | [Dev Avatar]  [Architect Avatar]|  |
| 2. Microsegmentation & mTLS               |  | "How does eBPF intercept bugs?" |  |
| 3. Sub-second Threat Quarantining         |  |                                 |  |
|                                           |  | [ Under Hood ] [ Playbook ]     |  |
| #CyberSecurity #DevSecOps #Kubernetes     |  +---------------------------------+  |
|                                                                                   |
| [✓ Approve]     [✗ Reject]     [📅 Schedule]     [⚡ Post Now]     [👁️ Preflight]   |
+-----------------------------------------------------------------------------------+
```

- **Maker-Checker Enforcement**: If the author attempts to approve their own draft, Postall rejects the action with `403 Forbidden: Peer review required`.
- **Preflight Scorecard**: Evaluates read-time, technical density, hashtag presence, and brand safety on a 100-point scale before transmission.

---

### 3. Multi-Model ROI Calculator & Boardroom Telemetry

```
+-----------------------------------------------------------------------------------+
| PREBUILT DASHBOARDS :: ENTERPRISE TOKEN ROI CALCULATOR                            |
+-----------------------------------------------------------------------------------+
|  Monthly Volume Cadence: [ 80 Posts / Month ]   Average Words: [ 400 Words ]      |
|                                                                                   |
|  Provider Model              Rate / 1M Tokens    Projected Monthly    Annual Cost |
|  -------------------------------------------------------------------------------  |
|  OpenAI GPT-4o               $30.00 / 1M         $2.72                $32.64      |
|  Anthropic Claude 3.5 Sonnet $15.00 / 1M         $1.36                $16.32      |
|  Google Gemini 2.5 Pro       $7.00 / 1M          $0.63                $7.61       |
|  Google Gemini 3.5 Flash     $0.35 / 1M          $0.03                $0.38       |
|  Postall Sovereign Engine    $0.00 (AIR-GAPPED)  $0.00                $0.00       |
|  -------------------------------------------------------------------------------  |
|  CUMULATIVE ENTERPRISE VALUE: 100% Zero-Egress Freedom · Data Leakage Impossibility|
+-----------------------------------------------------------------------------------+
```

- Accessible via `GET /api/analytics/roi-calculator`.
- Provides financial officers and security leadership with concrete, unalterable proof of token savings.

---

### 4. Zero-Trust Gateway & Cryptographic Security Architecture

```
+-----------------------+     RS256 JWT Signed      +-------------------------+
|    POSTALL ENGINE     | ------------------------> |     POSTALL GATEWAY     |
|     (Core Docker)     |   (Anti-Replay jti nonce  |   (Zero-Trust Proxy)    |
|       Port 8000       |    Payload SHA-256 hash)  |        Port 8080        |
+-----------------------+                           +-------------------------+
                                                                 |
                                +--------------------------------+--------------------+
                                |                                |                    |
                                v                                v                    v
                        [ LinkedIn API ]                  [ X/Twitter API ]   [ Meta / IG API ]
```

- **Signed Dispatches**: Every publication request across all 10 social networks carries a 60-second expiring RS256 JWT signed with your node's RSA private key.
- **Anti-Replay Cache**: The Gateway rejects any duplicate request within its sliding TTL window (`401 Replay Attack Detected`).
- **Tamper Protection**: Any intercepted or modified HTTP payload fails body SHA-256 verification (`401 Payload Tampering Failed`).
