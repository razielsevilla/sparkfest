"use client";

import { useEffect, useRef, useState } from "react";
import { Users, HeartHandshake, ShieldCheck, BellRing } from "lucide-react";

const steps = [
  {
    number: "1",
    emoji: <Users size={32} strokeWidth={1.5} />,
    title: "Create a Trusted Circle",
    description:
      "A family member signs up and adds Lola's profile, then invites relatives, OFWs, and barangay volunteers.",
  },
  {
    number: "2",
    emoji: <HeartHandshake size={32} strokeWidth={1.5} />,
    title: "Daily Check-In",
    description:
      "Lola taps one big button, picks her mood emoji, and optionally records a voice note — done in under 30 seconds.",
  },
  {
    number: "3",
    emoji: <ShieldCheck size={32} strokeWidth={1.5} />,
    title: "AI Watches Over",
    description:
      "Gemini AI scans suspicious messages for scam patterns and generates warm weekly companionship summaries.",
  },
  {
    number: "4",
    emoji: <BellRing size={32} strokeWidth={1.5} />,
    title: "Circle Gets Notified",
    description:
      "Instant push alerts for scam threats or missed check-ins, plus weekly summaries so family always stays connected.",
  },
];

const StepCard = ({ step, index }) => {
  const cardRef = useRef(null);
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });
  const [cardTransform, setCardTransform] = useState("perspective(1200px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)");
  const [isHovering, setIsHovering] = useState(false);

  const handleMouseMove = (e) => {
    if (!cardRef.current) return;
    const rect = cardRef.current.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    setMousePosition({ x, y });

    const centerX = rect.width / 2;
    const centerY = rect.height / 2;
    
    const rotateX = ((y - centerY) / centerY) * -3;
    const rotateY = ((x - centerX) / centerX) * 3;

    setCardTransform(`perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.01, 1.01, 1.01)`);
  };

  const handleMouseEnter = () => setIsHovering(true);
  
  const handleMouseLeave = () => {
    setIsHovering(false);
    setCardTransform("perspective(1200px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)");
  };

  return (
    <article
      ref={cardRef}
      className="reveal group sticky bg-white/95 backdrop-blur-2xl border border-white/80 rounded-3xl p-8 sm:p-14 overflow-hidden transition-all duration-300 hover:bg-white/65 cursor-default shadow-[0_10px_40px_rgba(15,118,110,0.05),inset_0_0_0_1px_rgba(255,255,255,0.6)] hover:border-primary/30 hover:shadow-[0_25px_60px_rgba(15,118,110,0.1),inset_0_0_0_1px_rgba(255,255,255,0.8)] will-change-transform max-md:transform-none!"
      style={{
        top: `calc(120px + ${index * 30}px)`,
        zIndex: index + 1,
        transform: cardTransform,
      }}
      onMouseMove={handleMouseMove}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      {/* Mouse Glow */}
      <div 
        className="absolute inset-0 pointer-events-none z-10 transition-opacity duration-400 mix-blend-multiply" 
        style={{ 
          opacity: isHovering ? 1 : 0,
          background: `radial-gradient(800px circle at ${mousePosition.x}px ${mousePosition.y}px, rgba(20, 184, 166, 0.15), transparent 40%)`
        }}
        aria-hidden="true" 
      />

      {/* Giant outline number in the background */}
      <div 
        className="absolute -right-5 top-1/2 -translate-y-1/2 text-[18rem] max-md:text-[12rem] max-md:-right-10 font-black text-transparent pointer-events-none select-none z-0 line-height-1 transition-all duration-500 [font-family:var(--font-primary),sans-serif] [-webkit-text-stroke:2px_rgba(15,118,110,0.06)] group-hover:[-webkit-text-stroke:2px_rgba(15,118,110,0.12)] group-hover:-translate-y-1/2 group-hover:scale-105" 
        aria-hidden="true"
      >
        {step.number}
      </div>

      <div className="relative z-20 flex gap-10 items-center max-md:flex-col! max-md:items-start! max-md:gap-6!">
        <div className="w-20 h-20 max-md:w-16 max-md:h-16 rounded-[1.25rem] bg-gradient-to-br from-white/90 to-white/50 shadow-[0_8px_24px_rgba(15,118,110,0.08),inset_0_0_0_1px_rgba(255,255,255,0.8)] flex items-center justify-center shrink-0 transition-transform duration-500 ease-[cubic-bezier(0.34,1.56,0.64,1)] group-hover:scale-110 group-hover:-rotate-5">
          <span className="text-[2.5rem] max-md:text-[2rem] text-primary select-none filter drop-shadow-[0_4px_6px_rgba(0,0,0,0.1)]">{step.emoji}</span>
        </div>
        <div className="flex-1">
          <h3 className="text-2xl max-md:text-[1.35rem] font-extrabold text-text-primary tracking-tight mb-3">
            <span className="inline-block text-xs font-bold uppercase tracking-widest text-primary bg-primary-light/12 py-1 px-3.5 rounded-full mr-3.5 align-middle max-md:block max-md:w-max max-md:mb-2">
              Step {step.number}
            </span>
            {step.title}
          </h3>
          <p className="text-lg max-md:text-base text-text-secondary leading-relaxed max-w-[500px]">
            {step.description}
          </p>
        </div>
      </div>

      <div 
        className="absolute inset-0 pointer-events-none opacity-30 z-0 transition-opacity duration-500 group-hover:opacity-60" 
        style={{
          backgroundImage: "radial-gradient(circle at 1px 1px, rgba(15, 118, 110, 0.04) 1px, transparent 0)",
          backgroundSize: "32px 32px"
        }}
        aria-hidden="true" 
      />
    </article>
  );
};

export default function HowItWorks() {
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
      { threshold: 0.1, rootMargin: "0px 0px -50px 0px" }
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
    <section id="how-it-works" className="py-24 sm:py-32 px-4 sm:px-6 lg:px-8 relative overflow-visible" ref={sectionRef}>
      <div className="max-w-[1200px] mx-auto">
        <div className="text-center mb-20 reveal">
          <span className="inline-flex items-center gap-2 text-xs font-semibold tracking-widest text-primary bg-primary/8 py-1.5 px-4 rounded-full mb-5 uppercase">
            How It Works
          </span>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-text-primary tracking-tight mb-4">
            Simple for Seniors, Powerful for Family
          </h2>
          <p className="text-base sm:text-lg text-text-secondary max-w-[640px] mx-auto leading-relaxed">
            From setup to daily protection — Gabay Sr. is designed so even
            non-tech-savvy seniors can use it with confidence.
          </p>
        </div>

        <div className="relative max-w-[850px] mx-auto flex flex-col gap-8 pb-16">
          {steps.map((step, i) => (
            <StepCard key={i} step={step} index={i} />
          ))}
        </div>
      </div>
    </section>
  );
}
