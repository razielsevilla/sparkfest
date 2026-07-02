"use client";

import Image from "next/image";
import styles from "./Footer.module.css";

export default function Footer() {
  return (
    <footer className={styles.footer}>
      {/* Decorative top border glow */}
      <div className={styles.topGlow} />

      <div className="container">
        <div className={styles.mainGrid}>
          {/* Brand Column */}
          <div className={styles.brandCol}>
            <a href="#" className={styles.logo} aria-label="Gabay Sr. home">
              <Image src="/images/logo.png" alt="Gabay Sr. Logo" width={44} height={44} className={styles.logoImage} />
              <span className={styles.logoText}>Gabay Sr.</span>
            </a>
            <p className={styles.mission}>
              Empowering Filipino families to protect their elderly loved ones
              with modern AI technology, scam defense, and a simple, intuitive
              design built just for them.
            </p>
            <div className={styles.socials}>
              <a href="#" aria-label="Facebook">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
              </a>
              <a href="#" aria-label="Twitter">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M22 4s-.7 2.1-2 3.4c1.6 10-9.4 17.3-18 11.6 2.2.1 4.4-.6 6-2C3 15.5.5 9.6 3 5c2.2 2.6 5.6 4.1 9 4-.9-4.2 4-6.6 7-3.8 1.1 0 3-1.2 3-1.2z"/></svg>
              </a>
              <a href="#" aria-label="Instagram">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"/></svg>
              </a>
            </div>
          </div>

          {/* Links Grid */}
          <div className={styles.linksContainer}>
            <div className={styles.linkGroup}>
              <h4>Product</h4>
              <ul>
                <li><a href="/#features">Key Features</a></li>
                <li><a href="/#how-it-works">How It Works</a></li>
                <li><a href="/#security">Security &amp; Privacy</a></li>
                <li><a href="/#who-its-for">Who It&apos;s For</a></li>
              </ul>
            </div>

            <div className={styles.linkGroup}>
              <h4>System</h4>
              <ul>
                <li><a href="/#tech-stack">Google Technologies</a></li>
                <li><a href="/#tech-stack">Gemini AI Engine</a></li>
                <li><a href="/#tech-stack">Firestore Database</a></li>
                <li><a href="/#tech-stack">Push Notifications</a></li>
              </ul>
            </div>

            <div className={styles.linkGroup}>
              <h4>Company</h4>
              <ul>
                <li><a href="/about">About Us</a></li>
                <li><a href="/contact">Contact Support</a></li>
                <li><a href="/privacy">Privacy Policy</a></li>
                <li><a href="/terms">Terms of Service</a></li>
              </ul>
            </div>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className={styles.bottomBar}>
          <p className={styles.copyright}>
            &copy; {new Date().getFullYear()} Gabay Sr. All rights reserved. Made with ❤️ in the Philippines.
          </p>
          <div className={styles.legalLinks}>
            <a href="/terms">Terms</a>
            <a href="/privacy">Privacy</a>
            <a href="#">Cookies</a>
          </div>
        </div>
      </div>
    </footer>
  );
}
