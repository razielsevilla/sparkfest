"use client";

import Navbar from "../components/layout/Navbar";
import Footer from "../components/layout/Footer";
import ScrollToTop from "../components/ui/ScrollToTop";

export default function ContactPage() {
  return (
    <>
      <Navbar />
      <main className="pt-[150px] pb-[100px] bg-bg-warm min-h-screen max-md:pt-[120px]">
        <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8">
          <header className="text-center mb-20 max-w-[800px] mx-auto">
            <span className="inline-flex items-center gap-2 text-xs font-semibold tracking-widest text-primary bg-primary/8 py-1.5 px-4 rounded-full mb-5 uppercase">
              Get in Touch
            </span>
            <h1 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-text-primary tracking-tight mb-4">
              Contact Support
            </h1>
            <p className="text-base sm:text-lg text-text-secondary max-w-[640px] mx-auto leading-relaxed">
              We&apos;re here to help you set up and manage your Trusted Circle.
            </p>
          </header>

          <div className="max-w-[800px] mx-auto bg-white rounded-3xl p-8 sm:p-16 shadow-[0_10px_40px_rgba(15,118,110,0.05)] border border-primary/10">
            <section className="mb-16 last:mb-0">
              <h2 className="text-2xl sm:text-[1.75rem] font-bold text-primary mb-6 pb-3 border-b-2 border-primary/10">
                How can we help?
              </h2>
              <p className="text-[1.05rem] leading-relaxed text-text-secondary mb-5">
                If you need help setting up Gabay Sr. for your family, or if you are a barangay
                representative looking to implement our volunteer mode, we&apos;re here to help.
              </p>
              <ul className="list-none p-0 m-0 flex flex-col gap-3">
                <li className="text-[1.05rem] text-text-secondary pl-6 relative before:content-['✦'] before:absolute before:left-0 before:text-primary before:text-[0.8rem] before:top-1">
                  <strong>Email:</strong> support@gabaysr.ph
                </li>
                <li className="text-[1.05rem] text-text-secondary pl-6 relative before:content-['✦'] before:absolute before:left-0 before:text-primary before:text-[0.8rem] before:top-1">
                  <strong>Phone:</strong> (02) 8123 4567
                </li>
                <li className="text-[1.05rem] text-text-secondary pl-6 relative before:content-['✦'] before:absolute before:left-0 before:text-primary before:text-[0.8rem] before:top-1">
                  <strong>Address:</strong> Metro Manila, Philippines
                </li>
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
