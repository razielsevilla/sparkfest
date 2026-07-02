"use client";

import { useEffect, useRef } from "react";
import styles from "./TechStack.module.css";

const technologies = [
  {
    logo: "💙",
    name: "Flutter",
    tag: "Frontend Framework",
    description:
      'Powers a unified, responsive, single-codebase frontend divided into "Senior Mode" and "Family/Volunteer Mode."',
    accent: "blue",
  },
  {
    logo: "🔥",
    name: "Firebase",
    tag: "Backend & Notifications",
    description:
      "Serverless backend infrastructure — Firestore, Authentication, Cloud Functions, and Firebase Cloud Messaging for real-time push alerts.",
    accent: "amber",
  },
  {
    logo: "✨",
    name: "Gemini API",
    tag: "AI & Safety Engine",
    description:
      "Drives natural language features including scam message analysis and warm, conversational weekly companionship summaries.",
    accent: "purple",
  },
];

export default function TechStack() {
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
    <section id="tech-stack" className={styles.section} ref={sectionRef}>
      <div className="container">
        <div className={`${styles.header} reveal`}>
          <span className="section-label">Google Technologies</span>
          <h2 className="section-title">Built on a Modern Google Stack</h2>
          <p className="section-subtitle">
            Leveraging best-in-class Google technologies for reliability,
            real-time updates, and advanced AI capabilities.
          </p>
        </div>

        <div className={styles.staggeredGrid}>
          {technologies.map((tech, i) => (
            <article
              key={i}
              className={`${styles.card} ${styles[tech.accent]} reveal`}
              style={{ transitionDelay: `${i * 0.15}s` }}
            >
              <div className={styles.floatingEmoji}>
                {tech.logo}
              </div>
              <span className={styles.tag}>{tech.tag}</span>
              <h3>{tech.name}</h3>
              <p>{tech.description}</p>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}
