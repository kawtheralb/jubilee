#Jubilee's Middle Ground channel supposedly aims to bring people together.
#When controlling for topic (religion), which video is associated with more incivility?
#Are more replies associated with a higher like count for the comment?
#Which video topic is associated with more incivility?

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


setwd("/Users/kawtheralbader/Desktop/UArizona/Spring 2024/POL Digital Traces/Final/jubilee")

# First, transform all the raw csv files into dataframes
christiandata <- read.csv("/Users/kawtheralbader/Desktop/UArizona/Spring 2024/POL Digital Traces/Final/jubilee/christian.csv")
muslimdata <- read.csv("/Users/kawtheralbader/Desktop/UArizona/Spring 2024/POL Digital Traces/Final/jubilee/muslim.csv")
mormondata <- read.csv("/Users/kawtheralbader/Desktop/UArizona/Spring 2024/POL Digital Traces/Final/jubilee/mormon.csv")
controldata <- read.csv("/Users/kawtheralbader/Desktop/UArizona/Spring 2024/POL Digital Traces/Final/jubilee/control.csv")


# Next, clean the dataframes to only include variables of interest (i.e., comment text, reply count, like count, and isreply).
# Also add a column for a new variable detailing which condition each video is)

controlcomments <- controldata %>%
  subset(select = -c(id,publishedAt,authorChannelId,authorChannelUrl,isReplyTo,isReplyToName,authorName))
controlcomments <- cbind(controlcomments, condition=0)

christiancomments <- christiandata %>%
  subset(select = -c(id,publishedAt,authorChannelId,authorChannelUrl,isReplyTo,isReplyToName,authorName))
  christiancomments <- cbind(christiancomments, condition=1)

muslimcomments <- muslimdata %>%
  subset(select = -c(id,publishedAt,authorChannelId,authorChannelUrl,isReplyTo,isReplyToName,authorName))
  muslimcomments <- cbind(muslimcomments, condition=2)

mormoncomments <- mormondata %>%
  subset(select = -c(id,publishedAt,authorChannelId,authorChannelUrl,isReplyTo,isReplyToName,authorName))
  mormoncomments <- cbind(mormoncomments, condition=3)
  
  
# Export the new dataframes as CSV files
write.csv(controlcomments, "/Users/kawtheralbader/Desktop/UArizona/Spring 2024/POL Digital Traces/Final/jubilee/controlcomments.csv", row.names = FALSE)
write.csv(christiancomments, "/Users/kawtheralbader/Desktop/UArizona/Spring 2024/POL Digital Traces/Final/jubilee/christiancomments.csv", row.names = FALSE)
write.csv(muslimcomments, "/Users/kawtheralbader/Desktop/UArizona/Spring 2024/POL Digital Traces/Final/jubilee/muslimcomments.csv", row.names = FALSE)
write.csv(mormoncomments, "/Users/kawtheralbader/Desktop/UArizona/Spring 2024/POL Digital Traces/Final/jubilee/mormoncomments.csv", row.names = FALSE)


# Combine all the dataframes into one data frame and then one CSV file for Pysentimiento
setwd("/Users/kawtheralbader/Desktop/UArizona/Spring 2024/POL Digital Traces/Final/jubilee/")

file_paths <- c("controlcomments.csv", "christiancomments.csv", "muslimcomments.csv", "mormoncomments.csv")

combined_df <- bind_rows(lapply(file_paths, read_csv))

# Remove replies to only keep replied-to comments
combinedallcomments <- combined_df %>%
  pivot_longer(
    cols = starts_with("replyCount"),
    values_drop_na = TRUE # Drop NAs
  )

# Randomly sample 750 subjects from each condition
sampled_combined <- combinedallcomments %>%
  group_by(condition) %>%
  sample_n(size = 750, replace = FALSE)

write_csv(sampled_combined, "allcomments.csv")


# NEXT: Upload this file to Google Co-lab and use Pysentimiento.
# THEN: Open the "jubilee.process.R" R script and follow directions to process data.