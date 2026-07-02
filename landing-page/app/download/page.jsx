"use client";

import Image from "next/image";
import Navbar from "../components/layout/Navbar";

export default function DownloadPage() {
  return (
    <>
      <Navbar />
      <main className="min-h-screen bg-bg-warm text-text-primary pt-[80px] relative overflow-hidden flex flex-col justify-center before:absolute before:inset-0 before:pointer-events-none before:z-0 before:bg-[linear-gradient(rgba(15,118,110,0.08)_1px,transparent_1px),linear-gradient(90deg,rgba(15,118,110,0.08)_1px,transparent_1px)] before:bg-[size:50px_50px] after:absolute after:top-[-30%] after:left-[-20%] after:w-[80%] after:h-[80%] after:bg-[radial-gradient(circle,rgba(20,184,166,0.08)_0%,transparent_60%)] after:pointer-events-none after:z-0">
        <div className="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8 w-full">

          <div className="grid grid-cols-1 md:grid-cols-[1fr_1.15fr] gap-12 items-center pb-16 relative z-10">
            
            {/* Left Side: Text and Download Action */}
            <div className="flex flex-col gap-6 relative z-10 max-md:items-center max-md:text-center">
              <h1 className="text-primary-dark text-5xl sm:text-7xl lg:text-[4.8rem] font-black leading-none mb-4 drop-shadow-[0_4px_15px_rgba(15,118,110,0.15)]">
                Gabay Sr. App
              </h1>
              <p className="text-2xl text-text-primary font-semibold">
                Download Gabay Sr. Latest Version Free.
              </p>
              <p className="text-text-secondary text-[1.25rem] max-w-[550px] leading-relaxed">
                Companionship, Scam Protection, AI Summaries, and Trusted Circle. Keep your elderly loved ones safe and connected.
              </p>
              
              <button className="inline-flex items-center gap-4 bg-gradient-to-r from-primary to-primary-light text-white py-4.5 px-10 rounded-full font-extrabold text-[1.3rem] cursor-pointer hover:translate-y-[-4px] hover:scale-105 hover:shadow-[0_12px_35px_rgba(15,118,110,0.4)] shadow-[0_8px_25px_rgba(15,118,110,0.3)] transition-all duration-350 uppercase tracking-widest w-fit">
                Download Now
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                  <polyline points="7 10 12 15 17 10"/>
                  <line x1="12" y1="15" x2="12" y2="3"/>
                </svg>
              </button>
            </div>

            {/* Right Side: Media Frame */}
            <div className="relative flex justify-center z-10">
              <div className="border-4 border-primary rounded-3xl overflow-hidden shadow-[0_20px_40px_rgba(15,118,110,0.15),0_0_40px_rgba(15,118,110,0.1)] relative aspect-video w-full max-w-[1000px] bg-white lg:[transform:perspective(1200px)_rotateY(-8deg)_rotateX(4deg)] lg:hover:[transform:perspective(1200px)_rotateY(0deg)_rotateX(0deg)_scale(1.02)] transition-transform duration-350 ease-in-out">
                {/* Reusing hero image as the featured image for the download page */}
                <Image 
                  src="/images/hero.png" 
                  alt="Gabay Sr. App Preview" 
                  width={600} 
                  height={338} 
                  className="object-cover w-full h-full"
                  priority
                />
              </div>
            </div>

          </div>
        </div>

        {/* Decorative bottom curve matching Gabay Sr. theme */}
        <div className="absolute bottom-0 left-0 w-full pointer-events-none opacity-50 z-0" aria-hidden="true">
          <svg viewBox="0 0 1440 120" preserveAspectRatio="none" className="w-full h-auto">
            <path d="M0,0 C480,120 960,120 1440,0 L1440,120 L0,120 Z" fill="#0F766E" />
          </svg>
        </div>
      </main>
    </>
  );
}
