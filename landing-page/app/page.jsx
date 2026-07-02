import Navbar from "./components/layout/Navbar";
import Hero from "./components/sections/Hero";
import Features from "./components/sections/Features";
import HowItWorks from "./components/sections/HowItWorks";
import TechStack from "./components/sections/TechStack";
import Users from "./components/sections/Users";
import Security from "./components/sections/Security";
import CTA from "./components/sections/CTA";
import Footer from "./components/layout/Footer";
import ScrollToTop from "./components/ui/ScrollToTop";

export default function Home() {
  return (
    <>
      <Navbar />
      <main>
        <Hero />
        <Users />
        <Features />
        <HowItWorks />
        <Security />
        <TechStack />
        <CTA />
      </main>
      <Footer />
      <ScrollToTop />
    </>
  );
}
