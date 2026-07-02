"use client";

import { useEffect, useRef } from "react";
import styles from "./Users.module.css";

const personas = [
  {
    emoji: "👵",
    name: "Lola Luz & Lolo Pepe",
    role: "Senior Citizen",
    quote:
      '"Hindi ko na kailangang mangamba sa mga text na scam, may tagapagbantay na ako."',
    bullets: [
      "Simplified 1-click check-in interface",
      "AI message scanning & scam verdict",
      "Accessible voice-note diary capture",
    ],
    accent: "teal",
  },
  {
    emoji: "👨‍👩‍👧",
    name: "OFW Relative & Family",
    role: "Trusted Circle Member",
    quote:
      '"Kahit malayo ako sa ibang bansa, alam kong ligtas at maayos ang kalagayan ni Nanay."',
    bullets: [
      "Weekly AI conversational summaries",
      "Instant push alerts for scam targets",
      "Firestore daily check-in logs history",
    ],
    accent: "amber",
  },
  {
    emoji: "🏘️",
    name: "Barangay & OSCA Staff",
    role: "Local Support Network",
    quote:
      '"Mas madali nang tugunan ang pangangailangan ng mga nakatatanda sa aming komunidad."',
    bullets: [
      "Centralized senior welfare dashboards",
      "Automatic triggers for missed checks",
      "Barangay-level safety networks",
    ],
    accent: "primary",
  },
];

export default function Users() {
  const sectionRef = useRef(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("visible");
          }
        });
      },
      { threshold: 0.15 }
    );

    const el = sectionRef.current;
    if (el) {
      el.querySelectorAll(".reveal").forEach((child) =>
        observer.observe(child)
      );
    }

    return () => observer.disconnect();
  }, []);

  return (
    <section id="who-its-for" className={styles.section} ref={sectionRef}>
      <div className="container">
        <div className={`${styles.header} reveal`}>
          <span className="section-label">Who It&apos;s For</span>
          <h2 className="section-title">Designed for Every Filipino Family</h2>
          <p className="section-subtitle">
            Whether you&apos;re a senior, an overseas worker, or a local
            volunteer — Gabay Sr. has a role for you in keeping our elders safe.
          </p>
        </div>

        <div className={styles.grid}>
          {personas.map((persona, i) => (
            <article
              key={i}
              className={`${styles.card} ${styles[persona.accent]} reveal`}
              style={{ transitionDelay: `${i * 0.1}s` }}
            >
              {/* Colored banner top with emoji */}
              <div className={styles.banner}>
                <div className={styles.emojiCircle}>
                  <span className={styles.emoji}>{persona.emoji}</span>
                </div>
              </div>

              {/* Body */}
              <div className={styles.body}>
                <h3>{persona.name}</h3>
                <span className={styles.role}>{persona.role}</span>

                <blockquote className={styles.quote}>
                  {persona.quote}
                </blockquote>

                <ul className={styles.bullets}>
                  {persona.bullets.map((bullet, idx) => (
                    <li key={idx}>
                      <span className={styles.check} aria-hidden="true">✓</span>
                      {bullet}
                    </li>
                  ))}
                </ul>
              </div>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}
