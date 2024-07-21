# Wine Reviews Text Analysis

## Overview

This project involves a comprehensive text analysis of wine reviews and ratings conducted by Wine Enthusiasts. The goal is to provide actionable insights for a local winery in California, focusing on the textual content of wine descriptions and comparing reviews of more expensive wines with less expensive ones.

## Dataset

The dataset used for this analysis is sourced from the Vivino Rating System, which provides ratings for millions of wines. The data can be obtained from the following link:
[Wine Reviews Dataset](https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-05-28)

You can download the data using the following R code:
```R
wine_ratings <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-28/winemag-data-130k-v2.csv")
