# Load necessary libraries
library(tidyverse)
library(tm)
library(tidytext)
library(topicmodels)
library(shiny)
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(igraph)
library(ggraph)
library(wordcloud)


# Load the dataset
wine_ratings <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-28/winemag-data-130k-v2.csv")

# Clean the dataset
wine_ratings_clean <- wine_ratings %>%
  select(country, description, points, price) %>%
  filter(!is.na(price), !is.na(points))

# Divide the dataset into expensive and less expensive wines based on median price
median_price <- median(wine_ratings_clean$price, na.rm = TRUE)
expensive_wines <- wine_ratings_clean %>%
  filter(price > median_price)
less_expensive_wines <- wine_ratings_clean %>%
  filter(price <= median_price)

# Divide the dataset into high rated and low rated wines based on median points
median_points <- median(wine_ratings_clean$points, na.rm = TRUE)
high_rated_wines <- wine_ratings_clean %>%
  filter(points > median_points)
low_rated_wines <- wine_ratings_clean %>%
  filter(points <= median_points)

# Tokenize the descriptions
wine_tokens <- wine_ratings_clean %>%
  unnest_tokens(word, description)

# Remove stop words
data("stop_words")
wine_tokens <- wine_tokens %>%
  anti_join(stop_words)

# Create word clouds
expensive_words <- expensive_wines %>%
  unnest_tokens(word, description) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE)

less_expensive_words <- less_expensive_wines %>%
  unnest_tokens(word, description) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE)

high_rated_words <- high_rated_wines %>%
  unnest_tokens(word, description) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE)

low_rated_words <- low_rated_wines %>%
  unnest_tokens(word, description) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE)

# Word cloud for expensive wines
wordcloud(expensive_words$word, expensive_words$n, max.words = 100, colors = brewer.pal(8, "Dark2"))

# Word cloud for less expensive wines
wordcloud(less_expensive_words$word, less_expensive_words$n, max.words = 100, colors = brewer.pal(8, "Set3"))

# Word cloud for high rated wines
wordcloud(high_rated_words$word, high_rated_words$n, max.words = 100, colors = brewer.pal(8, "Dark2"))

# Word cloud for low rated wines
wordcloud(low_rated_words$word, low_rated_words$n, max.words = 100, colors = brewer.pal(8, "Set3"))

# Sentiment analysis with AFINN
afinn <- get_sentiments("afinn")
expensive_sentiment <- expensive_wines %>%
  unnest_tokens(word, description) %>%
  inner_join(afinn, by = "word") %>%
  group_by(word) %>%
  summarise(total_value = sum(value))

less_expensive_sentiment <- less_expensive_wines %>%
  unnest_tokens(word, description) %>%
  inner_join(afinn, by = "word") %>%
  group_by(word) %>%
  summarise(total_value = sum(value))

high_rated_sentiment <- high_rated_wines %>%
  unnest_tokens(word, description) %>%
  inner_join(afinn, by = "word") %>%
  group_by(word) %>%
  summarise(total_value = sum(value))

low_rated_sentiment <- low_rated_wines %>%
  unnest_tokens(word, description) %>%
  inner_join(afinn, by = "word") %>%
  group_by(word) %>%
  summarise(total_value = sum(value))

# Visualize sentiment distribution
ggplot(expensive_sentiment, aes(reorder(word, total_value), total_value)) +
  geom_col(fill = "blue") +
  coord_flip() +
  xlab("Sentiment Score") +
  ylab("Total Value") +
  ggtitle("Sentiment Distribution for Expensive Wines")

ggplot(less_expensive_sentiment, aes(reorder(word, total_value), total_value)) +
  geom_col(fill = "red") +
  coord_flip() +
  xlab("Sentiment Score") +
  ylab("Total Value") +
  ggtitle("Sentiment Distribution for Less Expensive Wines")

ggplot(high_rated_sentiment, aes(reorder(word, total_value), total_value)) +
  geom_col(fill = "green") +
  coord_flip() +
  xlab("Sentiment Score") +
  ylab("Total Value") +
  ggtitle("Sentiment Distribution for High Rated Wines")

ggplot(low_rated_sentiment, aes(reorder(word, total_value), total_value)) +
  geom_col(fill = "orange") +
  coord_flip() +
  xlab("Sentiment Score") +
  ylab("Total Value") +
  ggtitle("Sentiment Distribution for Low Rated Wines")

# Topic modeling with LDA
dtm <- wine_tokens %>%
  count(document = row_number(), word) %>%
  cast_dtm(document, word, n)

lda_model <- LDA(dtm, k = 4, control = list(seed = 1234))
lda_topics <- tidy(lda_model, matrix = "beta")

# Visualize topics
top_terms <- lda_topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

ggplot(top_terms, aes(reorder(term, beta), beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  labs(title = "Top Terms in Each Topic", x = NULL, y = "Beta")

# Country-Based Analysis
country_reviews <- wine_ratings_clean %>%
  count(country, sort = TRUE)

# Plot country-based analysis
ggplot(country_reviews, aes(reorder(country, n), n)) +
  geom_col(fill = "purple") +
  coord_flip() +
  labs(title = "Number of Reviews by Country", x = "Country", y = "Number of Reviews")

