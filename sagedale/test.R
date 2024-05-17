list.of.packages <- c("ape",
                      "Biostrings",
                      "dplyr",
                      "FastaUtils",
                      "ORFik",
                      "readr",
                      "tidyr",
                      "rBLAST",
                      "seqinr",
                      "stringr")

lapply(list.of.packages, require, character.only = TRUE)
