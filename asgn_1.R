######################

library(tidyverse)

tech_salary_data <- read_csv("MSCI 718/salaries_clean.csv",
                 col_types = cols(
                   location_name=col_factor()
                 ))
View(tech_salary_data)
str(tech_salary_data)

head(tech_salary_data)
summary(tech_salary_data)
summary(tech_salary_data$location_name)
summary(tech_salary_data$annual_base_pay)
glimpse(tech_salary_data)

# select required columns from dataframe
tech_salary_data <- select(tech_salary_data, location_name, annual_base_pay)

#split location_name into city and state
tech_salary_data <- tech_salary_data %>% separate(location_name, into= c("city", "state"), sep=",")
view(tech_salary_data)
tech_salary_data <- select(tech_salary_data, city, annual_base_pay)

# Checking for normality
tech_salary_data %>% ggplot(aes(annual_base_pay))+geom_histogram()

#outlier detected in this QQ plot
tech_salary_data %>% ggplot(aes(sample=annual_base_pay))+stat_qq()

# check outlier value by arranging data in descending order
arrange(tech_salary_data, desc(annual_base_pay)) %>%
  print(n=30)

# filter data to eliminate outliers; 11 entries filtered out
tech_salary_data <- filter(tech_salary_data, annual_base_pay<=2000000)

# checking for null values in any of the columns
sum(is.na(tech_salary_data$city)) #0
sum(is.na(tech_salary_data$annual_base_pay)) #4
# dropping NA in annual_base_pay column
tech_salary_data <- tech_salary_data %>% drop_na(annual_base_pay)
sum(is.na(tech_salary_data$annual_base_pay))

tech_salary_data <- within(tech_salary_data, city[city %in% 
                            c("san francisco","south san francisco","san francisco (palo alto)",
                              "san fransico","san franciaco","san fransisco","sf","sf bay area",
                              "ssf","bay area","sf bay area","palo alto","menlo park") ] <- 'san francisco bay area')
tech_salary_data <- within(tech_salary_data, city[city %in% c("seattle","seattel","sewttle" ) ] <- "seattle")
tech_salary_data <- within(tech_salary_data, city[city %in% c("new york city","new york" ,"nyc" ) ] <- 'new york city')
tech_salary_data <- within(tech_salary_data, city[city %in% c("redmond","redmon" ) ] <- 'redmond')

tech_salary_data <- within(tech_salary_data, city[!city  %in% c("san francisco bay area", "new york city"   ,
                                        "seattle"      ,          "mountain view"    ,      "london"      ,     "redmond"               , 
                                        "austin"          ,       "chicago"      ,          "boston"           ,      "san jose"    ,         
                                        "toronto"               , "los angeles"     ,       "berlin"       ,          "remote"           ,
                                        "sunnyvale"      ,        "vancouver"   ,           "atlanta",           "cambridge"          ,
                                        "denver"         ,         "portland") ] <- 'other')

view(tech_salary_data)

# confidence interval prep
tech_salary_data_summary <- tech_salary_data %>%
  group_by(city) %>%
  summarise(observations=n(), avg_annual_base_pay=mean(annual_base_pay), stdErr=sd(annual_base_pay)/sqrt(n()))
view(tech_salary_data_summary)

ggplot(tech_salary_data_summary, aes(x=avg_annual_base_pay, y=city))+
  geom_point()+
  geom_label(aes(label=round(avg_annual_base_pay,3)),nudge_y = 0.3)+
  geom_errorbarh(aes(xmax=avg_annual_base_pay+1.96*stdErr, xmin=avg_annual_base_pay-1.96*stdErr))+
  labs(x="Avg Annual Base Pay", y="", title = "CI for annual base pay wrt city")+
  theme_bw()

# Checking for normality
tech_salary_data_summary %>% ggplot(aes(avg_annual_base_pay))+geom_histogram()
tech_salary_data_summary %>% ggplot(aes(sample=avg_annual_base_pay))+stat_qq()
tech_salary_data_summary %>% ggplot(aes(sample=avg_annual_base_pay))+stat_qq()+geom_qq_line(aes(color="red"))+theme(legend.position = "none")+labs(x="X-axis", y="Y-axis")

#plotting
tech_salary_data_summary %>% ggplot(aes(y=city, x=avg_annual_base_pay))+geom_point()
tech_salary_data_summary %>% ggplot(aes(y=city, x=avg_annual_base_pay))+geom_boxplot()

# horizontal bar plot
tech_salary_data_summary %>% 
  ggplot(aes(y=city, x=avg_annual_base_pay))+geom_bar(stat="identity")+
  labs(x="Average Annual Base Salary", y="City", title = "BarPlot for city v/s average annual base salary")

# This salary_data_summary_no_na comes out looking weird bcoz outlier wasnt removed from that dataset
#salary_data_summary_no_na %>% ggplot(aes(y=city, x=avg_annual_base_pay))+geom_bar(stat="identity")

##############################
# san jose ; mountain view ; vancouver
view(tech_salary_data)

tech_salary_data_filter <- tech_salary_data %>% 
  filter(city %in% c("san jose","mountain view", "vancouver")) %>%
  select(city, annual_base_pay) %>%
  arrange(city)
view(tech_salary_data_filter)

# checking for normality
tech_salary_data_filter %>% ggplot(aes(sample=annual_base_pay))+stat_qq()
tech_salary_data_filter %>% ggplot(aes(sample=annual_base_pay))+stat_qq()+geom_qq_line(aes(color="red"))+theme(legend.position = "none")+labs(x="X-axis", y="Y-axis")

tech_salary_data_filter_summary <- tech_salary_data_filter %>%
  group_by(city) %>%
  summarise(observations=n(), avg_annual_base_pay=mean(annual_base_pay), stdErr=sd(annual_base_pay)/sqrt(n()))
view(tech_salary_data_filter_summary)

ggplot(tech_salary_data_filter_summary, aes(x=avg_annual_base_pay, y=city))+
  geom_point()+
  geom_label(aes(label=round(avg_annual_base_pay,3)),nudge_y = 0.2)+
  geom_errorbarh(aes(xmax=avg_annual_base_pay+1.96*stdErr, xmin=avg_annual_base_pay-1.96*stdErr))+
  labs(x="Average Annual Base Salary", y="City", title = "Confidence Intervals for city v/s average annual base salary")+
  theme_bw()

# hypothesis= H0: the mean avg salary of 3 cities is equal (i.e. they are drawn from populations with same mean); 
#             H1: not equal (i.e. drawn from population with unequal means)
# confidence interval : we've taken into consideration a 95% confidence interval

# since the number of observations are 40+21+12=73 so its>30 so by central limit theorem
# we can say that the means are normally distributed. So, we'll use z-test.
# as we know for a 95% alpha -> z-value =1.96 so we'll input it into our formula
# std error = s.d.(x)/sqrt(n)
# As can be seen from the plot, the conf intervals overlap so we can conclude that 
# these are not likely different and we fail to reject the null hypotheses and these sample means are drawn from populations with the same mean