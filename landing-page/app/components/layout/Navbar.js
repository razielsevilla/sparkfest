"use client";

import { useState, useEffect } from "react";
import Image from "next/image";
import styles from "./Navbar.module.css";

export default function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => setScrolled(window.scrollY > 40);
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const toggleMenu = () => setMenuOpen((prev) => !prev);
  const closeMenu = () => setMenuOpen(false);

  return (
    <nav
      id="navbar"
      className={`${styles.navbar} ${scrolled ? styles.scrolled : ""}`}
    >
      <div className={`container ${styles.navInner}`}>
        <a href="#" className={styles.logo} aria-label="Gabay Sr. home">
          <Image src="/images/logo.png" alt="Gabay Sr. Logo" width={40} height={40} className={styles.logoImage} />
          <span>Gabay Sr.</span>
        </a>

        <ul className={`${styles.links} ${menuOpen ? styles.open : ""}`}>
          <li>
            <a href="/#features" onClick={closeMenu}>
              Features
            </a>
          </li>
          <li>
            <a href="/#how-it-works" onClick={closeMenu}>
              How It Works
            </a>
          </li>
          <li>
            <a href="/#tech-stack" onClick={closeMenu}>
              Tech Stack
            </a>
          </li>
          <li>
            <a href="/#who-its-for" onClick={closeMenu}>
              Who It&apos;s For
            </a>
          </li>
          <li>
            <a href="/#cta" className={styles.cta} onClick={closeMenu}>
              Download App
            </a>
          </li>
        </ul>

        <button
          className={`${styles.hamburger} ${menuOpen ? styles.hamburgerOpen : ""}`}
          onClick={toggleMenu}
          aria-label="Toggle navigation menu"
          aria-expanded={menuOpen}
        >
          <span />
          <span />
          <span />
        </button>
      </div>
    </nav>
  );
}
