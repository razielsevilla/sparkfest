"use client";

import Image from "next/image";
import Link from "next/link";
import styles from "./Download.module.css";
import Navbar from "../components/layout/Navbar";

export default function DownloadPage() {
  return (
    <>
      <Navbar />
      <main className={styles.pageContainer}>
        <div className={`container ${styles.largeContainer}`}>

          <div className={styles.contentGrid}>
            
            {/* Left Side: Text and Download Action */}
            <div className={styles.textContent}>
              <h1 className={styles.title}>Gabay Sr. App</h1>
              <p className={styles.subtitle}>
                Download Gabay Sr. Latest Version Free.
              </p>
              <p className={styles.description}>
                Companionship, Scam Protection, AI Summaries, and Trusted Circle. Keep your elderly loved ones safe and connected.
              </p>
              
              <button className={styles.downloadBtn}>
                Download Now
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                  <polyline points="7 10 12 15 17 10"/>
                  <line x1="12" y1="15" x2="12" y2="3"/>
                </svg>
              </button>
            </div>

            {/* Right Side: Media Frame */}
            <div className={styles.mediaContainer}>
              <div className={styles.imageFrame}>
                {/* Reusing hero image as the featured image for the download page */}
                <Image 
                  src="/images/hero.png" 
                  alt="Gabay Sr. App Preview" 
                  width={600} 
                  height={338} 
                  className={styles.previewImage}
                  priority
                />
              </div>
            </div>

          </div>
        </div>

        {/* Decorative bottom curve matching Gabay Sr. theme */}
        <div className={styles.bottomCurve} aria-hidden="true">
          <svg viewBox="0 0 1440 120" preserveAspectRatio="none">
            <path d="M0,0 C480,120 960,120 1440,0 L1440,120 L0,120 Z" fill="#0F766E" />
          </svg>
        </div>
      </main>
    </>
  );
}
