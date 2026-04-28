# Contributing

Thanks for helping improve **Awesome LLM Data Preparation**! This list gets better every time a community member sends a pointer, fixes a broken link, or reorganizes an entry.

## TL;DR

- **Just have a paper to add?** Open an [issue with the *Add a paper* template](./.github/ISSUE_TEMPLATE/add-paper.yml) — takes 60 seconds. We will take it from there.
- **Want to edit the list directly?** Open a PR. Follow the format below.

---

## What belongs here

This repository is scoped to **data preparation for Large Language Models**, including:

- Corpus **collection** (web, curated, domain-specific, multilingual).
- Document **parsing** (PDF / HTML / OCR to training-ready text).
- **Filtering** (safety, PII, bias, language, quality, contamination).
- **Deduplication** (exact / fuzzy / model-based).
- **Generation** (self-instruct, synthetic, paraphrasing, reasoning augmentation).
- **Evaluation & selection** (coreset, LLM-judge, gradient, self-instruction).
- End-to-end **workflows** and **systems** (FineWeb, Dolma, Data-Juicer, DataFlow, NeMo Curator, …).
- **Datasets** that are notable because of their preparation recipe.

Papers that are *generally about LLMs* but do not contribute to data preparation belong in other awesome lists (e.g. [Awesome-LLM](https://github.com/Hannibal046/Awesome-LLM)).

---

## Format for new entries

Each paper should be a single Markdown list item in the appropriate file under [`papers/`](./papers):

```md
- **Short name / dataset** — Author et al., Venue Year. One-line description of the data-preparation contribution. [[arXiv]](https://arxiv.org/abs/XXXX.YYYYY) [[code]](https://github.com/...) [[HF]](https://huggingface.co/...)
```

**Rules of thumb.**

- Use the short recognizable name first (FineWeb, Dolma, MinHash-LSH), not the full paper title.
- Include author family name(s), venue, and year — these help readers triage.
- The one-line description should describe **what the paper does for data preparation**, not what the paper is about generically. Good: *"SoftDedup reweights samples by redundancy, reducing training cost while improving accuracy."* Bad: *"A new deduplication method."*
- Prefer `arXiv` + `code` + `HF` links. Drop fields that don't exist.
- Put new entries in **chronological order** within their sub-section (oldest first), unless the sub-section is a curated short list.

---

## Which file to edit?

| Paper topic | File |
|---|---|
| Pre-training collection / filter / dedup / parsing | [`papers/pre-training.md`](./papers/pre-training.md) |
| Continual pre-training | [`papers/continual-pre-training.md`](./papers/continual-pre-training.md) |
| SFT / RL / RLHF / RLAIF | [`papers/post-training.md`](./papers/post-training.md) |
| New dataset / corpus | [`papers/datasets.md`](./papers/datasets.md) |
| Related survey | [`papers/surveys.md`](./papers/surveys.md) |
| Tooling / system | top-level [`README.md`](./README.md) and (optionally) a new section in the appropriate file |

If a paper spans stages (e.g. DataFlow, Data-Juicer), add it to the most specific stage file *and* link from the tools section of the README.

---

## PR process

1. Fork and create a feature branch: `git checkout -b add-mypaper`.
2. Edit the right file(s). Keep changes minimal; one PR ≈ one topic.
3. Double-check that all links render and point to the canonical source.
4. If you update the main README, please keep both `README.md` and `README_zh.md` in sync.
5. Open a PR. Describe *why* the paper fits and in which sub-section you placed it.
6. A maintainer will review within ~7 days.

**Please do not** submit papers that are your own work without at least one citation trail (venue / arXiv) — we are building a survey-quality list, not a promotional channel.

---

## Code of conduct

Be kind, be specific, assume good intent. We reject submissions with promotional framing or without verifiable sources, but we will always explain why.

---

Thanks! ⭐ If you haven't yet, star the repo — it keeps maintainers motivated.
