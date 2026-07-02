"use client";

import { useEffect, useRef, useState } from "react";
import { Smartphone, Flame, Sparkles, CloudCog, Palette } from "lucide-react";

const technologies = [
  {
    logo: <Smartphone size={32} strokeWidth={1.5} />,
    name: "Flutter",
    tag: "Frontend Framework",
    description:
      'Powers a unified, responsive, single-codebase frontend divided into "Senior Mode" and "Family/Volunteer Mode."',
    accent: "blue",
  },
  {
    logo: <Flame size={32} strokeWidth={1.5} />,
    name: "Firebase",
    tag: "Backend & Notifications",
    description:
      "Serverless backend infrastructure — Firestore, Authentication, Cloud Functions, and Firebase Cloud Messaging for real-time push alerts.",
    accent: "amber",
  },
  {
    logo: <Sparkles size={32} strokeWidth={1.5} />,
    name: "Gemini API",
    tag: "AI & Safety Engine",
    description:
      "Drives natural language features including scam message analysis and warm, conversational weekly companionship summaries.",
    accent: "purple",
  },
  {
    logo: <CloudCog size={32} strokeWidth={1.5} />,
    name: "Cloud Functions",
    tag: "Serverless Compute",
    description:
      "Automates check-in reminders, triggers scam alerts, and orchestrates weekly AI summaries without maintaining servers.",
    accent: "amber",
  },
  {
    logo: <Palette size={32} strokeWidth={1.5} />,
    name: "Material Design",
    tag: "Accessible UI",
    description:
      "Provides high-contrast, large-touch-target components essential for the senior-friendly interface.",
    accent: "blue",
  }
];

const accentColors = {
  blue: {
    color: "#3b82f6",
    shadowTint: "rgba(59, 130, 246, 0.15)",
    borderClass: "hover:border-blue-500",
  },
  amber: {
    color: "#d97706",
    shadowTint: "rgba(245, 158, 11, 0.15)",
    borderClass: "hover:border-amber-600",
  },
  purple: {
    color: "#7c3aed",
    shadowTint: "rgba(139, 92, 246, 0.15)",
    borderClass: "hover:border-purple-600",
  },
};

