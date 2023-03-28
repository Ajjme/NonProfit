
source("./03_Scripts/000_init.R")

source("./03_Scripts/020_MCE_processing.R")


# Import the data
glimpse(full_mce)


# Create example data
set.seed(123)
data <- data.frame(
  x = rep(letters[1:5], each = 5),
  y = rep(1:5, 5),
  value = runif(25, 0, 1)
)

# Create heat map
ggplot(data, aes(x = x, y = y, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "steelblue") +
  theme_minimal() +
  ggtitle("Example Heat Map") +
  xlab("X Variable") +
  ylab("Y Variable")
