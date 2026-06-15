# MCP: Docker

## Purpose

Docker container and compose management for Hermes Workspace.

## Scope

- Container health inspection
- Docker compose lifecycle management
- Container logs access
- Network inspection

## Access Control

| Operation      | devops-admin   | dev-coder  | default    |
|---------------|----------------|------------|------------|
| docker ps     | auto           | auto       | auto       |
| docker logs   | auto           | auto       | auto       |
| docker inspect| auto           | auto       | auto       |
| compose up    | approval       | blocked    | blocked    |
| compose down  | approval       | blocked    | blocked    |
| restart       | approval       | blocked    | blocked    |
| prune         | forbidden      | forbidden  | forbidden  |

## Integration

```
MCP Server: docker
Transport: stdio or HTTP
Authentication: docker socket (read-only by default)
```

## Security

- Docker socket mounted read-only by default
- Write operations require explicit approval
- Destructive prune operations forbidden
