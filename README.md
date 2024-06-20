# Data Manipulation Steps with dplyr library on possum.csv file
Some data manipulation steps are applied "possum.csv" has been applied on the data. The report and details of the study are available in this repository.


### **Part 1.a**

#### **Read the possum.csv File**

At this stage, the aim is to reach a dataframe structure where the relevant operations can be applied correctly.

Firstly, the **possum.csv** file has been read using the **read.table()** function, and then each column name has been reassigned. The reason for this is that there are extra quotation marks in the column headers. Next, the **gsub()** function has been used to remove the quotation marks from columns with extra quotation marks. The gsub() function replaces the quotation marks with empty spaces in the specified column of the dataset. 
Finally, the column bell.girth, which appears as a character but will be numeric, has been converted to numeric data with **as.numeric()** function.

```{r}
possum.data = read.table("possum.csv", header = TRUE, sep =",", dec = ".", quote = "'") #read the possum.csv file as dataframe

#assigned the colnames in possum.data
colnames(possum.data) = c("Species", "case", "site", "Pop", "sex", "age", "head.length", "skull.width", "total.length",
                          "tail.length", "foot.length", "ear.conch.length", "eye", "chest.girth", "belly.girth") 

#removed the quotation marks in the relevant columns
possum.data$Species = gsub('"', '', possum.data$Species)
possum.data$Pop = gsub('"', '', possum.data$Pop)
possum.data$sex = gsub('"', '', possum.data$sex)
possum.data$belly.girth = gsub('"', '', possum.data$belly.girth)

possum.data$belly.girth = as.numeric(possum.data$belly.girth) #defined the numeric data bell.girth column

#The possum.data has been prepared for manipulation and operations.
head(possum.data)
```

#### **Finding the Sex With the Maximum Length**

At this stage, operations are performed on the possum dataset to determine the gender of the species with the longest length. The operations are as follows:


Firstly, an example with the maximum length according to total.length has been drawn and assigned to the variable information.max.length. Then, to provide a more concise view, a dataframe has been created from the example with the maximum length, which has the type name row.names and includes gender and total.length.

The sex of the species with the maximum length is **female** (total.length = 96.5 with **C54**).

```{r}
# Finding the example with the maximum total.length and assigning this information to the variable information.max.length
information.max.length = possum.data[which(possum.data$total.length == max(possum.data$total.length)),]

# Creating a dataframe from the example with the maximum length to provide a more concise view
summary.max.length = data.frame(
  total.length = information.max.length$total.length,
  sex = information.max.length$sex,
  row.names = information.max.length$Species
)
summary.max.length
```

### **Part 1.b**
#### **The Relationship Between Tail and Head Length in Possum Dataset**

At this stage, the **aim is to visualize the relationship between tail length and head length data in the possum dataset**. The steps followed for visualization are as follows:

1. Firstly, the **plot()** function creates an empty plot with the **type = "n"** parameter, and **x and y axis labels** along with a **title** are determined.

2. Next, red-colored points are created to represent the **Victoria population**. The **points()** function retrieves tail length and head length values from the possum dataset that meet the condition **possum.data$Pop == "Vic"**. The symbols of these points are **triangles** and their color is **red**.

3. Blue-colored points are then created to represent other populations. Again, the **points()** function is used, but this time with the condition **possum.data$Pop == "other"**. The symbols of these points are **circles** and their color is **blue**.

4. The **text()** function is used to add population labels to each point. It takes the position of each point and adds **population labels **(possum.data$Pop)** on top of these points.

The resulting graph illustrates the relationship between tail length and head length for different populations in the possum dataset.

According to the obtained graph **(Figure 1)**, the feature of being from the Victoria region shows, on average, shorter head.length and tail.length compared to other regions. Additionally, the examples of head.length and tail.length in other regions are notably longer than those in the Victoria region. From this visualization, we can infer that being from the Victoria region increases the probability of having shorter head.length and tail.length features.

