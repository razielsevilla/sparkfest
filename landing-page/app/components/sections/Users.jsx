"use client";

import { useEffect, useRef } from "react";
import { Heart, Globe, Building } from "lucide-react";

const personas = [
  {
    id: "senior",
    emoji: <Heart size={44} strokeWidth={1.5} />,
    name: "Lola Luz & Lolo Pepe",
    role: "Senior Citizen",
    quote:
      '"Hindi ko na kailangang mangamba sa mga text na scam, may tagapagbantay na ako."',
    bullets: [
      "Simplified 1-click check-in interface",
      "AI message scanning & scam verdict",
      "Accessible voice-note diary capture",
    ],
    accent: "teal",
  },
  {
    id: "ofw",
    emoji: <Globe size={44} strokeWidth={1.5} />,
    name: "OFW Relative & Family",
    role: "Trusted Circle Member",
    quote:
      '"Kahit malayo ako sa ibang bansa, alam kong ligtas at maayos ang kalagayan ni Nanay."',
    bullets: [
      "Weekly AI conversational summaries",
      "Instant push alerts for scam targets",
      "Firestore daily check-in logs history",
    ],
    accent: "amber",
  },
  {
    id: "local",
    emoji: <Building size={44} strokeWidth={1.5} />,
    name: "Barangay & OSCA Staff",
    role: "Local Support Network",
    quote:
      '"Mas madali nang tugunan ang pangangailangan ng mga nakatatanda sa aming komunidad."',
    bullets: [
      "Centralized senior welfare dashboards",
      "Automatic triggers for missed checks",
      "Barangay-level safety networks",
    ],
    accent: "primary",
  },
];

const accentColors = {
  teal: {
    accentColor: "text-teal-600",
    orbGradient: "from-teal-600 to-teal-400",
    orbShadow: "shadow-[0_8px_30px_rgba(13,148,136,0.3)]",
    tagBg: "bg-teal-600/8 text-teal-600",
    borderGlow: "border-teal-500/10",
  },
  amber: {
    accentColor: "text-amber-600",
    orbGradient: "from-amber-600 to-amber-400",
    orbShadow: "shadow-[0_8px_30px_rgba(245,158,11,0.3)]",
    tagBg: "bg-amber-600/8 text-amber-600",
    borderGlow: "border-amber-500/10",
  },
  primary: {
    accentColor: "text-primary",
    orbGradient: "from-primary to-primary-light",
    orbShadow: "shadow-[0_8px_30px_rgba(15,118,110,0.3)]",
    tagBg: "bg-primary/8 text-primary",
    borderGlow: "border-primary/10",
  },
};

export default function Users() {
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
      { threshold: 0.15 }
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
    <section id="who-its-for" className="py-20 sm:py-32 px-4 sm:px-6 lg:px-8 relative overflow-hidden" ref={sectionRef}>
      <div className="max-w-[1200px] mx-auto">
        <div className="text-center mb-20 reveal">
          <span className="inline-flex items-center gap-2 text-xs font-semibold tracking-widest text-primary bg-primary/8 py-1.5 px-4 rounded-full mb-5 uppercase">
            Who It&apos;s For
          </span>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-text-primary tracking-tight mb-4">
            Designed for Every Filipino Family
          </h2>
          <p className="text-base sm:text-lg text-text-secondary max-w-[640px] mx-auto leading-relaxed">
            Whether you&apos;re a senior, an overseas worker, or a local
            volunteer — Gabay Sr. connects you all in one Trusted Circle.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 items-stretch reveal">
          
          {personas.map((persona, i) => {
            const colors = accentColors[persona.accent];
            return (
              <div
                key={persona.id}
                className="group flex flex-col items-center gap-6 w-full text-center hover:-translate-y-2 transition-transform duration-400 ease-[cubic-bezier(0.34,1.56,0.64,1)]"
                style={{ transitionDelay: `${i * 0.1}s` }}
              >
                {/* Glowing Orb */}
                <div className="relative w-[150px] h-[150px] flex items-center justify-center">
                  <div className="absolute inset-0 rounded-full border-2 border-primary/20 opacity-30 animate-pulse-ring" />
                  <div className="absolute -inset-2.5 rounded-full border-[1.5px] border-primary/10 opacity-15 animate-pulse-ring [animation-delay:1.5s]" />
                  <div className={`w-[100px] h-[100px] rounded-full bg-gradient-to-br ${colors.orbGradient} flex items-center justify-center ${colors.orbShadow} relative z-10 transition-transform duration-500 ease-[cubic-bezier(0.34,1.56,0.64,1)] group-hover:scale-115 text-white`}>
                    {persona.emoji}
                  </div>
                </div>

                {/* Persona Content Card */}
                <div className="flex flex-col gap-3.5 items-center w-full bg-white/60 backdrop-blur-md p-6 rounded-3xl border border-white/80 shadow-[0_10px_30px_rgba(0,0,0,0.03)] flex-1">
                  <div className={`inline-flex text-[0.7rem] font-bold uppercase tracking-wider py-1.5 px-3.5 rounded-full ${colors.tagBg}`}>
                    {persona.role}
                  </div>
                  <h3 className="text-2xl font-extrabold text-text-primary tracking-tight leading-tight">
                    {persona.name}
                  </h3>
                  <blockquote className="text-[0.95rem] italic text-text-secondary leading-relaxed my-2">
                    {persona.quote}
                  </blockquote>
                  <div className="flex flex-col gap-2 w-full">
                    {persona.bullets.map((bullet, idx) => (
                      <span
                        key={idx}
                        className="inline-flex items-center gap-2 text-[0.82rem] font-semibold text-text-primary bg-white border border-primary/12 py-1.5 px-4 rounded-full transition-all duration-300 hover:bg-primary/8 hover:border-primary hover:-translate-y-0.5 w-full justify-start"
                      >
                        <span className="w-1.5 h-1.5 rounded-full bg-primary shrink-0" />
                        {bullet}
                      </span>
                    ))}
                  </div>
                </div>
              </div>
            );
          })}
          
        </div>
      </div>
    </section>
  );
}
