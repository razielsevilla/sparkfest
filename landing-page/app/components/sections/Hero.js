"use client";

import { useState } from "react";
import styles from "./Hero.module.css";

export default function Hero() {
  // Interactive Demo State
  const [demoMode, setDemoMode] = useState("checkin"); // "checkin" | "scam"

  // Checkin Flow State
  const [checkinStep, setCheckinStep] = useState("home"); // "home" | "mood" | "success"
  const [selectedMood, setSelectedMood] = useState("");

  // Scam Checker State
  const [scamInput, setScamInput] = useState("");
  const [scamStatus, setScamStatus] = useState("idle"); // "idle" | "checking" | "result"
  const [scamResult, setScamResult] = useState(null);

  const startCheckin = () => {
    setCheckinStep("mood");
  };

  const selectMood = (mood) => {
    setSelectedMood(mood);
    setCheckinStep("success");
    setTimeout(() => {
      setCheckinStep("home");
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
                    📶 🔋
                  </div>
                </div>

                {/* Internal Simulator Navigation */}
                <div className={styles.simulatorTabs}>
                  <button
                    className={`${styles.simTab} ${demoMode === "checkin" ? styles.simTabActive : ""}`}
                    onClick={() => setDemoMode("checkin")}
                  >
                    👵 Senior Check-In
                  </button>
                  <button
                    className={`${styles.simTab} ${demoMode === "scam" ? styles.simTabActive : ""}`}
                    onClick={() => setDemoMode("scam")}
                  >
                    🔍 Scam Checker
                  </button>
                </div>
              </div>

              <div className={styles.phoneScreen}>

                {/* MODE 1: DAILY CHECK-IN FLOW */}
                {demoMode === "checkin" && (
                  <div className={styles.screenInnerCheckin}>
                    {checkinStep === "home" && (
                      <div className={styles.checkinHome}>
                        <div className={styles.avatar}>👵</div>
                        <h2>Kumusta, Lola Luz?</h2>
                        <p>Gusto mo bang mag check-in sa pamilya mo ngayon?</p>
                        <button onClick={startCheckin} className={styles.checkinBigBtn}>
                          I-CHECK IN NGAYON
                          <span className={styles.ripple} />
                        </button>
                      </div>
                    )}

                    {checkinStep === "mood" && (
                      <div className={styles.checkinMood}>
                        <h2>Ano ang nararamdaman mo ngayon?</h2>
                        <div className={styles.moodGrid}>
                          <button onClick={() => selectMood("Masaya 😊")} className={`${styles.moodCard} ${styles.moodHappy}`}>
                            <span className={styles.moodEmoji}>😊</span>
                            <span>Masaya</span>
                          </button>
                          <button onClick={() => selectMood("Okay lang 😐")} className={`${styles.moodCard} ${styles.moodOk}`}>
                            <span className={styles.moodEmoji}>😐</span>
                            <span>Okay lang</span>
                          </button>
                          <button onClick={() => selectMood("Malungkot 😢")} className={`${styles.moodCard} ${styles.moodSad}`}>
                            <span className={styles.moodEmoji}>😢</span>
                            <span>Malungkot</span>
                          </button>
                        </div>
                      </div>
                    )}

                    {checkinStep === "success" && (
                      <div className={styles.checkinSuccess}>
                        <div className={styles.successIcon}>✓</div>
                        <h2>Salamat, Lola Luz!</h2>
                        <p className={styles.successToast}>
                          Naipadala na namin ang iyong check-in mood <strong>({selectedMood})</strong> sa iyong Trusted Circle.
                        </p>
                        <div className={styles.successBanner}>
                          👨‍👩‍👧 Naabisuhan na sila
                        </div>
                      </div>
                    )}
                  </div>
                )}

                {/* MODE 2: SCAM CHECKER FLOW */}
                {demoMode === "scam" && (
                  <div className={styles.screenInnerScam}>
                    <h3>Suriin ang Mensahe</h3>
                    <p className={styles.scamHelp}>Mag-paste ng mensahe o pumili ng halimbawa sa ibaba:</p>

                    <div className={styles.templateGrid}>
                      <button
                        onClick={() => setScamTemplate("CONGRATS! You won Php 500,000 from OSCA Charity. Claim now at http://scam-link.ru/osca")}
                        className={styles.templateBtn}
                      >
                        🎁 OSCA Win
                      </button>
                      <button
                        onClick={() => setScamTemplate("GCASH Alert: Your account is suspended. Please update information at https://gcash-security-update.net/login")}
                        className={styles.templateBtn}
                      >
                        💳 GCash Lock
                      </button>
                      <button
                        onClick={() => setScamTemplate("Hi Ma, kumusta ka na? Text ka naman sa bagong number ko na ito.")}
                        className={styles.templateBtn}
                      >
                        💬 Kamag-anak
                      </button>
                    </div>

                    <div className={styles.scamInputWrap}>
                      <textarea
                        value={scamInput}
                        onChange={(e) => setScamInput(e.target.value)}
                        placeholder="I-type o i-paste ang mensahe dito..."
                        className={styles.scamTextarea}
                        rows={4}
                      />
                    </div>

                    <div className={styles.scamActions}>
                      <button
                        onClick={handleScamCheck}
                        className={styles.scamCheckBtn}
                        disabled={scamStatus === "checking"}
                      >
                        {scamStatus === "checking" ? "Sinusuri..." : "I-check kung Scam 🔍"}
                      </button>
                    </div>

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
                          🛡️ Risk Verdict: <strong>{scamResult.level}</strong>
                        </div>
                        <div className={styles.verdictBody}>
                          <p><strong>Dahilan:</strong> {scamResult.reason}</p>
                          <p className={styles.verdictAction}><strong>Rekomendasyon:</strong> {scamResult.action}</p>
                        </div>
                        {scamResult.color === "red" && (
                          <div className={styles.verdictBanner}>
                            ⚠️ Push alert sent to your Trusted Circle!
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
