"use client";

import Image from "next/image";
import { useEffect, useRef, useState } from "react";

const features = [
  {
    icon: "/images/trusted-circle.png",
    title: 'The "Trusted Circle" Mechanism',
    description:
      "A secure network connecting the senior with family, remote relatives, and local volunteers to monitor well-being seamlessly.",
    accent: "teal",
    size: "large",
    badge: "Real-time Connectivity",
  },
  {
    icon: "/images/daily-checkin.png",
    title: "Accessible Daily Check-Ins",
    description:
      "A highly simplified, icon-driven interface designed specifically for elderly users to log their mood and daily activities without frustration.",
    accent: "amber",
    size: "tall",
    badge: "Senior-Friendly UI",
  },
  {
    icon: "/images/scam-shield.png",
    title: "AI-Powered Scam Protection",
    description:
      "A built-in message checker that analyzes suspicious texts for common Philippine scam patterns, delivering an easy-to-understand risk verdict.",
    accent: "red",
    size: "tall",
    badge: "Powered by AI",
  },
  {
    icon: "/images/alerts-summary.png",
    title: "Automated Alerts & Summaries",
    description:
      "AI-generated weekly companionship summaries in a warm tone, plus immediate push notifications for high-risk scams or missed check-ins.",
    accent: "primary",
    size: "large",
    badge: "Automated Insights",
  },
];

const accentStyles = {
  teal: {
    accentColor: "text-teal-600",
    glowColor: "rgba(13, 148, 136, 0.25)",
    cardShadow: "shadow-[0_25px_60px_rgba(13,148,136,0.15)]",
    borderColor: "hover:border-teal-500/30",
  },
  amber: {
    accentColor: "text-amber-600",
    glowColor: "rgba(245, 158, 11, 0.25)",
    cardShadow: "shadow-[0_25px_60px_rgba(245,158,11,0.15)]",
    borderColor: "hover:border-amber-500/30",
  },
  red: {
    accentColor: "text-red-500",
    glowColor: "rgba(239, 68, 68, 0.2)",
    cardShadow: "shadow-[0_25px_60px_rgba(239,68,68,0.12)]",
    borderColor: "hover:border-red-500/30",
  },
  primary: {
    accentColor: "text-primary",
    glowColor: "rgba(15, 118, 110, 0.25)",
    cardShadow: "shadow-[0_25px_60px_rgba(15,118,110,0.15)]",
    borderColor: "hover:border-primary/30",
  },
};

const FeatureCard = ({ feature, index }) => {
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
    
    const rotateX = ((y - centerY) / centerY) * -4;
    const rotateY = ((x - centerX) / centerX) * 4;

    setCardTransform(`perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.02, 1.02, 1.02)`);
  };

  const handleMouseEnter = () => setIsHovering(true);
  
  const handleMouseLeave = () => {
    setIsHovering(false);
    setCardTransform("perspective(1200px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)");
  };

  const styles = accentStyles[feature.accent];

  return (
    <article
      ref={cardRef}
      className={`reveal relative bg-white/40 backdrop-blur-2xl border border-white/80 rounded-3xl p-8 sm:p-12 overflow-hidden transition-all duration-300 hover:bg-white/60 cursor-default shadow-[0_10px_30px_rgba(0,0,0,0.03),inset_0_0_0_1px_rgba(255,255,255,0.5)] hover:${styles.cardShadow} hover:z-10 ${styles.borderColor} max-md:transform-none!`}
      style={{ 
        transitionDelay: `${index * 0.15}s`,
        transform: cardTransform,
      }}
      onMouseMove={handleMouseMove}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      {/* Glow */}
      <div 
        className="absolute inset-0 pointer-events-none z-10 transition-opacity duration-400 mix-blend-multiply" 
        style={{ 
          opacity: isHovering ? 1 : 0,
          background: `radial-gradient(800px circle at ${mousePosition.x}px ${mousePosition.y}px, ${styles.glowColor}, transparent 40%)`
        }}
        aria-hidden="true" 
      />

      <div className={`relative z-20 flex gap-8 items-start h-full max-md:flex-col! max-md:gap-6! ${feature.size === "large" ? "lg:items-center" : "lg:flex-col lg:justify-center lg:gap-6"}`}>
        {feature.badge && (
          <span className={`absolute top-6 right-6 bg-white/80 border border-black/5 py-1 px-3 rounded-full text-xs font-semibold ${styles.accentColor} shadow-sm backdrop-blur-md z-30 max-md:relative! max-md:top-0! max-md:right-0! max-md:self-start! max-md:-mb-2!`}>
            {feature.badge}
          </span>
        )}
        <div className="w-16 h-16 rounded-[1.25rem] overflow-hidden shrink-0 bg-white p-2.5 shadow-[0_8px_24px_rgba(0,0,0,0.06)] border border-black/4 transition-transform duration-500 ease-[cubic-bezier(0.34,1.56,0.64,1)] group-hover:scale-110 group-hover:-rotate-5">
          <Image
            src={feature.icon}
            alt={feature.title}
            width={64}
            height={64}
            className="w-full h-full object-contain"
          />
        </div>
        <div className="flex-1">
          <h3 className={`font-bold leading-tight mb-3 text-text-primary tracking-tight transition-colors duration-300 ${feature.size === "large" ? "text-xl sm:text-2xl" : "text-[1.35rem]"}`}>
            {feature.title}
          </h3>
          <p className="text-base text-text-secondary leading-relaxed">{feature.description}</p>
        </div>
      </div>

      <div 
        className="absolute inset-0 pointer-events-none opacity-30 z-0 transition-opacity duration-500 hover:opacity-60" 
        style={{
          backgroundImage: `radial-gradient(circle at 1px 1px, ${styles.glowColor.replace('0.25', '0.05').replace('0.2', '0.05')} 1px, transparent 0)`,
          backgroundSize: "32px 32px"
        }}
        aria-hidden="true" 
      />
    </article>
  );
};

export default function Features() {
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
    <section id="features" className="py-24 sm:py-32 px-4 sm:px-6 lg:px-8 relative overflow-hidden" ref={sectionRef}>
      <div className="max-w-[1200px] mx-auto">
        <div className="text-center mb-20 reveal">
          <span className="inline-flex items-center gap-2 text-xs font-semibold tracking-widest text-primary bg-primary/8 py-1.5 px-4 rounded-full mb-5 uppercase">
            Key Features
          </span>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-text-primary tracking-tight mb-4">
            Everything Lola &amp; Lolo Need in One App
          </h2>
          <p className="text-base sm:text-lg text-text-secondary max-w-[640px] mx-auto leading-relaxed">
            Four powerful features working together to keep Filipino seniors
            connected, protected, and cared for — all through one simple
            interface.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-[1100px] mx-auto">
          {features.map((feature, i) => (
            <FeatureCard key={i} feature={feature} index={i} />
          ))}
        </div>
      </div>
    </section>
  );
}
