import { LEVELS } from "@/lib/content/schema";

/**
 * The signature CORTEX progression visual: a ring of 5 arc segments, one per
 * mastery level. Filled = level passed, dimmed = available but not passed,
 * near-invisible = content not yet authored.
 */
export function LevelRing({
  completedLevels = 0,
  availableLevels,
  color,
  size = 40,
  strokeWidth = 4,
  label,
}: {
  /** Highest level the user has passed (0–5). */
  completedLevels?: number;
  /** Which levels have authored content (default: all). */
  availableLevels?: number[];
  /** Ring color (domain hex). */
  color: string;
  size?: number;
  strokeWidth?: number;
  /** Center label; defaults to completed level count. */
  label?: string;
}) {
  const radius = (size - strokeWidth) / 2;
  const center = size / 2;
  const segmentAngle = 360 / LEVELS.length;
  const gapAngle = 10;

  return (
    <svg
      width={size}
      height={size}
      viewBox={`0 0 ${size} ${size}`}
      role="img"
      aria-label={`Level ${completedLevels} of 5`}
    >
      {LEVELS.map((level, i) => {
        const start = -90 + i * segmentAngle + gapAngle / 2;
        const end = -90 + (i + 1) * segmentAngle - gapAngle / 2;
        const available = availableLevels?.includes(level) ?? true;
        const filled = level <= completedLevels;
        return (
          <path
            key={level}
            d={arcPath(center, center, radius, start, end)}
            fill="none"
            stroke={color}
            strokeWidth={strokeWidth}
            strokeLinecap="round"
            opacity={filled ? 1 : available ? 0.22 : 0.08}
          />
        );
      })}
      <text
        x={center}
        y={center}
        textAnchor="middle"
        dominantBaseline="central"
        fill={completedLevels > 0 ? color : "var(--color-faint)"}
        style={{ fontSize: size * 0.32, fontWeight: 700 }}
      >
        {label ?? completedLevels}
      </text>
    </svg>
  );
}

function arcPath(
  cx: number,
  cy: number,
  r: number,
  startDeg: number,
  endDeg: number,
): string {
  const start = polar(cx, cy, r, startDeg);
  const end = polar(cx, cy, r, endDeg);
  const largeArc = endDeg - startDeg > 180 ? 1 : 0;
  return `M ${start.x} ${start.y} A ${r} ${r} 0 ${largeArc} 1 ${end.x} ${end.y}`;
}

function polar(cx: number, cy: number, r: number, deg: number) {
  const rad = (deg * Math.PI) / 180;
  return { x: cx + r * Math.cos(rad), y: cy + r * Math.sin(rad) };
}
