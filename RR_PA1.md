Reproducible Research 
=====================
### Peer Assessment 1
### *Alexis Segovia*
### 17/12/2015

Used libraries:

```r
library(ggplot2) ## to use qplot
library(sqldf)  ## to use sql commands
library(Hmisc) ## to use miscellaneus graphics
```


### Loading and preprocessing the data

1. Load the data (i.e. read.csv())

```{r, echo = TRUE}
activityData <- read.csv('activity.csv')
```

2. Process/transform the data (if necessary) into a format suitable for your analysis

```{r, echo = TRUE}
activityData$date <- as.Date(activityData$date)
```

### What is mean total number of steps taken per day?


```{r, echo = TRUE}
stepsTakenPerDay <- tapply(activityData$steps, activityData$date, sum, na.rm=TRUE)
```

1. Make a histogram of the total number of steps taken each day


```{r, echo = TRUE}
qplot(stepsTakenPerDay,geom="histogram",binwidth = 400,main ='Total Steps Taken Per Day', xlab="Steps", ylab='Frequency', fill=I("gray"),  col=I("red")) 
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 

2. Calculate and report the mean and median total number of steps taken per day

```{r, echo = TRUE}
stepsTakenPerDayMean <- mean(stepsTakenPerDay)
stepsTakenPerDayMedian <- median(stepsTakenPerDay)
```
- Mean  : 9354.2295082
- Median: 10395

### What is the average daily activity pattern?

```{r, echo = TRUE}
averDailyActivity <- aggregate(x=list(meanSteps=activityData$steps), by=list(interval=activityData$interval), FUN=mean, na.rm=TRUE)
```

1. Make a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```{r, echo = TRUE}
ggplot(data=averDailyActivity, aes(x=interval, y=meanSteps)) +
    geom_line() + xlab("5-minute interval") + ylab("Average Number of Steps Taken") 
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png) 

2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```{r, echo = TRUE}
StepsByInterval <- aggregate(steps ~ interval, activityData, mean)
plot(StepsByInterval$interval,StepsByInterval$steps, type="l", xlab="Interval", ylab="Number of Steps",main="Average Number of Steps per Day by Interval")
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png) 

```{r, echo = TRUE}
maxNUmberSteps <- StepsByInterval[which.max(StepsByInterval$steps),1]
```
Max Number of Steps : 835

### Imputing missing values

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)


```{r, echo = TRUE}
totalNA <- sqldf('SELECT ad.* FROM "activityData" as ad
    WHERE ad.steps IS NULL ORDER BY ad.date, ad.interval ') 
```
    
Total Number of missing values: 2304 

2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.


```{r, echo = TRUE}
activityDataNA <- na.omit(activityData)
intervals <- ddply(activityDataNA,~interval, summarise, mean=mean(steps))
results <- sqldf('SELECT ad.*, ada.mean  FROM "intervals" as ada
    JOIN "activityData" as ad
    ON ad.interval = ada.interval 
    ORDER BY ad.date, ad.interval ') 
```

3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

```{r, echo = TRUE}
results$steps[is.na(results$steps)] <- results$mean[is.na(results$steps)]
```

4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.

Prepare data to plot


```{r, echo = TRUE}
ResultsTotalSteps <- as.integer( sqldf(' 
    SELECT sum(steps)  
    FROM results') )

ResultsTotalStepsDaily <- sqldf(' 
    SELECT date, sum(steps) as "ResultsTotalStepsDaily" 
    FROM results GROUP BY date 
    ORDER BY date') 

Resultsdailysteps <- sqldf('   
    SELECT date, ResultsTotalStepsDaily as "steps"
    FROM "ResultsTotalStepsDaily"
    ORDER BY date') 
```

Histogram of the total number of steps taken each day.


```{r, echo = TRUE}
hist(Resultsdailysteps$steps, 
     main="After Imputate NA",
     breaks=10, col=3,
     xlab="Total Number of Steps Taken Daily")
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14-1.png) 

### Are there differences in activity patterns between weekdays and weekends?

Adding a column called (Week).


```{r, echo = TRUE}
results$week <- as.factor(ifelse(weekdays(results$date) %in% 
                c("sabado","domingo"),"weekend", "weekday"))


ResultsWeek <- sqldf('   
    SELECT interval, avg(steps) as "AverageSteps", week
    FROM results
    GROUP BY week, interval
    ORDER BY interval ')
```

```{r, echo = TRUE}
p <- xyplot(AverageSteps ~ interval | factor(week), data=ResultsWeek, 
       type = 'l',
       main="Differences in activity patterns between weekdays and weekends",
       xlab="5-Minute Interval",
       ylab="Average of Steps Taken")
print (p) 
```

![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16-1.png) 

*Yes. There are more activities at weekend*
