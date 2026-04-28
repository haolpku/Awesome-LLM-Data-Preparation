<div align="center">

# Awesome LLM Data Preparation · 大语言模型数据准备精选

<!-- TODO: 将 assets/cover.pdf 导出为 assets/cover.png 后替换下面的引用。
     GitHub Markdown 无法直接渲染 PDF。 -->
<!-- ![封面](assets/cover.png) -->

**系统梳理大语言模型（LLM）三阶段数据准备：预训练 → 持续预训练 → 后训练。**

*把原始文本变成可训练信号：收集 → 过滤 → 生成 → 评估。*

<p>
  <a href="https://github.com/haolpku/Awesome-LLM-Data-Preparation/stargazers"><img src="https://img.shields.io/github/stars/haolpku/Awesome-LLM-Data-Preparation?style=for-the-badge&logo=github&color=FFD700" alt="Stars"></a>
  <a href="https://github.com/haolpku/Awesome-LLM-Data-Preparation/network/members"><img src="https://img.shields.io/github/forks/haolpku/Awesome-LLM-Data-Preparation?style=for-the-badge&logo=github&color=8A2BE2" alt="Forks"></a>
  <a href="https://github.com/haolpku/Awesome-LLM-Data-Preparation/issues"><img src="https://img.shields.io/github/issues/haolpku/Awesome-LLM-Data-Preparation?style=for-the-badge&color=critical" alt="Issues"></a>
  <a href="https://github.com/haolpku/Awesome-LLM-Data-Preparation/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-CC--BY--4.0-green?style=for-the-badge" alt="License"></a>
  <a href="https://awesome.re"><img src="https://awesome.re/badge-flat2.svg" alt="Awesome"></a>
</p>

<p>
  <a href="./README.md">🇬🇧 English README</a> ·
  <a href="./papers/pre-training.md">📘 预训练论文清单</a> ·
  <a href="./papers/continual-pre-training.md">📗 持续预训练清单</a> ·
  <a href="./papers/post-training.md">📙 后训练清单</a> ·
  <a href="./papers/datasets.md">📚 数据集总表</a>
</p>

</div>

---

## 🔥 最新动态

