"use client";

import { useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";

export default function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => setScrolled(window.scrollY > 40);
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const toggleMenu = () => setMenuOpen((prev) => !prev);
  const closeMenu = () => setMenuOpen(false);

  return (
    <nav
      id="navbar"
      className={`fixed top-0 left-0 right-0 z-50 py-4 transition-all duration-350 ease-in-out ${
        scrolled
          ? "bg-bg-warm/85 backdrop-blur-lg shadow-[0_1px_12px_rgba(15,118,110,0.08)] py-2.5"
          : ""
      }`}
    >
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-2.5 font-extrabold text-2xl text-primary z-50" aria-label="Gabay Sr. home">
          <Image
            src="/images/logo.png"
            alt="Gabay Sr. Logo"
            width={40}
            height={40}
            className="w-10 h-10 object-contain rounded-sm"
          />
          <span>Gabay Sr.</span>
        </Link>

        <ul
          className={`flex items-center gap-8 max-md:hidden ${
            menuOpen
              ? "max-md:flex fixed inset-0 bg-bg-warm/97 backdrop-blur-lg flex-col justify-center items-center z-40"
              : ""
          }`}
        >
          <li>
            <Link
              href="/#features"
              onClick={closeMenu}
              className="text-[0.92rem] font-medium text-text-secondary hover:text-primary relative py-1 after:absolute after:bottom-[-2px] after:left-0 after:w-0 after:h-[2px] after:bg-primary after:rounded-sm hover:after:w-full after:transition-all after:duration-350 after:ease-[cubic-bezier(0.34,1.56,0.64,1)]"
            >
              Features
            </Link>
          </li>
          <li>
            <Link
              href="/#how-it-works"
              onClick={closeMenu}
              className="text-[0.92rem] font-medium text-text-secondary hover:text-primary relative py-1 after:absolute after:bottom-[-2px] after:left-0 after:w-0 after:h-[2px] after:bg-primary after:rounded-sm hover:after:w-full after:transition-all after:duration-350 after:ease-[cubic-bezier(0.34,1.56,0.64,1)]"
            >
              How It Works
            </Link>
          </li>
          <li>
            <Link
              href="/#tech-stack"
              onClick={closeMenu}
              className="text-[0.92rem] font-medium text-text-secondary hover:text-primary relative py-1 after:absolute after:bottom-[-2px] after:left-0 after:w-0 after:h-[2px] after:bg-primary after:rounded-sm hover:after:w-full after:transition-all after:duration-350 after:ease-[cubic-bezier(0.34,1.56,0.64,1)]"
            >
              Tech Stack
            </Link>
          </li>
          <li>
            <Link
              href="/#who-its-for"
              onClick={closeMenu}
              className="text-[0.92rem] font-medium text-text-secondary hover:text-primary relative py-1 after:absolute after:bottom-[-2px] after:left-0 after:w-0 after:h-[2px] after:bg-primary after:rounded-sm hover:after:w-full after:transition-all after:duration-350 after:ease-[cubic-bezier(0.34,1.56,0.64,1)]"
            >
              Who It&apos;s For
            </Link>
          </li>
          <li>
            <Link
              href="/download"
              className="bg-gradient-to-r from-primary to-primary-light text-white font-semibold py-2.5 px-5.5 rounded-full shadow-[0_4px_16px_rgba(15,118,110,0.3)] hover:translate-y-[-2px] hover:scale-103 hover:shadow-[0_6px_24px_rgba(15,118,110,0.4)] transition-all duration-200"
              onClick={closeMenu}
            >
              Download App
            </Link>
          </li>
        </ul>

        {/* Mobile menu overlay */}
        {menuOpen && (
          <ul className="md:hidden fixed inset-0 bg-bg-warm/97 backdrop-blur-lg flex flex-col justify-center items-center gap-8 z-40">
            <li>
              <Link href="/#features" onClick={closeMenu} className="text-xl font-medium text-text-secondary hover:text-primary">
                Features
              </Link>
            </li>
            <li>
              <Link href="/#how-it-works" onClick={closeMenu} className="text-xl font-medium text-text-secondary hover:text-primary">
                How It Works
              </Link>
            </li>
            <li>
              <Link href="/#tech-stack" onClick={closeMenu} className="text-xl font-medium text-text-secondary hover:text-primary">
                Tech Stack
              </Link>
            </li>
            <li>
              <Link href="/#who-its-for" onClick={closeMenu} className="text-xl font-medium text-text-secondary hover:text-primary">
                Who It&apos;s For
              </Link>
            </li>
            <li>
              <Link
                href="/download"
                className="bg-gradient-to-r from-primary to-primary-light text-white font-semibold py-3 px-8 rounded-full shadow-[0_4px_16px_rgba(15,118,110,0.3)]"
                onClick={closeMenu}
              >
                Download App
              </Link>
            </li>
          </ul>
        )}

        <button
          className="md:hidden flex flex-col gap-1.25 cursor-pointer z-50 p-2 bg-transparent border-none"
          onClick={toggleMenu}
          aria-label="Toggle navigation menu"
          aria-expanded={menuOpen}
        >
          <span className={`w-6 h-[2.5px] bg-text-primary rounded-sm transition-all duration-350 ${menuOpen ? "rotate-45 translate-y-[6px] translate-x-[2px]" : ""}`} />
          <span className={`w-6 h-[2.5px] bg-text-primary rounded-sm transition-all duration-350 ${menuOpen ? "opacity-0 -translate-x-2.5" : ""}`} />
          <span className={`w-6 h-[2.5px] bg-text-primary rounded-sm transition-all duration-350 ${menuOpen ? "-rotate-45 -translate-y-[6px] translate-x-[2px]" : ""}`} />
        </button>
      </div>
    </nav>
  );
}
