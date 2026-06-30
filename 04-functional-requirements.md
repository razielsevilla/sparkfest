# 4. Functional Requirements

## 4.1 User Stories

| ID | As a... | I want to... | So that... | Priority |
|---|---|---|---|---|
| US-01 | Family member | register my elderly parent as a senior profile | I can start monitoring their wellbeing and safety | Must |
| US-02 | Family member | invite other relatives/volunteers to the Trusted Circle | responsibility for monitoring is shared | Must |
| US-03 | Senior (or assisting volunteer) | log a daily check-in with minimal typing | I can express how I'm doing without difficulty | Must |
| US-04 | Family member | view a weekly summary of my parent's activities and mood | I feel connected despite being far away | Must |
| US-05 | Senior or family member | paste or forward a suspicious message into the app | I can find out if it's a scam before acting on it | Must |
| US-06 | Trusted Circle member | receive an instant alert when a scam is flagged | I can intervene quickly | Must |
| US-07 | Trusted Circle member | receive an alert if the senior hasn't checked in for 2+ days | I know to follow up in case something is wrong | Should |
| US-08 | Family member | find the nearest OSCA office for my parent | I can help them access benefits they're entitled to | Should |
| US-09 | Senior | use the app with large buttons and simple navigation | I am not overwhelmed by the interface | Must |
| US-10 | Volunteer/barangay worker | manage check-ins for multiple seniors | I can support several beneficiaries efficiently | Could |

**Priority key:** Must = required for elimination round submission. Should = required for final pitch if team advances. Could = post-hackathon roadmap, build only if time permits.

## 4.2 Detailed Feature Specifications

### 4.2.1 Senior Profile & Trusted Circle Setup

**Description:** Allows a family member or volunteer to create a profile for a senior and invite others to form a monitoring circle.

**Inputs required:**
- Senior's name, age, photo (optional), barangay/city
- Primary contact's name and phone number
- Trusted Circle members: name, relationship, phone number

**Business rules:**
- Each senior profile must have at least 1 Trusted Circle member to be considered "active"
- A Trusted Circle member may be linked to multiple senior profiles (e.g., a barangay volunteer)
- No login/password required for the senior; access for the senior is via a simplified PIN or none at all (assisted use assumption)

### 4.2.2 Daily Check-In

**Description:** A simple, icon-driven flow for the senior (or someone assisting them) to log their day.

**Flow:**
1. Senior/assistant opens app to a single home screen with a large "Check In Today" button
2. Mood selection via 3–5 large emoji-style icons (e.g., Masaya, Okay lang, Malungkot)
3. Optional: select activity icons (Nakausap ang pamilya, Nag-ehersisyo, Pumunta sa labas, Nagpahinga)
4. Optional: free-text or voice note (≤ 30 seconds) for additional context
5. Submit → data stored in Firestore, timestamped

**Business rules:**
- One check-in per day per senior; resubmission overwrites the same day's entry
- If no check-in is logged by end of day for 2 consecutive days, trigger US-07 alert

### 4.2.3 Weekly Companionship Summary

**Description:** An AI-generated, warm, easy-to-read summary of the senior's week, generated from check-in data.

**Process:**
1. Cloud Function runs weekly (e.g., every Sunday 6PM) per active senior profile
2. Aggregates the week's check-in moods, activities, and notes
3. Sends structured data to Gemini API with a prompt instructing a warm, family-friendly tone in Filipino/Taglish
4. Stores the generated summary and pushes a notification to all Trusted Circle members

> Sample prompt direction (see [8. API & Service Specifications](./08-api-specifications.md) for full prompt spec): "Summarize this senior's week for their family in 3–4 warm sentences, in Filipino or Taglish, highlighting positive moments and gently flagging any days they seemed low or didn't check in."

### 4.2.4 Scam Message Checker

**Description:** Lets a user paste or forward a suspicious SMS/message/number and receive a plain-language risk verdict.

**Flow:**
1. User pastes message text (and/or sender number) into a text field
2. App sends content to Gemini API with a scam-detection prompt tuned to common Philippine scam patterns
3. Gemini returns: risk level (Mataas/Katamtaman/Mababa), reason in plain Filipino/English, and recommended action
4. If risk is "Mataas" (High), automatically trigger an alert to the Trusted Circle (US-06)

**Business rules:**
- All checked messages are logged with timestamp and risk verdict for the senior's history
- No message content is stored longer than necessary for the check + 30-day audit trail

### 4.2.5 Trusted Circle Alerts

**Description:** Push notifications sent to all Trusted Circle members for a given senior when a triggering event occurs.

**Trigger events:**
- High-risk scam message detected (immediate)
- Missed check-in for 2+ consecutive days (daily check via scheduled function)
- Mood marked as "Malungkot" (sad) for 3+ consecutive check-ins (soft wellbeing flag)

**Delivery:** Firebase Cloud Messaging (FCM) push notification + in-app notification center.

### 4.2.6 OSCA / Barangay Directory

**Description:** Static, curated list of OSCA offices and barangay contacts relevant to the demo area (Laguna).

For V1, this is a Firestore collection seeded manually by the team — not a live government API integration.

---

**Previous:** [3. Scope](./03-scope.md) · **Next:** [5. Non-Functional Requirements](./05-non-functional-requirements.md)