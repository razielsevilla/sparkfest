"use client";

import Navbar from "../components/layout/Navbar";
import Footer from "../components/layout/Footer";
import ScrollToTop from "../components/ui/ScrollToTop";
import styles from "../components/ui/StaticPage.module.css";

export default function TermsPage() {
  return (
    <>
      <Navbar />
      <main className={styles.main}>
        <div className="container">
          <header className={styles.header}>
            <span className="section-label">Legal</span>
            <h1 className="section-title">Terms of Service</h1>
            <p className="section-subtitle">
              Guidelines for using Gabay Sr. responsibly.
            </p>
          </header>

          <div className={styles.content}>
            <section className={styles.section}>
              <h2>Usage Guidelines</h2>
              <p>
                By using Gabay Sr., you agree to use the service responsibly to care for your
                loved ones.
              </p>
              <p>
                <strong>Important Note:</strong> The AI Scam checker is a preventative tool and 
                does not guarantee 100% detection of all threats. Always practice vigilance and
                personally verify suspicious messages when possible.
              </p>
            </section>
          </div>
        </div>
      </main>
      <Footer />
      <ScrollToTop />
    </>
  );
}
