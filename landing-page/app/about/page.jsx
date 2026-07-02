"use client";

import Navbar from "../components/layout/Navbar";
import Footer from "../components/layout/Footer";
import ScrollToTop from "../components/ui/ScrollToTop";
import styles from "../components/ui/StaticPage.module.css";

export default function AboutPage() {
  return (
    <>
      <Navbar />
      <main className={styles.main}>
        <div className="container">
          <header className={styles.header}>
            <span className="section-label">Gabay Sr.</span>
            <h1 className="section-title">About Us</h1>
            <p className="section-subtitle">
              Learn more about our mission to protect Filipino seniors.
            </p>
          </header>

          <div className={styles.content}>
            <section className={styles.section}>
              <h2>Our Story</h2>
              <p>
                Gabay Sr. was born out of a desire to protect the elderly in the Philippines
                from the rising threat of digital scams, while also providing them a simple,
                warm way to stay connected with their families and the community.
              </p>
              <p>
                Our mission is to bridge the digital divide for seniors by using state-of-the-art
                AI technology behind a radically simple, accessible interface. We believe that
                technology should protect our loved ones, not confuse them.
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
