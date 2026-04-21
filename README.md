# Reiseki — Local-first AI assistant for files, reminders, and document generation

Reiseki runs inference locally and does not require a cloud LLM API. It provides a FastAPI-based chat UI, optional desktop packaging via pywebview, local SQLite memory, and tool access for files, reminders, documents, and lightweight data analysis.

![Python](https://img.shields.io/badge/Python-3.10%2B-blue)
![FastAPI](https://img.shields.io/badge/FastAPI-0.115%2B-green)
![Ollama](https://img.shields.io/badge/Ollama-local-orange)

---

## Features

- Local LLM inference via Ollama
- File-system tools: list, read, write, create directories
- Local memory persisted in SQLite
- Reminders / appointments in the UI
- Document export: `.docx`, `.xlsx`, `.csv`, `.pdf`
- Basic data analysis and chart generation
- Streaming responses via SSE
- Optional DuckDuckGo web search with explicit confirmation
- Optional LAN access for phone/browser on the same network

---

## Privacy / Security model

### Local by default
- Ollama inference runs locally
- Agent server binds to `127.0.0.1` by default
- Memory is stored locally in SQLite
- File access is restricted to `AGENT_ROOT`

### Network use
- Installing dependencies
- Pulling Ollama models
- DuckDuckGo search after explicit confirmation
- Optional LAN access if enabled

> [!CAUTION]
> Reiseki restricts file access to `AGENT_ROOT`, but it is not a sandbox or security boundary. For sensitive use cases, run it in a dedicated workspace, VM, or container.

> [!IMPORTANT]
> `AGENT_ROOT` defines the workspace the agent may access.  
> By default, `AGENT_ROOT=.` (the current working directory). For safer use, run Reiseki inside a dedicated workspace or set `AGENT_ROOT` explicitly.


## Requirements

- Python 3.10+
- [Ollama](https://ollama.com/download)

Pull a model first:

```bash
ollama pull gemma4:e2b
```

## Install

### Option 1: Release installer

Download the latest release from the [Releases](../../releases) page:

- `ReisekiSetup.exe` — Windows
- `Reiseki.dmg` — macOS

### Option 2: From source

```bash
git clone https://github.com/Flo1632/reiseki.git
cd reiseki
pip install -r requirements.txt
```

### Option 3: Script installer

For systems with Python and Ollama already installed:

- `install.sh` — macOS / Linux
- `install.bat` — Windows

These installer scripts create a virtual environment, install dependencies, pull the default model, and generate a launch script.

## Run

### Browser

```bash
python agent/agent.py
```

Open:

```text
http://localhost:8000
```

### Desktop window

```bash
python agent/launcher.py
```

## Configuration

| Variable | Default | Description |
|---|---|---|
| `AGENT_MODEL` | `gemma4:e2b` | Ollama model |
| `AGENT_ROOT` | `.` | Accessible workspace root |
| `AGENT_HOST` | `127.0.0.1` | Bind host |

Example:

```bash
AGENT_ROOT=~/reiseki-workspace AGENT_MODEL=gemma4:e2b python agent/agent.py
```

## Example prompts

- `Summarize all Markdown files in this folder.`
- `Create a todo.xlsx with task, deadline, and status columns.`
- `Read notes.pdf and extract the main points.`
- `Search the web for the latest FastAPI release notes.`
- `Remind me tomorrow at 09:00 to send the invoice.`

## Tools

| Tool | Description |
|---|---|
| `list_directory` | List files and folders |
| `read_file` | Read file content |
| `write_file` | Write a file |
| `create_directory` | Create a directory |
| `web_search` | Search via DuckDuckGo |
| `save_memory` | Store memory in SQLite |
| `list_memories` | List saved memories |
| `add_appointment` | Create a reminder |
| `list_appointments` | List reminders |
| `create_docx` | Generate a Word file |
| `create_xlsx` | Generate an Excel file |
| `create_csv` | Generate a CSV file |
| `create_pdf` | Generate a PDF file |
| `analyse_data` | Analyze tabular data |
| `create_chart` | Render a matplotlib chart |

## Stack

- **LLM backend:** Ollama
- **API:** FastAPI + Uvicorn
- **Validation:** Pydantic v2
- **Memory:** SQLite
- **Desktop wrapper:** pywebview
- **Frontend:** HTML / CSS / JavaScript

## Notes

- LAN access is **off by default**
- v0.1.3 adds:
  - LAN toggle in the UI
  - PDF read support
  - PDF creation support
  - model switching in the UI without restart

---

## Disclaimer

> [!CAUTION]
> Reiseki is provided **"as is"**, without warranty of any kind, express or implied.
> Use it at your own risk. The authors are not liable for any claim, damages, or other liability arising from the use of the software, including but not limited to data loss, incorrect outputs, failed  automations, or system misconfiguration.
> Reiseki can read and modify files inside `AGENT_ROOT`. Always review outputs and keep backups of important data.
> Reiseki is not a security boundary or sandbox. If you need stronger isolation, run it inside a dedicated workspace, VM, or container.
> Reiseki uses a local large language model (LLM) via Ollama to generate responses, files, and analyses. Additionally, please keep the following in mind:

- **No guarantee of correctness** — LLM outputs can be inaccurate, incomplete, or entirely fabricated ("hallucinations"). **Always review generated content before relying on it.**
- **File operations at your own risk** — The agent can read, write, and overwrite files within `AGENT_ROOT`. **Make sure you have backups of important data.**
- **Not professional advice** — Generated documents, analyses, and scheduling suggestions do not replace professional legal, financial, or medical advice.
- **Model-dependent quality** — Output quality depends entirely on the Ollama model you choose. Reiseki itself is not an AI model.
- **Built with AI** — This project was built entirely with [Claude Code](https://docs.anthropic.com/en/docs/claude-code) by Anthropic.

---

## License

MIT