```{r, fig.align='center', fig.cap="**Figure 1.** **Tail Length vs Head Length between Victoria and Other Pop**"}
#Creating an empty plot with specified x-axis and y-axis labels. type = "n" indicates an empty plot.
  
plot(possum.data$tail.length, possum.data$head.length,
     main = "Tail Length vs. Head Length",
     xlab = "Tail Length", ylab = "Head Length", type = "n") 

#After creating an empty plot, drawings will be made on this empty plot using the points function.

#Points in red are plotted to represent the Victoria population based on tail.length and head.length attributes.

points(possum.data$tail.length[possum.data$Pop == "Vic"], 
       possum.data$head.length[possum.data$Pop == "Vic"], 
       pch = 17, col = "red", cex = 1, lwd = 0.5)

#Points in light blue are plotted to represent other populations based on tail.length and head.length attributes.

points(possum.data$tail.length[possum.data$Pop== "other"], 
       possum.data$head.length[possum.data$Pop == "other"], 
       pch = 19, col = "blue", cex = 1, lwd = 0.5)

#Population labels are added to each point.
text(possum.data$tail.length, possum.data$head.length, 
     labels = possum.data$Pop, pos = 2)
```

### **Part 1.c**

#### **Mean Tail Lengths by Gender**

At this stage, the aim is to compute the average tail length of possums based on their sex.

1. Firstly, the **which()** function is used to filter possums with "f" (female) and "m" (male) sexes.

2. Then, the $tail.length is used to select only the tail length column. The **sapply()** function applies the **mean()** function to the respective column.

3. The results are assigned to variables named **female.tail.mean: `r sapply(data.frame(possum.data[which(possum.data$sex=="f"),]$tail.length), mean)`** and **male.tail.mean: `r sapply(data.frame(possum.data[which(possum.data$sex=="m"),]$tail.length), mean)`** . 
According to the result obtained, the average tail length of the female species is greater than that of the male species.

The male species has the smallest average tail length. When total length measurements are checked, no significant difference is observed. The values between the two sexes appear to be close to each other. Since the average result values are also close to each other, this is an expected outcome.

#### **Single-line Codes**
```{r}
#females-tail.length
female.tail.mean = sapply(data.frame(possum.data[which(possum.data$sex=="f"),]$tail.length), mean)
#males-tail.length
male.tail.mean = sapply(data.frame(possum.data[which(possum.data$sex=="m"),]$tail.length), mean)

print(female.tail.mean)
print(male.tail.mean)
```

#### **Repeat Analysis using Dplyr Package**

1. Firstly, possums were filtered based on their sex, 'f' (female) and 'm' (male), using the **filter()** function.

2. Then, the **summarise()** function was used to calculate the mean value of the tail lengths of the selected possums. The parameter **'na.rm = TRUE'** ensures that **missing values (NA)** are not considered when calculating the mean.

3. The results were assigned to variables named **'female.tail.mean.pipe'** and **'male.tail.mean.pipe'** and printed out.

This way, with the **dplyr package's pipe operator %>%* **, the data processing steps became more **readable** and **organized**.

```{r}
#Repeat analysis using Dplyr package

#Average tail length of female possums has been calculated.
female.tail.mean.pipe = possum.data %>%
  filter(sex == "f") %>% # Filtering for sex using the filter() function.
  summarise(mean(tail.length, na.rm = TRUE)) # Calculating the mean of tail lengths and assigning the result to the respective variable.

#Average tail length of male possums has been calculated.
male.tail.mean.pipe = possum.data %>%
  filter(sex == "m") %>% # Filtering for sex using the filter() function.
  summarise(mean(tail.length, na.rm = TRUE)) # Calculating the mean of tail lengths and assigning the result to the respective variable.

print(female.tail.mean.pipe)
print(male.tail.mean.pipe)
```

The same results have been obtained through repeated analyses using dplyr.

### **Part 1.d**
#### **Mean Tail Length according to Gender and Habitat in Possum Dataset**

At this stage, the aim was to extract tail length information from the possum dataset based on **gender** and **habitat (Pop)** and calculate the average lengths accordingly. The operations are as follows:

