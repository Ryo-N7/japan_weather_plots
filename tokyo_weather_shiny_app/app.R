# Packages:
library(shiny)
library(ggplot2)
library(dplyr)
library(scales)
library(glue)
library(extrafont)
library(ggiraph)
loadfonts()

# load dataframe
# tokyo_weather_shiny_app/data/
tokyo_weather_df_ggiraph <- readRDS(file = "data/tokyo_weather_df_ggiraph.RDS")

# colorbrewer2.org: diverging 8-class palette
cols <- rev(c('#d53e4f','#f46d43','#fdae61','#fee08b','#e6f598','#abdda4','#66c2a5','#3288bd'))

labels <- c("10", "12", "14", "16", "18", "20", "22", "24", "26", "28", "30", "32")

breaks <- c(seq(10, 32, by = 2))

# ggplot obj
tkw <- tokyo_weather_df_ggiraph %>% 
  ggplot(aes(x = date, y = year, fill = avg_temp)) +
  geom_tile_interactive(aes(x = date, y = year, 
                            fill = avg_temp, 
                            tooltip = tokyo_weather_df_ggiraph$tooltip, 
                            data_id = tokyo_weather_df_ggiraph$tooltip)) +
  scale_fill_gradientn(
    colours = cols,
    labels = labels,
    breaks = breaks,
    limits = c(11, max(tokyo_weather_df_ggiraph$avg_temp))) +
  guides(fill = guide_colorbar(title = expression("Temperature " ( degree~C)),
                               reverse = FALSE,
                               title.position = "left",
                               nrow = 1)) +
  labs(title = "Summers in Tokyo are Getting Longer and Hotter (1876-2017)",
       subtitle = glue::glue("
                             One Row = One Year, From June 1st to September 30th
                             Average Temperature (Celsius)
                             "),
       caption = "Data from Toyo Keizai News via Japan Meteorological Agency") +
  theme_minimal() +
  theme(text = element_text(family = "Roboto Condensed"),
        axis.title = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank(),
        legend.position = "bottom",
        legend.key.width = unit(2, "cm"))





# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Sidebar with a slider input for number of bins 
   ggiraphOutput("plot")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$plot <- renderggiraph({
      
     ggiraph(code = print(tkw), zoom_max = 5, width = 1)
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

