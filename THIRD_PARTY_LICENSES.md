# Third-Party Licenses

Reiseki depends on the following third-party packages. All are installed via pip and are not modified or bundled.

## LGPL-3.0

### fpdf2
- **License:** GNU Lesser General Public License v3.0 (LGPL-3.0)
- **Source:** https://github.com/py-pdf/fpdf2
- **Usage:** PDF document generation

fpdf2 is used as a standard pip dependency and is not statically linked or modified. End users may replace it with a modified version by installing an alternative version via pip. Full license text: https://www.gnu.org/licenses/lgpl-3.0.html

## MIT / BSD / Apache-2.0

All other dependencies (fastapi, uvicorn, ollama, pydantic, ddgs, qrcode, Pillow, pywebview,
python-docx, openpyxl, xlrd, pandas, matplotlib, python-multipart, pdfplumber) are distributed
under MIT, BSD, or Apache-2.0 licenses, which are fully compatible with this project's MIT license.
