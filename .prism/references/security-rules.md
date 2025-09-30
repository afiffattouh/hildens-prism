# Security Rules

## Authentication Rules
- All endpoints require authentication except /health and /auth/*
- JWT tokens expire after 1 hour
- Refresh tokens expire after 7 days

## Authorization Rules
- Role-based access control (RBAC)
- Principle of least privilege
- Default deny policy

## Data Protection Rules
- PII must be encrypted at rest
- All API communication over HTTPS
- Sensitive data masked in logs
