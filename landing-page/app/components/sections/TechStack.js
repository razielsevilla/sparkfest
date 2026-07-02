"use client";

import { useEffect, useRef, useState } from "react";
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
  {
    logo: "⚡",
    name: "Cloud Functions",
    tag: "Serverless Compute",
    description:
      "Automates check-in reminders, triggers scam alerts, and orchestrates weekly AI summaries without maintaining servers.",
    accent: "amber",
  },
  {
    logo: "📱",
    name: "Material Design",
    tag: "Accessible UI",
    description:
      "Provides high-contrast, large-touch-target components essential for the senior-friendly interface.",
    accent: "blue",
  }
];

export default function TechStack() {
  const sectionRef = useRef(null);
  const [hoveredIndex, setHoveredIndex] = useState(null);

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

  // Double the array for seamless infinite scrolling
  const marqueeItemsRow1 = [...technologies, ...technologies];
  // Slightly different order for the second row so they don't look identical
  const marqueeItemsRow2 = [...technologies.slice(2), ...technologies.slice(0, 2)];
  const marqueeItemsRow2Double = [...marqueeItemsRow2, ...marqueeItemsRow2];

  return (
    <section id="tech-stack" className={styles.section} ref={sectionRef}>
      <div className={styles.diagonalBg} aria-hidden="true" />
      
      <div className="container">
        <div className={`${styles.header} reveal`}>
          <span className="section-label">Google Technologies</span>
          <h2 className="section-title">Built on a Modern Google Stack</h2>
          <p className="section-subtitle">
            Leveraging best-in-class Google technologies for reliability,
            real-time updates, and advanced AI capabilities.
          </p>
        </div>
      </div>

      <div className={`${styles.marqueeContainer} reveal`}>
        {/* Row 1 - Left scrolling */}
        <div className={styles.marqueeRow}>
          <div className={`${styles.marqueeContent} ${styles.scrollLeft} ${hoveredIndex !== null ? styles.paused : ''}`}>
            {marqueeItemsRow1.map((tech, i) => (
              <div
                key={`r1-${i}`}
                className={`${styles.techPill} ${styles[tech.accent]} ${hoveredIndex === `r1-${i % technologies.length}` ? styles.expanded : ''}`}
                onMouseEnter={() => setHoveredIndex(`r1-${i % technologies.length}`)}
                onMouseLeave={() => setHoveredIndex(null)}
              >
                <div className={styles.pillHeader}>
                  <span className={styles.pillIcon}>{tech.logo}</span>
                  <div className={styles.pillTitles}>
                    <span className={styles.pillTag}>{tech.tag}</span>
                    <h3 className={styles.pillName}>{tech.name}</h3>
                  </div>
                </div>
                <div className={styles.pillBody}>
                  <p>{tech.description}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Row 2 - Right to Left scrolling */}
        <div className={styles.marqueeRow}>
          <div className={`${styles.marqueeContent} ${styles.scrollRight} ${hoveredIndex !== null ? styles.paused : ''}`}>
            {marqueeItemsRow2Double.map((tech, i) => (
              <div
                key={`r2-${i}`}
                className={`${styles.techPill} ${styles[tech.accent]} ${hoveredIndex === `r2-${i % technologies.length}` ? styles.expanded : ''}`}
                onMouseEnter={() => setHoveredIndex(`r2-${i % technologies.length}`)}
                onMouseLeave={() => setHoveredIndex(null)}
              >
                <div className={styles.pillHeader}>
                  <span className={styles.pillIcon}>{tech.logo}</span>
                  <div className={styles.pillTitles}>
                    <span className={styles.pillTag}>{tech.tag}</span>
                    <h3 className={styles.pillName}>{tech.name}</h3>
                  </div>
                </div>
                <div className={styles.pillBody}>
                  <p>{tech.description}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>


    </section>
  );
}
