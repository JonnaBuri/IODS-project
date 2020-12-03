# Week 6 wrangling

# Task 1
# Read the data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep  ="\t", header = T)

str(BPRS)
str(RATS)

# Task 2
# categorical to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Task 3
# convert to long and extract week and time variables
library(dplyr)
library(tidyr)

BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
RATSL <- RATS %>% gather(key = time, value = rats, -ID, -Group)

# Extract the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))
RATSL <-  RATSL %>% mutate(time = as.integer(substr(time,3,3)))


# Task 4
# Explore the data / compare long versions to wide
glimpse(BPRS)
glimpse(BPRSL)
glimpse(RATS)
glimpse(RATSL)

names(BPRS)
names(BPRSL)
names(RATS)
names(RATSL)

str(BPRS)
str(BPRSL)
str(RATS)
str(RATSL)

summary(BPRS)
summary(BPRSL)
summary(RATS)
summary(RATSL)

# save data
write.csv(BPRSL, file = "data/bprs.csv", row.names = FALSE)
write.csv(RATSL, file = "data/rats.csv", row.names = FALSE)
