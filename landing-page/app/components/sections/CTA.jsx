"use client";

import { useEffect, useRef } from "react";
import Link from "next/link";
import { Heart, Shield, Star } from "lucide-react";

export default function CTA() {
  const sectionRef = useRef(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("visible");
          }
        });
      },
      { threshold: 0.2 }
    );

    const el = sectionRef.current;
    if (el) observer.observe(el);

    return () => observer.disconnect();
  }, []);

  return (
    <section
      id="cta"
      className="group relative overflow-hidden py-24 sm:py-32 pb-32 sm:pb-48 w-screen left-1/2 right-1/2 -ml-[50vw] -mr-[50vw] bg-primary"
      ref={sectionRef}
    >
      {/* Cinematic mesh background */}
      <div
        className="absolute inset-[-50%] w-[200%] h-[200%] bg-[radial-gradient(circle_at_50%_50%,rgba(20,184,166,0.4)_0%,transparent_50%),radial-gradient(circle_at_80%_20%,rgba(245,158,11,0.3)_0%,transparent_40%),radial-gradient(circle_at_20%_80%,rgba(13,95,89,0.6)_0%,transparent_50%)] pointer-events-none z-10"
        style={{
          backgroundSize: "100% 100%",
        }}
        aria-hidden="true"
      />
      
      {/* Floating decorations */}
      <div className="absolute inset-0 z-20 pointer-events-none" aria-hidden="true">
        <span className="absolute top-[15%] left-[10%] opacity-40 blur-[1px] animate-float-drift"><Heart size={24} strokeWidth={1.5} className="text-white" /></span>
        <span className="absolute top-[75%] left-[45%] opacity-40 blur-[1px] animate-float-drift [animation-delay:2s]"><Shield size={20} strokeWidth={1.5} className="text-white" /></span>
        <span className="absolute top-[20%] right-[15%] opacity-40 blur-[1px] animate-float-drift [animation-delay:1s]"><Star size={24} strokeWidth={1.5} className="text-white" /></span>
      </div>

      {/* Large subtle watermark text for background depth */}
      <div className="absolute inset-0 z-10 pointer-events-none flex flex-col justify-center items-center overflow-hidden" aria-hidden="true">
        <div className="font-primary text-[8rem] sm:text-[20vw] font-black leading-[0.85] text-white/[0.03] whitespace-nowrap uppercase transition-all duration-600 group-hover:text-white/[0.12] group-hover:scale-105 group-hover:-rotate-2">
          GABAY
        </div>
        <div className="font-primary text-[8rem] sm:text-[20vw] font-black leading-[0.85] text-white/[0.03] whitespace-nowrap uppercase transition-all duration-600 group-hover:text-white/[0.12] group-hover:scale-105 group-hover:-rotate-2">
          SR.
        </div>
      </div>

      {/* Subtle minimalist rings */}
      <div className="absolute inset-0 z-10 pointer-events-none overflow-hidden" aria-hidden="true">
        <div className="absolute w-[120vw] height-[120vw] top-[-60vw] left-[-20vw] border border-white/[0.05] rounded-full" />
        <div className="absolute w-[80vw] height-[80vw] bottom-[-40vw] right-[-10vw] border border-white/[0.05] rounded-full" />
      </div>

      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 relative z-20">
        <div className="grid grid-cols-1 lg:grid-cols-[1.1fr_0.9fr] gap-16 items-center max-lg:text-center">
          {/* Left: Text & Action */}
          <div className="reveal text-white">
            <h2 className="text-4xl sm:text-5xl lg:text-[3.5rem] font-extrabold mb-5 tracking-tight leading-tight">
              Be Part of Every Senior&apos;s <br />
              <span className="text-secondary-light relative inline-block after:content-[''] after:absolute after:bottom-[0.1em] after:left-0 after:w-full after:h-[0.25em] after:bg-amber-500/40 after:-z-10 after:rounded-md">
                Trusted Circle
              </span>
            </h2>
            <p className="text-lg sm:text-xl text-white/85 max-w-[520px] max-lg:mx-auto mb-10 leading-relaxed">
              Whether you&apos;re a family member miles away, an OFW abroad, or a
              barangay volunteer — Gabay Sr. makes sure no Lola or Lolo is ever
              alone or unprotected.
            </p>
            <Link
              href="/download"
              className="inline-flex items-center gap-2 font-primary font-semibold text-lg text-primary py-4 px-10 rounded-full bg-white shadow-[0_8px_30px_rgba(0,0,0,0.2)] hover:translate-y-[-3px] hover:scale-104 hover:shadow-[0_12px_40px_rgba(0,0,0,0.3)] transition-all duration-350"
            >
              Get Early Access
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                <path d="M5 12h14" />
                <path d="m12 5 7 7-7 7" />
              </svg>
            </Link>
          </div>

          {/* Right: Icon Cluster */}
          <div className="reveal flex justify-center items-center relative h-[400px] max-lg:h-[340px] max-lg:mt-[-2rem]" style={{ transitionDelay: '0.2s' }}>
            <div className="relative w-40 h-40 bg-white/10 backdrop-blur-md rounded-full flex items-center justify-center shadow-[0_0_60px_rgba(20,184,166,0.4)]">
              <Shield size={64} className="text-white filter drop-shadow-[0_10px_20px_rgba(0,0,0,0.2)]" />
              <div className="absolute text-[2.5rem] bottom-8 right-9 animate-float-drift">
                <Heart size={36} className="text-red-500 fill-red-500" />
              </div>
              
              {/* Orbiting elements */}
              <div className="absolute w-[320px] h-[320px] max-sm:w-[260px] max-sm:h-[260px] border border-dashed border-white/20 rounded-full animate-spin">
                <div className="absolute -top-6 left-[calc(50%-25px)] w-[50px] h-[50px] bg-white rounded-full flex items-center justify-center shadow-[0_8px_24px_rgba(0,0,0,0.15)]">
                  <Shield size={16} className="text-primary-light" />
                </div>
                <div className="absolute bottom-7 -right-2 w-[50px] h-[50px] bg-white rounded-full flex items-center justify-center shadow-[0_8px_24px_rgba(0,0,0,0.15)]">
                  <Heart size={16} className="text-red-600 fill-red-600" />
                </div>
                <div className="absolute bottom-7 -left-2 w-[50px] h-[50px] bg-white rounded-full flex items-center justify-center shadow-[0_8px_24px_rgba(0,0,0,0.15)]">
                  <Star size={16} className="text-secondary-light fill-secondary-light" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      {/* Scroll indicator curve */}
      <div className="absolute bottom-[-1px] left-0 w-full h-[8vw] min-h-[60px] z-20 pointer-events-none" aria-hidden="true">
        <svg viewBox="0 0 1440 120" preserveAspectRatio="none" className="w-full h-full block">
          <path d="M0,0 C480,120 960,120 1440,0 L1440,120 L0,120 Z" fill="#064e3b" />
        </svg>
      </div>
    </section>
  );
}
