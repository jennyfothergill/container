library(tidyverse)
wavs <- "/bsushare/annehamby-shared/oskoutput"
args <- commandArgs(trailingOnly = TRUE)
if (length(args) >= 1) {
    wavs <- args[1]
}
files <- list.files(wavs, pattern="prosodyAcf.csv", full.names = TRUE, recursive=TRUE)
# runs 5 files
#files <- head(files,5)
# Creating a data frame
df <- data.frame(
  File=character(),
  voicedtime=double(),
  PercentageVoiced=double(),
  Unvoiced=double(),
  Voiced=double(),
  Breaks=double()
)

i <- 0
for (file in files) {
  data <- read.csv(file, sep = ";")
    data <- data %>%
    mutate(VoicePresence = case_when(voiceProb_sma < .55 ~ 0,
                                     voiceProb_sma > .55 ~ 1))

    voiced <- sum(data$VoicePresence, na.rm = TRUE)
    total <- nrow(data)
    PercentageVoiced <- voiced/total
    totaltime <- max(data$frameTime)
    voicedtime <- totaltime*PercentageVoiced

    # if voiceProb is less than .55, then classify as unvoiced
    data$unvoiced <- ifelse(data$voiceProb_sma < .55, "Unvoiced", "Voiced")


    #### Count the number of times that Unvoiced or Voiced appear sequentially using Run Length Encoding (RLE). ####

    # The following will create a column that shows what's occuring. Note the 1, 2, 3..
    # sequence when voiced (0) and unvoice (1) switch.
    data$sequence_count <- sequence(rle(as.character(data$unvoiced))$lengths)

    # Take the data derived using rle and create a dataframe of voiced and unvoiced regions
    rle_output <- rle(data$unvoiced)
    Voice_Unvoiced_Segments <- data.frame(voicing = rle_output$values, duration = rle_output$lengths)

    Unvoiced <- sum(subset(Voice_Unvoiced_Segments, voicing == "Unvoiced")$duration)
    Voiced <- sum(subset(Voice_Unvoiced_Segments, voicing == "Voiced")$duration)
    Breaks <- Unvoiced/(Unvoiced+Voiced)

    # Appending rows to the existing data frame
    new_row <- data.frame(File = file, voicedtime = voicedtime, PercentageVoiced = PercentageVoiced, Unvoiced = Unvoiced, Voiced = Voiced, Breaks = Breaks)

    df <- rbind(df, new_row)
    i <- i + 1
    print(sprintf("finishied %d of %d files...", i, length(files)))
}

print("done.")

write.csv(df, "speech_variables.csv")







