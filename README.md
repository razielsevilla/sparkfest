# Quatronizze - Gabay Sr.

This folder contains the full software documentation for **Gabay Sr.**, a companionship and scam-protection mobile application for Filipino senior citizens, built for **SparkFest 2026** (GDG PUP).

> Theme: Building Smarter, Safer, and More Inclusive Communities

## Project Brief

**Gabay Sr.** is a mobile-first application dedicated to building smarter, safer, and more inclusive communities for Filipino senior citizens. Recognizing the growing challenges of social isolation and digital vulnerability, the app connects elderly users with a "Trusted Circle" of family members, OFWs, and local barangay volunteers. Through simplified daily check-ins and AI-powered scam detection, Gabay Sr. ensures that our seniors remain emotionally supported and digitally protected, bridging the physical distance between them and their loved ones.

---

## 🚀 Key Features (For Landing Page Highlights)

* **The "Trusted Circle" Mechanism**
    A secure network connecting the senior with family, remote relatives, and local volunteers to monitor well-being seamlessly.
* **Accessible Daily Check-Ins**
    A highly simplified, icon-driven interface designed specifically for elderly users to log their mood and daily activities without frustration.
* **AI-Powered Scam Protection**
    A built-in message checker that analyzes suspicious texts for common Philippine scam patterns, delivering an easy-to-understand risk verdict to the senior.
* **Automated Alerts & Summaries**
    The Trusted Circle receives AI-generated weekly companionship summaries in a warm tone, as well as immediate push notifications if a high-risk scam is detected or if a senior misses two consecutive daily check-ins.

---

## Quatronizze Members

| Name | Role |
|------|------|
| Raziel Lloyd Sevilla | Project Manager - Lead Researcher |
| Jericho Varde | Lead Developer |
| Charles Platon | Web Developer |
| Paul John Palamara | Web Developer |


---

## 🛠 Google Technologies Used
This project leverages a modern Google tech stack to ensure reliability, real-time updates, and advanced AI capabilities:

* **Flutter:** Powers a unified, responsive, single-codebase frontend divided into "Senior Mode" and "Family/Volunteer Mode."
* **Firebase:** Provides serverless backend infrastructure, including Firestore (database), Authentication, Cloud Functions, and Firebase Cloud Messaging (FCM) for real-time push alerts.
* **Gemini API:** Drives the core natural language features, including analyzing messages for scam detection and generating warm, conversational weekly companionship summaries.

## Table of Contents

| # | File | Contents |
|---|------|----------|
| 1 | [01-executive-summary.md](./docs/01-executive-summary.md) | Problem statement, target users, value proposition |
| 2 | [02-problem-validation.md](./docs/02-problem-validation.md) | Research basis: isolation & scam statistics, existing solution gaps |
| 3 | [03-scope.md](./docs/03-scope.md) | MVP boundaries — what's in and out of scope for V1 |
| 4 | [04-functional-requirements.md](./docs/04-functional-requirements.md) | User stories and detailed feature specifications |
| 5 | [05-non-functional-requirements.md](./docs/05-non-functional-requirements.md) | Usability, performance, security, and other quality requirements |
| 6 | [06-system-architecture.md](./docs/06-system-architecture.md) | Architecture diagram, tech stack, project folder structure |
| 7 | [07-data-model.md](./docs/07-data-model.md) | Firestore collections and field-level schema |
| 8 | [08-api-specifications.md](./docs/08-api-specifications.md) | Cloud Functions and Gemini API prompt specs |
| 9 | [09-ui-ux-guidelines.md](./docs/09-ui-ux-guidelines.md) | Design principles, color/typography tokens, screen flows |
| 10 | [10-alerts-notifications.md](./docs/10-alerts-notifications.md) | Alert trigger conditions and notification message templates |
| 11 | [11-sprint-plan.md](./docs/11-sprint-plan.md) | Day-by-day development plan and team role split |
| 12 | [12-testing-strategy.md](./docs/12-testing-strategy.md) | Test scenarios, functional checklist, usability testing |
| 13 | [13-submission-checklist.md](./docs/13-submission-checklist.md) | SparkFest submission requirements and judging criteria self-check |
| 14 | [14-glossary.md](./docs/14-glossary.md) | Filipino terms used throughout the app and docs |

## Quick Links

- Core mechanism: the **Trusted Circle** — one feature serving both companionship and scam protection (see [01](./docs/01-executive-summary.md))
- Tech stack: Flutter + Firebase + Gemini API (see [06](./docs/06-system-architecture.md))
- Gemini prompts ready to use: see [08](./docs/08-api-specifications.md#84-gemini-api-prompt-specifications)
- Build timeline: June 28 – July 2, 2026 (see [11](./docs/11-sprint-plan.md))