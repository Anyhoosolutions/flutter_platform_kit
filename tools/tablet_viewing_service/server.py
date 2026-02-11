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
            # Explicitly open with utf-8 encoding
            with open(SAVE_FILE, "r", encoding="utf-8") as f:
                raw_text = f.read()
            return self.wrap_content(raw_text)
        return "<h1>Tablet Bridge Ready</h1><p>Send something from Cursor!</p>"

    def wrap_content(self, raw_text):
        html_body = markdown.markdown(raw_text, extensions=['fenced_code', 'tables', 'nl2br'])
        return f"""
        <!DOCTYPE html>
        <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta http-equiv="refresh" content="5">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown-dark.min.css">
                <style>
                    body {{ background-color: #0d1117; margin: 0; padding: 0; display: flex; flex-direction: column; align-items: center; }}
                    .markdown-body {{ box-sizing: border-box; min-width: 200px; max-width: 900px; width: 100%; margin: 0 auto; padding: 45px; background-color: #0d1117; color: #c9d1d9; }}
                    .markdown-body > * {{ display: block !important; float: none !important; clear: both !important; width: 100% !important; }}
                    .sync-header {{ position: sticky; top: 0; background: #161b22; padding: 10px; text-align: center; font-size: 12px; color: #8b949e; border-bottom: 1px solid #30363d; width: 100%; z-index: 100; }}
                    pre {{ background-color: #161b22 !important; border: 1px solid #30363d; overflow-x: auto; white-space: pre-wrap; word-wrap: break-word; }}
                </style>
            </head>
            <body>
                <div class="sync-header">
                    Displaying: {SAVE_FILE} | Last Synced: {time.strftime('%H:%M:%S')}
                </div>
                <article class="markdown-body">
                    {html_body}
                </article>
            </body>
        </html>
        """

    def do_POST(self):
        length = int(self.headers['Content-Length'])
        # Ensure we decode the incoming bytes using utf-8
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

print(f"Server active. Persistence enabled via {SAVE_FILE}")
HTTPServer(('0.0.0.0', 8080), TabletHandler).serve_forever()
