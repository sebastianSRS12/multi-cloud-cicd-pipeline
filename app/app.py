from flask import Flask, jsonify
import os

from prometheus_flask_exporter import PrometheusMetrics
app = Flask(__name__)
# Expose Prometheus metrics at /metrics
metrics = PrometheusMetrics(app, group_by='endpoint')

@app.route('/')
def home():
    cloud = os.getenv('CLOUD_PROVIDER', 'Local')
    return jsonify({"message": f"Hello from {cloud}! This is a multi-cloud CI/CD demo."})

@app.route('/health')
def health():
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port)