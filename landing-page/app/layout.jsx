import "./globals.css";

export const metadata = {
  title: "Gabay Sr. — Companionship & Scam Protection for Filipino Seniors",
  description:
    "Gabay Sr. connects Filipino senior citizens with a Trusted Circle of family, OFWs, and local volunteers through simplified daily check-ins and AI-powered scam detection. Built with Flutter, Firebase, and Gemini API for SparkFest 2026.",
  keywords: [
    "Gabay Sr",
    "Filipino seniors",
    "scam protection",
    "companionship app",
    "trusted circle",
    "SparkFest 2026",
    "elderly care",
    "AI scam detection",
  ],
  authors: [{ name: "Team Gabay Sr." }],
  openGraph: {
    title: "Gabay Sr. — Companionship & Scam Protection for Filipino Seniors",
    description:
      "A mobile-first app connecting Filipino seniors with their Trusted Circle for companionship and digital safety.",
    type: "website",
  },
};

export default function RootLayout({ children }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body suppressHydrationWarning>
        {/* Animated background blobs */}
        <div className="fixed inset-0 -z-10 pointer-events-none overflow-hidden" aria-hidden="true">
          <div className="absolute rounded-full blur-[100px] opacity-30 animate-blob-float w-[600px] h-[600px] bg-primary-light -top-[15%] -left-[10%]" />
          <div className="absolute rounded-full blur-[100px] opacity-30 animate-blob-float w-[500px] h-[500px] bg-secondary top-[30%] -right-[10%] [animation-delay:-7s] [animation-duration:25s]" />
          <div className="absolute rounded-full blur-[100px] opacity-30 animate-blob-float w-[450px] h-[450px] bg-primary -bottom-[10%] left-[20%] [animation-delay:-14s] [animation-duration:22s]" />
        </div>
        {children}
      </body>
    </html>
  );
}
