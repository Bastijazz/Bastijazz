library(tidyverse)
library(dplyr)
library(lubridate)
library(ggplot2)
library(data.table)
#Import all csv files using vroom:
  jul_2021 <- vroom("C:/Users/user/Documents/R/case study/202107-divvy-tripdata-2.csv")
  aug_2021 <- vroom("C:/Users/user/Documents/R/case study/202108-divvy-tripdata-2.csv")
  sep_2021 <- vroom("C:/Users/user/Documents/R/case study/202109-divvy-tripdata-2.csv")


  oct_2021 <- vroom("C:/Users/user/Documents/R/case study/202110-divvy-tripdata-2.csv")
  nov_2021 <- vroom("C:/Users/user/Documents/R/case study/202111-divvy-tripdata-2.csv")
  dec_2021 <- vroom("C:/Users/user/Documents/R/case study/202112-divvy-tripdata-2.csv")

  jan_2022 <- vroom("C:/Users/user/Documents/R/case study/202201-divvy-tripdata-2.csv")
  feb_2022 <- vroom("C:/Users/user/Documents/R/case study/202202-divvy-tripdata-2.csv")
  mar_2022 <- vroom("C:/Users/user/Documents/R/case study/202203-divvy-tripdata-2.csv")

  apr_2022 <- vroom("C:/Users/user/Documents/R/case study/202204-divvy-tripdata-2.csv")
  may_2022 <- vroom("C:/Users/user/Documents/R/case study/202205-divvy-tripdata-2.csv")
  jun_2022 <- vroom("C:/Users/user/Documents/R/case study/202206-divvy-tripdata-2.csv")

#binding quarters of data with ride lengths and day.  
Q3_2021 <- rbind(jul_2021, aug_2021, sep_2021)
Q4_2021 <- rbind(oct_2021, nov_2021, dec_2021)
Q1_2022 <- rbind(jan_2022, feb_2022, mar_2022)
Q2_2022 <- rbind(apr_2022, may_2022, jun_2022) 


rm(apr_2022, dec_2021, feb_2022, jan_2022, jan_2022, jun_2022, mar_2022, may_2022, nov_2021, oct_2021, aug_2021, jul_2021, sep_2021)
  
#Renaming columns:
Q3_2021 <- rename(Q3_2021
                  ,trip_id = ride_id
                  ,bikeid = rideable_type 
                  ,start_time = started_at  
                  ,end_time = ended_at  
                  ,from_station_name = start_station_name 
                  ,from_station_id = start_station_id 
                  ,to_station_name = end_station_name 
                  ,to_station_id = end_station_id 
                  ,usertype = member_casual)

Q4_2021 <- rename(Q4_2021
                  ,trip_id = ride_id
                  ,bikeid = rideable_type 
                  ,start_time = started_at  
                  ,end_time = ended_at  
                  ,from_station_name = start_station_name 
                  ,from_station_id = start_station_id 
                  ,to_station_name = end_station_name 
                  ,to_station_id = end_station_id 
                  ,usertype = member_casual)                    
Q1_2022 <- rename(Q1_2022
                  ,trip_id = ride_id
                  ,bikeid = rideable_type 
                  ,start_time = started_at  
                  ,end_time = ended_at  
                  ,from_station_name = start_station_name 
                  ,from_station_id = start_station_id 
                  ,to_station_name = end_station_name 
                  ,to_station_id = end_station_id 
                  ,usertype = member_casual)
Q2_2022 <- rename(Q2_2022
                  ,trip_id = ride_id
                  ,bikeid = rideable_type 
                  ,start_time = started_at  
                  ,end_time = ended_at  
                  ,from_station_name = start_station_name 
                  ,from_station_id = start_station_id 
                  ,to_station_name = end_station_name 
                  ,to_station_id = end_station_id 
                  ,usertype = member_casual)

# Inspect the dataframes and look for incongruencies.
str(Q3_2021)
str(Q4_2021)
str(Q1_2022)
str(Q2_2022)


#Remove unecessary data.
Q3_2021 <- subset(Q3_2021, select = -c(start_lat, start_lng, end_lat, end_lng))
Q4_2021 <- subset(Q4_2021, select = -c(start_lat, start_lng, end_lat, end_lng))
Q1_2022 <- subset(Q1_2022, select = -c(start_lat, start_lng, end_lat, end_lng))
Q2_2022 <- subset(Q2_2022, select = -c(start_lat, start_lng, end_lat, end_lng))


#Stack all quarters into a single dataset.
all_trips <- rbind(Q3_2021, Q4_2021, Q1_2022, Q2_2022) 
#Checking size of all_trips
format(object.size(all_trips), units = "auto")
#Remove quarters to save RAM memory.
rm(Q1_2022, Q2_2022, Q3_2021, Q4_2021)

