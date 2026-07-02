"use client";

import Navbar from "../components/layout/Navbar";
import Footer from "../components/layout/Footer";
import ScrollToTop from "../components/ui/ScrollToTop";
import styles from "../components/ui/StaticPage.module.css";

export default function ContactPage() {
  return (
    <>
      <Navbar />
      <main className={styles.main}>
        <div className="container">
          <header className={styles.header}>
            <span className="section-label">Get in Touch</span>
            <h1 className="section-title">Contact Support</h1>
            <p className="section-subtitle">
              We're here to help you set up and manage your Trusted Circle.
            </p>
          </header>

          <div className={styles.content}>
            <section className={styles.section}>
              <h2>How can we help?</h2>
              <p>
                If you need help setting up Gabay Sr. for your family, or if you are a barangay
                representative looking to implement our volunteer mode, we're here to help.
              </p>
              <ul>
                <li><strong>Email:</strong> support@gabaysr.ph</li>
                <li><strong>Phone:</strong> (02) 8123 4567</li>
                <li><strong>Address:</strong> Metro Manila, Philippines</li>
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
