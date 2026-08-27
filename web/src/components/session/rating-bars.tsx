"use client";

/** Confidence (1–5, before reveal) and quality (0–5, after reveal) rating rows. */

const CONFIDENCE_LABELS = ["Guessing", "Unsure", "Maybe", "Confident", "Certain"];
const QUALITY_LABELS = [
  "Blackout",
  "Wrong",
  "Almost",
  "Hard",
  "Good",
  "Perfect",
];

export function ConfidenceBar({
  value,
  onChange,
}: {
  value: number | null;
  onChange: (v: number) => void;
}) {
  return (
    <RatingRow
      label="How confident are you?"
      values={[1, 2, 3, 4, 5]}
      labels={CONFIDENCE_LABELS}
      selected={value}
      onChange={onChange}
      colorFor={() => "var(--color-primary)"}
    />
  );
}

export function QualityBar({
  onChange,
}: {
  onChange: (v: number) => void;
}) {
  return (
    <RatingRow
      label="How well did you recall it?"
      values={[0, 1, 2, 3, 4, 5]}
      labels={QUALITY_LABELS}
      selected={null}
      onChange={onChange}
      colorFor={(v) =>
        v <= 1
          ? "var(--color-danger)"
          : v <= 3
            ? "var(--color-warning)"
            : "var(--color-success)"
      }
    />
  );
}

function RatingRow({
  label,
  values,
  labels,
  selected,
  onChange,
  colorFor,
}: {
  label: string;
  values: number[];
  labels: string[];
  selected: number | null;
  onChange: (v: number) => void;
  colorFor: (v: number) => string;
}) {
  return (
    <div>
      <p className="text-center text-sm font-medium text-muted-foreground">
        {label}
      </p>
      <div className="mt-3 flex justify-center gap-2">
        {values.map((v, i) => {
          const color = colorFor(v);
          const isSelected = selected === v;
          return (
            <button
              key={v}
              onClick={() => onChange(v)}
              className="group flex w-14 flex-col items-center gap-1.5 sm:w-16"
            >
              <span
                className="flex size-10 items-center justify-center rounded-xl border text-sm font-bold transition-all group-hover:scale-105 sm:size-11"
                style={{
                  borderColor: `color-mix(in srgb, ${color} ${isSelected ? 90 : 35}%, transparent)`,
                  background: `color-mix(in srgb, ${color} ${isSelected ? 25 : 8}%, transparent)`,
                  color,
                }}
              >
                {v}
              </span>
              <span className="text-[0.6rem] text-faint">{labels[i]}</span>
            </button>
          );
        })}
      </div>
    </div>
  );
}
