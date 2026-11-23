#!/bin/sh
set -eu

png_path="Hekatean-Orphic-Mystery.png"

FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch \
  --force \
  --index-filter "git rm --cached --ignore-unmatch '$png_path'" \
  --prune-empty \
  --tag-name-filter cat \
  -- --all

git for-each-ref \
  --format='delete %(refname)' \
  refs/original |
  git update-ref --stdin

git reflog expire --expire=now --all
git gc --prune=now --aggressive

git push origin --force --all
git push origin --force --tags

echo "PNG removed from local and remote Git history."
