#This analysis uses synthetic data generated to mimic the Moses illusion experiment.
#The synthetic data preserves overall structure and mean statistics but contains no real participants information.

##NOTE: The synthetic dataset is already clean, so preprocessing here is minimal.
#In the original dataset, additional steps were performed to identify outliers, 
#remove duplicate responses, handle missing values, and more. 
#These steps are omitted here because the synthetic data has been generated to mimic a clean dataset.


library(tidyverse)
library(binom)
library(ggplot2)

moses <- read.csv("data/synthetic_moses.csv")
head(moses)
#View(moses)
#2214 entries - 10 variables

length(unique(moses$ID)) #Finding n. of participants
#54

table(moses$ID) #Checking how many questions/answers per participant
#41

str(moses) #Checking data type of each column to see for any potential mistake

###Preprocessing###

moses_clean <-   moses |>
  filter(RESPONSE_TIME >= 200 & RESPONSE_TIME <= 20000) |>
  select(ID, ITEM, CONDITION, RESPONSE_TIME, LIST, TYPE, QUESTION, CORRECT_ANSWER, ANSWER_CLEAN, ACCURATE) |>
  na.omit()

#View(moses_clean)
any(duplicated(moses_clean)) #Checking for duplicates
nrow(moses_clean) #Checking number of valid entries

###Descriptive statistics###

moses_clean |> #Computing descriptive statistics summary of response times for each sentence type
  group_by(CONDITION) |>
  summarise(MEAN.RT = mean(RESPONSE_TIME),
            SD.RT = sd(RESPONSE_TIME),
            MIN.RT = min(RESPONSE_TIME),
            MAX.RT = max(RESPONSE_TIME)) 
#                     MEAN.RT - SD.RT - MIN.RT - MAX.RT
#Bad control -           4426 - 2908 - 200  - 14684
#Illusion -              4455 - 3145 -  200 - 15292              
#Well-formed control -   5261 - 3568 -  200 -  18323
#Well-formed question  - 4394 - 3247 -  200 - 16362
#Can use it to double check plot 2

moses_clean |> #Computing descriptive statistics summary of response times for each participant
  group_by(ID) |>
  summarise(MEAN.RT = mean(RESPONSE_TIME),
            SD.RT = sd(RESPONSE_TIME),
            MIN.RT = min(RESPONSE_TIME),
            MAX.RT = max(RESPONSE_TIME)) 

###Statistical Analyses###

#Confidence intervals for accuracy per condition
accuracy_summary <- moses_clean |>
  group_by(CONDITION) |>
  summarise(correct = sum(ACCURATE == "correct"),
            total = n(),
            .groups = "drop") |>
  mutate(prop = correct / total)

ci <- binom.confint(x = accuracy_summary$correct, #Computing 95% Wilson confidence intervals for binomial proportions
                    n = accuracy_summary$total,
                    method = "wilson")

accuracy_summary$lower <- ci$lower
accuracy_summary$upper <- ci$upper

accuracy_summary
##CONDITION            95% CI
#1 Bad control      [0.74, 0.81]
#2 Illusion         [0.19, 0.25]
#3 Well-formed c.   [0.61, 0.69]      
#4 Well-formed q.   [0.61, 0.70]

#Chi-square test for Accuracy x Condition
table_acc <- table(moses_clean$CONDITION, moses_clean$ACCURATE)
chisq.test(table_acc) #Checking if accuracy differs by condition
#X-squared = 431.12, df = 6, p-value < 2.2e-16

#Logistic regression: prediction correct vs incorrect
moses_clean$CORRECT_BIN <- ifelse(moses_clean$ACCURATE == "correct", 1, 0)
glm_acc <- glm(CORRECT_BIN ~ CONDITION, data = moses_clean, family = binomial)
summary(glm_acc)

###Plots###

#Plot 1 shows percentage of correct answers by condition
p1 <- moses_clean |>
  group_by(CONDITION, ACCURATE) |>
  summarise(N = n()) |>
  group_by(CONDITION) |>
  mutate(SUM = sum(N),
         PERC = 100*N/SUM) |>
  filter(ACCURATE == "correct") |>
  ggplot() +
  aes(x = CONDITION, y = PERC) +
  geom_col() +
  labs(x = "Question type", y = "% of correct answers")

ggsave(filename = "plots/percent_correct_condition.png",
       plot = p1,
       width = 6,
       height = 4,
       dpi = 300)

moses_clean |> ##Quick verification of synthetic percentages
  group_by(CONDITION, ACCURATE) |>
  summarise(N = n()) |>
  group_by(CONDITION) |>
  mutate(SUM = sum(N),
         PERC = 100*N/SUM) |>
  filter(ACCURATE == "correct") |>
  select(CONDITION, PERC)
#CONDITION             PERC
#1 Bad control           77.4
#2 Illusion              21.8
#3 Well-formed control   65.2
#4 Well-formed question  65.2


#Plot 2 shows mean response time by condition 
p2 <- moses_clean |>
  group_by(CONDITION) |>
  summarize(mean_rt = mean(RESPONSE_TIME)) |>
  mutate(CONDITION = recode(CONDITION,
                            "Well-formed control" = "Well-formed c.",
                            "Well-formed question" = "Well-formed q.")) |>
  arrange(mean_rt) |>
  ggplot() +
  aes(x = CONDITION, y = mean_rt, fill = mean_rt) +
  geom_bar(stat = "identity") +
  labs(title = "Mean response time by Question type", x = "Question type", y = "Mean response time (in ms)")

ggsave(filename = "plots/response_time.png",
       plot = p2,
       width = 6,
       height = 4,
       dpi = 300)

moses_clean |> ##Quick verification of synthetic percentages
  group_by(CONDITION) |>
  summarize(mean_rt = mean(RESPONSE_TIME)) |>
  mutate(CONDITION = recode(CONDITION,
                            "Well-formed control" = "Well-formed c.",
                            "Well-formed question" = "Well-formed q.")) |>
  arrange(mean_rt)
#CONDITION      mean_rt
#1 Well-formed q.   4394
#2 Bad control      4426
#3 Illusion         4455
#4 Well-formed c.   5261

#Plot 3 shows accuracy proportions with 95% confidence intervals
p3 <- ggplot(accuracy_summary, aes(x= CONDITION, y = prop)) +
  geom_point() +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.2) +
  labs( y = "Proportion of correct responses",
        x = "Condition")

ggsave(filename = "plots/prop_correct.png",
       plot = p3,
       width = 6,
       height = 4,
       dpi = 300)

#Plot 4 shows Chi-square visualization of accuracy by condition
accuracy_table <- moses_clean |>
  group_by(CONDITION, ACCURATE) |>
  summarise(N = n(), .groups = "drop") |>
  group_by(CONDITION) |>
  mutate(PERC = 100 * N / sum(N)) |>
  ungroup()|>
  mutate(CONDITION = recode(CONDITION,
                            "Well-formed control" = "Well-formed c.",
                            "Well-formed question" = "Well-formed q."))

p4 <- ggplot(accuracy_table, aes(x = CONDITION, y = PERC, fill = ACCURATE)) +
  geom_col(position = "stack") + 
  labs(x = "Question type", y = "Percentage of responses", fill = "Response type") +
  theme_classic() +
  scale_fill_manual(values = c("correct" = "seagreen3",
                               "incorrect" = "tomato",
                               "dont_know" = "gold"))

ggsave(filename = "plots/acc_by_condition.png",
       plot = p4,
       width = 6,
       height = 4,
       dpi = 300)