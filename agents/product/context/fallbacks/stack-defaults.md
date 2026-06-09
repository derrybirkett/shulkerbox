# stack fallback — lite profile

Used when `.bloom/stack/` is not mounted. Defines a single working profile so
the `product` agent can scaffold a real, runnable app in Stage 3 even without
the curated `stack` repo.

The real `stack` repo offers multiple profiles, working starters, and tuned
configs. This file replicates only the **lite** profile, just enough to ship
a first slice.

---

## Profile: lite

| Concern | Choice |
|---|---|
| Framework | Next.js 16 (App Router) |
| Language | TypeScript |
| Styling | Tailwind CSS |
| UI primitives | shadcn/ui |
| Database | Supabase (Postgres + Auth + Storage) |
| Hosting | Vercel |
| Package manager | pnpm |
| Node | 24 LTS |

## Scaffold commands

Run from an empty target directory:

```bash
# 1. Next.js app
pnpm create next-app@latest . \
  --typescript --tailwind --app --eslint --src-dir \
  --import-alias "@/*"

# 2. shadcn/ui
pnpm dlx shadcn@latest init -d
pnpm dlx shadcn@latest add button input label card

# 3. Supabase client
pnpm add @supabase/supabase-js @supabase/ssr

# 4. Env scaffolding
cp .env.example .env.local 2>/dev/null || cat > .env.local <<EOF
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
EOF

# 5. Vercel link (optional, only if user wants deploy now)
# pnpm dlx vercel link
```

## Default file layout

```
src/
  app/
    layout.tsx          # root layout with Tailwind + font
    page.tsx            # marketing / landing
    (auth)/
      login/page.tsx
      signup/page.tsx
    (app)/
      layout.tsx        # authed shell
      dashboard/page.tsx
  components/
    ui/                 # shadcn output
  lib/
    supabase/
      client.ts         # browser client
      server.ts         # server client (cookies)
      middleware.ts     # auth refresh
  middleware.ts         # Next middleware → supabase/middleware.ts
```

## Default auth flow

- Email + password via Supabase Auth (magic link is fine too, ask the user).
- Server Components read the session via `createServerClient` in
  `lib/supabase/server.ts`.
- `middleware.ts` refreshes the session cookie on every request.
- A `(app)/layout.tsx` redirects unauthed users to `/login`.

## Default data model

The agent must add one migration per slice. The first migration is always:

```sql
-- 0001_init.sql
-- (Supabase auto-creates auth.users. Add your domain tables here.)
```

The agent should add tables matching `docs/architecture.md` as separate
migrations as slices ship.

## Acceptance: "app boots" means

1. `pnpm dev` starts without errors
2. `/` renders the marketing page
3. `/signup` lets a user create an account
4. `/dashboard` shows for authed users, redirects to `/login` for guests

That's the bar for Stage 3 complete. Anything beyond is a Stage 4 slice.

## When to escalate to full stack repo

Pull in `.bloom/stack/` as a submodule when:
- You need a profile other than lite (e.g. mobile, marketing-only, data-heavy)
- You're shipping to production and want the tuned configs
- You want the working starters with auth, billing, and emails wired up

The fallback exists to get from zero to a running dev server. It is not a
production-quality baseline.
