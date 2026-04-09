#!/usr/bin/env python3
"""
Desktop launcher for File Agent
================================
Opens the web UI in a native desktop window via pywebview.
The FastAPI server starts in a background thread on localhost only.

Usage:
    python launcher.py

Requires pywebview:
    pip install pywebview
"""

import threading
import time

import uvicorn
import webview

from agent import app, MODEL, ROOT, _local_ip


def _start_server() -> None:
    """Run uvicorn in a background daemon thread (localhost only)."""
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="error")


if __name__ == "__main__":
    print(f"Model  : {MODEL}")
    print(f"Root   : {ROOT}")
    print(f"LAN IP : {_local_ip()} (scan QR code in the app to open on phone)")

    # Start server in background
    t = threading.Thread(target=_start_server, daemon=True)
    t.start()

    # Brief pause so the server is ready before the window opens
    time.sleep(1.2)

    # Open native window — title updates once agent name is configured
    webview.create_window(
        "Reiseki",
        "http://127.0.0.1:8000",
        width=1200,
        height=820,
        min_size=(800, 600),
    )
    webview.start()
