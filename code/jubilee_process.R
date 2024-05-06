# This R script is for processing data downloaded from pysentimiento on Google Co-lab

# Install packages
if (!require("pacman")) {
  install.packages("pacman")
}

pacman::p_load(
  tidyverse, # tidyverse pkgs including purrr
  bench, # performance test 
  tictoc, # performance test
  broom, # tidy modeling
  glue, # paste string and objects
  furrr, # parallel processing
  rvest, # web scraping
  devtools, # dev tools 
  usethis, # workflow     
  roxygen2, # documentation 
  testthat, # testing 
  dplyr,
  tidyverse,
  patchwork) # arranging ggplots 

# Set working directory
setwd("/Users/kawtheralbader/Desktop/UArizona/Spring 2024/POL Digital Traces/Final/jubilee")

# Read sentiment scores from the CSV file downloaded off of Google Co-Lab
# NOTE: This CSV file will be modified by Google Co-Lab to include sentiment scores

sentiment_scores <- read.csv("allcomments_pysentimientoraw.csv", header = TRUE)

# Function to extract 'NEG', 'NEU', and 'POS' from a single score
extract_sent_scores <- function(score) {
  # Check if the score is missing or not in the expected format
  if (is.na(score) || !grepl("'NEG'", score) || !grepl("'NEU'", score) || !grepl("'POS'", score)) {
    return(c(neg = NA, neu = NA, pos = NA))  # Return NA values if the score is missing or not in the expected format
  }
  
  scores <- gsub("[^0-9.,]", "", unlist(strsplit(score, ",")))
  neg <- as.numeric(sub(".*'NEG': ", "", scores[1]))
  neu <- as.numeric(sub(".*'NEU': ", "", scores[2]))
  pos <- as.numeric(sub(".*'POS': ", "", scores[3]))
  return(c(neg = neg, neu = neu, pos = pos))
}

# Apply the function to each sentiment score using lapply
# Create a dataframe that binds the scores by row
result1 <- lapply(sentiment_scores$sentiment_scores, extract_sent_scores)

result1_df <- do.call(rbind, result1)


# Now repeat the above for emotions and hate scores:


# Repeated for emotion scores:
emotion_predictions <- read.csv("allcomments_pysentimientoraw.csv", header = TRUE)

extract_emo_scores <- function(score) {
  scores <- gsub("[^0-9.,]", "", unlist(strsplit(score, ",")))
  others <- as.numeric(sub(".*'others': ", "", scores[1]))
  joy <- as.numeric(sub(".*'joy': ", "", scores[2]))
  sadness <- as.numeric(sub(".*'sadness': ", "", scores[3]))
  anger <- as.numeric(sub(".*'anger': ", "", scores[4]))
  surprise <- as.numeric(sub(".*'surprise': ", "", scores[5]))
  disgust <- as.numeric(sub(".*'disgust': ", "", scores[6]))
  fear <- as.numeric(sub(".*'fear': ", "", scores[7]))
  return(c(others = others, joy = joy, sadness = sadness, anger = anger,
           surprise = surprise, disgust = disgust, fear = fear))
}

result2 <- lapply(emotion_predictions$emotion_predictions, extract_emo_scores)
result2_df <- do.call(rbind, result2)


# Repeated for hate scores:
hate_predictions <- read.csv("allcomments_pysentimientoraw.csv", header = TRUE)

extract_hate_scores <- function(score) {
  scores <- gsub("[^0-9.,]", "", unlist(strsplit(score, ",")))
  hateful <- as.numeric(sub(".*'hateful': ", "", scores[1]))
  targeted <- as.numeric(sub(".*'targeted': ", "", scores[2]))
  aggressive <- as.numeric(sub(".*'aggressive': ", "", scores[3]))
  return(c(hateful = hateful, targeted = targeted, aggressive = aggressive))
}

result3 <- lapply(hate_predictions$hate_predictions, extract_hate_scores)

result3_df <- do.call(rbind, result3)


# Bind all the score dataframes for sentiment, emotion, and hate into one dataframe
resultall_df <- cbind (result1_df, result2_df, result3_df)

# Create a dataframe for the original file that I will bind all the scores to
allcommentsfinalstep_df <- read.csv("allcomments_pysentimientoraw.csv", header = TRUE)

# Bind the scores to the original file and export it into a CSV
finaldatafile <- cbind(allcommentsfinalstep_df,resultall_df)
write_csv(finaldatafile, "finaldatacomments.csv")