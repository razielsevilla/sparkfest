"use client";

import { useEffect, useRef } from "react";
import styles from "./CTA.module.css";

export default function CTA() {
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
      { threshold: 0.2 }
    );

    const el = sectionRef.current;
    if (el) observer.observe(el);

    return () => observer.disconnect();
  }, []);

  return (
    <section id="cta" className={styles.section}>
      <div className="container">
        <div className={`${styles.card} reveal`} ref={sectionRef}>
          <div className={styles.glow1} aria-hidden="true" />
          <div className={styles.glow2} aria-hidden="true" />

          <div className={styles.content}>
            <h2>
              Be Part of Every Senior&apos;s Trusted Circle
            </h2>
            <p>
              Whether you&apos;re a family member miles away, an OFW abroad, or a
              barangay volunteer — Gabay Sr. makes sure no Lola or Lolo is ever
              alone or unprotected.
            </p>
            <a href="#hero" className={`btn ${styles.ctaBtn}`}>
              Get Early Access
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12h14" /><path d="m12 5 7 7-7 7" /></svg>
            </a>
          </div>
        </div>
      </div>
    </section>
  );
}
