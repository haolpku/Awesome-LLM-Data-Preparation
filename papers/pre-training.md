# 📘 Pre-training Data Preparation — Annotated Papers

> Back to [main README](../README.md) · Companion: [`continual-pre-training.md`](./continual-pre-training.md) · [`post-training.md`](./post-training.md) · [`datasets.md`](./datasets.md)

This page complements the main README with fuller annotations and references. Papers are grouped by **data operation**; within each group we follow a rough chronological narrative.

---

## Table of Contents

- [Data Collection](#data-collection)
  - [Scale-oriented crawling](#scale-oriented-crawling)
  - [Reproducibility-oriented mixtures](#reproducibility-oriented-mixtures)
  - [Capability-oriented enrichment](#capability-oriented-enrichment)
- [Data Parsing (documents → text)](#data-parsing)
- [Data Filtering](#data-filtering)
  - [Sensitive & harmful content](#sensitive--harmful-content)
  - [Bias & fairness](#bias--fairness)
  - [Redundancy & contamination](#redundancy--contamination)
  - [Language, format, quality](#language-format-quality)
- [Deduplication](#deduplication)
  - [Exact-based](#exact-based-deduplication)
  - [Fuzzy-based](#fuzzy-based-deduplication)
  - [Model-based](#model-based-deduplication)

---

## Data Collection

### Scale-oriented crawling

The foundational era emphasized *size and diversity* from Common Crawl.

- **CCNet** — Wenzek et al., LREC 2020. Language ID + boilerplate removal + KenLM perplexity cleaning, released a scalable multilingual pipeline. [[arXiv]](https://arxiv.org/abs/1911.00359) [[code]](https://github.com/facebookresearch/cc_net)
- **WebText** — Radford et al., 2019. Proxy for quality via Reddit-karma outbound links, used to train GPT-2. [[paper]](https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf)
- **C4** — Raffel et al., *JMLR 2020*. Large-scale English filtering + deduplication; base of T5. [[arXiv]](https://arxiv.org/abs/1910.10683) [[HF]](https://huggingface.co/datasets/allenai/c4)
- **ClueWeb22** — Overwijk et al., 2022. 10B web docs, browser rendering, visual DOM features, semantic annotations. [[arXiv]](https://arxiv.org/abs/2211.15848)
- **CulturaX** — Nguyen et al., 2023. 167 languages, 6.3T tokens. [[arXiv]](https://arxiv.org/abs/2309.09400) [[HF]](https://huggingface.co/datasets/uonlp/CulturaX)
- **GlotCC** — Kargaran et al., 2024. 1000+ languages, low-resource coverage. [[arXiv]](https://arxiv.org/abs/2410.23825)

**Takeaways.** Strong baseline for scale, but uneven quality, questionable licenses, and limited reproducibility.

### Reproducibility-oriented mixtures

The 2022–2024 wave prioritized *open recipes, ablations, and licensing* so that third parties could reproduce training.

- **The Pile** — Gao et al., 2020. 22 curated sources; the first widely-used open mixture. [[arXiv]](https://arxiv.org/abs/2101.00027)
- **RedPajama-Data v1** — LLaMA-mix recreation. [[repo]](https://github.com/togethercomputer/RedPajama-Data)
- **RedPajama-Data v2** — Together AI, 2023. 80+ CC snapshots and **40+ document-level quality signals**. [[blog]](https://together.ai/blog/redpajama-data-v2) [[HF]](https://huggingface.co/datasets/togethercomputer/RedPajama-Data-V2)
- **Dolma** — Soldaini et al., 2024. 3T-token corpus + modular toolkit. [[arXiv]](https://arxiv.org/abs/2402.00159) [[HF]](https://huggingface.co/datasets/allenai/dolma)
- **RefinedWeb** — Penedo et al., 2023. CC-only with heavy cleaning and dedup — base of Falcon. [[arXiv]](https://arxiv.org/abs/2306.01116)
- **FineWeb / FineWeb-Edu** — Penedo et al., 2024. Lightweight scalable filters; strong downstream gains on knowledge & reasoning. [[arXiv]](https://arxiv.org/abs/2406.17557) [[HF]](https://huggingface.co/datasets/HuggingFaceFW/fineweb)
- **Common Corpus** — 2025. Permissively-licensed / public-domain sources at trillion-token scale.
- **DataComp-LM (DCLM)** — Li et al., 2024. 240T tokens, standardized benchmarks and recipes for data-centric comparison; showed that 7B trained on the best subset reached 64% MMLU (+6.6pp over prior open SoTA with 40% less compute). [[arXiv]](https://arxiv.org/abs/2406.11794)

**Takeaways.** The community settled on *open, composable, documented mixtures* with transparent filtering, moving beyond "bigger is better."

### Capability-oriented enrichment

Recent work targets *specific capabilities and domains*.

- **Code.** **The Stack v2** / **StarCoder2** — Lozhkov et al., 2024. 600+ languages, stronger code/reasoning. [[arXiv]](https://arxiv.org/abs/2402.19173) [[HF]](https://huggingface.co/datasets/bigcode/the-stack-v2)
- **Math.** **OpenWebMath** — Paster et al., 2023. LaTeX-preserving web math. [[arXiv]](https://arxiv.org/abs/2310.06786). **OpenMathInstruct-2** — Toshniwal et al., 2024. 14M problem–solution pairs. [[arXiv]](https://arxiv.org/abs/2410.01560). **MegaMath** — Zhou et al., 2025. 371B math tokens by fusing web + code + synthetic. **Nemotron-MIND** — multi-style synthetic dialogues over OpenWebMath.
- **Biomed.** **PMC-LLaMA** — Wu et al., 2023 (CPT on PubMed Central). **Me-LLaMA** — Xie et al., 2024 (129B biomed tokens + instruction data). **Biomed-Enriched** — Touchent et al., 2025 (LLM-based selection on PubMed).

**Takeaways.** Targeted enrichment boosts efficiency but surfaces overfitting, license, and contamination risks.

---

## Data Parsing

Raw documents (PDFs, books, papers) hold long-form, high-quality text beyond the open web. Parsing them into training-ready text is now a major sub-area.

- **MinerU** — Wang et al., 2024. High-precision PDF → Markdown / JSON with integrated layout parsing and OCR, preserving math/code/tables/reading-order. Valuable for long-context and domain skills. [[paper]](https://arxiv.org/abs/2409.18839) [[repo]](https://github.com/opendatalab/MinerU)

---

## Data Filtering

### Sensitive & harmful content

- **PII detection.** Regex & dictionary rules (ROOTS, WanJuan-CC); NER with Presidio, spaCy, or WikiPII-trained BERT NER (Subramani et al., 2023; Hathurusinghe et al., 2021).
- **Toxic / offensive content.** Sensitive-word lists (ROOTS, WanJuan-CC, PanGu-α); n-gram classifiers (C4, mT5); URL blocklists (WebText, RefinedWeb, CulturaX); model-based classifiers — fastText toxicity, BERT toxicity, Perspective API.

### Bias & fairness

- **Counterfactual Data Augmentation (CDA)** — Zhao et al. 2018, Lu et al. 2019, Garg 2019; and **CDS**/blindness/selective variants (Maudslay 2019; Dwork 2011; Zayed 2022).
- **Scoring against trigger phrases** — Ngo et al., 2021. LM probability on bias-trigger prompts to flag/rank documents.

### Redundancy & contamination

- **Contamination.** 13-gram (GPT-3), 8-gram 70% overlap (PaLM), 10+ token any-span (LLaMA-2). See also [Dodge et al. 2021](https://arxiv.org/abs/2104.08758).
- **Deduplication.** See the full section below.

### Language, format, quality

- **Language ID.** fastText-LID, CLD3, langid.py with confidence thresholds.
- **Extraction / boilerplate.** Trafilatura (Barbaresi 2021), Boilerpipe (Kohlschütter 2010), dataset-specific heuristics (CCNet, RefinedWeb).
- **Heuristic quality signals.** Length, alphabet ratio, symbol density, line-based bad-word counters (Gopher rules, [C4 rules](https://arxiv.org/abs/1910.10683)).
- **Model-based quality.**
  - *Perplexity* — KenLM 5-gram per language (CCNet).
  - *Binary quality classifier* — GPT-3, GLaM, PaLM, LLaMA.
  - *Efficient trillion-token filters* — **Ultra-FineWeb** (verification-based lightweight classifier, 2025). [[paper]](https://arxiv.org/abs/2505.05427)
  - *LLM-assisted line-level* — **FinerWeb-10BT** (Henriksson et al., 2025).
  - *Multilingual LLM-as-judge* — **JQL** (35 languages, 2025).
  - *Quality-diversity joint optimization* — **QuaDMix** (2025).

---

## Deduplication

Dedup is so central we give it its own section.

### Exact-based deduplication

- **Whole-document hashing** — MD5 / SHA-1 / SHA-256; used in CCNet, LLaMA / LLaMA-2, The Stack (Git commit hash), Dolma, RedPajama-V2. Bloom filters reduce memory at web scale.
- **Substring matching.**
  - **C4** — removes documents containing any 3 consecutive sentences already in the corpus.
  - **EXACTSUBSTR** — Lee et al., 2021. Suffix arrays, removes all ≥50-token duplicates. Adopted by RefinedWeb, clinical corpora, etc. [[arXiv]](https://arxiv.org/abs/2107.06499)

### Fuzzy-based deduplication

- **MinHash-LSH** — Broder 1997; Indyk & Motwani 1998. The de-facto standard; used by GPT-3, The Pile, Gopher, RefinedWeb, SlimPajama, RedPajama-V2.
- **SimHash** — Manku et al., 2007. Used in RedPajama-1T.
- **TLSH** — OSCAR-23.01.
- **TF-IDF similarity** — TigerBot.
- **Levenshtein distance** — PaLM for code dedup.
- **SoftDedup** — Hu et al., 2024. Reweights samples by redundancy; reduces cost and improves accuracy. [[arXiv]](https://arxiv.org/abs/2407.06654)
- **LSHBloom** — 2024. MinHashLSH + Bloom filters for faster, memory-efficient web-scale dedup. [[arXiv]](https://arxiv.org/abs/2411.04257)
- **Mosaic Memory** — 2024. Empirical study showing models still memorize near-duplicates despite perturbations → current fuzzy dedup is necessary but not sufficient. [[arXiv]](https://arxiv.org/abs/2405.15523)

### Model-based deduplication

- **SemDeDup** — Abbas et al., 2023. OPT/CLIP embeddings + k-means; cosine-threshold per cluster. [[arXiv]](https://arxiv.org/abs/2303.09540)
- **D4** — 2023. SemDeDup followed by centroid-proximity pruning to increase diversity. [[arXiv]](https://arxiv.org/abs/2308.12284)
- **MiniPile** / **Data-Juicer** — Reference implementations of embedding-cluster dedup.
- **Noise-Robust bi-encoder + cross-encoder re-rank** — 2022. Fine-tuned SBERT for contrastive pair detection. [[arXiv]](https://arxiv.org/abs/2210.04261)
- **GenDedup** — 2024. Generative keyword-prediction: if the model confidently predicts keywords of a text, flag it as likely memorized ⇒ duplicate. [[arXiv]](https://arxiv.org/abs/2401.05883)

---

## Practical end-to-end workflow (what FineWeb / Dolma look like)

1. **Structural cleaning** — language ID, boilerplate removal, exact + near-dup (MinHash-LSH, SoftDedup).
2. **Compliance checks** — PII redaction, safety filters, licensing.
3. **Quality scoring** — efficient classifiers or lightweight LLM judges (Ultra-FineWeb, JQL).
4. **Language-aware passes** — for multilingual robustness (fastText, CLD3, JQL).
5. **Mixture optimization** — quality-diversity balancing (QuaDMix) with transparent retention/filter stats.
6. **Tooling** — NeMo Curator / Dolma Toolkit / Data-Juicer / DataFlow to operationalize at scale.

---

> 🙏 Missing something you'd like to see here? **Send a PR** (see [`CONTRIBUTING.md`](../CONTRIBUTING.md)) or open an issue with the *Add-a-paper* template.
