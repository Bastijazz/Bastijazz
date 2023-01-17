---
Title: Car Diagnosis
Author: Bastian
Date: "2023-01-13"
---

## Diagnosting my car, using data.

I have a 2013 Mazda 6 diesel, which I got second hand. The car had a number of problems which have been sorted out but a new problem has appeared.

##The problem: Power loss when the car is warmed up.

Normally, any car has the same amount of power when on demand if the engine is healthy.
However, my car started to lose power after driving for around 10 minutes, it still runs but the throttle response is much slower and the car seems to be saving power.
This is annoying, but most of all, it shows that something is clearly wrong.
After consulting with a mechanic, he mentioned that the engine could be overheating.

When an engine overheats, the car will light up a warning on the dashboard, it's impossible to miss.
So, I decided to use data to perform a diagnosis and see if the car's computer can show me something I can't see on the dashboard.

## The method.

For around 30 years, OBD II has been the standard for car diagnostics, a cable is connected to the OBD port and a computer retrieves live and historical data (in some cases).

In my case, I have an OBD Bluetooth device which pairs to my phone, so I can see live data and if needed, I can store it and send the recorded data via email.

I will be using R code on Rstudio to perform the analysis and visualize the data.

## Sample trip.

After warming up the car for about 5 minutes, I started to record the data which I considered relevant.


During the day, the maximum temperature was 25 degrees Celsius, which is something we should consider when measuring a potential engine overheat situation.
<img src="temperature180822.png" >

Familiarizing with the data.


```{r}
lines_per_second <- nrow(Mazdata_13_08_2022) / max(Mazdata_13_08_2022$`time(s)`)
  
  #Let's see for how long the car has been collecting data. We can use the "last" function from the Dplyr package on the "time" column to find that out.
  #We also convert it to character so the value is visible.
  
  total_time <- last(Mazdata_13_08_2022$time) %>% as.character(total_time)
```

Total sample time is 34 minutes and 51 seconds, the computer created 37 lines of data per second, for a total of 77785 lines.



##Let's visualize 

I have no official numbers on temperature limits set by the car's computer, but there is an error code which tells us that a certain limit has been reached.

To put this into a more human equivalent, let's think of fever.
  - Normal body temperature should be around 36 to 36,8 degrees Celsius.
  - Fever starts at around 38 degrees Celsius.
  - Between 37 to 38 degrees, is high temperature.



The car can be seen in a similar manner:
 - Normal running temperature is between 80 to 100 degrees, this depends on each car.
 - The car restricts power because of high temperature, but not overheat.

Using *ggplot2* and *grid* packages, I have put together the parameters which I think are relevant.

<img src="Speed%20vs%20temp%20before.png" >


##My first insights

The car has been behaving like this for some time, and I need to find the actors in the scene and see what each of them does.

 -Oil: lubricates the engine, viscosity is affected by temperature.
 -Oil filter: filters metal particles which could get into the lubrication system due to friction at high temperatures.
 -Oil temperature sensor: Measures oil temperature.
 -Coolant: flows through the engine and radiator to cool it down and keep it at an optimal temperature range.
 -Radiator: Cold air passes through it, lowering coolant temperature.
 -Ambient temperature: it affects oil and coolant temperature. 
 -Speed: Low speeds raise temperature of both oil and coolant.


##Potential origins of the problem:

 -Oil could be contaminated with diesel.
 -Oil change could past due date. It needs to be changed every certain amount of kilometers or time.
 -The coolant used could be wrong, modern cars are sensitive to coolant types.
 -Radiator is contaminated, if the coolant has tap water instead of destilled water, corrosion is created and the tubes can get clogged.
 -Radiator fans are not working.


We can see there is a peak at 103 degrees, and this would match the behavior of the car, limiting the power.


##Are coolant temperature and oil temperature related?

I would like to see if there is a correlation between engine coolant and engine oil temperatures.
Logic tells us there should be a certain correlation, as both run through the engine, but I would like to find how strongly connected they are.

```{r}
#correlation coolant vs oil temp
oil_temp_vs_coolant <- data.frame(Mazdata_13_08_2022$`ECT1(°C)`,
                          Mazdata_13_08_2022$`EOT(°C)`)
#delete empty lines
oil_temp_vs_coolant <- oil_temp_vs_coolant[-(1:5),]

#find out correlation index.
cor(oil_temp_vs_coolant)
cor.test(oil_temp_vs_coolant$Mazdata_13_08_2022..EOT..C.., oil_temp_vs_coolant$Mazdata_13_08_2022..ECT1..C..)

```

A correlation index of 0.676188 tells us that there is some positive correlation, however this is not a direct correlation.
In any case, this is something to consider if I want to make some changes.




###Disregarded potential problems 
 -Oil sensor: the measurements given are smooth and there are no strange peaks.
 -Radiator fan: Radiator fans work correctly, they switch on and off when the car is at idle.
 
##Action plan:

When working on a car, my approach is to start with the easiest and cheapest potential problems.


 -The first think to do, is to change the oil and oil filter.
 -The second step is to flush the coolant to make sure the radiator and water system are cleaned.
 -Last, refill coolant and oil type according to the owner's manual.
 
##Outcome and analysis.

For this test, the car has been running for almost 30 minutes and I did the same route as the previous time.
We need to consider that this day was 8 degrees Celsius warmer than the previous time.

<img src="temperature%20180822.png" >

<img src="After%20temp%20vs%20speed.png" >


 -The coolant on the engine was the wrong type (red instead of green), so after flushing the system, the correct one was added, mixed with distilled water.
 -Oil was changed to specific Mazda oil and filter.
 
After performing an initial test run to gather data, I saved it and run through the same process to visualize the status of the car.

Graph goes here:

-After running the car for a few weeks and a 5 day road trip, the car behaves as it should, no power loss and no signs of high temperature.



##Conclusion

 -Oil change interval and oil density according to specifications are crucial, especially on modern engines. 
 
 -Flushing the coolant and radiator helps in two ways:
  -The minerals and detergents protect the engine block from corrosion.
  -Keeps the engine temperature few degrees lower.

I am satisfied with the results.


