# 📗 Continual Pre-training (CPT) — Annotated Papers

> Back to [main README](../README.md) · [`pre-training.md`](./pre-training.md) · [`post-training.md`](./post-training.md) · [`datasets.md`](./datasets.md)

**Continual Pre-training (CPT)** sits between base pre-training and fine-tuning. The defining constraint: **inject new knowledge (domain, language, time) without catastrophic forgetting**, usually by further-training a pre-trained LLM on new unlabeled corpora.

We organize CPT data preparation along five axes: **Collection, Filtering, Evaluation, Generation, and Workflow.**

---

## Table of Contents

- [Data Collection](#data-collection)
  - [Domain-specific corpora](#domain-specific-corpora)
  - [Language coverage](#language-coverage)
  - [Temporal freshness](#temporal-freshness)
- [Data Filtering](#data-filtering)
- [Data Evaluation](#data-evaluation)
- [Data Generation](#data-generation)
- [Representative CPT Recipes](#representative-cpt-recipes)

---

## Data Collection

### Domain-specific corpora

Targets sectors where the base model is weakest (e.g., finance, medicine, law, scientific).

- **FinPythia-6.9B** — Xie et al., 2024. Targeted selection from financial news, reports, filings. [[paper]](https://arxiv.org/abs/2404.11845)
- **Japanese Financial CPT** — Hirano et al., 2024. Official policy statements + institutional publications. [[paper]](https://arxiv.org/abs/2403.06465)
- **PMC-LLaMA** — Wu et al., 2023. CPT on PubMed Central. [[paper]](https://arxiv.org/abs/2304.14454)
- **Me-LLaMA** — Xie et al., 2024. 129B-token biomedical corpus + instructions. [[paper]](https://arxiv.org/abs/2402.12749)
- **Biomed-Enriched** — Touchent et al., 2025. LLM-based selection over PubMed.
- **AstroMLab 2** — Pan et al., 2024. Domain CPT for astronomy showing proxy validation is essential for specialized science data. [[paper]](https://arxiv.org/abs/2409.19750)

### Language coverage

Extends LLMs to under-represented languages.

- **Portuguese CPT (120B tokens)** — Zilio et al., 2024. Strong gains in Portuguese from continued pre-training on an English-centric base.
- **Glot500** — ImaniGooghari et al., 2023. 500+ languages. [[ACL paper]](https://aclanthology.org/2023.acl-long.61/)
- **EMMA-500** — Ji et al., 2024. 546 languages, 74B+ tokens (MaLA corpus); CPT of Llama-2-7B. [[paper]](https://arxiv.org/abs/2409.17892) [[HF]](https://huggingface.co/collections/MaLA-LM/mala-corpus-66e05127641a51de34d39529)
- **Sailor** — Dou et al., 2024. Southeast Asian language CPT. [[paper]](https://arxiv.org/abs/2404.03608)
- **AURORA-M** — Nakamura et al., 2024. 435B tokens; two-stage CPT (CAP multilingual web/code + CAT alignment mix) with human-reviewed safety red-teaming. [[paper]](https://arxiv.org/abs/2404.00399) [[HF]](https://huggingface.co/aurora-m/datasets)
- **Efficient CPT for low-resource languages** — Nag et al., 2024. Vocabulary adaptation + selective corpus expansion.

### Temporal freshness

Ensures models acquire *new* knowledge aligned with evolving facts.

- **TemporalWiki** — Jang et al., 2022. CPT on incremental Wikipedia diffs; comparable perplexity gains with far less data. [[paper]](https://arxiv.org/abs/2204.14211)
- **Nemotron-CC v2** — NVIDIA, 2025. Multi-snapshot CC (2024–25) + synthetic rephrasing + global dedup, ~6.586T tokens. [[HF]](https://huggingface.co/datasets/nvidia/Nemotron-CC-v2)
- **NeuScraper** — Xu et al., 2024. Neural web scraping for clean, up-to-date web content.
- **Craw4LLM** — Yu et al., 2025. Aggressive filtering on recent CC for CPT.

---

## Data Filtering

CPT filtering differs from PT filtering in emphasis — it must adapt corpora to evolving model capabilities and target applications.

- **Long-context filters.** LADM (Long-range Attention Dependency Measure) scores paragraphs by how strongly spans attend to each other; selecting high-LADM samples yields superior long-context performance with fewer tokens.
- **Language & genre filters.** Train classifiers to detect domains (STEM, education, toxic) and retain only relevant segments (used in the 120B Portuguese corpus construction). For code CPT, filter out natural language to specialize.
- **Quality filters.** Rule-based cleaning + dedup + FastText classifiers (Guo et al. 2024; Nag et al. 2024), plus **model-informed filtering** using near-converged LLM checkpoints to score candidate batches — see **Ultra-FineWeb** (Wang et al., 2025). [[paper]](https://arxiv.org/abs/2505.05427)

---

## Data Evaluation

Evaluating the utility of new data before (or during) CPT prevents wasted compute.

### Similarity-based scoring

Measures how new data relates to existing corpora / downstream tasks.

- Token / embedding similarity and topic models — Shi et al., 2023; Parmar et al., 2024; Sam et al., 2025; Mizrahi et al., 2025.
- Limits of coarse similarity — Yauney et al., 2023.
- **Curriculum design by inter-corpus similarity** — Yildiz et al., 2024 show domain ordering materially affects continual learning outcomes (similar → specialization; interleaved → transfer). [[paper]](https://arxiv.org/abs/2402.02267)

### Proxy model evaluation

Small-scale probes instead of full CPT runs.

- Wang et al., 2025 — expose a near-converged checkpoint to candidate batches, monitor held-out loss. (Also underpins **Ultra-FineWeb**.)
- Chen et al., 2024 — lightweight validation loops reliably predict long-term gains.
- Xie et al. (FinPythia) — proxy validation to find domain corpora with outsized impact.
- AstroMLab 2 — proxy validation is essential for highly specialized scientific corpora.

---

## Data Generation

### Raw-text reformatting

Convert raw text into supervision-friendly formats (paraphrase, style conversion, dialogue recasting).

- **WRAP / paraphrase-based efficiency** — Maini et al., 2024. Rephrasing web data for data efficiency. [[paper]](https://arxiv.org/abs/2401.16380)
- **Chen et al. 2024** — Training on style conversions.
- **Jiang et al. 2024** — Mix of style rephrasings.
- **YuLan-Mini** — Hu et al., 2024. Dialogue reformulation in a compact CPT corpus. [[paper]](https://arxiv.org/abs/2412.17743)
- **Phi-4** — Abdin et al., 2024. Mixed-style conversions, compact but versatile.

### Reasoning augmentation

Inject synthetic chains-of-thought and reasoning structure.

- **Reasoning CPT** — Ishibashi et al., 2025. Prompts LLMs to reconstruct hidden reasoning steps behind STEM and law texts.
- **EntiGraph** — Yang et al., 2024. Entity-linked corpus expansion → richer semantic structures, better inter-entity reasoning.
- **MIND** — Akter et al., 2024. Synthetic dialogues with knowledge gaps for problem-solving ability. [[paper]](https://arxiv.org/abs/2410.12881)

### Domain expansion

Overcome sparse domain corpora by synthesizing / selecting relevant data.

- **FinPythia-6.9B** (finance), **MachineLearningLM** (Dong et al., 2025), **MIND** (math), **AstroMLab** (astronomy) — domain-focused CPT with filtered/augmented corpora.
- **TRAIT** — Liang et al., 2024. Task-oriented in-domain augmentation; selects domain-matched examples from general corpora then generates synthetic passages guiding the model on how to apply domain knowledge. [[paper]](https://arxiv.org/abs/2410.06481)

---

## Representative CPT Recipes

These are useful templates when planning your own CPT run.

| Recipe | What it does | Best for |
|---|---|---|
| **EMMA-500 (MaLA)** | Compile 546-language corpus → heavy cleaning + dedup → CPT Llama-2-7B | Multilingual extension |
| **AURORA-M** | Two-stage CPT (CAP multilingual web/code + CAT alignment mix), human-reviewed safety red-teaming | Multilingual + code + safety |
| **Nemotron-CC v2** | Multi-CC snapshots + LLM rephrasing + global dedup; 15-lang QA translations | General freshness |
| **Nemotron-MIND** | OpenWebMath → 7-style synthetic dialogues → heuristic filtering | Math reasoning |
| **MegaMath-Web-Pro-Max** | CC math-heavy pages → math/quality scoring → per-domain Parquet release | Math CPT |
| **YuLan-Mini CPT phase** | Curated + synthetic math/code/science annealed mix | Compact multi-domain |

---

> 🙏 Missing a CPT paper / dataset? **Send a PR** — see [`CONTRIBUTING.md`](../CONTRIBUTING.md).
