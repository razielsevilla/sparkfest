"use client";

import { useEffect, useRef } from "react";
import styles from "./HowItWorks.module.css";

const steps = [
  {
    number: "1",
    emoji: "👨‍👩‍👧",
    title: "Create a Trusted Circle",
    description:
      "A family member signs up and adds Lola's profile, then invites relatives, OFWs, and barangay volunteers.",
  },
  {
    number: "2",
    emoji: "📱",
    title: "Daily Check-In",
    description:
      'Lola taps one big button, picks her mood emoji, and optionally records a voice note — done in under 30 seconds.',
  },
  {
    number: "3",
    emoji: "🤖",
    title: "AI Watches Over",
    description:
      "Gemini AI scans suspicious messages for scam patterns and generates warm weekly companionship summaries.",
  },
  {
    number: "4",
    emoji: "🔔",
    title: "Circle Gets Notified",
    description:
      "Instant push alerts for scam threats or missed check-ins, plus weekly summaries so family always stays connected.",
  },
];

export default function HowItWorks() {
  const sectionRef = useRef(null);

  useEffect(() => {
    // Observer for the header
    const headerObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("visible");
          }
        });
      },
      { threshold: 0.15 }
    );

    // Observer for individual steps — staggered reveal
    const stepObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            // Use the data-index to create a stagger delay
            const index = parseInt(entry.target.dataset.index, 10) || 0;
            setTimeout(() => {
              entry.target.classList.add(styles.visible);
            }, index * 150);
            stepObserver.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.2, rootMargin: "0px 0px -40px 0px" }
    );

    const el = sectionRef.current;
    if (el) {
      // Observe header reveal elements
      el.querySelectorAll(".reveal").forEach((child) =>
        headerObserver.observe(child)
      );

      // Observe each step card individually
      el.querySelectorAll(`.${styles.step}`).forEach((child) =>
        stepObserver.observe(child)
      );
    }

    return () => {
      headerObserver.disconnect();
      stepObserver.disconnect();
    };
  }, []);

  return (
    <section id="how-it-works" className={styles.section} ref={sectionRef}>
      <div className="container">
        <div className={`${styles.header} reveal`}>
          <span className="section-label">How It Works</span>
          <h2 className="section-title">Simple for Seniors, Powerful for Family</h2>
          <p className="section-subtitle">
            From setup to daily protection — Gabay Sr. is designed so even
            non-tech-savvy seniors can use it with confidence.
          </p>
        </div>

        <div className={styles.steps}>
          {steps.map((step, i) => (
            <div
              key={i}
              className={styles.step}
              data-index={i}
            >
              <div className={styles.stepNumber}>{step.number}</div>
              {i < steps.length - 1 && (
                <div className={styles.stepConnector} aria-hidden="true" />
              )}
              <div className={styles.stepTitle}>
                <span className={styles.stepEmoji}>{step.emoji}</span>
                {step.title}
              </div>
              <p className={styles.stepDesc}>{step.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
