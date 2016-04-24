# File: ui.R
# Description: User interface for the Shiny app.
# Author: Miguel Ángel García
# Course: Coursera - Data Science Specialization - Final Project

# Inits libraries needed
require(shiny)
require(shinythemes)

shinyUI(fluidPage(theme = shinytheme("spacelab"),
  titlePanel("Real Time Word Predictor"),

  fluidRow(
      # Main panel with the instructions and some explanations
      column(12, wellPanel(
          HTML('
<p>The purpose of this Shiny app is to predict the next word you typed.</p>
<p>This is not only the next word for a phrase, but the next word <b>while you are typing</b>.</p>
<h2>Instructions:</h2>
<ul>
    <li>Please, type your phrase in the text box and <b>do not copy paste it</b>.</li> 
    <li>When you write a partial word, the app will suggest you five words that matched your last and your 
    current word.</li>
    <li>The app will detect a complete word after you press the space key; then it will suggest five words 
    based on the two last words.</li>
    <li>While you are typing, you can press the buttons to select the desired word. (This behavior is natural 
    in a touch device, like a tablet or a smartphone, but a little tricky in a PC).</li>
</ul>
</br>
<p>I sacrifice some accuracy to obtain better response (but still not optimal); so please, keep this in 
mind while judging it (and be patient between every key pressed). ;-)</p>
<p>You could read more on the <a href="http://deepdatalab.com/R/final-project-presentation.html#/">R presentation</a> 
and browse the source code on <a href="https://github.com/miguel-angel-garcia/final-project">GitHub</a>.</p>
<p><em>2016 - Miguel &Aacute;ngel Garc&iacute;a - Data Science Specialization final project</em></p>
               '),
          textInput("txtUserPhrase", "Type your phrase:")
      )),
      tags$div(
               list(
                 uiOutput("btnWord1", style="float:left;margin:3px 3px 3px 16px"),
                 uiOutput("btnWord2", style="float:left;margin:3px"),
                 uiOutput("btnWord3", style="float:left;margin:3px"),
                 uiOutput("btnWord4", style="float:left;margin:3px"),
                 uiOutput("btnWord5", style="float:left;margin:3px")
               )
      )
  )
))
