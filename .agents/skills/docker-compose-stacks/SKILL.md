```markdown
# docker-compose-stacks Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill teaches the core development patterns and conventions used in the `docker-compose-stacks` TypeScript repository. You'll learn about file naming, import/export styles, commit message formatting, and how to write and organize tests. While no automated workflows were detected, this guide provides suggested commands and step-by-step instructions for common development tasks.

## Coding Conventions

### File Naming
- Use **PascalCase** for file names.
  - Example: `DockerComposeStack.ts`

### Import Style
- Use **relative imports** for internal modules.
  - Example:
    ```typescript
    import { StackConfig } from './StackConfig';
    ```

### Export Style
- Use **named exports** rather than default exports.
  - Example:
    ```typescript
    export function createStack() { ... }
    export const STACK_VERSION = '1.0.0';
    ```

### Commit Messages
- Follow **Conventional Commits**.
- Use prefixes such as `docs`.
- Example:
  ```
  docs: update README with usage instructions
  ```

## Workflows

### Adding a New Stack Module
**Trigger:** When you need to add a new Docker Compose stack definition.
**Command:** `/add-stack-module`

1. Create a new file using PascalCase, e.g., `MyNewStack.ts`.
2. Implement the stack logic and export using named exports.
    ```typescript
    export function createMyNewStack() { ... }
    ```
3. Add relative imports in other modules as needed.
4. Write a corresponding test file named `MyNewStack.test.ts`.

### Updating Documentation
**Trigger:** When documentation needs to be updated or improved.
**Command:** `/update-docs`

1. Edit the relevant documentation files.
2. Use a conventional commit message with the `docs` prefix.
    ```
    docs: clarify stack configuration options
    ```
3. Push your changes.

### Writing and Running Tests
**Trigger:** When adding new features or fixing bugs.
**Command:** `/run-tests`

1. Create or update test files using the pattern `*.test.ts`.
2. Use your preferred (or project-standard) testing framework.
3. Run the tests (command may vary depending on setup, e.g., `npm test`).

## Testing Patterns

- Test files follow the pattern `*.test.ts`.
- The specific testing framework is not specified; use the project's standard or propose one.
- Place test files alongside the modules they test or in a dedicated `tests` directory.
- Example test file:
    ```typescript
    import { createStack } from './DockerComposeStack';

    describe('createStack', () => {
      it('should create a valid stack', () => {
        const stack = createStack();
        expect(stack).toBeDefined();
      });
    });
    ```

## Commands
| Command            | Purpose                                         |
|--------------------|-------------------------------------------------|
| /add-stack-module  | Scaffold a new Docker Compose stack module      |
| /update-docs       | Update or improve documentation                 |
| /run-tests         | Run all test suites                             |
```