- **2025.10** — v0.1 发布，配合 JCST 审稿中的综述论文《Data Preparation for Large Language Models》。
- **2025.10** — arXiv 预印本：*即将公开*。<!-- TODO: arXiv 链接公布后替换此处。 -->
- 欢迎提交 **PR**（补新论文 / 数据集 / 工作流），见 [贡献指南](#-如何贡献)。⭐ Star 本仓库第一时间追更。

---

## 💡 为什么做这个仓库？

LLM 正从 **模型为中心** 走向 **数据为中心**。架构的边际收益在收敛，但数据 *质量、覆盖、准备流水线* 正在成为决定能力、安全性和算力效率的瓶颈。

市面上关于 LLM 训练的资源已经很多，但把 **数据准备本身** 作为一级主题的并不多。本仓库配合我们的综述，旨在做到：

1. **给出清晰分类体系** —— 明确区分 *算子*（dedup / filter / score / rephrase…）与 *工作流*（如何组合成 FineWeb / Dolma / OpenMathInstruct / Infinity-Instruct 风格的流水线）。
2. **足够实用** —— 论文尽量附上 code / HF / dataset 链接，从读文献到开炼丹只有一步。
3. **持续更新** —— 数据准备领域月变，我们会快速 review PR。
4. **降低入门门槛** —— 三份阶段子页（PT / CPT / Post-train）让新人一个下午上手。

> 💬 **如果本仓库帮到你，请给个 ⭐ — 这是最有效的鼓励，也是我们持续维护的动力。**

---

## 🗺️ 总览分类

<!-- TODO: 将 assets/structure.pdf 导出为 assets/structure.png 后替换下面的引用。 -->
<!-- <p align="center"><img src="assets/structure.png" width="88%" /></p> -->

我们用两个维度组织整个领域：

- **训练阶段**：预训练 → 持续预训练 → 后训练（SFT / RL / RLHF）。
- **数据操作**：收集 → 过滤 → 生成 → 评估 → 工作流。

| 阶段 | 典型规模 | 单样本成本 | 过滤风格 | 主要目标 |
|---|---|---|---|---|
| **预训练 PT** | 10⁹ – 10¹² tokens | 低 | 启发式 + 可扩展 | 广覆盖与多样性 |
| **持续预训练 CPT** | 10⁷ – 10⁹ tokens | 中 | 混合 | 时效性与领域适配 |
| **后训练 SFT/RLHF** | 10³ – 10⁶ samples | 高 | 细粒度且严格 | 对齐与任务能力 |

**经验法则：** 粗到细的流水线最优 —— 便宜的规则先把明显的低质扔掉，再用模型级算子把算力集中在剩下的高价值样本上。预训练重吞吐量，后训练重单样本质量。

---

## 📖 目录

- [为什么做这个仓库？](#-为什么做这个仓库)
- [总览分类](#️-总览分类)
- [预训练数据准备](#-预训练数据准备)
- [持续预训练数据准备](#-持续预训练数据准备)
- [后训练数据准备](#-后训练数据准备)
- [数据集清单](#-数据集清单)
- [系统与工具](#-系统与工具)
- [相关综述](#-相关综述)
- [如何贡献](#-如何贡献)
- [引用](#-引用)
- [Star 历史](#-star-历史)
- [作者与联系方式](#-作者与联系方式)

---

## 🧱 预训练数据准备

> 完整论文清单见 [`papers/pre-training.md`](./papers/pre-training.md)

预训练数据准备大致经过了三个时代：

<blockquote>
<b>规模导向的爬取</b>（2019–2021） → <b>可复现的混合配方</b>（2022–2024） → <b>能力导向的精细增强</b>（2024–今）。
</blockquote>

三句话概括：*"全都要"* → *"负责任地精挑并公开配方"* → *"针对能力/领域做精细增强，同时注意许可与基准污染"*。

### 数据收集

- **规模导向爬取**：CCNet、WebText、C4、ClueWeb22、CulturaX（167 语言）、GlotCC。
- **可复现混合**：RedPajama-Data V2（80+ CC 快照 + 40+ 质量信号）、Dolma（3T token + 工具包）、FineWeb / FineWeb-Edu、Common Corpus（许可友好）、DataComp-LM（240T + 标准评测）。
- **能力导向增强**：The Stack v2 / StarCoder2（600+ 语言代码）、OpenWebMath（保留 LaTeX）、OpenMathInstruct-2、MegaMath（371B）、PMC-LLaMA / Me-LLaMA / Biomed-Enriched（生物医学）。

### 数据过滤

从四个维度展开：

- **敏感与有害内容**：PII（正则 / 词典 / Presidio / spaCy / BERT-NER），毒性（FastText / BERT 毒性 / Perspective API / URL 黑名单）。
- **偏见与公平**：CDA / CDS、触发短语 LM 打分。
- **冗余与污染**：
  - *精确去重*：MD5/SHA + Bloom Filter（CCNet / Dolma / RedPajama-V2），`EXACTSUBSTR` 后缀数组 50+ token 子串。
  - *模糊去重*：**MinHash-LSH**（GPT-3 / The Pile / Gopher / RefinedWeb / SlimPajama / RedPajama-V2）、**SimHash**、TLSH、TF-IDF、Levenshtein。
  - *近期进展*：**SoftDedup**、**LSHBloom**、Mosaic Memory 局限性研究。
  - *模型级*：**SemDeDup**、**D4**、噪声鲁棒双编码器+交叉编码器、**GenDedup**。
  - *污染检查*：GPT-3 用 13-gram，PaLM 8-gram 70% 重合，LLaMA-2 10+ token 重合。
- **语言/格式/质量**：fastText-LID、Trafilatura / Boilerpipe 抽正文；perplexity（KenLM）与分类器（GPT-3 二分类、**Ultra-FineWeb**、**FinerWeb-10BT**、**JQL**（35 语种 LLM-as-judge）、**QuaDMix**（质量-多样性联合优化））。

---

## 🔄 持续预训练数据准备

> 完整清单见 [`papers/continual-pre-training.md`](./papers/continual-pre-training.md)

CPT 的关键矛盾：**注入新知识（领域 / 语言 / 时间）同时不造成灾难性遗忘。**

- **领域语料**：FinPythia-6.9B（金融）、PMC-LLaMA、Me-LLaMA（129B 生物医学 + 指令）。
- **语种扩展**：120B Portuguese CPT、**Glot500**、**EMMA-500**（MaLA，546 语种）、**Sailor**、**AURORA-M**（435B，两阶段 + 人审安全）。
- **时效更新**：**TemporalWiki**、**Nemotron-CC v2**（多快照 + LLM 改写）、**NeuScraper**。
- **过滤策略**：LADM（长依赖选样）、体裁/领域分类、近收敛 checkpoint 的模型导向过滤（Ultra-FineWeb）。
- **评估策略**：相似度打分、curriculum 中的领域顺序效应（Yildiz 2024）、代理模型验证（Wang 2025、Chen 2024、AstroMLab-2）。
- **生成策略**：原文改写（WRAP / YuLan-Mini / Phi-4）、推理增强（**Reasoning CPT**、**EntiGraph**、**MIND**）、领域扩展（**TRAIT**、**MachineLearningLM**）。

---

## 🎯 后训练数据准备

> 完整清单见 [`papers/post-training.md`](./papers/post-training.md)

### SFT

- **数据收集**：现成 NLP 语料（FLAN、T0、LIMA）、人工标注（Free Dolly、Open-Assistant、Aya、OL-CC）、LLM 生成（Vicuna/ShareGPT、Instruction Wild、**WebR**、**BARE**）。
- **数据过滤**：**Repairity**（去掉低质推理轨迹）、step-wise 错误率过滤、**TFP**（打包阈值）。
- **数据评估 / 选样**：
  - *Coreset*：k-center、submodular、sensitivity、**D3**、**Influence**。
  - *LLM-based*：**GPTScore**、**MoDS**、**SelectLLM**、Self-Refine。
  - *Gradient-based*：**EL2U**、**LESS**、**LoGra**、**QLESS**。
  - *Self-Instruction*：**IFD**、**Cherry**、**Active Instruction Tuning**、**SelectIT**。
- **数据生成**：按任务类型（生成/QA/推理/NLU/对话）统一成 (instruction, response) 格式。
- **工作流** ：Corpus-to-Instruction / 人工标注 / LLM 合成 / 对话+过程监督 / 统一系统（[**DataFlow**](https://github.com/OpenDCAI/DataFlow)）。

### 可验证奖励的 RL

- **离线难度过滤**：采样 k 次 rollout，保留 pass-rate ∈ [0.2, 0.8] 的 prompt（DAPO 等 RLVR）。
- **在线难度过滤**：**GRPO** 训练中实时估计 pass-rate，[Bae et al. 2025](https://arxiv.org/abs/2504.03380) 给出理论/经验，AIME 上最多 +10pp。
- **可验证奖励**：boxed 答案、单元测试、编译/运行、符号验证器。

### RLHF / RLAIF

- **收集**：成对 / 排序偏好；自然语言批评-修订（Jin 2023）；与代理模型混合降成本。
- **过滤**：标注一致性、金标校准、margin 过滤、困难样本主动标注（**RL-THF**）。
- **评估**：**RewardBench**、**IC-RM**（轨迹内一致性）、**ALaRM**（层次评估）、RM 质量影响研究。
- **AI 反馈生成**：**Constitutional AI**、**RLAIF**（含 d-RLAIF）、**Self-Rewarding LM**；LLM-as-judge 的偏差校正（成对 / rubric / 多评委聚合）。

---

## 📚 数据集清单

> 完整表格见 [`papers/datasets.md`](./papers/datasets.md)

### 预训练 / CPT（节选）

| 数据集 | 领域 | 规模 | 年份 | 阶段 |
|---|---|---|---|---|
| [FineWeb](https://huggingface.co/datasets/HuggingFaceFW/fineweb) | 通用网页 | ~18.5T tokens | 2024 | PT |
| [RefinedWeb](https://huggingface.co/datasets/tiiuae/falcon-refinedweb) | 通用网页 | 600B tokens | 2023 | PT |
| [RedPajama-Data-1T](https://huggingface.co/datasets/togethercomputer/RedPajama-Data-1T) | LLaMA 混合 | ~1.2T tokens | 2023 | PT |
| [The Pile](https://pile.eleuther.ai/) | 通用英文 | ~825 GiB | 2020 | PT |
| [C4](https://huggingface.co/datasets/allenai/c4) | 通用网页 | ~807 GiB | 2019 | PT |
| [ROOTS](https://huggingface.co/bigscience-data) | 59 语种 | 1.6 TB | 2022 | PT |
| [CulturaX](https://huggingface.co/datasets/uonlp/CulturaX) | 167 语种 | 6.3T tokens | 2023 | PT |
| [HPLT v2](https://hplt-project.org/datasets/v2.0) | 193 语种 | ~8T tokens | 2025 | PT |
| [Dolma](https://huggingface.co/datasets/allenai/dolma) | 混合 | 3T tokens | 2023 | PT |
| [The Stack v2](https://huggingface.co/datasets/bigcode/the-stack-v2) | 代码 | ~900B tokens | 2024 | PT |
| [OpenWebMath](https://huggingface.co/datasets/open-web-math/open-web-math) | 数学 | 14.7B tokens | 2023 | PT |
| [EMMA-500 / MaLA](https://huggingface.co/collections/MaLA-LM/mala-corpus-66e05127641a51de34d39529) | 546 语种 | >74B tokens | 2024–25 | CPT |
| [AURORA-M](https://huggingface.co/aurora-m/datasets) | 多语 + 代码 | 435B tokens | 2024 | CPT |
| [Nemotron-CC v2](https://huggingface.co/datasets/nvidia/Nemotron-CC-v2) | 通用网页 | ~6.586T tokens | 2025 | PT/CPT |
| [Nemotron-MIND](https://huggingface.co/datasets/nvidia/Nemotron-MIND) | 数学 | >138B tokens | 2025 | CPT |
| [YuLan-Mini](https://huggingface.co/datasets/yulan-team/YuLan-Mini-Datasets) | 代码/数学/科学 | 1.08T tokens | 2024–25 | PT |
| [MegaMath-Web-Pro-Max](https://huggingface.co/datasets/OctoThinker/MegaMath-Web-Pro-Max) | 数学 | 69.2M 行 | 2025 | CPT |

### 后训练（节选）

| 数据集 | 领域 | 规模 | 年份 | 阶段 |
|---|---|---|---|---|
| [Infinity-Instruct](https://huggingface.co/datasets/BAAI/Infinity-Instruct) | 指令 & 对话 | 7.4M + 1.5M | 2025 | SFT |
| [OpenHermes 2.5](https://huggingface.co/datasets/teknium/OpenHermes-2.5) | 指令 & 对话 | ~1.0M | 2024 | SFT |
| [ShareGPT](https://huggingface.co/datasets/RyokoAI/ShareGPT52K) | 对话 | ~90K | 2023 | SFT/RLHF |
| [OpenMathInstruct-2](https://huggingface.co/datasets/nvidia/OpenMathInstruct-2) | 数学指令 | 14M pairs | 2024 | SFT |
| [NuminaMath-CoT](https://huggingface.co/datasets/AI-MO/NuminaMath-CoT) | 数学推理 | ~860K | 2024 | SFT |
| [Omni-MATH](https://huggingface.co/datasets/KbsdJames/Omni-MATH) | 数学评测 | 4,428 | 2024 | Eval |
| [SYNTHETIC-1](https://huggingface.co/datasets/PrimeIntellect/SYNTHETIC-1) | 通用推理 | ≥1.4M | 2025 | SFT |
| [EpiCoder-func-380k](https://huggingface.co/datasets/microsoft/EpiCoder-func-380k) | 代码/函数级 | 380K | 2025 | SFT |
| [KodCode-V1](https://huggingface.co/datasets/KodCode/KodCode-V1) | 代码 / RL | 487K | 2025 | SFT/RLHF |
| [SWE-bench Verified](https://huggingface.co/datasets/princeton-nlp/SWE-bench_Verified) | 软件工程 | 500 | 2024 | Eval |
| [ScienceQA](https://scienceqa.github.io/) | 科学 QA | 21,208 | 2022 | Eval/SFT |
| [ToolBench](https://github.com/OpenBMB/ToolBench) | 工具使用 | 16K+ APIs | 2023 | SFT |
| [WebWalkerQA](https://huggingface.co/datasets/callanwu/WebWalkerQA) | 网页智能体 | 680 QAs | 2025 | Eval |

### 起步推荐套装

1. 一份通用语料：**FineWeb** 或 **RedPajama-V2**。
2. 一份可复现混合：**DCLM** 或 **HPLTv2**。
3. 一份垂类：**OpenWebMath** 或 **The Stack v2**。
4. 一份 CPT 刷新：**Nemotron-CC v2** 或 **AURORA-M**。
5. 一组后训练：**Infinity-Instruct** + **OpenMathInstruct-2** + **KodCode-V1**。
6. 迭代评测：**Omni-MATH** + **SWE-bench Verified** + **ScienceQA**。

---

## 🛠 系统与工具

- [**DataFlow**](https://github.com/OpenDCAI/DataFlow) — 可组合算子的数据全生命周期框架（作者团队）。
- [**Data-Juicer**](https://github.com/modelscope/data-juicer) — 可扩展的 LLM 数据处理。
- [**NeMo Curator**](https://github.com/NVIDIA/NeMo-Curator) — GPU 加速，支持网页规模。
- [**Dolma Toolkit**](https://github.com/allenai/dolma) — Dolma 对应的模块化工具包。
- [**MinerU**](https://github.com/opendatalab/MinerU) — PDF → Markdown/JSON，保留公式/代码/表格。
- [**Trafilatura**](https://github.com/adbar/trafilatura) / [**Boilerpipe**](https://github.com/kohlschutter/boilerpipe) — 正文抽取。
- [**Presidio**](https://github.com/microsoft/presidio) — PII 检测与脱敏。

---

## 📎 相关综述

见 [`papers/surveys.md`](./papers/surveys.md)。

---

## 🤝 如何贡献

- 最快方式：用 [*Add a paper*](./.github/ISSUE_TEMPLATE/add-paper.yml) issue 模板告诉我们论文标题、年份、会议、一句话贡献 —— 我们来加。
- 也欢迎直接 PR 修改 [`papers/`](./papers) 下的对应文件，格式见 [`CONTRIBUTING.md`](./CONTRIBUTING.md)。

**请注明这篇论文对应的数据准备算子/阶段** —— 这是本清单相对通用 LLM 清单的核心价值。

---

## 📄 引用

如果本综述或本仓库对你有帮助，请引用：

```bibtex
@article{liang2025dataprep,
  title   = {Data Preparation for Large Language Models},
  author  = {Liang, Hao and Wong, Zhen Hao and Liu, Ruitong and Wang, Yuhan and
             Qiang, Meiyi and Zhao, Zhengyang and Shen, Chengyu and He, Conghui and
             Zhang, Wentao and Cui, Bin},
  journal = {Journal of Computer Science and Technology (JCST)},
  year    = {2025},
  note    = {Survey}
}
```

---

## 📈 Star 历史

<a href="https://star-history.com/#haolpku/Awesome-LLM-Data-Preparation&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=haolpku/Awesome-LLM-Data-Preparation&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=haolpku/Awesome-LLM-Data-Preparation&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=haolpku/Awesome-LLM-Data-Preparation&type=Date" />
  </picture>
</a>

---

## 👥 作者与联系方式

本仓库作者来自 **北京大学**、**北京中关村学院** 与 **上海人工智能实验室**。

- **梁昊 (Hao Liang)** — hao.liang@stu.pku.edu.cn
- **黄钲浩 (Zhen Hao Wong)** — zhenhao1141@stu.pku.edu.cn
- **刘芮彤、王宇涵、强美伊、赵正阳、申程宇**
- **何聪辉 (Conghui He)**，上海人工智能实验室
- **张文涛 (Wentao Zhang)** — wentao.zhang@pku.edu.cn
- **崔斌 (Bin Cui)**，通讯作者 — bin.cui@pku.edu.cn

> 发现漏洞、缺失论文或失效链接？[提 issue](../../issues) 即可，我们会看。

---

<div align="center">

**如果本仓库对你有帮助，欢迎点一个 ⭐ —— 这是我们持续维护的最大动力。**

*最近更新：2025-10。由综述作者团队维护。*

</div>
