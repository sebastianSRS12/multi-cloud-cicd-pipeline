from flask import Flask, jsonify
from flask_swagger_ui import get_swaggerui_blueprint
import os

from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)

# Swagger UI configuration
SWAGGER_URL = '/docs'
API_URL = '/static/swagger.yaml'  # We will need to serve this file

swaggerui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,
    API_URL,
    config={
        'app_name': "Multi-Cloud CI/CD Demo API"
    }
)

app.register_blueprint(swaggerui_blueprint, url_prefix=SWAGGER_URL)

# Expose Prometheus metrics at /metrics
metrics = PrometheusMetrics(app, group_by='endpoint')

@app.route('/')
def home():
    cloud = os.getenv('CLOUD_PROVIDER', 'Local')
    return jsonify({"message": f"Hello from {cloud}! This is a multi-cloud CI/CD demo."})

@app.route('/health')
def health():
    return jsonify({"status": "healthy"})

# Serve swagger.yaml
@app.route('/static/swagger.yaml')
def swagger_spec():
    return app.send_static_file('swagger.yaml')

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port)