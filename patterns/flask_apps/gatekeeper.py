from flask import Flask, request
import requests

app = Flask(__name__)

# Proxy Server Configuration
with open("proxy_addr", "r") as file:
    proxy_server_base_url = file.read().strip()


@app.route('/process_request', methods=['POST'])
def process_request():
    try:
        # Get the query parameter 'proxy_type' from the request URL
        proxy_type = request.args.get('proxy_type', default='direct_hit')

        # Validate the proxy_type parameter
        if proxy_type not in ['direct_hit', 'random', 'customized']:
            return "Invalid proxy_type parameter", 400

        # Forward request to the specified MySQL Proxy endpoint
        proxy_url = f"http://{proxy_server_base_url}/{proxy_type}"
        response = requests.post(proxy_url, data=request.data)

        if response.status_code == 200:
            return response.text, 200
        else:
            return "Error processing request", 500
    except Exception as e:
        return str(e), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
