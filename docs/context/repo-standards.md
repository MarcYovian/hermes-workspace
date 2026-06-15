# Repository Standards — Shared

Standards for all repositories managed by Hermes Workspace.

---

## Repository Structure (General)

All repositories under /apps/repos/ should follow language-standard conventions:

### PHP / Laravel
- MVC architecture
- Service Layer for business logic
- Repository Pattern for data access
- PSR-4 autoloading
- PHPUnit for testing

### Python / Odoo 18
- Native ORM
- Module-based structure
- Correct model inheritance
- Pytest for testing

### JavaScript / Nuxt / Vue
- Composables for reusable logic
- Framework state management (Pinia/Vuex)
- Modular component structure
- Playwright for E2E testing

## Coding Standards

### General
- Follow existing project conventions first
- Use framework-native patterns
- No hardcoded secrets
- No debug code in commits
- No commented-out code in commits

### PHP (Laravel)
- PSR-12 coding style
- Type hints where possible
- Docblocks for non-obvious methods
- Use Laravel facades and helpers properly

### Python (Odoo)
- PEP 8
- Odoo module conventions (models, views, security, data)
- Proper record rule definitions

### JavaScript
- ESLint recommended config
- Prefer const/let over var
- Async/await over callbacks
- Proper error handling

## Documentation Standards

- README.md for all projects
- Architecture decisions in docs/decisions/
- Operational procedures in runbooks/
- Code comments for non-obvious logic
- Update docs when changing behavior

## Testing Standards

- Write tests alongside code
- Run existing tests before commit
- Never claim tests pass without running them
- If no test suite exists, explain limitation