export default function TechStack() {
  const sectionRef = useRef(null);
  const [hoveredIndex, setHoveredIndex] = useState(null);

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

  // Double the array for seamless infinite scrolling
  const marqueeItemsRow1 = [...technologies, ...technologies];
  const marqueeItemsRow2 = [...technologies.slice(2), ...technologies.slice(0, 2)];
  const marqueeItemsRow2Double = [...marqueeItemsRow2, ...marqueeItemsRow2];

  return (
    <section id="tech-stack" className="py-20 sm:py-32 relative overflow-hidden" ref={sectionRef}>
      {/* Background patterns */}
      <div 
        className="absolute inset-0 pointer-events-none z-0 opacity-40" 
        style={{
          backgroundImage: "repeating-linear-gradient(45deg, rgba(15,118,110,0.02), rgba(15,118,110,0.02) 20px, transparent 20px, transparent 40px)",
        }}
        aria-hidden="true" 
      />
      
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="text-center mb-16 reveal">
          <span className="inline-flex items-center gap-2 text-xs font-semibold tracking-widest text-primary bg-primary/8 py-1.5 px-4 rounded-full mb-5 uppercase">
            Google Technologies
          </span>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-text-primary tracking-tight mb-4">
            Built on a Modern Google Stack
          </h2>
          <p className="text-base sm:text-lg text-text-secondary max-w-[640px] mx-auto leading-relaxed">
            Leveraging best-in-class Google technologies for reliability,
            real-time updates, and advanced AI capabilities.
          </p>
        </div>
      </div>

      {/* Marquee container with fade edges */}
      <div className="reveal relative flex flex-col gap-8 mb-20 w-full before:absolute before:top-0 before:bottom-0 before:left-0 before:w-[15%] before:z-10 before:bg-gradient-to-r before:from-bg-warm before:to-transparent before:pointer-events-none after:absolute after:top-0 after:bottom-0 after:right-0 after:w-[15%] after:z-10 after:bg-gradient-to-l after:from-bg-warm after:to-transparent after:pointer-events-none max-md:before:w-[5%] max-md:after:w-[5%]">
        
        {/* Row 1 - Left scrolling */}
        <div className="w-full overflow-hidden flex">
          <div className={`flex flex-nowrap items-center gap-8 pl-8 w-max will-change-transform animate-marquee-left ${hoveredIndex !== null ? "[animation-play-state:paused]" : ""}`}>
            {marqueeItemsRow1.map((tech, i) => {
              const isExpanded = hoveredIndex === `r1-${i % technologies.length}`;
              const colors = accentColors[tech.accent];
              return (
                <div
                  key={`r1-${i}`}
                  className={`flex flex-col bg-white/70 backdrop-blur-md border border-primary/10 rounded-[100px] p-4 w-[320px] cursor-pointer transition-all duration-400 ease-[cubic-bezier(0.34,1.56,0.64,1)] shadow-[0_4px_15px_rgba(0,0,0,0.02)] overflow-hidden ${
                    isExpanded 
                      ? `rounded-[24px]! bg-white! scale-102 z-20 border-[var(--accent-color)]` 
                      : ""
                  }`}
                  style={{
                    "--accent-color": colors.color,
                    boxShadow: isExpanded ? `0 15px 40px ${colors.shadowTint}` : undefined,
                  }}
                  onMouseEnter={() => setHoveredIndex(`r1-${i % technologies.length}`)}
                  onMouseLeave={() => setHoveredIndex(null)}
                >
                  <div className="flex items-center gap-4">
                    <span className="text-[2rem] leading-none flex items-center justify-center w-[50px] h-[50px] bg-white rounded-full shadow-[0_4px_10px_rgba(0,0,0,0.06)] shrink-0">
                      {tech.logo}
                    </span>
                    <div className="flex flex-col justify-center">
                      <span className="text-[0.65rem] font-bold uppercase tracking-wider mb-0.5" style={{ color: colors.color }}>
                        {tech.tag}
                      </span>
                      <h3 className="text-[1.1rem] font-extrabold text-text-primary leading-tight">
                        {tech.name}
                      </h3>
                    </div>
                  </div>
                  <div className={`transition-all duration-400 ease-[cubic-bezier(0.34,1.56,0.64,1)] ${isExpanded ? "max-h-[150px] opacity-100 mt-4 pt-4 border-t border-dashed border-black/8" : "max-h-0 opacity-0"}`}>
                    <p className="text-[0.85rem] text-text-secondary leading-relaxed">{tech.description}</p>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Row 2 - Right scrolling */}
        <div className="w-full overflow-hidden flex">
          <div className={`flex flex-nowrap items-center gap-8 pl-8 w-max will-change-transform animate-marquee-right ${hoveredIndex !== null ? "[animation-play-state:paused]" : ""}`}>
            {marqueeItemsRow2Double.map((tech, i) => {
              const isExpanded = hoveredIndex === `r2-${i % technologies.length}`;
              const colors = accentColors[tech.accent];
              return (
                <div
                  key={`r2-${i}`}
                  className={`flex flex-col bg-white/70 backdrop-blur-md border border-primary/10 rounded-[100px] p-4 w-[320px] cursor-pointer transition-all duration-400 ease-[cubic-bezier(0.34,1.56,0.64,1)] shadow-[0_4px_15px_rgba(0,0,0,0.02)] overflow-hidden ${
                    isExpanded 
                      ? `rounded-[24px]! bg-white! scale-102 z-20 border-[var(--accent-color)]` 
                      : ""
                  }`}
                  style={{
                    "--accent-color": colors.color,
                    boxShadow: isExpanded ? `0 15px 40px ${colors.shadowTint}` : undefined,
                  }}
                  onMouseEnter={() => setHoveredIndex(`r2-${i % technologies.length}`)}
                  onMouseLeave={() => setHoveredIndex(null)}
                >
                  <div className="flex items-center gap-4">
                    <span className="text-[2rem] leading-none flex items-center justify-center w-[50px] h-[50px] bg-white rounded-full shadow-[0_4px_10px_rgba(0,0,0,0.06)] shrink-0">
                      {tech.logo}
                    </span>
                    <div className="flex flex-col justify-center">
                      <span className="text-[0.65rem] font-bold uppercase tracking-wider mb-0.5" style={{ color: colors.color }}>
                        {tech.tag}
                      </span>
                      <h3 className="text-[1.1rem] font-extrabold text-text-primary leading-tight">
                        {tech.name}
                      </h3>
                    </div>
                  </div>
                  <div className={`transition-all duration-400 ease-[cubic-bezier(0.34,1.56,0.64,1)] ${isExpanded ? "max-h-[150px] opacity-100 mt-4 pt-4 border-t border-dashed border-black/8" : "max-h-0 opacity-0"}`}>
                    <p className="text-[0.85rem] text-text-secondary leading-relaxed">{tech.description}</p>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </section>
  );
}