1. Calculation of the average tail length for "victoria-female":

Female possums living in Victoria were filtered. The indices of these filtered positions were obtained using the **which()** function, and based on these indices, a data frame containing only the tail length information was created using the **data.frame()** function.
The **sapply()** function was used to calculate the **average tail lengths** within this data frame.

2. The same process was applied for **"victoria-male"**, but this time **filtering** was performed for **male** possums.

3. **Similar steps** were followed for **"other-female"** and **"other-male"**, but this time **filtering** was done for **other habitats (Pop=="other")**.

The results were assigned to variables named **"vic.female.tail.mean", "vic.male.tail.mean", "other.female.tail.mean"**, and **"other.male.tail.mean"** and printed out. This way, the average tail length for each gender and habitat combination was obtained.

#### **Single-line Codes**
```{r}
#The tail length information has been extracted from possum.data based on the filtered gender and region of occurrence,
#and a data frame has been created.
#The mean lengths have been calculated using the sapply() function for each gender and region combination at each step.

#vic-female
vic.female.tail.mean = sapply(data.frame(possum.data[which(possum.data$sex=="f" & possum.data$Pop=="Vic"),]$tail.length), mean)
#vic-male
vic.male.tail.mean = sapply(data.frame(possum.data[which(possum.data$sex=="m" & possum.data$Pop=="Vic"),]$tail.length), mean)
#other-female
other.female.tail.mean = sapply(data.frame(possum.data[which(possum.data$sex=="f" & possum.data$Pop=="other"),]$tail.length), mean)
#other-male
other.male.tail.mean = sapply(data.frame(possum.data[which(possum.data$sex=="m" & possum.data$Pop=="other"),]$tail.length), mean)

print(vic.female.tail.mean)
print(vic.male.tail.mean)
print(other.female.tail.mean)
print(other.male.tail.mean)   
```

From these outputs, it can be observed that there are some differences in tail lengths among different genders and regions. For example, the tail length of female individuals in other regions appears to be slightly longer than those in the Victoria region. Similarly, the tail length of males in the Victoria region seems to be slightly shorter than those in other regions.

#### **Repeat Analysis using Dplyr Package**

At this stage, filtering was initially performed based on gender and region using the **filter()** function for four different features. Then, the **summarise()** function was used to calculate the mean of the **"tail.length"** column, **ignoring NA values**.

The average tail lengths were computed for female possums in the "VIC" region, male possums in the "VIC" region, female possums in other regions, and male possums in other regions.

The results were assigned to separate variables for each combination and printed out. This way, the average tail length of possums was obtained based on their gender and region.

```{r}
#For each of the 4 features, filtering was performed primarily for gender and region with the filter() function.  
#Then the values of NA are ignored and the "tail.length" average is taken.

# Average tail length of female possums in the VIC region
vic.female.tail.mean.pipe = possum.data %>%
  filter(sex == "f" & Pop == "Vic") %>%
  summarise(mean(tail.length, na.rm = TRUE))

# Average tail length of male possums in the VIC region
vic.male.tail.mean.pipe = possum.data %>%
  filter(sex == "m" & Pop == "Vic") %>%
  summarise(mean(tail.length, na.rm = TRUE))

# Average tail length of female possums in other regions
other.female.tail.mean.pipe = possum.data %>%
  filter(sex == "f" & Pop == "other") %>%
  summarise(mean(tail.length, na.rm = TRUE))

# Average tail length of male possums in other regions
other.male.tail.mean.pipe = possum.data %>%
  filter(sex == "m" & Pop == "other") %>%
  summarise(mean(tail.length, na.rm = TRUE))

#Print results
print(vic.female.tail.mean.pipe)
print(vic.male.tail.mean.pipe)
print(other.female.tail.mean.pipe)
print(other.male.tail.mean.pipe)
```

The same results have been obtained through repeated analyses using dplyr.

### **Part 1.e** 

#### **Maximum and Minimum Mean Length as Site (Between 1 and 7)**

At this stage, the aim is to find the average minimum and maximum length characteristics of possums and visualize the relationship between the "site" attribute.

