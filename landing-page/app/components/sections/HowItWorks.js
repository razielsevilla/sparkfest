"use client";

import { useEffect, useRef, useState } from "react";
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

const StepCard = ({ step, index }) => {
  const cardRef = useRef(null);
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });
  const [cardTransform, setCardTransform] = useState("perspective(1200px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)");
  const [isHovering, setIsHovering] = useState(false);

  const handleMouseMove = (e) => {
    if (!cardRef.current) return;
    const rect = cardRef.current.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    setMousePosition({ x, y });

    const centerX = rect.width / 2;
    const centerY = rect.height / 2;
    
    // Subtle tilt for wide horizontal cards
    const rotateX = ((y - centerY) / centerY) * -3;
    const rotateY = ((x - centerX) / centerX) * 3;

    setCardTransform(`perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.01, 1.01, 1.01)`);
  };

  const handleMouseEnter = () => setIsHovering(true);
  
  const handleMouseLeave = () => {
    setIsHovering(false);
    setCardTransform("perspective(1200px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)");
  };

  return (
    <article
      ref={cardRef}
      className={`${styles.stepCard} reveal`}
      style={{
        top: `calc(120px + ${index * 30}px)`,
        zIndex: index + 1,
        transform: cardTransform,
        "--mouse-x": `${mousePosition.x}px`,
        "--mouse-y": `${mousePosition.y}px`,
      }}
      onMouseMove={handleMouseMove}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      <div 
        className={styles.mouseGlow} 
        style={{ opacity: isHovering ? 1 : 0 }}
        aria-hidden="true" 
      />

      {/* Giant outline number in the background */}
      <div className={styles.bgNumber} aria-hidden="true">
        {step.number}
      </div>

      <div className={styles.cardInner}>
        <div className={styles.iconWrap}>
          <span className={styles.stepEmoji}>{step.emoji}</span>
        </div>
        <div className={styles.cardText}>
          <h3 className={styles.stepTitle}>
            <span className={styles.stepNumberBadge}>Step {step.number}</span>
            {step.title}
          </h3>
          <p className={styles.stepDesc}>{step.description}</p>
        </div>
      </div>

      <div className={styles.patternOverlay} aria-hidden="true" />
    </article>
  );
};

export default function HowItWorks() {
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
      { threshold: 0.1, rootMargin: "0px 0px -50px 0px" }
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

        <div className={styles.stackedContainer}>
          {steps.map((step, i) => (
            <StepCard key={i} step={step} index={i} />
          ))}
        </div>
      </div>
    </section>
  );
}
