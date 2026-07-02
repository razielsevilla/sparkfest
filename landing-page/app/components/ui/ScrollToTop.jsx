"use client";

import { useState, useEffect } from "react";

export default function ScrollToTop() {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    const toggleVisibility = () => {
      if (window.scrollY > 400) {
        setVisible(true);
      } else {
        setVisible(false);
      }
    };

    window.addEventListener("scroll", toggleVisibility);
    return () => window.removeEventListener("scroll", toggleVisibility);
  }, []);

  const scrollToTop = () => {
    window.scrollTo({
      top: 0,
      behavior: "smooth",
    });
  };

  return (
    <button
      className={`fixed bottom-8 right-8 z-50 bg-white/45 backdrop-blur-md text-primary border border-primary/12 w-12.5 h-12.5 rounded-full cursor-pointer flex items-center justify-center shadow-[0_4px_16px_rgba(15,118,110,0.10)] transition-all duration-350 ease-[cubic-bezier(0.34,1.56,0.64,1)] ${
        visible
          ? "opacity-100 translate-y-0 scale-100 pointer-events-auto"
          : "opacity-0 translate-y-5 scale-80 pointer-events-none"
      } hover:bg-primary hover:text-white hover:-translate-y-1 hover:scale-105 hover:shadow-[0_8px_24px_rgba(15,118,110,0.25)] hover:border-primary`}
      onClick={scrollToTop}
      aria-label="Scroll back to top"
    >
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
        <path d="m18 15-6-6-6 6"/>
      </svg>
    </button>
  );
}
