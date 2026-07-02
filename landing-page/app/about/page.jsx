"use client";

import Navbar from "../components/layout/Navbar";
import Footer from "../components/layout/Footer";
import ScrollToTop from "../components/ui/ScrollToTop";

export default function AboutPage() {
  return (
    <>
      <Navbar />
      <main className="pt-[150px] pb-[100px] bg-bg-warm min-h-screen max-md:pt-[120px]">
        <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8">
          <header className="text-center mb-20 max-w-[800px] mx-auto">
            <span className="inline-flex items-center gap-2 text-xs font-semibold tracking-widest text-primary bg-primary/8 py-1.5 px-4 rounded-full mb-5 uppercase">
              Gabay Sr.
            </span>
            <h1 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-text-primary tracking-tight mb-4">
              About Us
            </h1>
            <p className="text-base sm:text-lg text-text-secondary max-w-[640px] mx-auto leading-relaxed">
              Learn more about our mission to protect Filipino seniors.
            </p>
          </header>

          <div className="max-w-[800px] mx-auto bg-white rounded-3xl p-8 sm:p-16 shadow-[0_10px_40px_rgba(15,118,110,0.05)] border border-primary/10">
            <section className="mb-16 last:mb-0">
              <h2 className="text-2xl sm:text-[1.75rem] font-bold text-primary mb-6 pb-3 border-b-2 border-primary/10">
                Our Story
              </h2>
              <p className="text-[1.05rem] leading-relaxed text-text-secondary mb-5">
                Gabay Sr. was born out of a desire to protect the elderly in the Philippines
                from the rising threat of digital scams, while also providing them a simple,
                warm way to stay connected with their families and the community.
              </p>
              <p className="text-[1.05rem] leading-relaxed text-text-secondary mb-5">
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
