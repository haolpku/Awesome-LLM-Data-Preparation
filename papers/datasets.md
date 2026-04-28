# 📚 Dataset Index

> Back to [main README](../README.md) · [`pre-training.md`](./pre-training.md) · [`continual-pre-training.md`](./continual-pre-training.md) · [`post-training.md`](./post-training.md)

A cross-stage index of widely-used datasets and their data preparation workflows, with direct links to arXiv / Hugging Face / project pages.

Columns: **Domain / Task · Data Workflow Detail · Size · Time · Stage**

---

## Table of Contents

- [Pre-training (PT)](#pre-training-pt)
- [Continual Pre-training (CPT)](#continual-pre-training-cpt)
- [Post-training (SFT / RLHF / Eval)](#post-training-sft--rlhf--eval)
- [Recommended Starter Kit](#recommended-starter-kit)
- [Workflow patterns & cautions](#workflow-patterns--cautions)

---

## Pre-training (PT)

### General web

| Dataset | Workflow detail | Size | Year |
|---|---|---|---|
| [**FineWeb**](https://huggingface.co/datasets/HuggingFaceFW/fineweb) | Crawl CC → text extraction → lang detect → quality filter → dedup → PII handling | ~18.5T tokens (v1.4) | 2024 |
| [**RefinedWeb**](https://huggingface.co/datasets/tiiuae/falcon-refinedweb) | CC only; heavy cleaning + dedup; public research extract | 600B tokens | 2023 |
| [**RedPajama-Data-1T**](https://huggingface.co/datasets/togethercomputer/RedPajama-Data-1T) | Recreate LLaMA mix (web, code, arXiv, Wiki, SE) → clean → dedup | ~1.2T tokens | 2023 |
| [**RedPajama-Data-V2**](https://huggingface.co/datasets/togethercomputer/RedPajama-Data-V2) | 80+ CC snapshots + 40+ quality signals; deduplicated pool | 30T+ tokens | 2023 |
| [**The Pile**](https://pile.eleuther.ai/) | 22 curated sources → cleaning → dedup → mixture spec | ~825 GiB | 2020 |
| [**C4**](https://huggingface.co/datasets/allenai/c4) | From CC → English detection → heuristic cleaning → dedup | ~807 GiB (en) | 2019 |
| [**Dolma**](https://huggingface.co/datasets/allenai/dolma) | Combine multiple sources → clean → dedup → safety filters | 3T tokens | 2023 |
| [**DataComp-LM**](https://huggingface.co/datasets/mlfoundations/dclm-pool-400m-1x) | Standardized pool + recipes + benchmark for data-centric comparisons | 240T tokens | 2024 |
| [**Zyda-2**](https://huggingface.co/datasets/Zyphra/Zyda-2) | Cross-source deduplication + model-based filtering | 5T tokens | 2024 |
| [**Nemotron-CC v2**](https://huggingface.co/datasets/nvidia/Nemotron-CC-v2) | Multi-CC snapshots (2024–25) → English filter → synthetic rephrasing (LLM) → global dedup; includes Diverse QA (15-lang translations) | ~6.586T tokens | 2025 |

### Multilingual

| Dataset | Workflow detail | Size | Year |
|---|---|---|---|
| [**ROOTS (BigScience)**](https://huggingface.co/bigscience-data) | 59 languages; ethics/licensing review → cleaning → dedup | 1.6 TB | 2022 |
| [**CulturaX**](https://huggingface.co/datasets/uonlp/CulturaX) | 167 languages; lang ID → filters → dedup → per-language release | 6.3T tokens | 2023 |
| [**HPLT v2**](https://hplt-project.org/datasets/v2.0) | CC + Internet Archive → quality filters → dedup → CC0 release | ~8T tokens; 193 langs | 2025 |
| [**GlotCC**](https://huggingface.co/datasets/cis-lmu/GlotCC-V1) | Broad language coverage with low-resource emphasis | 1000+ langs | 2024 |

### Code

| Dataset | Workflow detail | Size | Year |
|---|---|---|---|
| [**The Stack v2**](https://huggingface.co/datasets/bigcode/the-stack-v2) | From Software Heritage → license/lang detect → filter + dedup → repo splits | 67.5 TB raw / ~900B tokens | 2024 |
| [**The Stack (v1)**](https://huggingface.co/datasets/bigcode/the-stack) | Earlier version; Git commit-hash dedup | ~3 TB | 2022 |

### Math

| Dataset | Workflow detail | Size | Year |
|---|---|---|---|
| [**OpenWebMath**](https://huggingface.co/datasets/open-web-math/open-web-math) | Identify math-heavy pages → clean boilerplate → math-aware filter → dedup | 14.7B tokens | 2023 |

---

## Continual Pre-training (CPT)

| Dataset | Workflow detail | Size | Year |
|---|---|---|---|
| [**EMMA-500 / MaLA corpus**](https://huggingface.co/collections/MaLA-LM/mala-corpus-66e05127641a51de34d39529) | Compile & curate MaLA across 546 langs → heavy cleaning/dedup → CPT of Llama-2-7B; corpus & weights released | >74B tokens; 546 langs | 2024–25 |
| [**AURORA-M**](https://huggingface.co/aurora-m/datasets) | Two-stage CPT: CAP on multilingual web/code (processed) + CAT alignment mix; human-reviewed safety red-teaming | 435B tokens | 2024 |
| [**Nemotron-MIND**](https://huggingface.co/datasets/nvidia/Nemotron-MIND) | Convert OpenWebMath math text → multi-style synthetic dialogues (7 styles) → heuristic filtering → CPT 7B models | >138B tokens | 2025 |
| [**YuLan-Mini Datasets**](https://huggingface.co/datasets/yulan-team/YuLan-Mini-Datasets) | Open pre-training resources (cleaning, schedule/annealing, curated + synthetic math/code) with per-phase composition detailed | 1.08T tokens | 2024–25 |
| [**MegaMath-Web-Pro-Max**](https://huggingface.co/datasets/OctoThinker/MegaMath-Web-Pro-Max) | CC math-heavy pages → math/quality scoring (math_score, finemath_score, lang_score) → language detect & filters → global dedup → structured Parquet | 69.2M rows | 2025 |

---

## Post-training (SFT / RLHF / Eval)

### General instruction & chat

| Dataset | Workflow detail | Size | Year | Stage |
|---|---|---|---|---|
| [**Infinity-Instruct**](https://huggingface.co/datasets/BAAI/Infinity-Instruct) | Phase-1: curate foundational instructions from >100M pool via hybrid selection & dedup → Phase-2: synthesize chat instructions via instruction evolution → diagnostic filtering → formatting | 7.4M (foundational) + 1.5M (chat) | 2025 | SFT |
| [**OpenHermes 2.5**](https://huggingface.co/datasets/teknium/OpenHermes-2.5) | Compile open instruction/chat sets + GPT-4-distilled samples → cleaning/curation → deduplication → ShareGPT-style multi-turn formatting | ~1.0M samples | 2024 | SFT |
| [**ShareGPT**](https://huggingface.co/datasets/RyokoAI/ShareGPT52K) | User-shared ChatGPT conversations from ShareGPT.com → HTML-to-Markdown → cleaning & safety filtering → dedup → multi-turn formatting | ~90K conversations | 2023 | SFT/RLHF |
| [**Open-Assistant (oasst)**](https://huggingface.co/datasets/OpenAssistant/oasst1) | Crowdsourced multi-turn conversations with quality votes | 161K conversations | 2023 | SFT |
| [**Aya Dataset**](https://huggingface.co/datasets/CohereForAI/aya_dataset) | Multilingual crowdsourced instruction data via Aya Platform | 204K examples, 65 langs | 2024 | SFT |
| [**Alpaca (cleaned)**](https://huggingface.co/datasets/yahma/alpaca-cleaned) | Self-Instruct style generations via text-davinci-003 | 52K | 2023 | SFT |
| [**WizardLM Evol-Instruct**](https://huggingface.co/datasets/WizardLM/WizardLM_evol_instruct_V2_196k) | Iterative complexity evolution | 196K | 2023 | SFT |

### Math & reasoning

| Dataset | Workflow detail | Size | Year | Stage |
|---|---|---|---|---|
| [**OpenMathInstruct-2**](https://huggingface.co/datasets/nvidia/OpenMathInstruct-2) | Seed from GSM8K/MATH → Llama-3.1-405B teacher gen → format/length control → light filtering | 14M pairs | 2024 | SFT |
| [**NuminaMath-CoT**](https://huggingface.co/datasets/AI-MO/NuminaMath-CoT) | Competition problems scraping → CoT templating → normalization → filtering | ~860K pairs | 2024 | SFT |
| [**Omni-MATH**](https://huggingface.co/datasets/KbsdJames/Omni-MATH) | Olympiad problems curated → taxonomy/difficulty labels → formatting | 4,428 problems | 2024 | Eval |
| [**MATH**](https://github.com/hendrycks/math) | Hand-picked competition problems with step-by-step solutions | 12,500 problems | 2021 | Eval/SFT |
| [**GSM8K**](https://huggingface.co/datasets/openai/gsm8k) | Grade-school word problems with annotated step solutions | 8,500 | 2021 | Eval/SFT |
| [**SYNTHETIC-1**](https://huggingface.co/datasets/PrimeIntellect/SYNTHETIC-1) | DeepSeek-R1 generation → crowdsourced compute → verifier checks (LLM/symbolic) → filtered splits | ≥1.4M tasks | 2025 | SFT |

### Code & software engineering

| Dataset | Workflow detail | Size | Year | Stage |
|---|---|---|---|---|
| [**EpiCoder-func-380k**](https://huggingface.co/datasets/microsoft/EpiCoder-func-380k) | Instruction synthesis → function-level code (Python) → diversity/complexity curation → cleaning | 380K | 2025 | SFT |
| [**KodCode-V1**](https://huggingface.co/datasets/KodCode/KodCode-V1) | Synthetic tasks → verifiable solutions+unit tests → auto-eval → dedup → multi-style (Instruct/Complete/OJ) | 487K items | 2025 | SFT/RLHF |
| [**HumanEval**](https://huggingface.co/datasets/openai/openai_humaneval) | Hand-written Python functions with test cases | 164 | 2021 | Eval |
| [**MBPP**](https://huggingface.co/datasets/google-research-datasets/mbpp) | Basic Python programming problems | 974 | 2021 | Eval |
| [**SWE-bench**](https://www.swebench.com/) | Real GitHub issues requiring multi-file code edits | 2,294 | 2023 | Eval |
| [**SWE-bench Verified**](https://huggingface.co/datasets/princeton-nlp/SWE-bench_Verified) | GitHub issues → human-validated solvable subset → unit-test verification protocol | 500 | 2024 | Eval |

### Science, tool-use, agents

| Dataset | Workflow detail | Size | Year | Stage |
|---|---|---|---|---|
| [**ScienceQA**](https://scienceqa.github.io/) | K-12 science multimodal MCQ with rationale/explanation annotations | 21,208 | 2022 | Eval/SFT |
| [**ToolBench (ToolLLM)**](https://github.com/OpenBMB/ToolBench) | Crawl 16,464 REST APIs → LLM-generated single/multi-tool instructions → automatic evaluation & denoising | 16K+ APIs | 2023 | SFT |
| [**WebWalkerQA**](https://huggingface.co/datasets/callanwu/WebWalkerQA) | Curated deep multi-hop site tasks → QAs with gold navigation paths → bilingual (EN/ZH) | 680 QAs | 2025 | Eval |

### Preference & alignment

| Dataset | Workflow detail | Size | Year | Stage |
|---|---|---|---|---|
| [**Anthropic HH-RLHF**](https://huggingface.co/datasets/Anthropic/hh-rlhf) | Crowdsourced pairwise helpful/harmless preferences | 170K pairs | 2022 | RLHF |
| [**UltraFeedback**](https://huggingface.co/datasets/openbmb/UltraFeedback) | Multi-aspect GPT-4 judged preference data | 64K prompts, 256K pairs | 2023 | RLHF/DPO |
| [**RewardBench**](https://huggingface.co/datasets/allenai/reward-bench) | Evaluation set for reward models across categories | ~3K examples | 2024 | Eval (RM) |
| [**PKU-SafeRLHF**](https://huggingface.co/datasets/PKU-Alignment/PKU-SafeRLHF) | Safety-focused preference data | 300K+ pairs | 2023 | RLHF |

---

## Recommended Starter Kit

If you are building your first LLM data pipeline, start by downloading these:

1. **One general corpus** — **FineWeb** or **RedPajama-V2**.
2. **One reproducible mixture** — **DCLM** or **HPLTv2**.
3. **One specialized set** — **OpenWebMath** or **The Stack v2**.
4. **One CPT refresh** — **Nemotron-CC v2** or **AURORA-M**.
5. **Post-training set** — **Infinity-Instruct** (general) + **OpenMathInstruct-2** (math) + **KodCode-V1** (code).
6. **Benchmarks** — **Omni-MATH**, **SWE-bench Verified**, **ScienceQA**.

This covers coverage, reproducibility, specialization, freshness, SFT, and evaluation.

---

## Workflow patterns & cautions

**Common steps across pre-training and CPT.**
1. Large-scale crawling or standardized mixtures for reproducibility.
2. Filtering against harmful content, social bias, redundancy, contamination, quality/format.
3. Enrichment with domain / multilingual / synthetic data.
4. Structured reformatting (chapters, tables, equations preserved).

**Common steps across post-training.**
1. Seed selection (hybrid heuristics + embedding retrieval).
2. Synthetic generation with strong teacher models and verifiable signals.
3. Structured formatting (role tags, length/step control, schema normalization).
4. Safety filtering + dedup + small-scale human validation.

**Cautions.**
- **Contamination.** Always screen training data against eval sets, especially for benchmarks like SWE-bench (see *SWE-bench+* [Aleithan et al., 2024](https://arxiv.org/abs/2410.06992) and *SWE-bench illusion* [Liang et al., 2025](https://arxiv.org/abs/2506.12286)).
- **Licensing.** Stick to permissively-licensed corpora when downstream redistribution matters (Common Corpus; Stack v2 license detect).
- **Near-duplicate memorization.** Fuzzy dedup is necessary but not sufficient — see *Mosaic Memory*.
- **Cache hot topics.** Reproducibility tools (Dolma, RedPajama-V2) are preferred over one-off pipelines for research comparisons.
