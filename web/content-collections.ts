import {
  defineCollection,
  defineConfig,
  defineSingleton,
} from "@content-collections/core";
import { compileMDX, type Options as MdxOptions } from "@content-collections/mdx";
import rehypeKatex from "rehype-katex";
import rehypePrettyCode from "rehype-pretty-code";
import remarkGfm from "remark-gfm";
import remarkMath from "remark-math";
import { z } from "zod";

import { KATEX_MACROS } from "./src/lib/content/math";
import {
  chaptersFileSchema,
  conceptMetaSchema,
  levelFrontmatterSchema,
  quizFileSchema,
  worldsFileSchema,
} from "./src/lib/content/schema";

const mdxOptions: MdxOptions = {
  remarkPlugins: [remarkGfm, remarkMath],
  rehypePlugins: [
    [
      rehypePrettyCode,
      {
        theme: "github-dark-default",
        keepBackground: false,
        defaultLang: "python",
      },
    ],
    [rehypeKatex, { macros: KATEX_MACROS }],
  ] as MdxOptions["rehypePlugins"],
};

/**
 * One document per concept-level MDX file
 * (content/concepts/<domain>/<concept_id>/l<N>-<slug>.mdx).
 */
const conceptLevels = defineCollection({
  name: "conceptLevels",
  directory: "content/concepts",
  include: "**/*.mdx",
  schema: levelFrontmatterSchema.extend({ content: z.string() }),
  transform: async (doc, context) => {
    const [domain, conceptId] = doc._meta.directory.split("/");
    if (conceptId !== doc.concept) {
      throw new Error(
        `Frontmatter concept "${doc.concept}" does not match directory "${doc._meta.directory}"`,
      );
    }
    const body = await compileMDX(context, doc, mdxOptions);
    const { content: _content, ...rest } = doc;
    return { ...rest, domain, conceptId, body };
  },
});

/** One document per concept (meta.yaml next to its level files). */
const concepts = defineCollection({
  name: "concepts",
  directory: "content/concepts",
  include: "**/meta.yaml",
  parser: "yaml",
  schema: conceptMetaSchema,
  transform: (doc) => {
    const [domain, conceptId] = doc._meta.directory.split("/");
    if (conceptId !== doc.id) {
      throw new Error(
        `meta.yaml id "${doc.id}" does not match directory "${doc._meta.directory}"`,
      );
    }
    if (domain !== doc.domain) {
      throw new Error(
        `meta.yaml domain "${doc.domain}" does not match directory "${doc._meta.directory}"`,
      );
    }
    return doc;
  },
});

/** One document per domain quiz bank (content/quizzes/<domain>.yaml). */
const quizzes = defineCollection({
  name: "quizzes",
  directory: "content/quizzes",
  include: "*.yaml",
  parser: "yaml",
  schema: quizFileSchema,
});

const worlds = defineSingleton({
  name: "worlds",
  filePath: "content/curriculum/worlds.yaml",
  parser: "yaml",
  schema: worldsFileSchema,
});

const chapters = defineSingleton({
  name: "chapters",
  filePath: "content/curriculum/chapters.yaml",
  parser: "yaml",
  schema: chaptersFileSchema,
});

export default defineConfig({
  content: [conceptLevels, concepts, quizzes, worlds, chapters],
});
