"use client";

import Image from "next/image";
import { useEffect, useRef } from "react";
import styles from "./Features.module.css";

const features = [
  {
    icon: "/images/trusted-circle.png",
    title: 'The "Trusted Circle" Mechanism',
    description:
      "A secure network connecting the senior with family, remote relatives, and local volunteers to monitor well-being seamlessly.",
    accent: "teal",
  },
  {
    icon: "/images/daily-checkin.png",
    title: "Accessible Daily Check-Ins",
    description:
      "A highly simplified, icon-driven interface designed specifically for elderly users to log their mood and daily activities without frustration.",
    accent: "amber",
  },
  {
    icon: "/images/scam-shield.png",
    title: "AI-Powered Scam Protection",
    description:
      "A built-in message checker that analyzes suspicious texts for common Philippine scam patterns, delivering an easy-to-understand risk verdict.",
    accent: "red",
  },
  {
    icon: "/images/alerts-summary.png",
    title: "Automated Alerts & Summaries",
    description:
      "AI-generated weekly companionship summaries in a warm tone, plus immediate push notifications for high-risk scams or missed check-ins.",
    accent: "primary",
  },
];

export default function Features() {
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
    <section id="features" className={styles.section} ref={sectionRef}>
      <div className="container">
        <div className={`${styles.header} reveal`}>
          <span className="section-label">Key Features</span>
          <h2 className="section-title">
            Everything Lola &amp; Lolo Need in One App
          </h2>
          <p className="section-subtitle">
            Four powerful features working together to keep Filipino seniors
            connected, protected, and cared for — all through one simple
            interface.
          </p>
        </div>

        <div className={styles.grid}>
          {features.map((feature, i) => (
            <article
              key={i}
              className={`${styles.card} ${styles[feature.accent]} reveal`}
              style={{ transitionDelay: `${i * 0.08}s` }}
              data-index={String(i + 1).padStart(2, "0")}
            >
              <div className={styles.iconWrap}>
                <Image
                  src={feature.icon}
                  alt={feature.title}
                  width={64}
                  height={64}
                  className={styles.iconImg}
                />
              </div>
              <h3>{feature.title}</h3>
              <p>{feature.description}</p>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}
