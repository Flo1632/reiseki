#!/usr/bin/env bash
set -e

echo "=== Reiseki — macOS Installer ==="
echo ""

# ── 1. Check Python ───────────────────────────────────────────────────────────
if ! command -v python3 &>/dev/null; then
    echo "ERROR: Python 3 is not installed."
    echo "Download it from: https://www.python.org/downloads/"
    exit 1
fi

PYTHON_MINOR=$(python3 -c 'import sys; print(sys.version_info.minor)')
if [ "$PYTHON_MINOR" -lt 10 ]; then
    echo "ERROR: Python 3.10+ required. You have Python 3.${PYTHON_MINOR}."
    exit 1
fi
echo "✓ Python 3.${PYTHON_MINOR} found"

# ── 2. Check Ollama ───────────────────────────────────────────────────────────
if ! command -v ollama &>/dev/null; then
    echo ""
    echo "Ollama is not installed."
    echo "Please install it manually before running this installer:"
    echo ""
    echo "  → https://ollama.com/download"
    echo ""
    echo "After installing Ollama, run this script again."
    exit 1
else
    echo "✓ Ollama already installed"
fi

# ── 3. Start Ollama if not running ────────────────────────────────────────────
if ! curl -s http://localhost:11434 &>/dev/null; then
    echo "Starting Ollama in background..."
    ollama serve &>/dev/null &
    sleep 3
fi
echo "✓ Ollama is running"

# ── 4. Pull model ─────────────────────────────────────────────────────────────
MODEL="${AGENT_MODEL:-qwen2.5-coder:7b}"
echo "Pulling model: $MODEL (may take several minutes on first run)..."
ollama pull "$MODEL"
echo "✓ Model ready: $MODEL"

# ── 5. Create virtual environment ─────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/venv"

if [ ! -d "$VENV_DIR" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv "$VENV_DIR"
fi
echo "✓ Virtual environment ready"

# ── 6. Install Python dependencies ───────────────────────────────────────────
echo "Installing Python dependencies..."
"$VENV_DIR/bin/pip" install --quiet --upgrade pip
"$VENV_DIR/bin/pip" install --quiet -r "$SCRIPT_DIR/requirements.txt"
echo "✓ Dependencies installed"

# ── 7. Create launcher ────────────────────────────────────────────────────────
LAUNCHER="$SCRIPT_DIR/launch.sh"
cat > "$LAUNCHER" <<LAUNCH
#!/usr/bin/env bash
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
source "\$SCRIPT_DIR/venv/bin/activate"
# Start Ollama if not already running
curl -s http://localhost:11434 &>/dev/null || (ollama serve &>/dev/null & sleep 2)
python3 "\$SCRIPT_DIR/launcher.py"
LAUNCH
chmod +x "$LAUNCHER"
echo "✓ Launcher created: launch.sh"

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Start the app:  ./launch.sh"
echo "Browser fallback: http://localhost:8000"
echo ""
echo "To use a different model:"
echo "  AGENT_MODEL=qwen2.5-coder:14b ./launch.sh"
