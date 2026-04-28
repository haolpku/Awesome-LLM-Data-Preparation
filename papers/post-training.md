# 📙 Post-training Data Preparation — Annotated Papers

> Back to [main README](../README.md) · [`pre-training.md`](./pre-training.md) · [`continual-pre-training.md`](./continual-pre-training.md) · [`datasets.md`](./datasets.md)

After PT + CPT a model is knowledgeable but unaligned. **Post-training** — SFT, RL with verifiable rewards, RLHF/RLAIF, and DPO-style offline preference optimization — turns that knowledge into a task-effective, human-aligned assistant. Data prep at this stage emphasizes **quality, task coverage, and safety**, not throughput.

---

## Table of Contents

- [SFT — Supervised Fine-Tuning](#sft--supervised-fine-tuning)
  - [Data Collection](#sft-data-collection)
  - [Data Filtering](#sft-data-filtering)
  - [Data Evaluation / Selection](#sft-data-evaluation--selection)
  - [Data Generation](#sft-data-generation-by-task)
  - [Workflow Patterns](#sft-workflow-patterns)
- [RL with Verifiable Rewards](#rl-with-verifiable-rewards)
- [RLHF / RLAIF](#rlhf--rlaif)

---

## SFT — Supervised Fine-Tuning

SFT is supervised learning on high-quality **(instruction, output)** pairs. Preparation has four steps: collection, filtering, evaluation, generation, plus a workflow that ties them together.

### SFT: Data Collection

Four families of sources.

**1. Existing NLP corpora.**
- **FLAN** / **T0** / **PromptSource** — systematic conversion of classic NLP datasets into instruction form. (Mishra et al. 2022; Wei et al., FLAN 2022; Sanh et al., T0 2022; Bach et al., PromptSource 2022.)
- **LIMA** — Zhou et al., 2023. 75% of 1000 prompts sampled from Stack Exchange / wikiHow. *Less is more for alignment.* [[arXiv]](https://arxiv.org/abs/2305.11206)

**2. Manually-constructed.**
- **Free Dolly** — Databricks, 2023. 15k English instructions, no external AI or web sources.
- **InstructGPT** — Ouyang et al., 2022. ~13k labeler-written prompts + demonstrations. [[arXiv]](https://arxiv.org/abs/2203.02155)
- **Open-Assistant** — Köpf et al., 2024. 161k conversations / 66k trees, 35 languages. [[arXiv]](https://arxiv.org/abs/2304.07327)
- **Aya** — Singh et al., 2024. Broad multilingual annotation via Aya Annotation Platform.
- **OL-CC** — OpenDataLab. First large open-source Chinese instruction set via crowdsourcing.

**3. LLM-generated.**
- **Self-Instruct** — Wang et al., 2023. Bootstrap off the model's own generations. [[arXiv]](https://arxiv.org/abs/2212.10560)
- **Alpaca** — Taori et al., 2023. 52k Self-Instruct-style demonstrations with `text-davinci-003`.
- **Evol-Instruct / WizardLM** — Xu et al., 2023. Rewrite prompts step-by-step into more complex ones via a dedicated evolving template. [[arXiv]](https://arxiv.org/abs/2304.12244)
- **Tree-Instruct** — Zhao et al., 2023. Systematically controls instruction complexity.
- **Baize** — Xu et al., 2023. *Self-Chat* pipeline using ChatGPT as both user and assistant.
- **Koala** — Geng et al., 2023. Fine-tuned on ChatGPT distillation + open data.
- **BELLE** — Ji et al., 2023. 1.5M Chinese instructions auto-generated with `text-davinci-003`.
- **Vicuna / ShareGPT** — 2023. ~70k ChatGPT-share conversations.
- **Instruction Wild** — 110k ChatGPT-share instructions, English + Chinese.

**4. Hybrid (web + LLM rewriting).**
- **WebR** — Zhu et al., 2025. Web reconstruction: identify candidate (instruction, response) pairs from raw webpages, then rewrite with strong generative models. [[paper]](https://arxiv.org/abs/2410.09180)
- **BARE** — 2025. Dual-model: base model ensures diversity, instruction-tuned model enhances authenticity.

### SFT: Data Filtering

Shared filters (language ID, dedup, safety) apply. SFT-specific ones target (instruction, response) quality:

- **Repairity** — Tang et al., 2025. Systematically filters low-quality reasoning traces; retains only high-quality samples.
- **Step-wise error-rate filtering** — He et al., 2025. Shows step-wise error rate on complex reasoning significantly affects model performance; remove samples with high logical error rates.
- **TFP** — Dong et al., 2025. Threshold filtering during SFT **packing**: filter out pairs with large contextual discrepancies in the packed window → improves efficiency *and* effectiveness.

### SFT: Data Evaluation / Selection

Small high-quality sets often outperform large noisy sets; hence the emphasis on *selection*.

#### Coreset-based

- **k-center / greedy** — Sener et al., 2017.
- **Submodular** — Kothawade et al., 2021; Wei et al., 2015.
- **Sensitivity-based importance** — Bachem et al., 2017; Feldman et al., 2011.
- **D3** — Zhang et al., 2025. Data-driven instruction selection.
- **Influence-based** — Nikdan et al., 2025.

#### LLM-as-evaluator

- **GPTScore** — Fu et al., 2023. Generative LLMs as scoring functions. [[arXiv]](https://arxiv.org/abs/2302.04166)
- **MoDS** — Du et al., 2023. Model-oriented data selection.
- **SelectLLM** — Parkar et al., 2024.
- **Self-Refine** — Madaan et al., 2023. Rewriting as implicit evaluation.
- **LLM-judge reliability** — Chu et al., 2024 (stylistic bias); He et al., 2025 (step-wise evaluation); Lee et al., 2025 (survey of reasoning-trace evaluation).

#### Gradient-based

- **EL2U** — Paul, 2021. Gradient norm of a sample.
- **Dynamic EL2U for multi-task NLP** — Attendu et al., 2023.
- **LESS** — Xia et al., 2024. Adam-compatible influence with a compressed gradient datastore. [[arXiv]](https://arxiv.org/abs/2402.04333)
- **LoGra** — Choe et al., 2024. Low-rank projection for memory-efficient influence.
- **QLESS** — Ananta et al., 2025. Quantized gradients + random projection on top of LESS.

#### Self-instruction-based

- **IFD / Quantity→Quality** — Li et al., 2023. Self-identified difficulty.
- **One-Shot / Cherry** — Li et al., 2023. Few-shot-based quality signal.
- **Active Instruction Tuning** — Kung et al., 2023. Task-level uncertainty from instruction perturbations.
- **SelectIT** — Liu et al., 2024. Token / sentence / model-level scoring cascade.

### SFT: Data Generation (by task)

| Task | Typical transformation |
|---|---|
| Generation & creative | (article, summary) → (article, prompt, summary); Reddit → writing prompts |
| QA & IE | (context, question, answer) triples; unified generative IE (**InstructUIE**) |
| Reasoning | CoT annotation; GSM8K, MATH, HumanEval, MBPP; **PAL**, **PoT**; process supervision (**BiRM**, **Diverse CoT**) |
| NLU / classification | GLUE / SuperGLUE → instruction-formatted; FLAN / T0 templates |
| Dialogue | (user turn, assistant turn) pairs from real logs; ShareGPT, Vicuna, InstructGPT |

**Representative recent works.**
- **BiRM** — Chen et al., 2025. Bidirectional process reward, also predicting probability of future success.
- **Diverse Chains of Thought (DCoT)** — Puerto et al., 2025. Multiple distinct chains within one reasoning pass, enabling self-correction.
- **PAL** — Gao et al., 2023. Program-aided reasoning. [[arXiv]](https://arxiv.org/abs/2211.10435)
- **PoT** — Chen et al., 2023. Program of thoughts. [[arXiv]](https://arxiv.org/abs/2211.12588)

### SFT: Workflow Patterns

1. **Corpus-to-Instruction.** Existing NLP data → cleaning/dedup → template conversion → quality filter → large structured set. (FLAN, T0)
2. **Human / Crowdsourced.** Task description + seed → annotators → adjudication → formatting/dedup → small high-quality set. (Open-Assistant, Aya, Free Dolly)
3. **LLM-Synthetic.** Seed → LLM generates (instruction, response) → automatic filter → human spot-check → large diverse set. (Self-Instruct, WizardLM, **InstructSkillMix**, **GLAN**)
4. **Dialogue + Process-Supervision.** Multi-turn logs → segmentation → role tags → optional process supervision → privacy/safety filter. (InstructGPT, CoT, **Baichuan2-Sum**, **SQATIN**, raw-text pipelines)
5. **Unified systems.** [**DataFlow**](https://github.com/OpenDCAI/DataFlow), Data-Juicer, NeMo Curator — composable operators and automated execution.

---

## RL with Verifiable Rewards

A central challenge: prompts that are *too easy* or *too hard* give no gradient signal under policy-gradient objectives. Data/difficulty-aware filtering is the fix.

### Offline difficulty filtering

- **Estimate** prompt pass-rate by sampling *k* rollouts under the current/reference policy with a task-specific verifier.
- **Retain** prompts with **p̂ ∈ [0.2, 0.8]**; downweight/remove extremes.
- Widely used in reasoning-focused RLVR (e.g., **DAPO** — [Yu et al., 2025](https://arxiv.org/abs/2503.14476)).

### Online difficulty filtering

- Under **GRPO** ([DeepSeekMath](https://arxiv.org/abs/2402.03300); [DeepSeek-R1](https://arxiv.org/abs/2501.12948)), track pass-rate from the group of rollouts that form the group-relative advantage.
- **Bae et al., 2025** — theoretical + empirical support for *balanced* online filtering: keep prompts whose pass-rate stays near the middle band; replace others via async sampling to keep batch size constant. Up to **+10pp on AIME** over plain GRPO with fewer steps. [[arXiv]](https://arxiv.org/abs/2504.03380)

### Verifiable rewards & reliability

- Enforce strict output formats: boxed answers, tags, compile/run checks → unambiguous correctness ([DeepSeek-R1](https://arxiv.org/abs/2501.12948)).
- **PF-PPO** — Zhang et al., 2024. Filter *responses* by regions where the reward model is empirically reliable; consistent gains on HumanEval/MBPP and harder LeetCode-Contest. Complements GRPO when neural rewards are used. [[arXiv]](https://arxiv.org/abs/2409.06957)

---

## RLHF / RLAIF

RLHF trains a reward model (RM) from human preferences, then optimizes the policy. The data pipeline is the single biggest reliability lever.

### Data Collection

- **Pairwise / ranked preferences** — InstructGPT pipeline. [[arXiv]](https://arxiv.org/abs/2203.02155)
- **Natural-language critiques and revisions** — Jin et al., 2023. Higher data efficiency than pairwise labels. [[arXiv]](https://arxiv.org/abs/2309.14317)
- **Sources.** Synthetic responses from diverse SFT/RL checkpoints; crowdsourced pairwise annotations with domain-specific guidelines; hybrid (limited human + proxy/heuristic) to reduce cost (Zhang et al., *Vickrey*, 2024).

### Data Filtering

- Inter-annotator agreement filtering.
- Calibration with gold-standard examples.
- Toxicity / factuality removal.
- Normalization & dedup; margin-based filtering of low-confidence pairs.
- **Filtered DPO / filtered RLHF** — Morimura et al., 2024. Remove pairs where annotated responses aren't clearly superior.
- **RL-THF** — Xu et al., 2025. Targeted annotation of *hard cases* to maximize budget utility. [[paper]](https://arxiv.org/abs/2503.13372)

### Data Evaluation

- **Inter-annotator agreement** — Dong et al., 2024.
- **Quality-weighted training** — Wang et al., 2024 (*reward learning from weighted preference pairs*).
- **Held-out preference prediction** — InstructGPT style validation.
- **Consistency across semantically similar prompts** — Shen et al., 2023 (*Trickle-Down*).
- **Hierarchical reward evaluation** — ALaRM (Lai et al., 2024).
- **Benchmarks.** [**RewardBench**](https://github.com/allenai/reward-bench) (Allen AI, 2024).
- **Intra-trajectory consistency** — IC-RM, 2025.
- **RM-quality impact analysis** — Liu et al., 2024 (*the Elephant*).

### Data Generation (RLAIF / AI feedback)

Replace / supplement human raters with AI signals.

- **Constitutional AI** — Bai et al., 2022. Critique-and-revise via principles; preference pairs and rewrites without human labels for safety. [[arXiv]](https://arxiv.org/abs/2212.08073)
- **RLAIF** — Lee et al., 2023. LLM-as-judge generates pairwise preferences / scalar rewards; *d-RLAIF* removes the RM entirely by querying the judge online. [[arXiv]](https://arxiv.org/abs/2309.00267)
- **Self-Rewarding LM** — Yuan et al., 2024. Policy produces its own rewards via LLM-as-judge prompting; improves both policy and internal judge through rounds of preference optimization. [[arXiv]](https://arxiv.org/abs/2401.10020)
- **LLM-as-a-judge reliability.** Pairwise over score-only, rubric-grounded prompts, multi-judge aggregation, meta-evaluation vs. human labels — Zheng et al., 2023; Gu et al., 2024.

### Canonical RLHF/RLAIF workflows

| Pipeline | Core idea | Notes |
|---|---|---|
| **InstructGPT** | SFT → sample k responses → human pairwise → RM → PPO with KL to ref | Classic, still a strong baseline |
| **Constitutional AI** | Principle-driven critique-and-revision + AI-generated preferences | Cuts label cost; explicit safety rubrics |
| **RLAIF / d-RLAIF** | LLM-as-judge produces labels or online rewards | Either train an RM for PPO or skip the RM |
| **DPO** | Offline preference optimization against a fixed reference | Needs careful filtering/dedup/domain-balanced sampling |
| **DeepSpeed-Chat** | Codified end-to-end pipeline (candidate gen, safety/format, pairwise labeling, calibration, iterative on-policy refresh) | Good engineering reference |

---

> 🙏 Want to add your post-training paper? **Send a PR** — see [`CONTRIBUTING.md`](../CONTRIBUTING.md).
