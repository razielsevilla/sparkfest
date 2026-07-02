"use client";

import { useEffect, useRef, useState } from "react";
import { Heart, Globe, Building } from "lucide-react";
import styles from "./Users.module.css";

const personas = [
  {
    id: "senior",
    positionClass: "nodeTop",
    emoji: <Heart size={44} strokeWidth={1.5} />,
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
    id: "ofw",
    positionClass: "nodeBottomLeft",
    emoji: <Globe size={44} strokeWidth={1.5} />,
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
    id: "local",
    positionClass: "nodeBottomRight",
    emoji: <Building size={44} strokeWidth={1.5} />,
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
            volunteer — Gabay Sr. connects you all in one Trusted Circle.
          </p>
        </div>

        <div className={`${styles.networkContainer} reveal`}>
          
          {/* Network Nodes */}
          {personas.map((persona, i) => (
            <div
              key={persona.id}
              className={`${styles.nodeCard} ${styles[persona.positionClass]} ${styles[persona.accent]}`}
              style={{ transitionDelay: `${i * 0.1}s` }}
            >
              {/* Glowing Orb */}
              <div className={styles.orbContainer}>
                <div className={styles.orbRing} />
                <div className={styles.orbRing2} />
                <div className={styles.orb}>
                  {persona.emoji}
                </div>
              </div>

              {/* Persona Content */}
              <div className={styles.contentSide}>
                <div className={styles.roleTag}>{persona.role}</div>
                <h3 className={styles.personaName}>{persona.name}</h3>
                <blockquote className={styles.pullQuote}>
                  {persona.quote}
                </blockquote>
                <div className={styles.chipList}>
                  {persona.bullets.map((bullet, idx) => (
                    <span key={idx} className={styles.chip}>
                      <span className={styles.chipDot} />
                      {bullet}
                    </span>
                  ))}
                </div>
              </div>
            </div>
          ))}
          
        </div>
      </div>
    </section>
  );
}
