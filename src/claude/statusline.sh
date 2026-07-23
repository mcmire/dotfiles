#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
effort_level=$(echo "$input" | jq -r '.effort.level')

cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
cost_fmt=$(printf '$%.2f' "$cost")

total_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
total_secs=$((total_ms / 1000))
hours=$((total_secs / 3600))
remaining_secs=$((total_secs % 3600))
mins=$((remaining_secs / 60))
secs=$((remaining_secs % 60))

context_remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage')

echo "$model ($effort_level) | 🪣 $context_remaining% remaining | 💰 $cost_fmt | ⏱️ ${hours}h ${mins}m ${secs}s"
