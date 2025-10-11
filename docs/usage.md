# Usage

## Prerequisites

- Docker (≥ 20.10)
- Docker Compose (≥ 2.0)
- Python 3.9+
- Terraform 1.5+
- Git
- (Optional) Kubernetes cluster access (kubectl configured) for Helm deployments

## Local Development

```sh
# Clone the repository
git clone https://github.com/your-org/multi-cloud-cicd-pipeline.git
cd multi-cloud-cicd-pipeline

# Set up Python environment
python -m venv .venv
source .venv/bin/activate   # Unix
# .venv\Scripts\activate   # Windows
pip install -r app/requirements.txt

# Configure environment variables
cp .env.example .env
# Edit .env as needed (e.g., cloud credentials, Docker registry)

# Start local services
docker compose -f app/docker-compose.yml up --build
```

The Flask application will be available at `http://localhost:5000`.

## CI/CD Pipelines

Run the full CI/CD flow locally (lint, tests, build, push, Terraform plan):

```sh
./scripts/cicd_pipeline_local.sh
```

## Deploy to Cloud Providers

### AWS

```sh
./scripts/deploy_aws.sh
```

### Azure

```sh
./scripts/deploy_azure.sh
```

### GCP

```sh
./scripts/deploy_gcp.sh
```

Each script uses the corresponding Terraform module and Helm chart to provision resources and deploy the application.

## API Documentation

The Flask API is documented using Swagger/OpenAPI. Generate the specification with:

```sh
pip install flask-swagger-ui
flask run --host 0.0.0.0 --port 5000
```

The OpenAPI JSON can be accessed at `http://localhost:5000/openapi.json`. For a hosted version, see the `docs/api.md` page in this documentation site.

## Monitoring & Observability

- **Prometheus** – Scrapes metrics from the Flask app and infrastructure.
- **Grafana** – Dashboards for latency, error rates, and resource usage.
- **Logging** – Centralized logs via Loki or CloudWatch (AWS), Azure Monitor, GCP Cloud Logging.

## Security

- **Dependency scanning**: Enable Dependabot and Snyk in GitHub to automatically scan for vulnerable dependencies.
- **Secret management**: Store sensitive values (e.g., cloud credentials, SSH keys) in a secret manager such as HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, or GCP Secret Manager. Reference them in Terraform via `var.<name>` and avoid committing them to the repository.
- **Network hardening**: Restrict security group ingress rules to trusted IP ranges. Use bastion hosts or VPN for remote access.
- **TLS/HTTPS**: Configure the Flask application and load balancers to use TLS certificates. Consider using Let's Encrypt for automatic certificate provisioning.