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
    <section id="cta" className={styles.section} ref={sectionRef}>
      {/* Cinematic mesh background */}
      <div className={styles.meshBackground} aria-hidden="true" />
      
      {/* Floating Filipino-themed decorations */}
      <div className={styles.floatingDecorations} aria-hidden="true">
        <span className={styles.deco1}>🌺</span>
        <span className={styles.deco2}>⭐</span>
        <span className={styles.deco3}>🇵🇭</span>
      </div>

      {/* Large subtle watermark text for background depth */}
      <div className={styles.watermarkText} aria-hidden="true">
        <div className={styles.watermarkLine}>GABAY</div>
        <div className={styles.watermarkLine}>SR.</div>
      </div>

      {/* Subtle minimalist rings */}
      <div className={styles.minimalistRings} aria-hidden="true">
        <div className={styles.ring1} />
        <div className={styles.ring2} />
      </div>

      <div className={`container ${styles.container}`}>
        <div className={styles.contentGrid}>
          {/* Left: Text & Action */}
          <div className={`${styles.textContent} reveal`}>
            <h2>
              Be Part of Every Senior&apos;s <br />
              <span className={styles.textHighlight}>Trusted Circle</span>
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

          {/* Right: Icon Cluster */}
          <div className={`${styles.iconCluster} reveal`} style={{ transitionDelay: '0.2s' }}>
            <div className={styles.clusterCenter}>
              <div className={styles.shieldBase}>🛡️</div>
              <div className={styles.heartOverlay}>❤️</div>
              
              {/* Orbiting elements */}
              <div className={styles.orbitCircle} />
              <div className={styles.orbitItem1}>👨‍👩‍👧</div>
              <div className={styles.orbitItem2}>👵</div>
              <div className={styles.orbitItem3}>🏘️</div>
            </div>
          </div>
        </div>
      </div>
      
      {/* Scroll indicator curve */}
      <div className={styles.bottomCurve} aria-hidden="true">
        <svg viewBox="0 0 1440 120" preserveAspectRatio="none">
          <path d="M0,0 C480,120 960,120 1440,0 L1440,120 L0,120 Z" fill="#064e3b" />
        </svg>
      </div>
    </section>
  );
}
