# Send Cursor plans to tablet for review

## Idea

Instead of having to review data on the computer, let's have an easy way to send them to the tablet.

## Brief Solution Explanation

Have a `Cursor` `command` that can be triggered by the user and will place the information in a HTTP server that the tablet can access.

## Implementation

Here is the consolidated, step-by-step guide to setting up your automated "Cursor-to-Tablet" bridge using the Commands feature you found in your settings.


### Step 1: Create the "Tablet" Bash Script

This acts as the "courier" that takes text from Cursor and sends it to your server.

*    Open your terminal on your computer.

*    Run the following command to create the script file:
    Bash

*    sudo nano /usr/local/bin/tablet

*    Paste this code into the editor:
    
    Bash

    #!/bin/bash
    # Takes input from Cursor and sends it to the local Python server
    curl -s -X POST -H "Content-Type: text/plain" --data-binary @- http://localhost:8080

*    Save and exit (Ctrl+O, Enter, then Ctrl+X).

*    Make the script executable:

    sudo chmod +x /usr/local/bin/tablet

### Step 2: Set up the Python Receiver

This script creates a web page that your tablet can access. It includes an auto-refresh feature so you don't have to touch the tablet.

*    Install the Markdown formatter: pip install markdown.

*    Create a file named tablet_server.py and paste this:

```python
from http.server import HTTPServer, BaseHTTPRequestHandler
import markdown
import time

class TabletHandler(BaseHTTPRequestHandler):
    content = "<h1>Tablet Bridge Ready</h1><p>Waiting for your first export...</p>"

    def do_POST(self):
        length = int(self.headers['Content-Length'])
        raw_text = self.rfile.read(length).decode('utf-8')
        html_body = markdown.markdown(raw_text, extensions=['fenced_code', 'tables'])
        
        TabletHandler.content = f"""
        <html>
            <head>
                <meta http-equiv="refresh" content="5">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown.min.css">
                <style>
                    body {{ background: #0d1117; padding: 2rem; display: flex; justify-content: center; }}
                    .markdown-body {{ max-width: 800px; width: 100%; color: #c9d1d9; }}
                </style>
            </head>
            <body class="markdown-body">
                <div style="text-align: right; font-size: 11px; color: #8b949e;">Updated: {time.strftime('%H:%M:%S')}</div>
                {html_body}
            </body>
        </html>
        """
        self.send_response(200)
        self.end_headers()

    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(TabletHandler.content.encode('utf-8'))

print("Server active! Point your tablet to http://localhost:8080 (replace localhost with your IP)")
HTTPServer(('0.0.0.0', 8080), TabletHandler).serve_forever()
```

### Step 3: Configure the Cursor Command

Now, link the two together in the UI you showed me.

*    Go to Cursor Settings > Rules, Skills, Subagents.

*    Scroll down to Commands and click + New.

*    Fill it out as follows:

  * Name: `tablet`

  * Description: `Exports the current plan or text to my tablet.`

  * Body: 
  
  > "Summarize the current task or plan into clean, detailed Markdown. Then, execute the following shell command to send it: echo '{{input}}' | tablet. Confirm once sent."

### Step 4: Connect the Tablet

*    Find your IP: Run `ipconfig (Windows) or ifconfig | grep "inet "` (Mac). It usually looks like 192.168.1.XX.

*    Start the server: In your terminal, run python3 tablet_server.py.

*    Open Tablet: On your tablet's browser, go to http://192.168.1.XX:8080.

### Step 5: Using it

When you are chatting with Cursor and want a plan sent over, just type:

    /tablet send the technical roadmap we just discussed

Cursor will generate the markdown, pipe it to the tablet script, and your tablet will refresh automatically within 5 seconds to show the content.

