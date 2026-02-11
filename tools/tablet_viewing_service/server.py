from http.server import HTTPServer, BaseHTTPRequestHandler
import markdown
import time
import os

# Configuration
SAVE_FILE = "tablet_content.md"

class TabletHandler(BaseHTTPRequestHandler):
    content_html = ""

    def load_initial_content(self):
        if os.path.exists(SAVE_FILE):
            with open(SAVE_FILE, "r", encoding="utf-8") as f:
                raw_text = f.read()
            return self.wrap_content(raw_text)
        return "<h1>Tablet Bridge Ready</h1><p>Send something from Cursor!</p>"

    def wrap_content(self, raw_text):
        html_body = markdown.markdown(raw_text, extensions=['fenced_code', 'tables', 'nl2br'])
        return f"""
        <!DOCTYPE html>
        <html lang="en" data-theme="dark">
            <head>
                <meta charset="UTF-8">
                <meta http-equiv="refresh" content="5">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown-dark.min.css" id="theme-css">
                <style>
                    :root {{ --bg: #0d1117; --header: #161b22; --text: #c9d1d9; }}
                    [data-theme="light"] {{ --bg: #ffffff; --header: #f6f8fa; --text: #24292f; }}

                    body {{ background-color: var(--bg); color: var(--text); margin: 0; padding: 0; display: flex; flex-direction: column; align-items: center; transition: background 0.3s; }}
                    .markdown-body {{ box-sizing: border-box; min-width: 200px; max-width: 900px; width: 100%; margin: 0 auto; padding: 45px; background-color: transparent !important; }}

                    .sync-header {{
                        position: sticky; top: 0; background: var(--header); padding: 10px;
                        display: flex; justify-content: space-between; align-items: center;
                        font-size: 12px; color: #8b949e; border-bottom: 1px solid #30363d; width: 100%; z-index: 100;
                    }}
                    button {{
                        background: #21262d; color: #c9d1d9; border: 1px solid #30363d;
                        padding: 5px 10px; border-radius: 6px; cursor: pointer; margin-right: 20px;
                    }}
                    pre {{ overflow-x: auto; white-space: pre-wrap; word-wrap: break-word; }}
                </style>
            </head>
            <body>
                <div class="sync-header">
                    <span style="margin-left:20px;">Synced: {time.strftime('%H:%M:%S')}</span>
                    <button onclick="toggleTheme()">🌓 Toggle Theme</button>
                </div>
                <article class="markdown-body">
                    {html_body}
                </article>

                <script>
                    function applyTheme(theme) {{
                        document.documentElement.setAttribute('data-theme', theme);
                        const link = document.getElementById('theme-css');
                        link.href = theme === 'dark'
                            ? 'https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown-dark.min.css'
                            : 'https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown-light.min.css';
                        localStorage.setItem('theme', theme);
                    }}

                    function toggleTheme() {{
                        const current = document.documentElement.getAttribute('data-theme');
                        applyTheme(current === 'dark' ? 'light' : 'dark');
                    }}

                    // Restore preference on load
                    const saved = localStorage.getItem('theme') || 'dark';
                    applyTheme(saved);
                </script>
            </body>
        </html>
        """

    def do_POST(self):
        length = int(self.headers['Content-Length'])
        raw_text = self.rfile.read(length).decode('utf-8', errors='replace')
        with open(SAVE_FILE, "w", encoding="utf-8") as f:
            f.write(raw_text)
        TabletHandler.content_html = self.wrap_content(raw_text)
        self.send_response(200)
        self.end_headers()

    def do_GET(self):
        if not TabletHandler.content_html:
            TabletHandler.content_html = self.load_initial_content()
        self.send_response(200)
        self.send_header("Content-type", "text/html; charset=utf-8")
        self.end_headers()
        self.wfile.write(TabletHandler.content_html.encode('utf-8'))

print(f"Server active. Using {SAVE_FILE} for storage.")
HTTPServer(('0.0.0.0', 8080), TabletHandler).serve_forever()
