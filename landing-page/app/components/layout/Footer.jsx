"use client";

import Image from "next/image";
import Link from "next/link";

export default function Footer() {
  return (
    <footer className="relative bg-[#064e3b] text-white/70 py-24 px-4 sm:px-6 lg:px-8 -mt-[1px]">
      {/* Decorative gradient mesh background */}
      <div
        className="absolute inset-0 bg-[radial-gradient(circle_at_10%_90%,rgba(20,184,166,0.1)_0%,transparent_40%),radial-gradient(circle_at_90%_10%,rgba(245,158,11,0.08)_0%,transparent_50%)] pointer-events-none z-10"
        aria-hidden="true"
      />

      <div className="max-w-[1200px] mx-auto relative z-20">
        <div className="grid grid-cols-1 lg:grid-cols-[1.2fr_2fr] gap-16 mb-20">
          {/* Brand Column */}
          <div className="flex flex-col">
            <Link href="/" className="flex items-center gap-4 mb-6 hover:opacity-90 transition-opacity duration-300" aria-label="Gabay Sr. home">
              <div className="w-12 h-12 bg-white rounded-[14px] flex items-center justify-center shadow-[0_0_20px_rgba(20,184,166,0.3)] relative after:absolute after:inset-0 after:rounded-[14px] after:shadow-[inset_0_2px_5px_rgba(0,0,0,0.1)] after:pointer-events-none">
                <Image
                  src="/images/logo.png"
                  alt="Gabay Sr. Logo"
                  width={40}
                  height={40}
                  className="w-8 h-8 object-contain"
                />
              </div>
              <span className="font-primary text-3xl font-extrabold text-white tracking-tight">Gabay Sr.</span>
            </Link>
            <p className="text-[0.95rem] leading-relaxed text-white/70 mb-8 max-w-[340px] lg:max-w-[500px]">
              Empowering Filipino families to protect their elderly loved ones
              with modern AI technology, scam defense, and a simple, intuitive
              design built just for them.
            </p>
            <div className="flex gap-4">
              <a
                href="#"
                aria-label="Facebook"
                className="flex items-center justify-center w-[42px] h-[42px] rounded-full bg-white/6 backdrop-blur-md border border-white/10 text-white hover:bg-primary-light hover:border-primary-light hover:translate-y-[-4px] hover:scale-105 hover:shadow-[0_8px_20px_rgba(20,184,166,0.4)] transition-all duration-350"
              >
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
              </a>
              <a
                href="#"
                aria-label="Twitter"
                className="flex items-center justify-center w-[42px] h-[42px] rounded-full bg-white/6 backdrop-blur-md border border-white/10 text-white hover:bg-primary-light hover:border-primary-light hover:translate-y-[-4px] hover:scale-105 hover:shadow-[0_8px_20px_rgba(20,184,166,0.4)] transition-all duration-350"
              >
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M22 4s-.7 2.1-2 3.4c1.6 10-9.4 17.3-18 11.6 2.2.1 4.4-.6 6-2C3 15.5.5 9.6 3 5c2.2 2.6 5.6 4.1 9 4-.9-4.2 4-6.6 7-3.8 1.1 0 3-1.2 3-1.2z"/></svg>
              </a>
              <a
                href="#"
                aria-label="Instagram"
                className="flex items-center justify-center w-[42px] h-[42px] rounded-full bg-white/6 backdrop-blur-md border border-white/10 text-white hover:bg-primary-light hover:border-primary-light hover:translate-y-[-4px] hover:scale-105 hover:shadow-[0_8px_20px_rgba(20,184,166,0.4)] transition-all duration-350"
              >
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"/></svg>
              </a>
            </div>
          </div>

          {/* Links Grid */}
          <div className="grid grid-cols-2 sm:grid-cols-3 gap-8 sm:gap-12">
            <div className="flex flex-col">
              <h4 className="text-[1.05rem] font-bold text-white mb-6 tracking-wide">Product</h4>
              <ul className="flex flex-col gap-4">
                <li><Link href="/#features" className="text-[0.95rem] text-white/60 hover:text-white hover:translate-x-3 duration-300 transition-all inline-flex items-center relative hover:before:opacity-100 before:opacity-0 before:content-[''] before:absolute before:-left-3.5 before:w-1.5 before:h-[2px] before:bg-primary-light before:rounded-sm before:transition-opacity">Key Features</Link></li>
                <li><Link href="/#how-it-works" className="text-[0.95rem] text-white/60 hover:text-white hover:translate-x-3 duration-300 transition-all inline-flex items-center relative hover:before:opacity-100 before:opacity-0 before:content-[''] before:absolute before:-left-3.5 before:w-1.5 before:h-[2px] before:bg-primary-light before:rounded-sm before:transition-opacity">How It Works</Link></li>
                <li><Link href="/#security" className="text-[0.95rem] text-white/60 hover:text-white hover:translate-x-3 duration-300 transition-all inline-flex items-center relative hover:before:opacity-100 before:opacity-0 before:content-[''] before:absolute before:-left-3.5 before:w-1.5 before:h-[2px] before:bg-primary-light before:rounded-sm before:transition-opacity">Security &amp; Privacy</Link></li>
                <li><Link href="/#who-its-for" className="text-[0.95rem] text-white/60 hover:text-white hover:translate-x-3 duration-300 transition-all inline-flex items-center relative hover:before:opacity-100 before:opacity-0 before:content-[''] before:absolute before:-left-3.5 before:w-1.5 before:h-[2px] before:bg-primary-light before:rounded-sm before:transition-opacity">Who It&apos;s For</Link></li>
              </ul>
            </div>

            <div className="flex flex-col">
              <h4 className="text-[1.05rem] font-bold text-white mb-6 tracking-wide">System</h4>
              <ul className="flex flex-col gap-4">
                <li><Link href="/#tech-stack" className="text-[0.95rem] text-white/60 hover:text-white hover:translate-x-3 duration-300 transition-all inline-flex items-center relative hover:before:opacity-100 before:opacity-0 before:content-[''] before:absolute before:-left-3.5 before:w-1.5 before:h-[2px] before:bg-primary-light before:rounded-sm before:transition-opacity">Google Technologies</Link></li>
                <li><Link href="/#tech-stack" className="text-[0.95rem] text-white/60 hover:text-white hover:translate-x-3 duration-300 transition-all inline-flex items-center relative hover:before:opacity-100 before:opacity-0 before:content-[''] before:absolute before:-left-3.5 before:w-1.5 before:h-[2px] before:bg-primary-light before:rounded-sm before:transition-opacity">Gemini AI Engine</Link></li>
                <li><Link href="/#tech-stack" className="text-[0.95rem] text-white/60 hover:text-white hover:translate-x-3 duration-300 transition-all inline-flex items-center relative hover:before:opacity-100 before:opacity-0 before:content-[''] before:absolute before:-left-3.5 before:w-1.5 before:h-[2px] before:bg-primary-light before:rounded-sm before:transition-opacity">Firestore Database</Link></li>
                <li><Link href="/#tech-stack" className="text-[0.95rem] text-white/60 hover:text-white hover:translate-x-3 duration-300 transition-all inline-flex items-center relative hover:before:opacity-100 before:opacity-0 before:content-[''] before:absolute before:-left-3.5 before:w-1.5 before:h-[2px] before:bg-primary-light before:rounded-sm before:transition-opacity">Push Notifications</Link></li>
              </ul>
            </div>

            <div className="flex flex-col col-span-2 sm:col-span-1">
              <h4 className="text-[1.05rem] font-bold text-white mb-6 tracking-wide">Company</h4>
              <ul className="flex flex-col gap-4">
                <li><Link href="/about" className="text-[0.95rem] text-white/60 hover:text-white hover:translate-x-3 duration-300 transition-all inline-flex items-center relative hover:before:opacity-100 before:opacity-0 before:content-[''] before:absolute before:-left-3.5 before:w-1.5 before:h-[2px] before:bg-primary-light before:rounded-sm before:transition-opacity">About Us</Link></li>
                <li><Link href="/contact" className="text-[0.95rem] text-white/60 hover:text-white hover:translate-x-3 duration-300 transition-all inline-flex items-center relative hover:before:opacity-100 before:opacity-0 before:content-[''] before:absolute before:-left-3.5 before:w-1.5 before:h-[2px] before:bg-primary-light before:rounded-sm before:transition-opacity">Contact Support</Link></li>
                <li><Link href="/privacy" className="text-[0.95rem] text-white/60 hover:text-white hover:translate-x-3 duration-300 transition-all inline-flex items-center relative hover:before:opacity-100 before:opacity-0 before:content-[''] before:absolute before:-left-3.5 before:w-1.5 before:h-[2px] before:bg-primary-light before:rounded-sm before:transition-opacity">Privacy Policy</Link></li>
                <li><Link href="/terms" className="text-[0.95rem] text-white/60 hover:text-white hover:translate-x-3 duration-300 transition-all inline-flex items-center relative hover:before:opacity-100 before:opacity-0 before:content-[''] before:absolute before:-left-3.5 before:w-1.5 before:h-[2px] before:bg-primary-light before:rounded-sm before:transition-opacity">Terms of Service</Link></li>
              </ul>
            </div>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="flex flex-col sm:flex-row items-center justify-between pt-8 border-t border-white/8 text-[0.85rem] text-white/45 gap-6 text-center">
          <div>
            &copy; {new Date().getFullYear()} Gabay Sr. All rights reserved.
          </div>

          <div className="flex gap-6">
            <Link href="/terms" className="hover:text-white transition-colors duration-250">Terms</Link>
            <Link href="/privacy" className="hover:text-white transition-colors duration-250">Privacy</Link>
            <a href="#" className="hover:text-white transition-colors duration-250">Cookies</a>
          </div>
        </div>
      </div>
    </footer>
  );
}
