# doe-pharma 🧪

[![R](https://img.shields.io/badge/R-4.0%2B-blue?logo=r)](https://www.r-project.org/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.xxxx/xxxxxx.svg)](https://doi.org/10.xxxx/xxxxxx) *(opcional)*

**Design e análise de experimentos para validação de processos industriais na indústria farmacêutica e de manufatura.**

`doe-pharma` é um conjunto de funções em R para planejar, analisar e interpretar **experimentos de validação de processos** — como esterilização, mistura homogênea, secagem, filtração e outros — com foco em conformidade regulatória (ICH Q8, FDA 21 CFR Part 11, ISO 13485). Ao contrário da maioria dos pacotes de DOE no R, voltados para pesquisa acadêmica, este projeto é **especificamente desenhado para aplicações industriais reguladas**.

> 💡 **Diferencial**: Apesar da abundância de ferramentas de DOE em Python e R, **soluções voltadas para validação de processos na indústria farmacêutica são extremamente raras no GitHub**. Este projeto preenche essa lacuna com código reprodutível, transparente e auditável.

---

## 🎯 Principais funcionalidades

- ✅ **Planejamento de experimentos fatoriais fracionários** (`FrF2`) com controle de resolução.
- ✅ **Planejamento de superfície de resposta** (RSM/CCD) para otimização de processos.
- ✅ **Análise estatística robusta** com modelos lineares (`lm`) e diagnósticos de qualidade.
- ✅ **Codificação automática de fatores** como `-1` / `+1` (padrão da indústria).
- ✅ **Pronto para documentação regulatória**: saídas compatíveis com relatórios de validação.
