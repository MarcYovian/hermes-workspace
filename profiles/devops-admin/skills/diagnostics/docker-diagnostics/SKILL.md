---
name: docker-diagnostics
description: Inspect and diagnose Docker containers, compose stacks, and container networking.
compatibility:
  - hermes
metadata:
  hermes:
    tags: [docker, diagnostics, containers, networking]
    category: diagnostics
    requires_toolsets: [terminal, docker]
---

# Docker Diagnostics

Inspect and diagnose Docker containers, compose stacks, and container networking for troubleshooting and pre-mutation verification.

## When to Use

- Container is unhealthy or crashing
- Service not reachable through reverse proxy
- Before any Docker mutation (restart, config change, etc.)
- Compose stack not deploying or misconfigured
- Container networking issues between services

## Procedure

1. Check container health: `docker ps`, `docker inspect`, `docker stats`
2. Read container logs: `docker logs --tail=N --timestamps`
3. Inspect compose config: `docker compose config`, `docker compose ps`
4. Check container networking: `docker network ls`, `docker network inspect`
5. Cross-reference findings with compose manifest
6. Report diagnosis with evidence, never assumptions

Always read before mutating. Mutations require user approval.

## Pitfalls

- Restarting a container before understanding why it failed
- Assuming a container is healthy because `docker ps` shows it running
- Not checking compose config drift (running vs declared state)
- Overlooking dependency chain (container A depends on container B)

## Verification

- Confirm container state and health before reporting
- Verify compose config matches expected state
- Cross-check network connectivity between dependent services
- Ensure logs confirm the diagnosis, not contradict it
