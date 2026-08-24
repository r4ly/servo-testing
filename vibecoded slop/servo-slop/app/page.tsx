"use client";

import { useEffect, useState } from "react";
import styles from "./page.module.css";

const clamp = (value: number) => Math.min(180, Math.max(0, value));

export default function Home() {
  const [angle, setAngle] = useState(0);
  const [connected, setConnected] = useState(false);
  const distance = Math.abs(angle - 90);
  const eclipse = 1 - distance / 90;
  const darkness = Math.max(0, (eclipse - 0.42) / 0.58);
  const ring = Math.max(0, (1 - distance / 16) * (distance / 16) * 4);
  const totality = Math.max(0, 1 - distance / 5);
  const sceneStyle = { "--sun-x": `${12 + (angle / 180) * 76}%`, "--darkness": darkness, "--ring": ring, "--totality": totality } as React.CSSProperties;

  useEffect(() => {
    let active = true;
    const readMatlab = async () => {
      try {
        const response = await fetch("/api/angle", { cache: "no-store" });
        const data = await response.json() as { angle?: number; updatedAt?: number };
        if (!active || !Number.isFinite(data.angle)) return;
        setAngle(clamp(data.angle ?? 0));
        setConnected(Boolean(data.updatedAt && Date.now() - data.updatedAt < 2000));
      } catch { if (active) setConnected(false); }
    };
    void readMatlab();
    const timer = window.setInterval(() => void readMatlab(), 60);
    return () => { active = false; window.clearInterval(timer); };
  }, []);

  return <main className={styles.page}>
    <header><a href="/">UMBRA<span>.</span></a><span className={styles.feed}><i className={connected ? styles.active : ""} />MATLAB {connected ? "STREAM" : "WAITING"}</span></header>
    <section className={styles.stage} style={sceneStyle} aria-label="Servo-controlled solar eclipse">
      <div className={styles.stars} /><div className={styles.vignette} />
      <div className={styles.cloudBank + " " + styles.farClouds} /><div className={styles.cloudBank + " " + styles.midClouds} />
      <div className={styles.sun} /><div className={styles.ring} /><div className={styles.corona} /><div className={styles.moon} />
      <div className={styles.cloudBank + " " + styles.nearClouds} />
      <div className={styles.caption}><strong>{String(Math.round(angle)).padStart(3, "0")}°</strong><span>{distance < 5 ? "TOTALITY" : distance < 17 ? "ANNULAR MOMENT" : "SOLAR PASSAGE"}</span></div>
    </section>
    <section className={styles.controls}><input aria-label="Servo angle from MATLAB" type="range" min="0" max="180" value={angle} readOnly style={{ "--value": `${angle / 1.8}%` } as React.CSSProperties} /><div><span>0°</span><b>90°</b><span>180°</span></div></section>
  </main>;
}
