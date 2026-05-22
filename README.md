# Rack · 架

A personal operating system for me and Claude. Three systems — Work, Lux, Iris — one pixel-style interface.

為我和我的 Claude 而建的個人操作系統。三個系統——工作、Lux、自己——一個像素風界面。

## Systems · 系統

**WORK** — Operations dashboard. Lines, tasks, metrics, context.

**LUX** — Project ecosystem. 9 tools (Crosstalk, Catchword, Overtone, Tally, Aftertaste, Ember, Glimpse, Cue, Brain) with project cards, tasks, and idea pool.

**IRIS** — Personal growth. Direction-oriented lines, tasks, and learning journal.

## Setup · 部署

### 1. Supabase

Run `setup.sql` in your Supabase SQL editor.

### 2. GitHub Pages

Upload `index.html` to a GitHub repository. Enable Pages in Settings → Source: main.

### 3. Connect

Open the page, enter your Supabase URL and Anon Key.

### 4. Claude

Add `CLAUDE_INSTRUCTIONS.md` to your Claude project. Replace `YOUR_PROJECT_ID` with your actual project ID.

## Tech Stack · 技術棧

| Layer | Choice |
|-------|--------|
| Frontend | Single HTML + React CDN |
| Backend | Supabase (Postgres) |
| AI | Claude via Supabase MCP |
| Deploy | GitHub Pages |

---

RACK · Built with # by Iris & Claude
