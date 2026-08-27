import type { Metadata, Viewport } from "next";
import { Geist, JetBrains_Mono } from "next/font/google";
import "katex/dist/katex.min.css";
import "./globals.css";

import { AppShell } from "@/components/app-shell";
import { ServiceWorker } from "@/components/service-worker";
import { withBasePath } from "@/lib/base-path";
import { allConcepts } from "@/lib/content/api";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const jetbrainsMono = JetBrains_Mono({
  variable: "--font-jetbrains-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: {
    default: "CORTEX",
    template: "%s · CORTEX",
  },
  description:
    "Daily cognitive training for robotics and ML — leveled concepts, spaced repetition, and interview-grade mastery.",
  applicationName: "CORTEX",
  appleWebApp: {
    capable: true,
    title: "CORTEX",
    statusBarStyle: "black-translucent",
  },
  icons: {
    icon: [
      { url: withBasePath("/icons/favicon-32.png"), sizes: "32x32", type: "image/png" },
      { url: withBasePath("/icons/icon-192.png"), sizes: "192x192", type: "image/png" },
    ],
    apple: withBasePath("/icons/apple-touch-icon.png"),
  },
  formatDetection: { telephone: false },
};

export const viewport: Viewport = {
  themeColor: "#0d1117",
  colorScheme: "dark",
  width: "device-width",
  initialScale: 1,
  // Let the app paint under the notch / home indicator; we pad with
  // env(safe-area-inset-*) where it matters.
  viewportFit: "cover",
};

const LOCK_SCRIPT = `try{var e=localStorage.getItem('cortex.sync.endpoint');var r=localStorage.getItem('cortex.sync.remember')!=='false';var p=r?localStorage.getItem('cortex.sync.passphrase'):null;if(e&&!p)document.documentElement.setAttribute('data-sync-locked','');}catch(_){}`;

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="dark">
      <head>
        {/*
          Runs before first paint: if this device has sync configured but no
          remembered passphrase, hide the app until the gate is up, so locked
          content never flashes on screen.
        */}
        <script
          dangerouslySetInnerHTML={{
            __html: LOCK_SCRIPT,
          }}
        />
      </head>
      <body
        className={`${geistSans.variable} ${jetbrainsMono.variable} antialiased`}
      >
        <AppShell
          concepts={allConcepts.map((c) => ({
            id: c.id,
            title: c.title,
            domain: c.domain,
          }))}
        >
          {children}
        </AppShell>
        <ServiceWorker />
      </body>
    </html>
  );
}
