
library(MASS)

x <- sample( LETTERS[1:4], 1000, replace=TRUE, prob=c(0.25, 0.25, 0.25, 0.25) )
y <- rnorm(1000,10,10)
z <- rnorm(1000,5,5)


df <- data.frame(x,y, z)
df$x = as.factor(df$x)
colnames(df) <- c("x", "y", "z")

df.wide <- df %>% tidyr::pivot_wider(names_from = x, values_from=z)


fig <- plot_ly(df.wide, x = ~y)
fig <- fig %>% 
  add_trace(y = ~A, name = "A", type='scatter', mode='markers') %>% 
  add_trace(y = ~B, name = "B", type='scatter', mode='markers', visible = F) %>%
  layout(xaxis = list(domain = c(0.1, 1)),
         yaxis = list(title = "y"),
         updatemenus = list(
           list(
             y = 0.7,
             buttons = list(
               list(method = "restyle",
                    args = list("visible", list(TRUE, FALSE, FALSE, FALSE)),
                    label = "A"),
               list(method = "restyle",
                    args = list("visible", list(FALSE, TRUE, FALSE, FALSE)),
                    label = "B")))))

saveWidget(fig, file = "./06_Reports_Rmd/fig.html")
# save the Plotly object to an RDS file
saveRDS(fig, file = "./06_Reports_Rmd/fig.rds")

