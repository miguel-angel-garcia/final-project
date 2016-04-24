# File: prediction.R
# Description: Implements the word prediction function.
# Author: Miguel Ángel García
# Course: Coursera - Data Science Project

# Clear the lines, discarting wrong words (numbers and non character)
cleanLines <- function(lines, char.set = "en_US")
{
    regExpr <- switch(char.set,
                      "en_US" = "[^A-Z|a-z]{2,}[.,/]?",
                      "de_DE" = "[^A-Z|a-z|öäüÖÄÜß]{2,}[.,]?",
                      "fi_FI" = "[^A-Z|a-z|äÄöÖåÅ]{2,}[.,]?",
                      "ru_RU" = "[^\x20-\x7e]{2,}[.,]?")
    unlist(lapply(lines, FUN = function(x) gsub(x, pattern = regExpr, replacement = " \\* ")))
}

predictWord <- function(phrase, firstsChar = NULL)
{
    require(data.table)
    if(!exists('collTextDT'))
        load("data/collTextDT.rda")
    # require(quanteda)
    require(dplyr)
    
    # Initialize global variables
    if(!exists('globalPhrase'))
        globalPhrase <<- NULL
    if(!exists('globalFirstsChar'))
        globalFirstsChar <<- NULL
    if(!exists('globalPredWord'))
        globalPredWord <<- NULL
    
    # Check params
    if(firstsChar == "*" || is.na(firstsChar))
        firstsChar <- NULL
    
    # Split the phrase in words
    words <- NULL
    words <- tolower(tail(unlist(strsplit(cleanLines(phrase), " ")), 2))
    
    # If the phrase is the same as in the previous instance and we're searching for a word
    if(phrase == globalPhrase && 
       !is.null(firstsChar) && 
       !is.null(globalFirstsChar) &&
       !is.na(charmatch(globalFirstsChar, firstsChar)))
    {
        # If there is at least two words
        if(!is.na(words[2]))
        {
            globalPredWord <<- filter(globalPredWord, word1 == words[1] & 
                                          word2 == words[2] &
                                          substr(word3, 1, nchar(firstsChar)) == firstsChar)
            predWord <- globalPredWord[1:5, word3]
            
            # If the search didn't work, we'll use only the last word
            if(is.na(predWord[[1]][1]))
            {
                words[1] <- words[2]
                words[2] <- NA
            }
            else
                return(predWord)
        }
        
        # If there is only one word or the two words search didn't work
        if(is.na(words[2]))
        {
            globalPredWord <<- filter(globalPredWord, word1 == words[1] & 
                                          substr(word2, 1, nchar(firstsChar)) == firstsChar)
            globalPredWord <<- distinct(globalPredWord, word2)
            predWord <- globalPredWord[1:5, word2]
        }
        
        # If the search didn't work, we'll use the most frequent words (simplest version of Good-Turing)
        if(is.na(predWord[[1]][1]))
        {
            globalPredWord <<- filter(globalPredWord, substr(word1, 1, nchar(firstsChar)) == firstsChar)
            globalPredWord <<- distinct(globalPredWord, word1)
            predWord <- globalPredWord[1:5, word1]
        }
        
        # If still didn't work, we'll search for words without n-grams in the global corpus
        if(is.na(predWord[[1]][1]))
        {
            globalPredWord <<- filter(collTextDT, substr(word1, 1, nchar(firstsChar)) == firstsChar)
            globalPredWord <<- distinct(globalPredWord, word1)
            predWord <- globalPredWord[1:5, word1]
        }
        
        globalFirstsChar <<- firstsChar
        return(predWord)        
    }
    
    # Global vars assignment
    globalPhrase <<- phrase
    globalFirstsChar <<- firstsChar
    
    # If there is at least two words
    if(!is.na(words[2]))
    {
        if(!is.null(firstsChar))
            globalPredWord <<- filter(collTextDT, word1 == words[1] & 
                                   word2 == words[2] &
                                   substr(word3, 1, nchar(firstsChar)) == firstsChar)
        else
            globalPredWord <<- filter(collTextDT, word1 == words[1] & 
                                   word2 == words[2] &
                                   word3 != "")
        predWord <- globalPredWord[1:5, word3]

        # If the search didn't work, we'll use only the last word
        if(is.na(predWord[[1]][1]))
        {
            words[1] <- words[2]
            words[2] <- NA
        }
        else
            return(predWord)
    }
    
    # If there is only one word or the two words search didn't work
    if(is.na(words[2]))
    {
        if(!is.null(firstsChar))
            globalPredWord <<- filter(collTextDT, word1 == words[1] & 
                                   substr(word2, 1, nchar(firstsChar)) == firstsChar)
        else
            globalPredWord <<- filter(collTextDT, word1 == words[1] &
                                   word2 != "")
        globalPredWord <<- distinct(globalPredWord, word2)
        predWord <- globalPredWord[1:5, word2]
    }
    
    # If the search didn't work, we'll use the most frequent words (simplest version of Good-Turing)
    if(is.na(predWord[[1]][1]))
    {
        if(!is.null(firstsChar))
            globalPredWord <<- filter(collTextDT, substr(word1, 1, nchar(firstsChar)) == firstsChar)
        else
            globalPredWord <<- collTextDT
        globalPredWord <<- distinct(globalPredWord, word1)
        predWord <- globalPredWord[1:5, word1]
    }
    
    return(predWord)
}