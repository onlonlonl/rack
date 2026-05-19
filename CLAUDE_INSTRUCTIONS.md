# Rack · 架

A personal operating system with three systems: Work (operations), Lux (project ecosystem), Iris (personal growth).

**Project ID:** `YOUR_PROJECT_ID`

## Tables

### lines
| Field | Type | Description |
|-------|------|-------------|
| id | TEXT PK | e.g. "acquisition", "crosstalk", "xhs-brand" |
| name | TEXT | Display name |
| category | TEXT | "work" / "lux" / "self" |
| status | TEXT | "on_track" / "at_risk" / "blocked" / "active" / "done" |
| description | TEXT | Optional |
| key_metric_label | TEXT | Work only: metric name |
| key_metric_value | NUMERIC | Work only: metric number |
| key_metric_unit | TEXT | Work only: unit |
| next_action | TEXT | Next step |
| direction | TEXT | Iris only: long-term goal |
| icon | TEXT | Lux only: base64 32px PNG |
| order_index | INT | Display order |

### tasks
| Field | Type | Description |
|-------|------|-------------|
| id | BIGINT PK | Auto-increment |
| title | TEXT | Task description |
| work_line_id | TEXT | FK to lines.id |
| category | TEXT | "work" / "lux" / "self" |
| status | TEXT | "todo" / "in_progress" / "done" / "blocked" |
| priority | TEXT | "high" / "medium" / "low" |
| due_date | DATE | Optional |
| notes | TEXT | Optional |
| is_archived | BOOL | Default false |
| completed_at | TIMESTAMPTZ | Set when done |

### context_items (Work only)
| Field | Type | Description |
|-------|------|-------------|
| id | BIGINT PK | Auto-increment |
| type | TEXT | "priority" / "blocker" / "activity" / "observation" |
| content | TEXT | Description |
| status | TEXT | "active" / "waiting" / "open" / "resolved" |
| category | TEXT | Default "work" |
| topic | TEXT | Optional topic label |

### decisions (Work only)
| Field | Type | Description |
|-------|------|-------------|
| id | BIGINT PK | Auto-increment |
| decision | TEXT | What was decided |
| reasoning | TEXT | Why |
| made_by | TEXT | Who decided |
| made_at | TIMESTAMPTZ | When |
| category | TEXT | Default "work" |

### learnings (Iris only)
| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK | Auto-generated |
| content | TEXT | What was learned |
| source | TEXT | Optional: where it came from |
| tags | TEXT[] | Optional tag array |
| category | TEXT | Default "self" |

### ideas (Lux only)
| Field | Type | Description |
|-------|------|-------------|
| id | UUID PK | Auto-generated |
| content | TEXT | The idea |
| line_id | TEXT | Optional FK to lines.id (which project) |
| status | TEXT | "active" / "adopted" / "dropped" |
| category | TEXT | Default "lux" |

### daily_metrics (Work only)
| Field | Type | Description |
|-------|------|-------------|
| date | DATE PK | Entry date |
| new_guanchayuan | INT | New observers |
| new_chapin | INT | New reviews |
| new_negative | INT | Negative reviews |
| active_guanchayuan | INT | Active observers |
| curated_chapin | INT | Curated reviews |
| conversion_rate | NUMERIC | Optional |
| notes | TEXT | Optional |

## Daily Routine

1. Check `tasks` for overdue or blocked items across all categories
2. Check `context_items` for unresolved blockers (Work)
3. Check `ideas` with status "active" (Lux)
4. Review recent `learnings` (Iris)

## Read Examples

```sql
-- All active tasks for work
SELECT * FROM tasks WHERE category = 'work' AND status != 'done' AND NOT is_archived ORDER BY priority, created_at;

-- Lux project overview
SELECT * FROM lines WHERE category = 'lux' ORDER BY order_index;

-- Recent learnings
SELECT * FROM learnings ORDER BY created_at DESC LIMIT 10;

-- Active ideas
SELECT * FROM ideas WHERE status = 'active' ORDER BY created_at DESC;
```

## Write Examples

```sql
-- Add a task
INSERT INTO tasks (title, work_line_id, category, status, priority)
VALUES ('Review Q3 metrics', 'quality', 'work', 'todo', 'medium');

-- Log a learning
INSERT INTO learnings (content, source, tags, category)
VALUES ('Attention is weighted sum, not focus', '3Blue1Brown', ARRAY['AI','attention'], 'self');

-- Add an idea
INSERT INTO ideas (content, line_id, category)
VALUES ('Add yearly review feature to Crosstalk', 'crosstalk', 'lux');

-- Adopt an idea
UPDATE ideas SET status = 'adopted' WHERE id = 'xxx';
```

## Behavior

- When updating lines, keep `next_action` current
- When completing a task, set `completed_at` and `status = 'done'`
- For Iris lines, update both `current` and `direction` fields
- For Lux projects, update `current` and `next_action`
- Use "the user" not personal names in all outputs
