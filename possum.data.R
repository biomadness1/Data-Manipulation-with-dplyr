library(dplyr)

#Part a: 

#At this stage, the 'possum.csv' data has been read as a data frame using the 'read.table' function.
#Read the dataset as a dataframe in R. Find the possum with highest overall length. 
#What is its gender? Find the answers using codes. Do not use for loops.

possum.data = read.table("possum.csv", header = TRUE, sep = ",", dec = ".", quote = "'") #read the possum.csv file as dataframe

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

# Finding the example with the maximum total.length and assigning this information to the variable information.max.length
information.max.length = possum.data[which(possum.data$total.length == max(possum.data$total.length)),]

# Creating a dataframe from the example with the maximum length to provide a more concise view
summary.max.length = data.frame(
  total.length = information.max.length$total.length,
  sex = information.max.length$sex,
  row.names = information.max.length$Species
)
summary.max.length

#Part b:

#Plot a graph to show the relationship between tail length and head length. 
#The possums from Victoria and from other regions should be shown with different colors and different shapes in this plot. 
#Is there any difference in the relation in terms of being from Victoria or not?
  
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

#Part c:
#Calculate the means of tail length separately for males and females in a single-line code without using dplyr. 
#Which gender has the smallest average tail length? Is the difference meaningful? 
#Do you see a more meaningful difference between genders if 
#you check the means of total length? Repeat the analysis by using the dplyr package.

#Single-line codes

#females-tail.length
female.tail.mean = sapply(data.frame(possum.data[which(possum.data$sex=="f"),]$tail.length), mean)
#males-tail.length
male.tail.mean = sapply(data.frame(possum.data[which(possum.data$sex=="m"),]$tail.length), mean)

print(female.tail.mean)
print(male.tail.mean)

#Repeat analysis using Dplyr package

# Average tail length of female possums has been calculated.
female.tail.mean.pipe = possum.data %>%
  filter(sex == "f") %>% # Filtering for sex using the filter() function.
  summarise(mean(tail.length, na.rm = TRUE)) # Calculating the mean of tail lengths and assigning the result to the respective variable.

# Average tail length of male possums has been calculated.
male.tail.mean.pipe = possum.data %>%
  filter(sex == "m") %>% # Filtering for sex using the filter() function.
  summarise(mean(tail.length, na.rm = TRUE)) # Calculating the mean of tail lengths and assigning the result to the respective variable.

print(female.tail.mean.pipe)
print(male.tail.mean.pipe)

#Part d: 
#Use a single-line code to calculate the mean of tail lengths of male and female possums, and the possums from Victoria and from other 
#ons simultaneously (For example, your output should show the average tail length of female possums from Victoria). 
#Repeat the analysis by using the dplyr package.

#Single-line codes
  
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

#Repeat analysis using Dplyr package

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

#Part e:

#Single-line codes
  
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

#Repeat analysis using Dplyr package

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

#Part f: 
  
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