1. First, specific columns (7, 8, 9, 10, 11, 12, 13, 14, 15) are selected from possum.data, and average values are calculated for each "Family" group. This operation is performed using the "aggregate" function, and the result is assigned to the "location.possum.mean" dataframe.

2. Then, average values for each row in the "location.possum.mean" dataframe are calculated, and a vector is created by taking the average of these average values. This represents an average length value for each site.

3. To find the "Family" group with the longest average length, rows containing the maximum average length are assigned to the "longest.mean.length" variable. To find the "Family" group with the shortest average length, rows containing the minimum average length are assigned to the "shortest.mean.length" variable.

4. Finally, a scatter plot is drawn showing the relationship between tail length and head length in the "location.possum.mean" dataframe. The title, x and y-axis labels are determined, and "Family" labels are placed on each point.

According to the results obtained, on average, **the longest possums are found at site 1**, with a length of **69.07758**. On average, **the shortest possums are found at site 6**, with a length of **63.69538**.

When examining the plot created using the averages of site 7 **(Figure 2)**:

**Site 1:** The average tail length and head length are both at the mean for both values.

**Site 2:** The average tail length and head length are displayed as shorter compared to other regions.

**Site 3:** The average tail and head lengths are slightly above the mean.

**Site 4:** The average tail length and head length are displayed as shorter compared to other regions.

**Site 5:** It has similar averages to Site 7. The average head and tail lengths are parallel.

**Site 6:** While the average head length is short for the group, the tail length is longer compared to the mean.

**Site 7:** It has similar averages to Site 5. The average head and tail lengths are parallel.


#### **Single-line and Visualization with plot()**
```{r, fig.align='center', fig.cap= "**Figure 2. Tail Length vs. Head Length Means as Seven Sites**"}
#Calculate the average length for each family
location.possum.mean = aggregate(possum.data[, 7:15], list(Family = possum.data$site), function(x) mean(x, na.rm = TRUE))

mean.site.length = apply(location.possum.mean[, -1], 1, mean) #Find the mean length for each site

#Find the sites with the longest mean length
longest.mean.length = location.possum.mean[mean.site.length == max(mean.site.length), ]
longest.mean.length

max(mean.site.length) #Print the maximum mean length

#Find the sites with the shortest mean length
shortest.mean.length = location.possum.mean[mean.site.length == min(mean.site.length), ]
shortest.mean.length

min(mean.site.length) #Print the minimum mean length

#Plotting Tail Length vs. Head Length Means for Seven Sites
plot(location.possum.mean$tail.length, location.possum.mean$head.length, main = "Tail Length vs. Head Length Means as Seven Sites",
     xlab = "location.possum.mean$tail.length", ylab = "location.possum.mean$head.length", pch = 17, 
     col = "purple", cex = 3, lwd = 0.5)

#Adding sites names next to each point
text(location.possum.mean$tail.length, location.possum.mean$head.length, 
     labels = location.possum.mean$Family, pos = 2)
```

#### **Repeat Analysis using Dplyr Package**

At this stage, a series of operations have been performed to process the data in the possum.data dataset and find the sites with the maximum and minimum average lengths. Each operation involves the following steps:

1. Grouping is done on the possum.data dataset and it is grouped by the sites of each family.

2. Next, columns 7, 8,  9, 10, 11, 12, 13, 14 and 15 are selected. These columns contain attributes such as head.length, total.length, tail.length, foot.length, and ear.conch.length.

3. The mean is calculated for each selected column, with the argument na.rm = TRUE ensuring that missing values are not considered. **summarise_all()** has been used to perform the same summarization operation across all columns of the dataset in a single step.

4. The mean values calculated for all columns are taken, and a new column named mutate_mean_length is created using **rowwise().**

5. Finally, by selecting the mutate_mean_length column, a summary table is created containing the maximum and minimum average lengths. This is done using the **summarize() function.**

6. As a result, the summary table that is generated contains the indices of the sites with maximum and minimum average lengths, along with these lengths.

