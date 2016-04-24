# File: server.R
# Description: Data process for the Shiny app.
# Author: Miguel Ángel García
# Course: Coursera - Data Science Specialization - Final Project

# Inits libraries needed
require(shiny)
require(quanteda)

getPhraseAndWord <- function(text)
{
    currentWord <- tolower(tail(unlist(strsplit(cleanLines(text), " ")), 1))
    # Check if there isn't current word
    if(substr(text, nchar(text), nchar(text)) == " " || 
       identical(currentWord, character(0)))
    {
        currentWord <- NULL
        currentPhrase <- gsub("^\\s+|\\s+$", "", text)
    }
    else
    {
        currentPhrase <- gsub("^\\s+|\\s+$", "", 
                              substr(text, 1, 
                                     nchar(text) - nchar(currentWord)))
    }
    return(c(currentPhrase, currentWord))
}

shinyServer(function(input, output, session) 
{
    words <- eventReactive(input$txtUserPhrase,
    {
        # The first step is to obtain the current writing word and the phrase
        currentPhraseAndWord <- getPhraseAndWord(input$txtUserPhrase)
        # print(paste("Current word: ", currentPhraseAndWord[2]))
        
        # Get the predicted word!
        nextWord <- predictWord(currentPhraseAndWord[1], currentPhraseAndWord[2])

        return(nextWord[!is.na(nextWord)])
    })
    
    # If pressed, substitute the current word by the button word
    addWord1 <- observeEvent(input$action1, {
        currentPhraseAndWord <- getPhraseAndWord(input$txtUserPhrase)
        if(currentPhraseAndWord[1] == "")
            newPhrase <- paste(words()[1], " ", sep = "")
        else
            newPhrase <- paste(currentPhraseAndWord[1], " ", words()[1], " ", sep = "")
        updateTextInput(session, "txtUserPhrase", value = newPhrase)
    })
    addWord2 <- observeEvent(input$action2, {
        currentPhraseAndWord <- getPhraseAndWord(input$txtUserPhrase)
        if(currentPhraseAndWord[1] == "")
            newPhrase <- paste(words()[2], " ", sep = "")
        else
            newPhrase <- paste(currentPhraseAndWord[1], " ", words()[2], " ", sep = "")
        updateTextInput(session, "txtUserPhrase", value = newPhrase)
    })
    addWord3 <- observeEvent(input$action3, {
        currentPhraseAndWord <- getPhraseAndWord(input$txtUserPhrase)
        if(currentPhraseAndWord[1] == "")
            newPhrase <- paste(words()[3], " ", sep = "")
        else
            newPhrase <- paste(currentPhraseAndWord[1], " ", words()[3], " ", sep = "")
        updateTextInput(session, "txtUserPhrase", value = newPhrase)
    })
    addWord4 <- observeEvent(input$action4, {
        currentPhraseAndWord <- getPhraseAndWord(input$txtUserPhrase)
        if(currentPhraseAndWord[1] == "")
            newPhrase <- paste(words()[4], " ", sep = "")
        else
            newPhrase <- paste(currentPhraseAndWord[1], " ", words()[4], " ", sep = "")
        updateTextInput(session, "txtUserPhrase", value = newPhrase)
    })
    addWord5 <- observeEvent(input$action5, {
        currentPhraseAndWord <- getPhraseAndWord(input$txtUserPhrase)
        if(currentPhraseAndWord[1] == "")
            newPhrase <- paste(words()[5], " ", sep = "")
        else
            newPhrase <- paste(currentPhraseAndWord[1], " ", words()[5], " ", sep = "")
        updateTextInput(session, "txtUserPhrase", value = newPhrase)
    })
    
    # Creating the dynamic buttons with the predicted words
    output$btnWord1 <- renderUI(
    {
        if(!is.na(words()[1]))
            actionButton("action1", label = words()[1])
    })
    output$btnWord2 <- renderUI(
    {
        if(!is.na(words()[2]))
            actionButton("action2", label = words()[2])
    })
    output$btnWord3 <- renderUI(
    {
        if(!is.na(words()[3]))
            actionButton("action3", label = words()[3])
    })
    output$btnWord4 <- renderUI(
    {
        if(!is.na(words()[4]))
            actionButton("action4", label = words()[4])
    })
    output$btnWord5 <- renderUI(
    {
        if(!is.na(words()[5]))
            actionButton("action5", label = words()[5])
    })
})
