# Analyzing the Moses Illusion: A Data-Driven Study of Semantic Errors

## Overview
This project investigates the Moses illusion, a cognitive phenomenon in which individuals fail to notice an inconsistency or error in a question or statement, even when they know the correct information. 
A classic example is the question "How many animals of each kind did Moses take on the ark?", to which many respondents answer "two", despite knowing that it was Noah, and not Moses, who built the ark.

The project analyses response accuracy and response times across different question types, using descriptive statistics and statistical tests (confidence intervals, chi-square, logistic regression) to examine how often participants fall for the Moses illusion and how semantic distortions affect processing.

## Why This Project
This project demonstrates my ability to:
- Analyze experimental data related to language comprehension and cognition
- Apply statistical reasoning and exploratory data analysis to behavioral data 
- Handle data ethically by using a synthetic dataset for reproducibility
- Communicate results clearly through plots and a scientific poster

The Moses illusion is particularly relevant to computational linguistics, cognitive science, and NLP, as it highlights how humans process meaning shallowly when the surface structure appears familiar.

## Research Question
Did the participants fall for the illusion, or did they know the answer?

## Data
- Participants: 54
- Questions per participant: 41
- Conditions:
    - Illusion questions
    - Well-formed questions
    - Well-formed control questions
    - Bad control questions

### Data Availability and Ethics
The original dataset was collected as part of a university-run experiment and cannot be shared due to GDPR, data ownership and ethical contraints.

To ensure transparency and reproducibility, this repository includes a synthetic dataset that mirrors the structure and key statistical properties of the original data.
No real participant data is included.

## Data Cleaning and Preprocessing
Note: The synthetic dataset is already clean.

The steps below illustrate the preprocessing tha would be applied to the original experimental data.

- Giving descriptive names to variables for clarity
- Selecting relevant columns for analysis
- Removing missing values
- Filtering invalid or extreme response times
- Reordering factor levels for plotting
- Checking unique values and duplicates
- Identifying potential outliers

## Analysis and Key Results
- Data cleaning / preprocessing: Filtered extreme response times, removed missing values and checked duplicates
- Accuracy by question type (with 95% confidence intervals):
    - Illusion questions: ~22% correct (95% CI: 18–25%)
    - Well-formed questions: ~65% correct (95% CI: 61–69%)
    - Bad control: ~74% correct (95% CI: 74–81%)
- Chi-square test: Accuracy significantly differed by condition (χ² = 431.12, df = 6, p < 0.001)
- Logistic regression: Probability of a correct response differed significantly by condition; participants were much less likely to answer illusion questions correctly than other types
- Response times:
    - Fastest: well-formed questions (~4394 ms)
    - Slowest: well-formed control (~5261 ms)
    - Illusion and Bad control: intermediate
- Visualization: Bar plots show % correct and mean response times; confidence interval plot illustrate uncertainly around accuracy estimates 

The results illustrate the typical patterns of the Moses illusion and the analysis workflow using synthetic data.

## Outputs
- Reproducible R analysis scripts
- Synthetic dataset
- Plots summarizing accuracy, response times, and confidence intervals
- Scientific poster (PDF) summarizing the study

## Project Structure
- data/ - synthetic dataset (synthetic_moses.csv)
- scripts/ - data generation and analysis scripts
- plots/ - figures produced by the analysis
- poster/ - scientific poster (PDF) produced with LATEX

## Tools and Requirements
- Language: R
- Environment: RStudio
- Packages: tidyverse, binom, ggplot2

## Skills Demonstrated
- Experimental data analysis
- Data cleaning and preprocessing
- Statistical reasoning 
- Data visualization
- Reproducible research practices
- Ethical data handling (synthetic data)

## Author
Giorgia Sorrentino