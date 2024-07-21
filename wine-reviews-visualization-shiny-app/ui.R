#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
library(shiny)
library(ggplot2)
library(wordcloud)
library(dplyr)
library(tidytext)
library(topicmodels)
library(tm)
library(RColorBrewer)

# UI for the Shiny app
ui <- fluidPage(
  titlePanel("Wine Reviews Text Analysis"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price Range", min = min(wine_ratings_clean$price, na.rm = TRUE), max = max(wine_ratings_clean$price, na.rm = TRUE),
                  value = c(min(wine_ratings_clean$price, na.rm = TRUE), max(wine_ratings_clean$price, na.rm = TRUE))),
      selectInput("countryInput", "Country", choices = unique(wine_ratings_clean$country), selected = "US", multiple = TRUE),
      sliderInput("ratingInput", "Rating Range", min = min(wine_ratings_clean$points, na.rm = TRUE), max = max(wine_ratings_clean$points, na.rm = TRUE),
                  value = c(min(wine_ratings_clean$points, na.rm = TRUE), max(wine_ratings_clean$points, na.rm = TRUE)))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Word Cloud - Expensive Wines", plotOutput("expensiveWordCloud")),
        tabPanel("Word Cloud - Less Expensive Wines", plotOutput("lessExpensiveWordCloud")),
        tabPanel("Word Cloud - High Rated Wines", plotOutput("highRatedWordCloud")),
        tabPanel("Word Cloud - Low Rated Wines", plotOutput("lowRatedWordCloud")),
        tabPanel("Sentiment Analysis - Expensive Wines", plotOutput("expensiveSentiment")),
        tabPanel("Sentiment Analysis - Less Expensive Wines", plotOutput("lessExpensiveSentiment")),
        tabPanel("Sentiment Analysis - High Rated Wines", plotOutput("highRatedSentiment")),
        tabPanel("Sentiment Analysis - Low Rated Wines", plotOutput("lowRatedSentiment")),
        tabPanel("Topic Modeling", plotOutput("ldaPlot")),
        tabPanel("Country Analysis", plotOutput("countryPlot"))
      )
    )
  )
)

