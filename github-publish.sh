#!/bin/bash
set -e

GH=/opt/homebrew/bin/gh
REPO_NAME=family-hub
DIR=~/Documents/FamilyHub

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   Family Hub — GitHub Publisher      ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "→ Paste your GitHub token and press Enter:"
echo "  (token is at github.com/settings/tokens — look for family-hub-cli)"
echo ""
read -s -p "Token: " TOKEN
echo ""

if [ -z "$TOKEN" ]; then
  echo "✗ No token entered. Exiting."
  exit 1
fi

echo ""
echo "[1/4] Authenticating with GitHub..."
echo "$TOKEN" | $GH auth login --with-token
echo "✓ Logged in as: $($GH api user -q .login)"
USERNAME=$($GH api user -q .login)

echo "[2/4] Committing latest changes..."
cd $DIR
git add -A
git diff --cached --quiet || git commit -m "Update: store tags, deal alerts, Metro grocery sections"

echo "[3/4] Creating GitHub repo and pushing..."
$GH repo create $REPO_NAME --public --source=. --remote=origin --push 2>/dev/null || true
git push -u origin main 2>/dev/null || git push --force -u origin main

echo "[4/4] Enabling GitHub Pages..."
$GH api repos/$USERNAME/$REPO_NAME/pages 
  --method POST 
  -f source[branch]=main 
  -f source[path]=/ 2>/dev/null || true

sleep 2
echo ""
echo "╔══════════════════════════════════════╗"
echo "║  ✓ Done! Your app is live at:        ║"
echo "║                                      ║"
echo "║  https://$USERNAME.github.io/$REPO_NAME  ║"
echo "║                                      ║"
echo "║  (Pages can take ~60s to go live)    ║"
echo "╚══════════════════════════════════════╝"
echo ""
