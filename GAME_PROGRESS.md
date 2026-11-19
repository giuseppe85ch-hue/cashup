# CASHUP: saved player and content progress

## Current database foundation

The production Supabase database now contains two additive tables:

- `public.player_game_progress`: per-user game saves, 1–10 save slots per game, JSON save state (max 64 KiB), level, score, and play time.
- `public.player_content_progress`: per-user progress for books, audiobooks, videos, courses, recipes, and music, including percent complete and a small position payload.

Both tables have RLS and FORCE RLS enabled. Authenticated users can read/write/delete only their own rows. Anonymous access is revoked. Verification confirmed both tables exist, FORCE RLS is true, authenticated select/insert privileges are present, and anon select is false.

## Integration contract for games and media modules

Use the signed-in Supabase user session; never send another user's ID from a client-supplied profile. For game saves, upsert on `(user_id, game_id, save_slot)`. For content progress, upsert on `(user_id, content_id, content_type)`. Update `updated_at` on every save.

Suggested game save shape:
```json
{
  "schema_version": 1,
  "checkpoint": "level-03-stage-02",
  "inventory": [],
  "settings": {},
  "unlocked": []
}
```

Suggested content position shape:
- Book: chapter, page, section.
- Audiobook: chapter, track, position_seconds.
- Video: playback_position_seconds.
- Course: module, lesson, checkpoint.
- Recipe: servings, completed_steps.
- Music: playlist_id, last_track_id, position_seconds.

## Safety boundaries

- Client-stored progress is player convenience data, not a trusted score or financial ledger.
- Never issue cash, redeemable points, tournament wins, or payouts based solely on client-supplied progress or score.
- Competitive rankings and rewards require server-authoritative validation, anti-cheat rules, rate limits, and audit logging.
- Content identifiers must refer to licensed or owned content. These tables do not grant rights to music, books, video, or recipes.
- The tables are created, but the existing web UI/game engines have not yet been wired to these APIs. That integration is the next implementation stage.

## Applied SQL

The exact additive SQL migration is in `database/player_progress_saves.sql`.
