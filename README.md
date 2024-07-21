# Wine Reviews Text Analysis

## Overview
This project involves a comprehensive text analysis of wine reviews and ratings conducted by Wine Enthusiasts. The goal is to provide actionable insights for a local winery in California, focusing on the textual content of wine descriptions and comparing reviews of more expensive wines with less expensive ones.

## Dataset
The dataset used for this analysis is sourced from the Vivino Rating System, which provides ratings for millions of wines. The data can be obtained from the following link: [Wine Reviews Dataset](https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-05-28).

You can download the data using the following R code:

```r
wine_ratings <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-28/winemag-data-130k-v2.csv")
```

## Project Deliverables
For this project, the following deliverables were created and included in this repository:

1. **Project Report**: A comprehensive report detailing the text analysis and business insights derived from the wine reviews.
2. **R Shiny Dashboard**: An interactive dashboard created using R Shiny to visualize the data and provide insights.
3. **R Code**: The R scripts used to process the data, perform text analysis, and create visualizations.

## Project Structure
The repository is structured as follows:

- **Text-Mining-NLP.R**: R script containing the code for text analysis and visualizations.
- **Wine-Reviews-Text-Analysis-Report.pdf**: Project report in PDF format.
- **wine-reviews-visualization-shiny-app/**: Directory containing the R Shiny application files.
  - `server.R`: Server-side logic for the Shiny app.
  - `ui.R`: User interface layout for the Shiny app.

## Installation and Usage
To run the R Shiny dashboard locally, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/Cyberpunk379/wine-reviews-text-analysis.git
    cd wine-reviews-text-analysis
    ```

2. Install the required R packages:
    ```r
    install.packages(c("shiny", "dplyr", "ggplot2", "readr", "tidytext", "tm"))
    ```

3. Run the Shiny app:
    ```r
    shiny::runApp("wine-reviews-visualization-shiny-app")
    ```

## Business Insights
The analysis reveals several key insights:

- **Expensive vs. Inexpensive Wines**: Expensive wines tend to have more positive reviews with specific adjectives like "complex," "rich," and "balanced," while less expensive wines are often described with terms like "simple" and "fruity."
- **Common Themes**: Common themes in highly rated wines include mentions of specific fruits, oak aging, and well-balanced acidity.
- **Reviewer Preferences**: Reviewers often highlight unique flavors and aging processes in their descriptions of higher-rated wines.

## Conclusion
This project demonstrates the potential of text analysis to uncover valuable insights from wine reviews. The findings can help the winery better understand customer preferences and improve their product offerings.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements
- Thanks to Wine Enthusiasts for providing the dataset.
- Special thanks to the R community and the contributors of the `tidytuesday` project.
```
