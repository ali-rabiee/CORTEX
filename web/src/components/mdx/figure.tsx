import { withBasePath } from "@/lib/base-path";

/**
 * A diagram with a caption. `src` is an app-absolute path into `public/figures/`
 * — SVG preferred, so it stays crisp, small, and legible on a phone.
 *
 * ```mdx
 * <Figure src="/figures/bc-compounding-error.svg"
 *         alt="Learner trajectory drifting away from the expert's"
 *         caption="Each small error moves the robot into states the expert never demonstrated." />
 * ```
 */
export function Figure({
  src,
  alt,
  caption,
}: {
  src: string;
  alt: string;
  caption?: string;
}) {
  return (
    <figure className="my-6">
      <div className="overflow-x-auto rounded-card border border-border bg-surface/60 p-4">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src={withBasePath(src)}
          alt={alt}
          className="mx-auto block h-auto w-full max-w-xl"
        />
      </div>
      {caption && (
        <figcaption className="mt-2 text-center text-xs leading-relaxed text-faint">
          {caption}
        </figcaption>
      )}
    </figure>
  );
}
