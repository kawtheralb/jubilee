# jubilee

In this project, I explore how to treat a set of YouTube videos as a quasi-experiment, exposing participants (i.e., YouTube commenters) to four "stimuli" (including a control) conditions.
Using the YouTube channel, [Jubilee]([url](https://www.youtube.com/@jubilee)), as an example, I selected four videos (three from the ["Middle Ground"]([url](https://www.youtube.com/playlist?list=PLBVNJo7nhINSjBZdNezW15PzOTCc-10m9)) playlist). I used YouTube Data Tools to randomly sample comments from each video then used the Pysentimiento package on Python to assess comments for incivility.

# Data

The data for this project can be found under the "Data" directory. You can get similar data using YouTube Data Tools (specifically, the "Video Info and Comments" module).

For this project, I used YouTube Data Tools to collect comments from four videos on the Jubilee channel:
1. 5th Graders vs 1 Secret Adult (ft. Brianna Mizura) | Odd One Out https://www.youtube.com/watch?v=fgLxHNhpy24
2. Can Christians and Ex-Christians See Eye to Eye? | Middle Ground https://www.youtube.com/watch?v=ipym_PANZec
3. Are Women and Men Equal? Ex-Muslims vs Muslims | Middle Ground https://www.youtube.com/watch?v=5fYEL1BsbQc
4. Can Mormons and Ex Mormons See Eye to Eye? | Middle Ground
https://www.youtube.com/watch?v=Run1f29po8g&t=19s  

On YouTube Data Tools, enter the video IDs when prompted and limit comments to 2,000 top level comments. Download each file as a .csv file. Do this for every video you are interested in; you should have four .csv files downloaded.

# Code

**Cleanup**
Once you have your data collected, you will need to clean your data. Run the "jubilee_cleanup" R script to do so. This script will:
- Clean the dataframes to only include variables of interest, e.g., like count, comments, isreply
- Add a new variable detailing which condition each video is (i.e., 0 = control, 1 = Christian, 2 = Muslim, 3 = Mormon)
- Randomly sample 750 comments from each condition
- Combine all the dataframes into one .csv file to upload to Google Co-Lab

**Pre-processing**
Next, you will have to upload your data to Google Colaboratory and run the Python script titled "Jubilee - Python"
This script will:
- Run the Pysentimiento package and result in three new variables appended to your .csv file: sentiment, hate speech, and emotion.

**Processing/Parsing**
Finally, you will have to parse through each of the three Pysentimiento variables using the R script titled "jubilee_process." This script will:
- Parse through each of the Pysentimiento variables and create separate sub-variables. For example, sentiment  will be parsed into three variables: positive, neutral, negative; hate speech will be parsed into three variables: aggression, hatefulness, and targetedness; emotion will be parsed into variables like anger, disgust, fear, etc.

You will now have your final dataset titled "finaldatacomments.csv"

# Analysis

You can use any data analysis program to analyze your data. I used SPSS and I ran the syntax file "Jubilee SPSS Syntax.sps". This file will
1. Run an ANOVA with "condition" (i.e., stimuli) as the independent variable and the different Pysentimiento sentiment, hate speech, and emotion dimensions as the dependent variables.
2. Compute a new scale for hate speech combining the different hate speech dimensions (i.e., aggression, hatefulness, and targetedness)

# Contact
If you have any questions, please contact kawtheralbader@arizona.edu
