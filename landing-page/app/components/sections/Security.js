"use client";

import { useEffect, useRef } from "react";
import styles from "./Security.module.css";

const securityFeatures = [
  {
    icon: "🔒",
    title: "Closed Network",
    description:
      "Gabay Sr. operates on a strict invite-only basis. No strangers can ever message or access your loved one's profile.",
  },
  {
    icon: "🛡️",
    title: "Real-Time AI Shield",
    description:
      "Suspicious messages are scanned instantly by Gemini AI, flagging phishing attempts before any dangerous links are tapped.",
  },
  {
    icon: "☁️",
    title: "Secure Infrastructure",
    description:
      "Powered by Google Firebase with strict security rules, ensuring check-in logs and personal data are encrypted and safe.",
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
    <section id="security" className={styles.section} ref={sectionRef}>
      <div className="container">
        <div className={`${styles.header} reveal`}>
          <span className="section-label">Security & Privacy</span>
          <h2 className="section-title">Built for Absolute Peace of Mind</h2>
          <p className="section-subtitle">
            We treat your family&apos;s data with the highest level of care. 
            Gabay Sr. is engineered from the ground up to keep seniors safe.
          </p>
        </div>

        <div className={styles.grid}>
          {securityFeatures.map((feature, i) => (
            <div
              key={i}
              className={`${styles.item} reveal`}
              style={{ transitionDelay: `${i * 0.15}s` }}
            >
              <div className={styles.iconWrap}>{feature.icon}</div>
              <h3>{feature.title}</h3>
              <p>{feature.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
