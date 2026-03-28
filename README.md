# Family Hub — Setup Guide

A shared, real-time family coordination web app. One link, both parents can view and edit from any device.

## Features

- **Meal Planner** — Weekly grid with breakfast/lunch/dinner slots, reflecting your cook rhythm
- **Grocery List** — Organized by store section; both parents can add and check off items in real time
- **Pickup/Drop-off Schedule** — Per-day school runs with who's doing what
- **Family Events** — Playdates, activities, appointments — all in one place

---

## Quick Start (Local Demo)

Open `index.html` directly in any browser. It works immediately in **demo mode** — data is stored in memory for the current tab session. To get real-time sync across both parents' devices, follow the Firebase setup below.

---

## Firebase Setup (Real-time Sync)

Real-time sync is powered by **Firebase Realtime Database** — a free Google service. Setup takes about 10 minutes.

### Step 1 — Create a Firebase Project

1. Go to [https://console.firebase.google.com](https://console.firebase.google.com)
2. Click **Add project** → name it something like `family-hub`
3. Disable Google Analytics (not needed) → **Create project**

### Step 2 — Add a Web App

1. On the project homepage, click the **</>** (Web) icon
2. Register the app with a nickname like `family-hub-web`
3. Copy the `firebaseConfig` object — you'll need it in the next step

### Step 3 — Enable Realtime Database

1. In the left sidebar, go to **Build → Realtime Database**
2. Click **Create Database**
3. Choose a location close to you (e.g. `us-central1`)
4. Select **Start in test mode** (open rules for now; you can lock it down later)
5. Click **Enable**

### Step 4 — Paste Config into index.html

Open `index.html` in a text editor and find this section near the bottom:

```javascript
const firebaseConfig = {
  apiKey:            "YOUR_API_KEY",
  authDomain:        "YOUR_PROJECT.firebaseapp.com",
  databaseURL:       "https://YOUR_PROJECT-default-rtdb.firebaseio.com",
  projectId:         "YOUR_PROJECT",
  storageBucket:     "YOUR_PROJECT.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId:             "YOUR_APP_ID"
};
```

Replace the placeholder values with the ones you copied from the Firebase console.

> **Important:** Make sure `databaseURL` is included — it's required for Realtime Database. It should look like:
> `https://your-project-default-rtdb.firebaseio.com`

### Step 5 — Host the App

For both parents to access the app from any device, you need to host it somewhere. The easiest free option:

#### Option A — Firebase Hosting (recommended, free)

1. Install Firebase CLI: `npm install -g firebase-tools`
2. In Terminal, `cd` to this `FamilyHub` folder
3. Run `firebase login` → sign in with the Google account from Step 1
4. Run `firebase init hosting` → select your project → set `public` directory to `.` (current folder) → say **No** to single-page app rewrite
5. Run `firebase deploy`
6. You'll get a URL like `https://your-project.web.app` — share this link with your partner

#### Option B — Any Static Host

Upload `index.html` to any static file host (Netlify, Vercel, GitHub Pages, etc.). The file is self-contained.

#### Option C — Local Network Only

If you're on the same Wi-Fi, run a local server:
```bash
cd ~/Documents/FamilyHub
python3 -m http.server 8080
```
Then open `http://YOUR_MAC_IP:8080` on any device on the network.
Find your Mac's IP in System Preferences → Network.

---

## Security Rules (Optional but Recommended)

Once you're done testing, replace the default open rules in Firebase Console → Realtime Database → Rules:

```json
{
  "rules": {
    ".read":  true,
    ".write": true
  }
}
```

This keeps it open for family use without a login. If you want to add password protection in a future version, Firebase Authentication can be layered on later.

---

## Google Calendar Sync (Future)

The app is designed for one-way push to Google Calendar (app → GCal) as a future enhancement. The data structure already stores event dates and times in a format ready for this integration.

---

## File Structure

```
FamilyHub/
├── index.html   ← The entire app (HTML + CSS + JS, all inline)
└── README.md    ← This file
```

---

## Customization Tips

- **Cook assignments** — Edit the `COOK_INFO` array near the top of the JS section to change who cooks which days
- **Grocery sections** — Edit the `GROCERY_SECTIONS` array to add/remove store sections
- **Color palette** — All colors are CSS variables at the top of the `<style>` block; easy to swap

---

## Troubleshooting

**"🔴 Offline" indicator in the app**
→ The Firebase config hasn't been filled in yet, or there's a network issue.

**Data not syncing between devices**
→ Double-check that `databaseURL` is in your config and matches your Firebase project's Realtime Database URL.

**Works on Mac but not Android**
→ If using the local server option, make sure both devices are on the same Wi-Fi and use the Mac's local IP address (not `localhost`).