# Server logic for the Shiny app
server <- function(input, output) {
  filtered_data <- reactive({
    wine_ratings_clean %>%
      filter(price >= input$priceInput[1] & price <= input$priceInput[2]) %>%
      filter(country %in% input$countryInput) %>%
      filter(points >= input$ratingInput[1] & points <= input$ratingInput[2])
  })
  
  output$expensiveWordCloud <- renderPlot({
    expensive_words <- filtered_data() %>%
      filter(price > median_price) %>%
      unnest_tokens(word, description) %>%
      anti_join(stop_words) %>%
      count(word, sort = TRUE)
    wordcloud(expensive_words$word, expensive_words$n, max.words = 100, colors = brewer.pal(8, "Dark2"))
  })
  
  output$lessExpensiveWordCloud <- renderPlot({
    less_expensive_words <- filtered_data() %>%
      filter(price <= median_price) %>%
      unnest_tokens(word, description) %>%
      anti_join(stop_words) %>%
      count(word, sort = TRUE)
    wordcloud(less_expensive_words$word, less_expensive_words$n, max.words = 100, colors = brewer.pal(8, "Set3"))
  })
  
  output$highRatedWordCloud <- renderPlot({
    high_rated_words <- filtered_data() %>%
      filter(points > median_points) %>%
      unnest_tokens(word, description) %>%
      anti_join(stop_words) %>%
      count(word, sort = TRUE)
    wordcloud(high_rated_words$word, high_rated_words$n, max.words = 100, colors = brewer.pal(8, "Dark2"))
  })
  
  output$lowRatedWordCloud <- renderPlot({
    low_rated_words <- filtered_data() %>%
      filter(points <= median_points) %>%
      unnest_tokens(word, description) %>%
      anti_join(stop_words) %>%
      count(word, sort = TRUE)
    wordcloud(low_rated_words$word, low_rated_words$n, max.words = 100, colors = brewer.pal(8, "Set3"))
  })
  
  output$expensiveSentiment <- renderPlot({
    expensive_sentiment <- filtered_data() %>%
      filter(price > median_price) %>%
      unnest_tokens(word, description) %>%
      anti_join(stop_words) %>%
      inner_join(afinn, by = "word") %>%
      group_by(word) %>%
      summarize(total_value = sum(value))
    ggplot(expensive_sentiment, aes(reorder(word, total_value), total_value)) +
      geom_col(fill = "blue") +
      xlab("Sentiment Score") +
      ylab("Total Value") +
      ggtitle("Sentiment Distribution for Expensive Wines") +
      coord_flip()
  })
  
  output$lessExpensiveSentiment <- renderPlot({
    less_expensive_sentiment <- filtered_data() %>%
      filter(price <= median_price) %>%
      unnest_tokens(word, description) %>%
      anti_join(stop_words) %>%
      inner_join(afinn, by = "word") %>%
      group_by(word) %>%
      summarize(total_value = sum(value))
    ggplot(less_expensive_sentiment, aes(reorder(word, total_value), total_value)) +
      geom_col(fill = "red") +
      xlab("Sentiment Score") +
      ylab("Total Value") +
      ggtitle("Sentiment Distribution for Less Expensive Wines") +
      coord_flip()
  })
  
  output$highRatedSentiment <- renderPlot({
    high_rated_sentiment <- filtered_data() %>%
      filter(points > median_points) %>%
      unnest_tokens(word, description) %>%
      anti_join(stop_words) %>%
      inner_join(afinn, by = "word") %>%
      group_by(word) %>%
      summarize(total_value = sum(value))
    ggplot(high_rated_sentiment, aes(reorder(word, total_value), total_value)) +
      geom_col(fill = "green") +
      xlab("Sentiment Score") +
      ylab("Total Value") +
      ggtitle("Sentiment Distribution for High Rated Wines") +
      coord_flip()
  })
  
  output$lowRatedSentiment <- renderPlot({
    low_rated_sentiment <- filtered_data() %>%
      filter(points <= median_points) %>%
      unnest_tokens(word, description) %>%
      anti_join(stop_words) %>%
      inner_join(afinn, by = "word") %>%
      group_by(word) %>%
      summarize(total_value = sum(value))
    ggplot(low_rated_sentiment, aes(reorder(word, total_value), total_value)) +
      geom_col(fill = "orange") +
      xlab("Sentiment Score") +
      ylab("Total Value") +
      ggtitle("Sentiment Distribution for Low Rated Wines") +
      coord_flip()
  })
  
  output$ldaPlot <- renderPlot({
    dtm <- filtered_data() %>%
      unnest_tokens(word, description) %>%
      count(document = row_number(), word) %>%
      cast_dtm(document, word, n)
    lda_model <- LDA(dtm, k = 4, control = list(seed = 1234))
    lda_topics <- tidy(lda_model, matrix = "beta")
    top_terms <- lda_topics %>%
      group_by(topic) %>%
      top_n(10, beta) %>%
      ungroup() %>%
      arrange(topic, -beta)
    ggplot(top_terms, aes(reorder(term, beta), beta, fill = factor(topic))) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~ topic, scales = "free") +
      coord_flip() +
      labs(title = "Top Terms in Each Topic",
           x = NULL, y = "Beta")
  })
  
  output$countryPlot <- renderPlot({
    country_reviews <- filtered_data() %>%
      count(country, sort = TRUE)
    ggplot(country_reviews, aes(reorder(country, n), n)) +
      geom_col(fill = "purple") +
      coord_flip() +
      labs(title = "Number of Reviews by Country",
           x = "Country", y = "Number of Reviews")
  })
}

shinyApp(ui = ui, server = server)