# Wrangling preparation for week 5

# Task 2 reading datasets
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")


# Task 3 EDA
str(hd)
str(gii)

summary(hd)
summary(gii)


# Task 4 Rename columns

library(dplyr)

colnames(hd)[3] <- "humandevelopindex" # HDI - human development index
colnames(hd)[4] <- "lifeexp"           # Life expectancy at death
colnames(hd)[5] <- "expedu"            # Expected years of schooling
colnames(hd)[6] <- "meaneduyrs"        # Mean years of schooling
colnames(hd)[7] <- "grossnationalincome"#GNI - Gross National Income per capita
colnames(hd)[8] <- "gniminushdi"       # Gross National Income per capita minus the Human Development Index


colnames(gii)[3] <- "genderineqindex"  # Gender inequality index
colnames(gii)[4] <- "maternalmort"     # Maternal mortality ratio
colnames(gii)[5] <- "adolbirth"        # Adolescent birth rate
colnames(gii)[6] <- "parliamentrepres" # Percetange of female representatives in parliament
colnames(gii)[7] <- "popsecedufem"     # Proportion of females with at least secondary education
colnames(gii)[8] <- "popsecedumal"     # Proportion of males with at least secondary education
colnames(gii)[9] <- "labforcefem"      # Proportion of females in the labour force
colnames(gii)[10] <- "labforcemal"     # Proportion of males in the labour force

# Task 5 New variables

gii$popsecratio <- gii$popsecedufem / gii$popsecedumal
gii$labforceratio <- gii$labforcefem / gii$labforcemal


# Task 6 Inner join

human <- inner_join(hd, gii, by = "Country")
dim(human) # 195 19
write.csv(human, file = "data/human-row.csv", row.names = FALSE)


# Week 5

# Dataset summary
str(human)
dim(human) #195 19

# You can find a brief explanation on the variables in the renaming section above ^^ (Week 4 - task 4)

# Task 1
library(stringr)
human$grossnationalincome <- str_replace(human$grossnationalincome, pattern=",", replace ="") %>% as.numeric

# Task 2
keep <- c("Country", "popsecedufem", "labforcefem", "lifeexp", "expedu", "grossnationalincome", "maternalmort", "adolbirth", "parliamentrepres")
human <- select(human, one_of(keep))
str(human)

# Task 3
# print out a completeness indicator of the 'human' data
complete.cases(human)

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

# filter out all rows with NA values
human_ <- filter(human, complete.cases(human))
dim(human_)

# Task 4
# look at the last 10 observations
tail(human_, 10)

# last indice we want to keep
last <- nrow(human_) - 7

# choose everything until the last 7 observations
human_ <- human_[1:last, ]
dim(human_)

# Task 5
# add countries as rownames
rownames(human_) <- human_$Country
dim(human_)

# remove the Country variable
human <- select(human_, -Country)
dim(human) # 155 8

write.csv(human, file = "data/human.csv", row.names = TRUE)