#Clean up and adding data to prepare for analysis.

#Export all data to keep as backup.
write.csv(all_trips,"C:/Users/user/Documents/R/case study/all_trips.csv", row.names=FALSE)

colnames(all_trips)  #List of column names
nrow(all_trips)  #How many rows are in data frame?
dim(all_trips)  #Dimensions of the data frame?
head(all_trips)  #See the first 6 rows of data frame.  Also tail(all_trips)
str(all_trips)  #See list of columns and data types (numeric, character, etc)
summary(all_trips)  #Statistical summary of data. Mainly for numerics

usage_per_membership <- setDT(all_trips)[, 100* .N / nrow(all_trips), by = usertype]


# Add columns that list the date, month, day, and year of each ride

#The default format is yyyy-mm-dd
#Format is wrong, so it's better to delete and re-format.
all_trips$start_time <- strptime(all_trips$start_time, format = "%d/%m/%Y %H:%M")
all_trips$end_time <- strptime(all_trips$end_time, format = "%d/%m/%Y %H:%M")

#maybe remove
all_trips$date <- as.Date(all_trips$start_time, format = "%d/%m/%y")

all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")
#/maybe remove.


#Sorting columns for clarity.

#Getting the names of the columns to organize them easily.
colnames(all_trips) 

all_trips <- all_trips [, c(1, 2, 3, 4, 5, 14, 7, 8, 9, 10., 11, 15, 12, 6, 13)]

# Add a "ride_length" calculation to all_trips (in seconds)
all_trips$ride_length <- difftime(all_trips$end_time,all_trips$start_time)
#Convert seconds to H:M:S
all_trips$ride_length <- seconds_to_period(all_trips$ride_length)


# Convert "ride_length" from Factor to numeric so we can run calculations on the data 
is.factor(all_trips$ride_length)
all_trips$ride_length <- as.character(as.numeric(all_trips$ride_length))


#Remove bad data.
# The dataframe includes a few hundred entries when bikes were taken out of docks and checked for quality by Divvy or ride_length was negative

write.csv(all_trips,"C:/Users/user/Documents/R/case study/all_trips_modified.csv", row.names=FALSE)

all_trips <- filter(all_trips, all_trips$ride_length >=0)#this worked


# Descriptive analysis on ride_length (all figures in seconds)
mean(all_trips$ride_length) #straight average (total ride length / rides)
median(all_trips$ride_length) #midpoint number in the ascending array of ride lengths
max(all_trips$ride_length) #longest ride
min(all_trips$ride_length) #shortest ride

# Compare members and casual users
aggregate(all_trips$ride_length_seconds ~ all_trips$usertype, FUN = mean)
aggregate(all_trips$ride_length_seconds ~ all_trips$usertype, FUN = median)
aggregate(all_trips$ride_length_seconds ~ all_trips$usertype, FUN = max)
aggregate(all_trips$ride_length_seconds ~ all_trips$usertype, FUN = min)

# See the average ride time by each day for members vs casual users
aggregate(all_trips$ride_length ~ all_trips$usertype + all_trips$day_of_week, FUN = mean)
aggregate(all_trips$ride_length_seconds ~ all_trips$usertype + all_trips$day, FUN = mean)
# Notice that the days of the week are out of order. Let's fix that.
all_trips$day_of_week <- ordered(all_trips$day_of_week, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# Now, let's run the average ride time by each day for members vs casual users
aggregate(all_trips$ride_length ~ all_trips$usertype + all_trips$day_of_week, FUN = mean)

# analyze ridership data by type and weekday
all_trips %>% 
  mutate(weekday = wday(start_time, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(usertype, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(usertype, weekday)								# sorts

#visualize the number of rides by rider type
all_trips %>% 
  mutate(weekday = wday(start_time, label = TRUE)) %>% 
  group_by(usertype, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(usertype, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = usertype)) +
  geom_col(position = "dodge")

#Visualization for average duration
all_trips %>% 
  mutate(weekday = wday(start_time, label = TRUE)) %>% 
  group_by(usertype, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(usertype, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = usertype)) +
  geom_col(position = "dodge") + facet_grid(all_trips$month)

#Plot for usage throughout different months

ggplot(data=all_trips, aes(x=day_of_week, y=average_duration)) 
+ fill=all_trips$usertype + geom_line() + facet_grid(all_trips$month)
+ expand_limits (y=0)


# Create a csv file

counts <- aggregate(all_trips$ride_length ~ all_trips$usertype + all_trips$day_of_week, FUN = mean)
write.csv(counts, file = '~/R/case study/avg_ride_length.csv')


#________________________________________________________________