```{r}
max.min.pipe.site <- possum.data %>%  #Start with the possum.data dataset
  group_by(Family = site) %>%          #Group by the 'site' variable and assign it as 'Family'
  select(c(7, 8, 9, 10, 11, 12, 13, 14, 15)) %>%      #Select the relevant columns (7, 8, 9, 10, 11, 12, 13, 14, 15)
  summarise_all(mean, na.rm = TRUE) %>% #Calculate the mean for each column, disregarding missing values
  rowwise() %>%                         #Set to operate row-wise
  mutate(mutate_mean_length = mean(c(head.length, total.length, tail.length, foot.length, ear.conch.length), na.rm = TRUE)) %>%  # Calculate the mean length from 'head.length', 'total.length', 'tail.length', 'foot.length', 'ear.conch.length' columns
  as.data.frame() %>%                   #Convert the result to a data frame
  select(mutate_mean_length) %>%        #Select the 'mutate_mean_length' column
  summarize(                            #Perform summarization
    max.site = which(mutate_mean_length == max(mutate_mean_length)),  #Find the position of maximum length
    max.site.length = max(mutate_mean_length),                        #Find the maximum length value
    min.site = which(mutate_mean_length == min(mutate_mean_length)),  #Find the position of minimum length
    min.site.length = min(mutate_mean_length)                         #Find the minimum length value
  )
max.min.pipe.site
```
The same results have been obtained through repeated analyses using dplyr.

### **Part 1.f**

#### **Evaluation of Possum Data Set According to Age**

At this stage, the average ages of possums in the Possum dataset were calculated. Initially, the **tapply()** function was used to compute the average age for each species, and this information was stored in a data frame named possum.age.mean. Then, using the **apply()** function, the overall average age for all species was obtained and assigned to a variable called possum.age.mean_x. This stage was implemented in a **single-line**.

Subsequently, an analysis was conducted using the **dplyr package** and the piping operator **%>%**:

The **mutate()** function was employed to create a new column indicating the age category for each possum. Those with an age below the average were labeled as **"young"**, while the rest were labeled as **"old"**.

The possums were grouped by age category using the **group_by()** function. Then, the **summarise()** function was utilized to calculate the **maximum skull width (max_skull_width)** for **each age category**.

Finally, the skull width of possums was analyzed based on both age category and gender. This was achieved by grouping the data by age category and gender using **group_by()** and **summarise()** functions, respectively.

The results were stored in variables named skull.width.summary and skull.width.gender.summary and printed out. This allowed for the examination of possum skull widths considering factors such as age and gender.

```{r}
#Calculated the average age of possums in the Possum dataset.
possum.age.mean = data.frame(tapply(possum.data$age, possum.data$Species, function(x) mean(x, na.rm = TRUE)))
possum.age.mean_x = apply(possum.age.mean, 2, function(x) mean(x, na.rm = TRUE))
possum.age.mean_x #ages average

#Dplyr and piping analysis

#Create a new column indicating whether each possum is young or old
possum.data = possum.data %>%
  mutate(age_category = ifelse(age < possum.age.mean_x, "young", "old"))

#Use piping to check the maximum skull width for young and old possums
skull.width.summary = possum.data %>%
  group_by(age_category) %>%
  summarise(max_skull_width = max(skull.width, na.rm = TRUE))

#Repeat the analysis by considering both age category and gender
skull.width.gender.summary = possum.data %>%
  group_by(age_category, sex) %>%
  summarise(max_skull_width = max(skull.width, na.rm = TRUE))

#Print results
print(skull.width.summary)
print(skull.width.gender.summary)
```

The obtained result shows the relationship between age, gender, and cranial width. At first glance, there appears to be a trend in cranial width with age. Generally, younger individuals tend to have larger cranial widths compared to older individuals. However, there are also significant differences between genders:

1. There is generally a difference in cranial width between women and men. For example, the cranial width of young women is typically larger than that of young men.

2. When looking at the data in the table, it can be observed that elderly men usually have the highest cranial width. This suggests that there may be an increase in cranial width with advancing age.
