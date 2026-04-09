# Reiseki — Local AI Assistant

Privacy-first local AI assistant for files, appointments, and documents — powered by Ollama. Runs entirely on your machine — no cloud API, no personal data leaves the device.

Accessible as a web app in your browser or as a native desktop window (via pywebview). Also reachable from your phone via QR code on the same local network.

![Python](https://img.shields.io/badge/Python-3.10%2B-blue)
![FastAPI](https://img.shields.io/badge/FastAPI-0.115%2B-green)
![Ollama](https://img.shields.io/badge/Ollama-local-orange)

---

## Features

- **Chat with your file system** — list, read, write, and create files through natural language
- **Web search** — DuckDuckGo queries with explicit user confirmation before sending
- **Persistent memory** — the agent remembers facts across conversations (SQLite)
- **Appointments** — schedule reminders with toast notifications in the UI
- **Document creation** — generate `.docx`, `.xlsx`, `.csv` files on request
- **Data analysis & charts** — analyse tabular data and render matplotlib charts
- **QR code access** — scan to open the UI from your phone on the same Wi-Fi
- **Desktop launcher** — opens in a native window via `pywebview`
- **Streaming responses** — token-by-token output via Server-Sent Events

---

## Requirements

- Python 3.10+
- [Ollama](https://ollama.com/download) installed and running locally

---

## Quick Start

### 1. Install Ollama and pull a model

```bash
# Install Ollama from https://ollama.com/download, then:
ollama pull qwen2.5-coder:7b
```

### 2. Clone and install dependencies

```bash
git clone https://github.com/Flo1632/reiseki.git
cd reiseki
pip install -r requirements.txt
```

### 3. Run

```bash
# Browser (default)
python agent/agent.py

# Native desktop window
python agent/launcher.py
```

Open [http://localhost:8000](http://localhost:8000) in your browser.

---

## Script Installers (macOS / Windows)

For non-developer users who have Python and Ollama already installed:

| Platform | Script |
|----------|--------|
| macOS / Linux | `install.sh` |
| Windows | `install.bat` |

These scripts create a virtual environment, install all Python dependencies, pull the default model, and generate a `launch.sh` / `launch.bat` shortcut to start the app.

> **Packaged releases (.exe / .dmg)** — standalone installers that bundle Python are planned and will be built automatically via GitHub Actions. Check the [Releases](../../releases) page once available.

---

## Configuration

| Environment Variable | Default | Description |
|---|---|---|
| `AGENT_MODEL` | `qwen2.5-coder:7b` | Ollama model to use |
| `AGENT_ROOT` | `.` (current dir) | Root directory the agent may access |
| `AGENT_HOST` | `127.0.0.1` | Host to bind the server to |

```bash
AGENT_MODEL=qwen2.5-coder:14b AGENT_ROOT=~/documents python agent/agent.py
```

---

## Security

- **Path traversal guard** — all file operations are restricted to `AGENT_ROOT`
- **Web search confirmation** — outbound search requires explicit in-UI approval
- **Local only** — Ollama and the agent server run on `localhost` by default

---

## Available Tools

| Tool | Description |
|---|---|
| `list_directory` | List files and folders |
| `read_file` | Read file content |
| `write_file` | Create or overwrite a file |
| `create_directory` | Create a new folder |
| `web_search` | Search via DuckDuckGo |
| `save_memory` | Persist a memory to SQLite |
| `list_memories` | Recall stored memories |
| `add_appointment` | Schedule an appointment |
| `list_appointments` | List upcoming appointments |
| `create_docx` | Generate a Word document |
| `create_xlsx` | Generate an Excel spreadsheet |
| `create_csv` | Generate a CSV file |
| `analyse_data` | Analyse tabular data with pandas |
| `create_chart` | Render a matplotlib chart |

---

## Stack

| Layer | Technology |
|---|---|
| LLM backend | Ollama |
| Web framework | FastAPI + Uvicorn |
| Data validation | Pydantic v2 |
| Persistent memory | SQLite |
| Desktop wrapper | pywebview |
| Frontend | Vanilla HTML/CSS/JS (sepia dark theme) |

---

## License

MIT
