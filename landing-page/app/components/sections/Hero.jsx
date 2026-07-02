"use client";

import { useState } from "react";
import Link from "next/link";
import {
  Signal,
  BatteryFull,
  Smile,
  Meh,
  Frown,
  CheckCircle2,
  Settings,
  User,
  Shield,
  Search,
  Lightbulb,
  ArrowLeft,
} from "lucide-react";

export default function Hero() {
  // Interactive Demo State
  const [demoMode, setDemoMode] = useState("home"); // "home" | "checkin" | "scam"

  // Checkin Flow State
  const [checkinStep, setCheckinStep] = useState("mood"); // "mood" | "success"
  const [selectedMood, setSelectedMood] = useState("");

  // Scam Checker State
  const [scamInput, setScamInput] = useState("");
  const [scamStatus, setScamStatus] = useState("idle"); // "idle" | "checking" | "result"
  const [scamResult, setScamResult] = useState(null);

  const startCheckin = () => {
    setCheckinStep("mood");
    setDemoMode("checkin");
  };

  const selectMood = (mood) => {
    setSelectedMood(mood);
    setCheckinStep("success");
    setTimeout(() => {
      setDemoMode("home");
      setCheckinStep("mood");
      setSelectedMood("");
    }, 3000);
  };

  const handleScamCheck = () => {
    if (!scamInput.trim()) return;
    setScamStatus("checking");
    setTimeout(() => {
      const isScam =
        scamInput.toLowerCase().includes("panalo") ||
        scamInput.toLowerCase().includes("win") ||
        scamInput.toLowerCase().includes("link") ||
        scamInput.toLowerCase().includes("click") ||
        scamInput.toLowerCase().includes("gcash") ||
        scamInput.toLowerCase().includes("otp");

      if (isScam) {
        setScamResult({
          level: "Mataas (High Risk)",
          color: "red",
          reason: "Naglalaman ng kahina-hinalang alok ng pera at humihingi ng agarang aksyon o pag-click sa link. Karaniwang scam pattern sa Pilipinas.",
          action: "HUWAG i-click ang link. I-block ang sender.",
        });
      } else {
        setScamResult({
          level: "Mababa (Low Risk)",
          color: "green",
          reason: "Normal na mensahe. Mukhang hindi ito naglalaman ng mga tipikal na scam keywords o kahina-hinalang link.",
          action: "Ligtas basahin, ngunit mag-ingat pa rin palagi.",
        });
      }
      setScamStatus("result");
    }, 1800);
  };

  return (
    <section id="hero" className="min-h-screen flex items-center px-4 sm:px-6 lg:px-8 pt-28 pb-16 relative">
      <div className="max-w-[1200px] mx-auto grid grid-cols-1 lg:grid-cols-[1.1fr_0.9fr] gap-16 items-center w-full">
        
        {/* Left Side: Copywriting */}
        <div className="relative z-10">
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight leading-[1.08] text-text-primary mb-6">
            Keeping Filipino Seniors <span className="bg-gradient-to-r from-primary to-primary-light bg-clip-text text-transparent">Safe</span> &amp; <span className="bg-gradient-to-r from-secondary to-amber-600 bg-clip-text text-transparent">Connected</span>
          </h1>

          <p className="text-lg sm:text-xl text-text-secondary max-w-[520px] leading-relaxed mb-10">
            Gabay Sr. connects elderly Filipinos with a Trusted Circle of
            family, OFWs, and barangay volunteers — through simplified daily
            check-ins and AI-powered scam detection.
          </p>

          <div className="flex items-center gap-4 flex-wrap">
            <Link
              href="/#cta"
              className="inline-flex items-center gap-2 font-primary font-semibold text-lg text-white py-3.5 px-8 rounded-full bg-gradient-to-r from-primary to-primary-light shadow-[0_6px_24px_rgba(15,118,110,0.35)] hover:translate-y-[-3px] hover:scale-103 hover:shadow-[0_10px_36px_rgba(15,118,110,0.45)] transition-all duration-350"
            >
              Protect Your Family
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                <path d="M5 12h14" />
                <path d="m12 5 7 7-7 7" />
              </svg>
            </Link>
          </div>

          {/* Stats section */}
          <div className="flex gap-10 mt-14">
            <div>
              <div className="text-4xl font-extrabold text-primary leading-tight">4.5M+</div>
              <div className="text-[0.82rem] text-text-secondary font-medium mt-1">Filipino seniors aged 65+</div>
            </div>
            <div>
              <div className="text-4xl font-extrabold text-primary leading-tight">68%</div>
              <div className="text-[0.82rem] text-text-secondary font-medium mt-1">Experience isolation</div>
            </div>
            <div>
              <div className="text-4xl font-extrabold text-primary leading-tight">₱5.8B</div>
              <div className="text-[0.82rem] text-text-secondary font-medium mt-1">Lost to scams yearly</div>
            </div>
          </div>
        </div>

        {/* Right Side: Interactive Phone Mockup */}
        <div className="flex flex-col items-center gap-6 w-full">
          <div className="w-full max-w-[450px] flex justify-center items-center">
            
            {/* Phone simulator */}
            <div className="w-full max-w-[380px] bg-slate-800 rounded-[42px] p-3 shadow-[0_25px_60px_-15px_rgba(15,118,110,0.25),0_0_0_4px_#475569,inset_0_4px_8px_rgba(255,255,255,0.2)] border-2 border-slate-900 relative flex flex-col aspect-[9/16] overflow-hidden animate-float-drift">
              
              {/* Phone Header / Notch */}
              <div className="bg-slate-900 rounded-t-[30px] pt-5 px-4 pb-3 relative text-white">
                <div className="w-[70px] h-[18px] bg-zinc-800 rounded-full mx-auto mb-3 shadow-[inset_0_2px_4px_rgba(0,0,0,0.6)]" />
                <div className="flex justify-between items-center text-xs font-semibold px-2 opacity-85">
                  <span>09:41</span>
                  <div className="flex gap-1.5">
                    <Signal size={14} /> <BatteryFull size={14} />
                  </div>
                </div>
              </div>

              {/* Phone Screen */}
              <div className="flex-1 bg-[#FFFBEB] rounded-b-[28px] p-5 overflow-y-auto flex flex-col relative">
                
                {/* MODE 1: HOME SCREEN */}
                {demoMode === "home" && (
                  <div className="flex flex-col animate-fade-in">
                    <div className="flex justify-between items-center text-primary font-extrabold text-lg mb-6">
                      <div className="flex items-center gap-3">
                        <User size={20} strokeWidth={2.5} />
                        <span>Magandang araw!</span>
                      </div>
                      <button className="text-slate-800 border-none bg-transparent cursor-pointer flex items-center justify-center">
                        <Settings size={20} />
                      </button>
                    </div>

                    <div className="flex items-center gap-4 mb-6">
                      <div className="w-[65px] h-[65px] bg-slate-200 rounded-full flex items-center justify-center text-primary shadow-[0_4px_10px_rgba(0,0,0,0.05)]">
                        <User size={36} />
                      </div>
                      <div className="text-xl font-black text-slate-800 leading-tight">
                        Kumusta, Lola Luz!
                      </div>
                    </div>

                    <div className="bg-emerald-50 border border-emerald-200 text-emerald-800 p-3.5 rounded-[24px] text-xs font-bold flex items-center gap-2 mb-6">
                      <CheckCircle2 size={16} />
                      Protektado ang account mo ng Trusted Circle.
                    </div>

                    <div className="flex flex-col gap-4 mb-6">
                      <button
                        onClick={startCheckin}
                        className="bg-primary text-white border-none rounded-[16px] p-4.5 font-extrabold text-base flex items-center justify-center gap-2 shadow-[0_4px_15px_rgba(15,118,110,0.2)] cursor-pointer hover:scale-102 transition-transform duration-200"
                      >
                        <CheckCircle2 size={24} />
                        I-CHECK IN NGAYON
                      </button>
                      <button
                        onClick={() => setDemoMode("scam")}
                        className="bg-secondary text-slate-800 border-none rounded-[16px] p-4.5 font-extrabold text-base flex items-center justify-center gap-2 shadow-[0_4px_15px_rgba(245,158,11,0.2)] cursor-pointer hover:scale-102 transition-transform duration-200"
                      >
                        <Shield size={24} />
                        I-CHECK KUNG SCAM
                      </button>
                    </div>

                    <div className="bg-white rounded-[20px] p-4 shadow-[0_4px_20px_rgba(0,0,0,0.03)]">
                      <div className="flex justify-between items-center font-bold text-slate-800 text-[0.95rem] mb-2">
                        <span>Araw-araw na Gabay</span>
                        <Lightbulb size={18} className="text-primary" />
                      </div>
                      <div className="text-[0.82rem] text-slate-600 leading-normal">
                        Siguraduhin na uminom ng sapat na tubig ngayong mainit ang panahon upang manatiling masigla.
                      </div>
                    </div>
                  </div>
                )}

                {/* MODE 2: DAILY CHECK-IN FLOW */}
                {demoMode === "checkin" && (
                  <div className="flex flex-col justify-center items-center h-full text-center">
                    {checkinStep === "mood" && (
                      <div className="w-full animate-fade-in">
                        <h2 className="text-xl font-extrabold text-primary-dark mb-6">
                          Ano ang nararamdaman mo ngayon?
                        </h2>
                        <div className="flex flex-col gap-4 w-full">
                          <button
                            onClick={() => selectMood("Masaya")}
                            className="flex items-center gap-6 bg-white border-2 border-primary/12 rounded-[20px] p-5 cursor-pointer hover:-translate-y-0.5 hover:scale-102 hover:shadow-md hover:border-primary-light hover:bg-amber-50/50 transition-all font-primary text-lg font-extrabold text-text-primary text-left"
                          >
                            <Smile size={40} strokeWidth={1.5} className="text-amber-500" />
                            <span>Masaya</span>
                          </button>
                          <button
                            onClick={() => selectMood("Okay lang")}
                            className="flex items-center gap-6 bg-white border-2 border-primary/12 rounded-[20px] p-5 cursor-pointer hover:-translate-y-0.5 hover:scale-102 hover:shadow-md hover:border-primary-light hover:bg-emerald-50/50 transition-all font-primary text-lg font-extrabold text-text-primary text-left"
                          >
                            <Meh size={40} strokeWidth={1.5} className="text-emerald-500" />
                            <span>Okay lang</span>
                          </button>
                          <button
                            onClick={() => selectMood("Malungkot")}
                            className="flex items-center gap-6 bg-white border-2 border-primary/12 rounded-[20px] p-5 cursor-pointer hover:-translate-y-0.5 hover:scale-102 hover:shadow-md hover:border-primary-light hover:bg-red-50/50 transition-all font-primary text-lg font-extrabold text-text-primary text-left"
                          >
                            <Frown size={40} strokeWidth={1.5} className="text-red-500" />
                            <span>Malungkot</span>
                          </button>
                        </div>
                      </div>
                    )}

                    {checkinStep === "success" && (
                      <div className="flex flex-col items-center gap-4 animate-scale-in">
                        <div className="w-[70px] h-[70px] bg-emerald-500 text-white rounded-full flex items-center justify-center text-[2.5rem] shadow-[0_4px_15px_rgba(16,185,129,0.4)]">
                          <CheckCircle2 size={48} />
                        </div>
                        <h2 className="text-2xl font-black text-emerald-800">
                          Salamat, Lola Luz!
                        </h2>
                        <p className="bg-white p-4 rounded-[20px] border border-primary/12 text-[0.92rem] text-text-secondary shadow-sm">
                          Naipadala na namin ang iyong check-in mood <strong>({selectedMood})</strong> sa iyong Trusted Circle.
                        </p>
                        <div className="bg-gradient-to-r from-primary to-primary-dark text-white py-2.5 px-6 font-bold text-[0.85rem] rounded-full mt-4 shadow-sm">
                          Naabisuhan na sila
                        </div>
                      </div>
                    )}
                  </div>
                )}

                {/* MODE 3: SCAM CHECKER FLOW */}
                {demoMode === "scam" && (
                  <div className="flex flex-col animate-fade-in">
                    <div className="flex justify-between items-center text-primary font-extrabold text-lg mb-6">
                      <div className="flex items-center gap-3">
                        <button
                          onClick={() => {
                            setDemoMode("home");
                            setScamStatus("idle");
                            setScamInput("");
                          }}
                          className="text-slate-800 border-none bg-transparent cursor-pointer flex items-center justify-center"
                        >
                          <ArrowLeft size={24} />
                        </button>
                        <span>Scam Checker</span>
                      </div>
                      <button className="text-slate-800 border-none bg-transparent cursor-pointer flex items-center justify-center">
                        <Settings size={20} />
                      </button>
                    </div>

                    <div className="bg-white rounded-[16px] p-5 shadow-[0_4px_20px_rgba(0,0,0,0.03)] mb-6 flex flex-col gap-5 border border-black/4">
                      <div className="flex flex-col gap-2">
                        <span className="font-bold text-slate-700 text-[0.85rem]">Nilalaman ng mensahe</span>
                        <textarea
                          value={scamInput}
                          onChange={(e) => setScamInput(e.target.value)}
                          placeholder="I-paste dito ang natanggap na text o mensahe..."
                          className="border border-slate-300 rounded-xl p-3.5 text-[0.88rem] leading-relaxed resize-none font-sans text-slate-800 h-[90px] focus:outline-none focus:border-primary-light"
                        />
                      </div>

                      <div className="flex flex-col gap-2">
                        <span className="font-bold text-slate-700 text-[0.85rem]">Numero ng nagpadala</span>
                        <input
                          type="text"
                          placeholder="Halimbawa: 0917XXXXXXX"
                          className="border border-slate-300 rounded-xl p-3 text-[0.88rem] font-sans text-slate-800 focus:outline-none focus:border-primary-light"
                        />
                      </div>

                      <button
                        onClick={handleScamCheck}
                        className="bg-primary text-white border-none rounded-xl p-4 font-extrabold text-[0.95rem] flex items-center justify-center gap-2 shadow-[0_4px_15px_rgba(15,118,110,0.3)] cursor-pointer disabled:bg-primary/50"
                        disabled={scamStatus === "checking"}
                      >
                        <Search size={18} />
                        {scamStatus === "checking" ? "SINUSURI..." : "I-CHECK ANG MENSAHE"}
                      </button>
                    </div>

                    {scamStatus === "idle" && (
                      <div className="bg-slate-200 rounded-[16px] p-5 mt-auto">
                        <div className="text-primary font-extrabold text-[0.95rem] mb-3">Tips para sa Inyong Seguridad</div>
                        <div className="flex items-start gap-2.5 text-[0.8rem] text-slate-800 mb-3 leading-snug">
                          <CheckCircle2 size={18} className="text-primary shrink-0" />
                          <span>Huwag mag-click ng mga link mula sa hindi kilalang numero.</span>
                        </div>
                        <div className="flex items-start gap-2.5 text-[0.8rem] text-slate-800 leading-snug">
                          <CheckCircle2 size={18} className="text-primary shrink-0" />
                          <span>Ang mga bangko ay hindi kailanman hihingi ng iyong OTP sa tawag o text.</span>
                        </div>
                      </div>
                    )}

                    {/* Checking State */}
                    {scamStatus === "checking" && (
                      <div className="flex flex-col items-center gap-2.5 py-4 animate-fade-in">
                        <div className="w-8 h-8 border-[3px] border-primary/15 border-t-primary rounded-full animate-spin" />
                        <p className="text-xs text-slate-600">Sinusuri ang mensahe gamit ang Gemini AI...</p>
                      </div>
                    )}

                    {/* Result State */}
                    {scamStatus === "result" && scamResult && (
                      <div
                        className={`p-4.5 rounded-[16px] border ${
                          scamResult.color === "red"
                            ? "bg-red-50 border-red-200 text-red-950"
                            : "bg-emerald-50 border-emerald-200 text-emerald-950"
                        } animate-fade-in`}
                      >
                        <div className="font-extrabold text-sm mb-3">
                          Risk Verdict: <strong>{scamResult.level}</strong>
                        </div>
                        <div className="text-[0.82rem] leading-relaxed mb-3">
                          <p className="mb-2"><strong>Dahilan:</strong> {scamResult.reason}</p>
                          <p><strong>Rekomendasyon:</strong> {scamResult.action}</p>
                        </div>
                        {scamResult.color === "red" && (
                          <div className="bg-red-600 text-white p-2 rounded-lg text-center font-bold text-[0.78rem] tracking-wide shadow-sm">
                            Push alert sent to your Trusted Circle!
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                )}

              </div>
              
              {/* Home Indicator Bar */}
              <div className="w-[120px] h-1.5 bg-slate-500 rounded-full mx-auto my-2 shrink-0" />
            </div>
            
          </div>
        </div>

      </div>
    </section>
  );
}
