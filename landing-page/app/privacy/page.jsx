"use client";

import Navbar from "../components/layout/Navbar";
import Footer from "../components/layout/Footer";
import ScrollToTop from "../components/ui/ScrollToTop";
import styles from "../components/ui/StaticPage.module.css";

export default function PrivacyPage() {
  return (
    <>
      <Navbar />
      <main className={styles.main}>
        <div className="container">
          <header className={styles.header}>
            <span className="section-label">Data Security</span>
            <h1 className="section-title">Privacy Policy</h1>
            <p className="section-subtitle">
              Your family's privacy is our absolute priority.
            </p>
          </header>

          <div className={styles.content}>
            <section className={styles.section}>
              <h2>Our Commitment</h2>
              <p>
                Gabay Sr. operates on a strict "Trusted Circle" basis. We only share information
                with the specific family members and volunteers you invite.
              </p>
              <ul>
                <li>We do not sell your data to third parties.</li>
                <li>Messages scanned for scams are processed securely and not stored permanently.</li>
                <li>Location data (if enabled) is only shared with the invited family members.</li>
              </ul>
            </section>
          </div>
        </div>
      </main>
      <Footer />
      <ScrollToTop />
    </>
  );
}
