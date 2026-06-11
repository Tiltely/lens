# Stack Detection

How a lens classifies the project before choosing Tier 2 questions. Scoped to the
stacks Tiltely actually runs; grows on demand (gaps feed the foundry).

## Procedure

1. If a valid dossier exists and records `stack:`, use it — do not re-detect.
2. Otherwise inspect, in order: lockfiles and manifests at the project root
   (`package.json` deps, `pnpm-workspace.yaml`, `turbo.json`), framework configs,
   directory shape. One Glob/Read pass — detection must be cheap.
3. Record the result in the dossier under `stack:`.

## Signals → classification

| Classification | Signals |
|---|---|
| `nextjs-web` | `next` in dependencies; `next.config.*`; `app/` or `pages/` dir |
| `nextjs-web (SPA-heavy)` | `nextjs-web` + most pages `"use client"`, token-bearing API client code |
| `nestjs-api` | `@nestjs/core` in dependencies; `nest-cli.json`; `src/main.ts` with `NestFactory` |
| `expo-mobile` | `expo` in dependencies; `app.json`/`app.config.*` with expo key |
| `monorepo` | workspaces field / `pnpm-workspace.yaml` / `turbo.json` — classify EACH package that the current task touches, not the repo as a whole |
| `unknown` | none of the above — trigger the missing-stack fallback (protocol.md) |

## Output format (dossier entry)

    stack: nestjs-api + nextjs-web (monorepo; task touches apps/api and apps/web)
