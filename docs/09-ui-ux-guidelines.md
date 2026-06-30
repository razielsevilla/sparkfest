# 9. UI/UX Design Guidelines

## 9.1 Design Principles

- **Icon-first, text-second:** every action should be recognizable by icon alone for low-literacy users
- **One primary action per screen:** avoid overwhelming the senior with multiple choices at once
- **High contrast, large touch targets:** minimum 56x56dp tap targets, font size ≥18sp for body text, ≥24sp for primary actions
- **Warm, non-clinical tone:** copy should read like a caring family member, not a medical or government form
- **Two distinct modes:** Senior Mode (simplified) and Family/Volunteer Mode (more data-dense) within the same app, switched via login type

## 9.2 Color & Typography

| Token | Value | Usage |
|---|---|---|
| Primary (Teal) | `#0F766E` | Primary buttons, headers, brand accents |
| Secondary (Warm Amber) | `#F59E0B` | Check-in highlights, positive mood indicators |
| Alert (Red) | `#DC2626` | Scam alerts only — reserve red exclusively for danger states |
| Background | `#FFFBEB` or `#FFFFFF` | Warm off-white background for senior mode screens |
| Text Primary | `#1F2937` | Body text, high contrast against light backgrounds |
| Font — Senior Mode | Noto Sans / system default, min 18sp | Maximize legibility and Filipino character support |
| Font — Family Mode | Same family, 14–16sp acceptable | Family mode can use denser, more standard mobile UI sizing |

## 9.3 Core Screen Flows

### 9.3.1 Onboarding Flow (Family/Volunteer Mode)

```
[Welcome Screen]
   ↓
[Sign Up / Log In via phone number + OTP]
   ↓
[Create Senior Profile]
   - Name, age, photo, barangay
   ↓
[Add Trusted Circle Members]
   - Add self automatically as first member
   - Option to invite more (name + phone)
   ↓
[Setup Complete] → [Family Dashboard Home]
```

### 9.3.2 Daily Check-In Flow (Senior Mode)

```
[Home Screen]
   - Large greeting: "Kumusta, Lola Luz?"
   - One large button: "I-CHECK IN NGAYON"
   ↓
[Mood Selection]
   - 3 large icon cards: Masaya 😊 / Okay lang 😐 / Malungkot 😢
   ↓
[Activity Selection] (optional, skippable)
   - Icon grid: Nakausap ang pamilya / Nag-ehersisyo /
     Pumunta sa labas / Nagpahinga
   ↓
[Optional Note]
   - Big microphone button for voice note (preferred)
   - Small text field as fallback
   ↓
[Confirmation Screen]
   - "Salamat, Lola Luz! Ipinaalam namin sa pamilya mo."
   - Auto-return to home after 3 seconds
```

### 9.3.3 Scam Checker Flow (Either Mode)

```
[Home Screen] → [I-CHECK KUNG SCAM] button
   ↓
[Input Screen]
   - Text field: "I-paste o i-type ang mensahe dito"
   - Optional: sender number field
   ↓
[Loading state] → ("Sinusuri namin ang mensahe...")
   ↓
[Result Screen]
   - Color-coded banner: Red (Mataas) / Amber (Katamtaman) / Green (Mababa)
   - Plain-language reasoning
   - Recommended action, large and clear
   - If high risk: auto-notification sent banner +
     "Naabisuhan na ang iyong Trusted Circle"
```

### 9.3.4 Family Dashboard (Family/Volunteer Mode)

```
[Dashboard Home]
   - Senior's name + last check-in status (Today / 2 days ago / etc.)
   - This week's mood trend (Improving / Stable / Declining icon)
   - Latest weekly summary card (AI-generated text)
   ↓
[Tabs: Summary | Check-in History | Scam Checks | Alerts | Circle]
   - Check-in History: calendar view, color-coded by mood
   - Scam Checks: list of past checks with risk levels
   - Alerts: notification log, mark as resolved
   - Circle: manage Trusted Circle members
```

---

**Previous:** [8. API & Service Specifications](./08-api-specifications.md) · **Next:** [10. Alerts & Notifications](./10-alerts-notifications.md)
