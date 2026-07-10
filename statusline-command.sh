#!/usr/bin/env bash

input=$(cat)

# --- Extract fields ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.id // "Claude"')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# --- Folder: basename of cwd ---
folder=$(basename "$cwd")

# --- Git branch (skip optional lock) ---
branch=""
if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir --no-optional-locks >/dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# --- Context progress bar (10 chars wide) ---
bar=""
if [ -n "$used_pct" ]; then
  filled=$(echo "$used_pct" | awk '{printf "%d", int($1/10 + 0.5)}')
  empty=$((10 - filled))
  bar_str=""
  bar_int=$(printf "%.0f" "$used_pct")
  bar=" ${bar_int}%"
fi

# --- Assemble parts ---
parts=""

# Folder
if [ -n "$folder" ]; then
  parts="${folder}"
fi



# Model
if [ -n "$model" ]; then
  parts="${parts}  ${model}"
fi

# Context bar
if [ -n "$bar" ]; then
  parts="${parts}${bar} "
fi

# Git branch
if [ -n "$branch" ]; then
  parts="${parts} ⎇ ${branch}"
fi

printf "%s" "$parts"