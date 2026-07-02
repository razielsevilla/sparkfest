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
        <div className="bg-blobs" aria-hidden="true">
          <div className="blob blob-1" />
          <div className="blob blob-2" />
          <div className="blob blob-3" />
        </div>
        {children}
      </body>
    </html>
  );
}
