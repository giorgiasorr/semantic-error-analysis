# This script generates a synthetic version of the Moses illusion dataset.
# The synthetic data mirrors the structure and key statistical properties
# of the original data, but contains no real participant information.

set.seed(123) #Setting seed for reproducibility

n_participants <- 54 # number of participants in the cleaned dataset
n_questions <- 41 # number of questions each participant answers

participants <- paste0("P", 1:n_participants)


conditions <- c("Illusion", "Well-formed question", "Well-formed control", "Bad control")
condition_vector <- sample(conditions, n_participants*n_questions, replace = TRUE) #Assigning conditions randomly

#Simulating response times
rt_means <- c("Illusion"=4425, "Well-formed question"=4119, "Well-formed control"=4972, "Bad control" = 4178)
rt_sd <- c("Illusion"=3596, "Well-formed question"=3611, "Well-formed control"=4193, "Bad control" = 3071)

response_time <- sapply(condition_vector, function(cond){ #generating a normally distributed RT for this condition
  rt <- rnorm(1, mean=rt_means[cond], sd=rt_sd[cond])
  rt <- max(200, min(rt, 20000)) #truncating extreme values
  return(rt)})


#Simulating accuracy
accuracy_probs <- c("Illusion"=0.222, "Well-formed question"=0.633, "Well-formed control"=0.645, "Bad control"=0.747)

accuracy <- sapply(condition_vector, function(cond){
  sample(c("correct", "incorrect", "dont_know"), 1, prob = c(accuracy_probs[cond], #prob. of "correct" for this condition
                                                             1-accuracy_probs[cond]-0.05, #prob. of "incorrect"
                                                             0.05))}) #prob. of "dont_know"
#Creating data frame
synth <- data.frame(
  ID= rep(participants, each = n_questions),
  ITEM = rep(1:n_questions, times = n_participants),
  CONDITION = condition_vector,
  RESPONSE_TIME = response_time,
  ACCURATE = accuracy,
  LIST = "List1", #placeholder to match original dataset structure
  TYPE = "Type1", #placeholder
  QUESTION = paste("Question", rep(1:n_questions, times = (n_participants))), 
  CORRECT_ANSWER = "Answer X", #placeholder
  ANSWER_CLEAN = "Answer Y") #placeholder

#Verifying distribution, summary statistics and mean RT
any(duplicated(synth)) #Checking for duplicates
table(synth$CONDITION, synth$ACCURATE) #Verifying accuracy distribution per condition
aggregate(RESPONSE_TIME ~ CONDITION, data=synth, mean) # Ensuring means are close to original 
summary(synth$RESPONSE_TIME) #Summary statistics for response times


write.csv(synth,"data/synthetic_moses.csv", row.names = FALSE)
