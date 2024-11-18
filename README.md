# Wine Quality Analysis

This repository contains an exploratory analysis and classification model evaluation for the **Wine Quality** dataset, focusing on red wine samples from northern Portugal. The project aims to help winemakers, oenophiles, and sommeliers understand the key physical factors that determine wine quality.

---

## Dataset

The dataset used in this project, "Wine Quality," is available from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/wine+quality). It contains 1,599 observations of red wine samples, with 11 independent variables describing physicochemical properties and one dependent variable, **quality** (rated on a scale from 3 to 8).

### Features:
- **Fixed Acidity**: Tartaric acid (g/dm³).
- **Volatile Acidity**: Acetic acid (g/dm³).
- **Citric Acid**: (g/dm³).
- **Residual Sugar**: (g/dm³).
- **Chlorides**: Sodium chloride (g/dm³).
- **Free Sulfur Dioxide**: (mg/dm³).
- **Total Sulfur Dioxide**: (mg/dm³).
- **Density**: (g/cm³).
- **pH**: Acidity level (0–14).
- **Sulphates**: Potassium sulphate (g/dm³).
- **Alcohol**: (% by volume).
- **Quality**: Output variable/predictor (integer scale 3–8).

---

## Objectives

This project explores:
1. Which factors influence the quality of red wine the most.
2. Experimentation with different classification methods to determine the highest accuracy.
3. Recommendations for winemakers to improve wine quality.
4. Criteria to assist professionals in classifying wine quality effectively.

---

## Files in the Repository

- **README.md**: This file, providing an overview of the project.
- **Winequality.Rmd**: R Markdown file containing the full report, including code, analysis, and conclusions.
- **WinequalityAnalysis.pdf**: Full explanatory analysis in PDF format.
- **winequality_r.R**: Standalone R script with all the code used for the analysis.
  
---

## Getting Started

```bash
1. Clone the repository:
   git clone https://github.com/thaaoliveira1/wine-quality-r.git
   cd wine-quality-r

2. Download the dataset from UCI Repository:
   https://archive.ics.uci.edu/ml/datasets/wine+quality
   and place it in the project folder.

3. Use winequality_r.R to execute the code or open Winequality.Rmd for a step-by-step analysis.

```

The dataset was divided into:
- **Training Data** (60%): For building models.
- **Validation Data** (20%): For fine-tuning models.
- **Test Data** (20%): For evaluating model performance.

Multiple regression models were tested to understand how each physicochemical property influences wine quality.

Findings from this analysis include:
- Insights into which properties significantly impact wine quality.
- Evaluation of different classification models with their respective accuracy.
- Suggestions for improving the production process to achieve high-quality wines.

Please cite the dataset if used:
P. Cortez, A. Cerdeira, F. Almeida, T. Matos, and J. Reis. Modeling wine preferences by data mining from physicochemical properties. Decision Support Systems, Elsevier, 47(4):547-553, 2009.

