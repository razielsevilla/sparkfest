"use client";

import { useEffect, useRef } from "react";
import { Lock, Cpu, Database } from "lucide-react";

const securityFeatures = [
  {
    icon: <Lock size={32} strokeWidth={1.5} />,
    title: "Closed Network",
    description:
      "Gabay Sr. operates on a strict invite-only basis. No strangers can ever message or access your loved one's profile.",
    glow: "teal",
  },
  {
    icon: <Cpu size={32} strokeWidth={1.5} />,
    title: "Real-Time AI Shield",
    description:
      "Suspicious messages are scanned instantly by Gemini AI, flagging phishing attempts before any dangerous links are tapped.",
    glow: "amber",
  },
  {
    icon: <Database size={32} strokeWidth={1.5} />,
    title: "Secure Infrastructure",
    description:
      "Powered by Google Firebase with strict security rules, ensuring check-in logs and personal data are encrypted and safe.",
    glow: "blue",
  },
];

const colorGlows = {
  teal: {
    neonStart: "rgba(20,184,166,0.4)",
    neonEnd: "rgba(20,184,166,0.02)",
    styleClass: "text-teal-400 hover:shadow-[0_0_30px_rgba(20,184,166,0.15)]",
    glowClass: "from-teal-400/40 via-teal-400/2 to-teal-400/40",
  },
  amber: {
    neonStart: "rgba(245,158,11,0.4)",
    neonEnd: "rgba(245,158,11,0.02)",
    styleClass: "text-amber-400 hover:shadow-[0_0_30px_rgba(245,158,11,0.15)]",
    glowClass: "from-amber-400/40 via-amber-400/2 to-amber-400/40",
  },
  blue: {
    neonStart: "rgba(59,130,246,0.4)",
    neonEnd: "rgba(59,130,246,0.02)",
    styleClass: "text-blue-400 hover:shadow-[0_0_30px_rgba(59,130,246,0.15)]",
    glowClass: "from-blue-400/40 via-blue-400/2 to-blue-400/40",
  },
};

export default function Security() {
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
      { threshold: 0.1 }
    );

    const el = sectionRef.current;
    if (el) {
      el.querySelectorAll(".reveal").forEach((child) =>
        observer.observe(child)
      );
    }

    return () => observer.disconnect();
  }, []);

  return (
    <section
      id="security"
      className="py-24 sm:py-32 relative bg-gradient-to-br from-[#041E1C] via-[#0A1F2D] to-[#0F2B26] overflow-hidden w-screen left-1/2 right-1/2 -ml-[50vw] -mr-[50vw]"
      ref={sectionRef}
    >
      {/* Animated particles */}
      <div className="absolute inset-0 z-10 pointer-events-none" aria-hidden="true">
        {[...Array(6)].map((_, i) => (
          <div
            key={i}
            className="absolute bottom-[-10px] w-1 h-1 rounded-full bg-teal-400/50 animate-float-drift"
            style={{
              left: `${15 + i * 15}%`,
              animationDelay: `${i * 1.8}s`,
              animationDuration: `${8 + i * 2}s`,
            }}
          />
        ))}
      </div>

      {/* Grain texture overlay */}
      <div 
        className="absolute inset-[-50%] w-[300%] h-[300%] pointer-events-none opacity-[0.03] z-10" 
        style={{
          backgroundImage: `url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='1'/%3E%3C/svg%3E")`
        }}
        aria-hidden="true" 
      />

      {/* Central floating shield */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 z-10 opacity-60 animate-float-drift max-md:opacity-30" aria-hidden="true">
        <svg width="200" height="200" viewBox="0 0 200 200" fill="none" className="max-md:w-[140px] max-md:h-[140px]">
          <path
            d="M100 10 L180 50 L180 110 C180 155 145 185 100 195 C55 185 20 155 20 110 L20 50 Z"
            fill="none"
            stroke="rgba(20, 184, 166, 0.08)"
            strokeWidth="2"
          />
          <path
            d="M100 30 L160 60 L160 105 C160 140 135 165 100 175 C65 165 40 140 40 105 L40 60 Z"
            fill="none"
            stroke="rgba(20, 184, 166, 0.05)"
            strokeWidth="1.5"
          />
        </svg>
      </div>

      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 relative z-20">
        <div className="text-center mb-20 reveal">
          <span className="inline-flex items-center gap-2 text-xs font-semibold tracking-widest text-primary-light bg-primary-light/12 py-1.5 px-4 rounded-full mb-5 uppercase">
            Security & Privacy
          </span>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-white tracking-tight mb-4">
            Built for Absolute Peace of Mind
          </h2>
          <p className="text-base sm:text-lg text-white/60 max-w-[640px] mx-auto leading-relaxed">
            We treat your family&apos;s data with the highest level of care. 
            Gabay Sr. is engineered from the ground up to keep seniors safe.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-[1100px] mx-auto relative z-20">
          {securityFeatures.map((feature, i) => {
            const colors = colorGlows[feature.glow];
            return (
              <div
                key={i}
                className={`reveal group relative rounded-2xl p-[2px] overflow-hidden transition-all duration-400 hover:-translate-y-1.5 bg-transparent ${colors.styleClass}`}
                style={{ transitionDelay: `${i * 0.15}s` }}
              >
                {/* Glowing neon border */}
                <div className={`absolute inset-0 rounded-2xl bg-gradient-to-br ${colors.glowClass} opacity-50 transition-opacity duration-400 group-hover:opacity-100 z-0`} />

                <div className="relative z-10 bg-[#0f1f2d]/90 backdrop-blur-xl rounded-[14px] p-10 flex flex-col gap-4 h-full">
                  <div className="text-4xl filter drop-shadow-[0_0_12px_rgba(20,184,166,0.4)] transition-transform duration-400 ease-[cubic-bezier(0.34,1.56,0.64,1)] group-hover:scale-115 group-hover:-translate-y-0.5">
                    {feature.icon}
                  </div>
                  <h3 className="text-xl font-bold text-white/95 tracking-tight">{feature.title}</h3>
                  <p className="text-[0.95rem] text-white/55 leading-relaxed">{feature.description}</p>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
