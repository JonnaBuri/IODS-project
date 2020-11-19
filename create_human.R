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

colnames(hd)[3] <- "humandevelopindex"
colnames(hd)[4] <- "lifeexp"
colnames(hd)[5] <- "expedu"
colnames(hd)[6] <- "meaneduyrs"
colnames(hd)[7] <- "grossnationalincome"
colnames(hd)[8] <- "gniminushdi"


colnames(gii)[3] <- "genderineqindex"
colnames(gii)[4] <- "maternalmort"
colnames(gii)[5] <- "adolbirth"
colnames(gii)[6] <- "parliamentrepres"
colnames(gii)[7] <- "popsecedufem"
colnames(gii)[8] <- "popsecedumal"
colnames(gii)[9] <- "labforcefem"
colnames(gii)[10] <- "labforcemal"

# Task 5 New variables

gii$popsecratio <- gii$popsecedufem / gii$popsecedumal
gii$labforceratio <- gii$labforcefem / gii$labforcemal


# Task 6 Inner join

human <- inner_join(hd, gii, by = "Country")
dim(human) # 195 19
write.csv(human, file = "data/human.csv", row.names = FALSE)
