"use client";

import { useEffect, useRef } from "react";
import { Lock, Cpu, Database } from "lucide-react";
import styles from "./Security.module.css";

const securityFeatures = [
  {
    icon: <Lock size={32} strokeWidth={1.5} />,
    title: "Closed Network",
    description:
      "Gabay Sr. operates on a strict invite-only basis. No strangers can ever message or access your loved one's profile.",
    glow: "teal",
  },
  {
    icon: <Cpu size={32} strokeWidth={1.5} />,
    title: "Real-Time AI Shield",
    description:
      "Suspicious messages are scanned instantly by Gemini AI, flagging phishing attempts before any dangerous links are tapped.",
    glow: "amber",
  },
  {
    icon: <Database size={32} strokeWidth={1.5} />,
    title: "Secure Infrastructure",
    description:
      "Powered by Google Firebase with strict security rules, ensuring check-in logs and personal data are encrypted and safe.",
    glow: "blue",
  },
];

export default function Security() {
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
      { threshold: 0.1 }
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
    <section id="security" className={styles.section} ref={sectionRef}>
      {/* Animated particles */}
      <div className={styles.particles} aria-hidden="true">
        {[...Array(6)].map((_, i) => (
          <div
            key={i}
            className={styles.particle}
            style={{
              left: `${15 + i * 15}%`,
              animationDelay: `${i * 1.8}s`,
              animationDuration: `${8 + i * 2}s`,
            }}
          />
        ))}
      </div>

      {/* Grain texture overlay */}
      <div className={styles.grainOverlay} aria-hidden="true" />

      {/* Central floating shield */}
      <div className={styles.centralShield} aria-hidden="true">
        <svg width="200" height="200" viewBox="0 0 200 200" fill="none">
          <path
            d="M100 10 L180 50 L180 110 C180 155 145 185 100 195 C55 185 20 155 20 110 L20 50 Z"
            fill="none"
            stroke="rgba(20, 184, 166, 0.08)"
            strokeWidth="2"
          />
          <path
            d="M100 30 L160 60 L160 105 C160 140 135 165 100 175 C65 165 40 140 40 105 L40 60 Z"
            fill="none"
            stroke="rgba(20, 184, 166, 0.05)"
            strokeWidth="1.5"
          />
        </svg>
      </div>

      <div className="container">
        <div className={`${styles.header} reveal`}>
          <span className="section-label section-label-light">Security & Privacy</span>
          <h2 className="section-title section-title-light">Built for Absolute Peace of Mind</h2>
          <p className="section-subtitle section-subtitle-light">
            We treat your family&apos;s data with the highest level of care. 
            Gabay Sr. is engineered from the ground up to keep seniors safe.
          </p>
        </div>

        <div className={styles.grid}>
          {securityFeatures.map((feature, i) => (
            <div
              key={i}
              className={`${styles.glassCard} ${styles[feature.glow]} reveal`}
              style={{ transitionDelay: `${i * 0.15}s` }}
            >
              <div className={styles.neonBorder} aria-hidden="true" />
              <div className={styles.cardContent}>
                <div className={styles.iconWrap}>{feature.icon}</div>
                <h3>{feature.title}</h3>
                <p>{feature.description}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
