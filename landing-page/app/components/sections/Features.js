"use client";

import Image from "next/image";
import { useEffect, useRef, useState } from "react";
import styles from "./Features.module.css";

const features = [
  {
    icon: "/images/trusted-circle.png",
    title: 'The "Trusted Circle" Mechanism',
    description:
      "A secure network connecting the senior with family, remote relatives, and local volunteers to monitor well-being seamlessly.",
    accent: "teal",
    size: "large",
    badge: "Real-time Connectivity"
  },
  {
    icon: "/images/daily-checkin.png",
    title: "Accessible Daily Check-Ins",
    description:
      "A highly simplified, icon-driven interface designed specifically for elderly users to log their mood and daily activities without frustration.",
    accent: "amber",
    size: "tall",
    badge: "Senior-Friendly UI"
  },
  {
    icon: "/images/scam-shield.png",
    title: "AI-Powered Scam Protection",
    description:
      "A built-in message checker that analyzes suspicious texts for common Philippine scam patterns, delivering an easy-to-understand risk verdict.",
    accent: "red",
    size: "tall",
    badge: "Powered by AI"
  },
  {
    icon: "/images/alerts-summary.png",
    title: "Automated Alerts & Summaries",
    description:
      "AI-generated weekly companionship summaries in a warm tone, plus immediate push notifications for high-risk scams or missed check-ins.",
    accent: "primary",
    size: "large",
    badge: "Automated Insights"
  },
];

const FeatureCard = ({ feature, index }) => {
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
    
    const rotateX = ((y - centerY) / centerY) * -4;
    const rotateY = ((x - centerX) / centerX) * 4;

    setCardTransform(`perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.02, 1.02, 1.02)`);
  };

  const handleMouseEnter = () => setIsHovering(true);
  
  const handleMouseLeave = () => {
    setIsHovering(false);
    setCardTransform("perspective(1200px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)");
  };

  return (
    <article
      ref={cardRef}
      className={`${styles.card} ${styles[feature.accent]} ${styles[feature.size]} reveal`}
      style={{ 
        transitionDelay: `${index * 0.15}s`,
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

      <div className={styles.cardInner}>
        {feature.badge && (
          <span className={styles.badge}>{feature.badge}</span>
        )}
        <div className={styles.iconWrap}>
          <Image
            src={feature.icon}
            alt={feature.title}
            width={64}
            height={64}
            className={styles.iconImg}
          />
        </div>
        <div className={styles.cardText}>
          <h3>{feature.title}</h3>
          <p>{feature.description}</p>
        </div>
      </div>

      <div className={styles.patternOverlay} aria-hidden="true" />
    </article>
  );
};

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

        <div className={styles.bentoGrid}>
          {features.map((feature, i) => (
            <FeatureCard key={i} feature={feature} index={i} />
          ))}
        </div>
      </div>
    </section>
  );
}
