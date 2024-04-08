#loading libraries
library(ggplot2)
library(lubridate)
library(data.table)

#First thing to do is to remove the data we won't need.
#ETH and BTC are much newer than gold
#I will add a column to the gold dataset to match the rest, and make plotting easier.

as.POSIXct(gold$Date)
as.Date(gold$Date)
ggplot(data = gold, mapping = aes(x=gold$Date, y= gold$Close)) + 
  geom_point() + 
  labs("text", x="date", y="Price USD at close")

#new df and merging to add missing data to Gold df

gold_names <- data.frame(X = 1:5703,
                        Name = "Gold",
                        Symbol = "XAU")
gold_2 %>%
  rename(
    Name = `gold_names$Name`,
    Symbol = `gold_names$Name`
  )
gold_2$`gold_names$Name` = NULL
gold_2$`gold_names$Symbol`= NULL

#Let's take the releavant columns from each table

eth_2 <- data.frame(ETH$Date,
                    ETH$Close,
                    ETH$Name,
                    ETH$Symbol)
btc_2 <-data.frame(BTC$Date,
                   BTC$Close,
                   BTC$Name,
                   BTC$Symbol)
gold_2 <-data.frame(gold_2$Date,
                    gold_2$Close,
                    gold_2$name,
                    gold_2$symbol)

gold_2 <-

comparison <- rbind(eth_2,
                    btc_2,
                    gold_2)
