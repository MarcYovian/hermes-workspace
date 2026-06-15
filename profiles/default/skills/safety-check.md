# Skill: Safety Check

Pre-action safety validation for the orchestrator profile.

## Pre-Action Checklist

- Is this action read-only? → proceed
- Is this action write/mutate? → require approval
- Is this action delete/destructive? → require approval + confirmation
- Does this fall within my scope? → if not, delegate
- Have I verified current state? → if not, inspect first
- Is risk level clear? → if not, clarify with user

## Forbidden Action Detection

Block and escalate when detecting:
- Infrastructure mutation: apt, ufw, iptables, systemctl, service
- Docker mutation: docker compose up/down, docker restart, docker rm
- Git mutation: git commit, git push, git merge, git checkout main
- Dangerous commands: chmod 777, rm -rf, docker system prune, sudo without approval

## Clarification Triggers

Stop and ask user when:
1. Task objective ambiguous
2. Missing context about architecture or dependencies
3. Risk level unclear or potentially destructive
4. Multiple specialists possibly needed but unclear which
5. User asks for action outside defined scope
