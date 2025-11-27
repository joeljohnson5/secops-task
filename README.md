SecOps Test – FastAPI Security Project

This repository contains a small FastAPI application designed to demonstrate secure API development, basic DevSecOps practices, and security testing. The project focuses on building the API locally, validating inputs, running tests, packaging the app using Docker, and including sample Kubernetes and Terraform files.

Architecture 

This project uses a lightweight, local-first architecture:

1. FastAPI Application

Main backend service (main.py)

/items endpoint with validation

Clean error handling


2. Local Development

Runs on http://127.0.0.1:9000

Interactive API docs at /docs

Python virtual environment

3. Automated Tests

Unit tests written with pytest

Validate correct endpoint behavior

Runs automatically in CI (GitHub Actions)

4. Docker Containerization

Dockerfile included

Allows consistent packaging and future deployment

5. Kubernetes Manifests (Sample Only)

Deployment and Service YAMLs included

Demonstrate how the API would run on Kubernetes

Not required to be deployed as part of this task

6. Terraform IaC (Sample Only)

A single main.tf file includes definitions for the mandatory AWS security components:

VPC with public/private subnets

NAT Gateway

S3 bucket for logs

AWS GuardDuty enabled

AWS WAF with managed rule set

IAM Role for Service Accounts (IRSA placeholder)

These represent how the architecture would be deployed securely on AWS, even though the infrastructure is not provisioned.

7. DevSecOps: CI Pipeline

A GitHub Actions workflow is included to:

Install dependencies

Run tests on every push

This ensures code quality and simulates continuous integration.

What I Did NOT Deploy (But Included as Design)

Since this is a learning project, I did not deploy full AWS infrastructure such as EKS, WAF, or GuardDuty. However, I included the required Terraform IaC and Kubernetes manifests to demonstrate understanding of how the system would operate in a real cloud environment.

Local Setup Instructions

1. Create and activate a virtual environment

python -m venv venv
venv\Scripts\activate   (for Windows)

2. Install dependencies
pip install -r requirements.txt

3. Run the FastAPI app
uvicorn main:app --reload --port 9000

4. Open Swagger UI
http://127.0.0.1:9000/docs

/items
http://127.0.0.1:9000/items


Running Tests

pytest

Security Hardening Summary

Security checks performed during the assessment:

Input validation
invalid data produces safe 422 responses with no internal leaks.

SQL injection behavior
Payloads such as abc' OR 1=1-- are treated as normal text — no SQL errors.

Error handling
No stack traces or sensitive information exposed.

Missing Authentication
The API is intentionally open for testing. In production, a token-based system or API gateway would be required.

Rate Limiting
No built-in rate limiting would normally be handled at gateway/WAF layer.

HTTPS/TLS
Local HTTP only; production would require TLS termination.

Security Headers
Basic FastAPI/Uvicorn headers; real deployments would add CSP, HSTS, etc.

A full detailed report is in api_security.md.

CI/CD Pipeline

A basic GitHub Actions workflow is used for Continuous Integration:
Runs on every push or pull request
Installs dependencies
Executes unit tests

Ensures code doesn't break unexpectedly
Deployment automation (CD) is not implemented but is supported via Docker + Kubernetes manifests for future extension.

Repository Structure 

secops-task/
├── main.py
├── requirements.txt
├── Dockerfile
├── tests/
├── kubernetes/          # sample Kubernetes manifests
├── terraform/           # sample AWS IaC (mandatory components)
├── api_security.md      # full pentesting report
├── .github/workflows/   # CI pipeline
└── README.md            # this documentation


 While the cloud infrastructure is not deployed, all required components are included in Terraform and explained clearly. 
