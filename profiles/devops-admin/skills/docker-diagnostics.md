# Skill: Docker Diagnostics

Inspect and diagnose Docker containers, compose stacks, and container networking.

## Behavior

- Check container health: docker ps, docker inspect, docker stats
- Read container logs: docker logs --tail=N
- Inspect compose config: docker compose config, docker compose ps
- Check container networking: docker network ls, docker network inspect
- Always read before mutating. Mutations require approval.
