from http.server import BaseHTTPRequestHandler, HTTPServer
import urllib.request
import os
import json

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # Health check endpoint for ECS target group
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(b'{"status":"healthy"}')
            return

        # Check if we should call another service via Service Connect
        upstream_url = os.environ.get('UPSTREAM_URL')
        upstream_response = None
        
        if upstream_url:
            try:
                req = urllib.request.Request(upstream_url)
                with urllib.request.urlopen(req, timeout=5) as response:
                    # Parse the upstream JSON response if possible
                    raw_response = response.read().decode('utf-8')
                    try:
                        upstream_response = json.loads(raw_response)
                    except json.JSONDecodeError:
                        upstream_response = raw_response
            except Exception as e:
                upstream_response = f"Error calling upstream ({upstream_url}): {str(e)}"

        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        
        service_name = os.environ.get('SERVICE_NAME', 'frontend-service')
        
        response_data = {
            "service": service_name,
            "message": f"Hello from {service_name}!",
        }
        
        if upstream_response is not None:
            response_data["upstream_response"] = upstream_response
            
        self.wfile.write(json.dumps(response_data, indent=2).encode('utf-8'))

def run(server_class=HTTPServer, handler_class=SimpleHTTPRequestHandler):
    port = int(os.environ.get('PORT', 8080))
    server_address = ('0.0.0.0', port)
    httpd = server_class(server_address, handler_class)
    print(f"Starting server on port {port}...")
    httpd.serve_forever()

if __name__ == '__main__':
    run()
