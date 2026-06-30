# 6. System Architecture

## 6.1 High-Level Architecture Overview

Gabay Sr. follows a mobile-client + serverless-backend architecture, chosen specifically for speed of development within the hackathon timeline. Flutter handles both the senior-facing and family-facing experiences as two distinct navigation flows within a single app (to minimize build overhead), backed by Firebase for data, auth, and real-time messaging, with Gemini API handling all natural-language tasks.

```
┌────────────────────────────────────────────────────────────┐
│                   FLUTTER MOBILE APP                       │
│  ┌──────────────────────┐    ┌───────────────────────────┐ │
│  │  Senior Mode (UI)    │    │  Family/Volunteer Mode    │ │
│  │  - Check-in flow     │    │  - Trusted Circle setup   │ │
│  │  - Scam checker      │    │  - Weekly summaries       │ │
│  │  - Simple nav        │    │  - Alerts & notifications │ │
│  └──────────┬───────────┘    └──────────┬────────────────┘ │
└─────────────┼───────────────────────────┼──────────────────┘
              │                           │
              ▼                           ▼
┌───────────────────────────────────────────────────────────┐
│                   FIREBASE BACKEND                        │
│  Firebase Auth   │  Firestore DB   │  Cloud Functions     │
│  (phone/PIN)     │  (profiles,     │  (alert triggers,    │
│                  │   check-ins,    │   weekly summary     │
│                  │   trusted       │   scheduler)         │
│                  │   circles)      │                      │
│  Firebase Cloud Messaging (push notifications)            │
└─────────────────────────┬─────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                   GEMINI API                            │
│  - Weekly companionship summary generation (Filipino)   │
│  - Scam message risk analysis (Taglish-aware)           │
└─────────────────────────────────────────────────────────┘
```

## 6.2 Technology Stack

| Layer | Technology | Justification |
|---|---|---|
| Mobile App | Flutter (Dart) | Single codebase for Android/iOS; team's chosen stack; fast prototyping with rich widget library |
| Backend / Database | Firebase (Firestore) | No backend server to provision; real-time sync; generous free tier; fast to integrate with Flutter |
| Authentication | Firebase Auth (phone number) | Matches how Filipino users already verify identity (SMS OTP); no email required for seniors |
| Serverless Functions | Firebase Cloud Functions (Node.js) | Handles scheduled jobs (weekly summary, missed check-in detection) without managing servers |
| Push Notifications | Firebase Cloud Messaging (FCM) | Native integration with Firebase; required for Trusted Circle alerts |
| AI / NLP | Gemini API (gemini-1.5-flash or latest available) | Required Google technology; strong multilingual support for Filipino/Taglish; low latency suitable for demo |
| Maps (optional, Should-have) | Google Maps Platform | For OSCA/barangay office directory with directions |

> **Note:** Google technology requirement is satisfied by Gemini API (primary) and Firebase (Google Cloud product family). Google Maps Platform is a Should-have addition if time allows.

## 6.3 Flutter Project Structure

Recommended folder structure to allow parallel development across team members without merge conflicts:

```
lib/
├── main.dart
├── core/
│   ├── theme/              # colors, text styles, large-button widgets
│   ├── constants/          # app-wide constants, route names
│   └── services/
│       ├── firebase_service.dart
│       ├── gemini_service.dart
│       └── notification_service.dart
├── models/
│   ├── senior_profile.dart
│   ├── trusted_circle_member.dart
│   ├── checkin.dart
│   ├── scam_check.dart
│   └── alert.dart
├── features/
│   ├── onboarding/         # profile + trusted circle setup
│   ├── checkin/            # daily check-in flow (senior mode)
│   ├── scam_checker/       # scam message checker
│   ├── summary/            # weekly summary view (family mode)
│   ├── alerts/             # notification center
│   └── directory/          # OSCA/barangay directory
├── widgets/                # shared large-button, icon-card widgets
└── routes/
    └── app_router.dart
```

---

**Previous:** [5. Non-Functional Requirements](./05-non-functional-requirements.md) · **Next:** [7. Data Model](./07-data-model.md)
