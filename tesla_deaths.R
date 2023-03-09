Work in progress


#Let's analyze data from an interesting set obtained from Kaggle.

#I want to find out about the deaths related to Tesla's autopilot and try to get to some conclusion.

#Importing the dataset and making some changes to the columns.

library(readr)
Tesla_Deaths <- read_csv("~/R/case study/Tesla Deaths - Deaths.csv", 
                           +     col_types = cols(Deaths = col_number(), 
                                                           `Tesla driver` = col_number(), `Tesla occupant` = col_number(), 
                                                          `Other vehicle` = col_number(), `Cyclists/ Peds` = col_number(), 
                                                          `TSLA+cycl / peds` = col_number()))

#Some of the last rows contain no valuable information, so I will delete them.

Tesla_Deaths_2 <- Tesla_Deaths[-(295:307),]

library(tidyverse)

deaths_by_country <- Tesla_Deaths_2 %>%
  arrange(Tesla_Deaths_2$Deaths) %>%
  group_by(Country) %>%
  summarise(country_deaths = sum(Deaths))
#We convert the dates from character to date. 
as.Date(Tesla_Deaths$Date, "%d/%m/%Y")



library(ggplot2)

ggplot(data=deaths_by_country) +
  geom_col(mapping = aes(x=Country, y=country_deaths)) +
  labs(x="Country", y= "Total Deaths") +
  geom_text(aes(Country, country_deaths ,label = country_deaths), vjust = -0.5) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust=1)) +
  annotate("text", x=10, y= 200, label = "Autopilot deaths between April 2013 and January 2023")


#Find description coincidences.

#As descriptions are very irregular, and most likely made by different sources, I would like to find patterns which will conduct me to a clearer idea.

#For that, I want to find the most common words within all descriptions.




description_frequent_words <- data.frame(table(unlist(strsplit(tolower(Tesla_Deaths_2$Description), " "))))
arrange(description_frequent_words, desc(description_frequency$Freq))



#From the causes of deaths, the first reason, Tesla kills pedestrian, tells us that these accidents happen at populated areas.
#I want to find out exact numbers, as descriptions are made by different people/sources.



pedestrian_victims <- Tesla_Deaths_2 %>%
  arrange(Tesla_Deaths_2$Description) %>%
  group_by(Description) %>%
  summarise(`Cyclists/ Peds`) %>%
  na.omit(Deaths) %>%
sum(pedestrian_victims$`Cyclists/ Peds`)




#Pivot the columns to create a nice plot.

deaths_by_victim <- Tesla_Deaths_2 %>%
  pivot_longer(
    cols = 8:11,
    names_to = "Victim type",
    values_to = "Number"
  )
deaths_by_victim_clean <- data.frame(deaths_by_victim$`Victim type`,
                                     deaths_by_victim$`Number`)
deaths_by_victim <- replace(deaths_by_victim, deaths_by_victim==0, NA)

ggplot(deaths_by_victim_clean) + geom_bar(mapping = aes(x=`Number`))

ggplot(deaths_by_victim) + geom_bar(mapping = aes(x=deaths_by_victim$`Number`, fill= deaths_by_victim$`Victim type`))

