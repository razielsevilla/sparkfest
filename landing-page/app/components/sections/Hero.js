"use client";

import { useState } from "react";
import { Signal, BatteryFull, Smile, Meh, Frown, CheckCircle2, Settings, User, Shield, Search, Lightbulb, ArrowLeft } from "lucide-react";
import styles from "./Hero.module.css";

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
      const isScam = scamInput.toLowerCase().includes("panalo") ||
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
          action: "HUWAG i-click ang link. Iblock ang sender."
        });
      } else {
        setScamResult({
          level: "Mababa (Low Risk)",
          color: "green",
          reason: "Normal na mensahe. Mukhang hindi ito naglalaman ng mga tipikal na scam keywords o kahina-hinalang link.",
          action: "Ligtas basahin, ngunit mag-ingat pa rin palagi."
        });
      }
      setScamStatus("result");
    }, 1800);
  };

  const setScamTemplate = (text) => {
    setScamInput(text);
    setScamStatus("idle");
  };

  return (
    <section id="hero" className={styles.hero}>
      <div className={`container ${styles.grid}`}>

        {/* Left Side: Copywriting */}
        <div className={styles.content}>
          <h1 className={styles.title}>
            Keeping Filipino Seniors <span className={styles.highlight}>Safe</span> &amp; <span className={styles.highlightAmber}>Connected</span>
          </h1>

          <p className={styles.description}>
            Gabay Sr. connects elderly Filipinos with a Trusted Circle of
            family, OFWs, and barangay volunteers — through simplified daily
            check-ins and AI-powered scam detection.
          </p>

          <div className={styles.actions}>
            <a href="#cta" className="btn btn-primary">
              Protect Your Family
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12h14" /><path d="m12 5 7 7-7 7" /></svg>
            </a>
          </div>

          {/* Stats section */}
          <div className={styles.stats}>
            <div className={styles.statItem}>
              <div className={styles.statNumber}>4.5M+</div>
              <div className={styles.statLabel}>Filipino seniors aged 65+</div>
            </div>
            <div className={styles.statItem}>
              <div className={styles.statNumber}>68%</div>
              <div className={styles.statLabel}>Experience isolation</div>
            </div>
            <div className={styles.statItem}>
              <div className={styles.statNumber}>₱5.8B</div>
              <div className={styles.statLabel}>Lost to scams yearly</div>
            </div>
          </div>
        </div>

        {/* Right Side: Interactive Phone Mockup */}
        <div className={styles.visualContainer}>
          <div className={styles.mediaFrame}>
            <div className={styles.phoneSimulator}>
              <div className={styles.phoneHeader}>
                <div className={styles.phoneSpeaker} />
                <div className={styles.phoneInfo}>
                  <span>09:41</span>
                  <div className={styles.phoneStatusIcons}>
                    <Signal size={14} /> <BatteryFull size={14} />
                  </div>
                </div>
              </div>

              <div className={styles.phoneScreen}>

                {/* MODE 1: HOME SCREEN */}
                {demoMode === "home" && (
                  <div className={styles.appHome}>
                    <div className={styles.appHeader}>
                      <div className={styles.appHeaderLeft}>
                        <User size={20} strokeWidth={2.5} />
                        <span>Magandang araw!</span>
                      </div>
                      <button className={styles.iconBtn}><Settings size={20} /></button>
                    </div>

                    <div className={styles.appHomeProfile}>
                      <div className={styles.appAvatar}>
                        <User size={36} />
                      </div>
                      <div className={styles.appGreeting}>
                        Kumusta, Lola Luz!
                      </div>
                    </div>

                    <div className={styles.appBanner}>
                      <CheckCircle2 size={16} />
                      Protektado ang iyong account ng Trusted Circle.
                    </div>

                    <div className={styles.appBtnBlock}>
                      <button onClick={startCheckin} className={styles.appBtnPrimary}>
                        <CheckCircle2 size={24} />
                        I-CHECK IN NGAYON
                      </button>
                      <button onClick={() => setDemoMode("scam")} className={styles.appBtnSecondary}>
                        <Shield size={24} />
                        I-CHECK KUNG SCAM
                      </button>
                    </div>

                    <div className={styles.appTipCard}>
                      <div className={styles.appTipHeader}>
                        <span>Araw-araw na Gabay</span>
                        <Lightbulb size={18} color="#0f766e" />
                      </div>
                      <div className={styles.appTipBody}>
                        Siguraduhin na uminom ng sapat na tubig ngayong mainit ang panahon.
                      </div>
                    </div>
                  </div>
                )}

                {/* MODE 2: DAILY CHECK-IN FLOW */}
                {demoMode === "checkin" && (
                  <div className={styles.screenInnerCheckin}>
                    {checkinStep === "mood" && (
                      <div className={styles.checkinMood}>
                        <h2>Ano ang nararamdaman mo ngayon?</h2>
                        <div className={styles.moodGrid}>
                          <button onClick={() => selectMood("Masaya")} className={`${styles.moodCard} ${styles.moodHappy}`}>
                            <Smile size={40} strokeWidth={1.5} className={styles.moodEmoji} />
                            <span>Masaya</span>
                          </button>
                          <button onClick={() => selectMood("Okay lang")} className={`${styles.moodCard} ${styles.moodOk}`}>
                            <Meh size={40} strokeWidth={1.5} className={styles.moodEmoji} />
                            <span>Okay lang</span>
                          </button>
                          <button onClick={() => selectMood("Malungkot")} className={`${styles.moodCard} ${styles.moodSad}`}>
                            <Frown size={40} strokeWidth={1.5} className={styles.moodEmoji} />
                            <span>Malungkot</span>
                          </button>
                        </div>
                      </div>
                    )}

                    {checkinStep === "success" && (
                      <div className={styles.checkinSuccess}>
                        <div className={styles.successIcon}>
                          <CheckCircle2 size={48} />
                        </div>
                        <h2>Salamat, Lola Luz!</h2>
                        <p className={styles.successToast}>
                          Naipadala na namin ang iyong check-in mood <strong>({selectedMood})</strong> sa iyong Trusted Circle.
                        </p>
                        <div className={styles.successBanner}>
                          Naabisuhan na sila
                        </div>
                      </div>
                    )}
                  </div>
                )}

                {/* MODE 3: SCAM CHECKER FLOW */}
                {demoMode === "scam" && (
                  <div className={styles.appScam}>
                    <div className={styles.appHeader}>
                      <div className={styles.appHeaderLeft}>
                        <button onClick={() => { setDemoMode("home"); setScamStatus("idle"); setScamInput(""); }} className={styles.iconBtn}>
                          <ArrowLeft size={24} />
                        </button>
                        <span>Scam Checker</span>
                      </div>
                      <button className={styles.iconBtn}><Settings size={20} /></button>
                    </div>

                    <div className={styles.appCard}>
                      <div className={styles.appInputGroup}>
                        <span className={styles.appLabel}>Nilalaman ng mensahe</span>
                        <textarea
                          value={scamInput}
                          onChange={(e) => setScamInput(e.target.value)}
                          placeholder="I-paste dito ang natanggap na text o mensahe..."
                          className={styles.appTextarea}
                        />
                      </div>
                      
                      <div className={styles.appInputGroup}>
                        <span className={styles.appLabel}>Numero ng nagpadala</span>
                        <input
                          type="text"
                          placeholder="Halimbawa: 0917XXXXXXX"
                          className={styles.appInput}
                        />
                      </div>

                      <button
                        onClick={handleScamCheck}
                        className={styles.appBtnPrimary}
                        style={{ marginTop: '0.5rem', borderRadius: '12px', padding: '1rem' }}
                        disabled={scamStatus === "checking"}
                      >
                        <Search size={18} />
                        {scamStatus === "checking" ? "SINUSURI..." : "I-CHECK ANG MENSAHE"}
                      </button>
                    </div>

                    {scamStatus === "idle" && (
                      <div className={styles.appSecurityTips}>
                        <div className={styles.appSecurityTitle}>Tips para sa Inyong Seguridad</div>
                        <div className={styles.appSecurityItem}>
                          <CheckCircle2 size={18} color="#0f766e" style={{flexShrink: 0}} />
                          <span>Huwag mag-click ng mga link mula sa hindi kilalang numero.</span>
                        </div>
                        <div className={styles.appSecurityItem}>
                          <CheckCircle2 size={18} color="#0f766e" style={{flexShrink: 0}} />
                          <span>Ang mga bangko ay hindi kailanman hihingi ng iyong OTP sa pamamagitan ng tawag o text.</span>
                        </div>
                      </div>
                    )}

                    {/* Checking State */}
                    {scamStatus === "checking" && (
                      <div className={styles.checkingLoader}>
                        <div className={styles.spinner} />
                        <p>Sinusuri ang mensahe gamit ang Gemini AI...</p>
                      </div>
                    )}

                    {/* Result State */}
                    {scamStatus === "result" && scamResult && (
                      <div className={`${styles.scamVerdict} ${scamResult.color === "red" ? styles.verdictRed : styles.verdictGreen}`}>
                        <div className={styles.verdictHeader}>
                          Risk Verdict: <strong>{scamResult.level}</strong>
                        </div>
                        <div className={styles.verdictBody}>
                          <p><strong>Dahilan:</strong> {scamResult.reason}</p>
                          <p className={styles.verdictAction}><strong>Rekomendasyon:</strong> {scamResult.action}</p>
                        </div>
                        {scamResult.color === "red" && (
                          <div className={styles.verdictBanner}>
                            Push alert sent to your Trusted Circle!
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                )}

              </div>
              <div className={styles.phoneHomeBar} />
            </div>
          </div>
        </div>

      </div>
    </section>
  );
}
