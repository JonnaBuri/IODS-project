# Ioanna Bouri
# 2/11/20
# Week 2: Data wrangling

# 2 
# Reading the data
data <- read.delim(file = "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header = TRUE)

# Print shape of data
dim(data)

# Show structure of the data
str(data)

# Show first rows of data records
head(data)

# So we have a dataframe with 183 records and 60 feature variables

# 3
# Creating an analysis dataset with variables: gender, age, attitude, deep, stra, surf

#d_sm:1=D03+D11+D19+D27
d_sm <- data$D03 + data$D11 + data$D19 + data$D27

#d_ri:1=D07+D14+D22+D30
d_ri <- data$D07 + data$D14 + data$D22 + data$D30

# d_ue:1=D06+D15+D23+D31
d_ue <- data$D06 + data$D15 + data$D23 + data$D31

# Estimate variable deep
deep <- d_sm + d_ri + d_ue
length(deep)

# st_os:1=ST01+ST09+ST17+ST25
st_os <- data$ST01 + data$ST09 + data$ST17 + data$ST25

# st_tm:1=ST04+ST12+ST20+ST28
st_tm <- data$ST04 + data$ST09 + data$ST20 + data$ST28

# Estimate variable stra
stra <- st_os + st_tm
length(stra)


# su_lp = SU02 + SU10 + SU18 + SU26
su_lp <- data$SU02 + data$SU10 + data$SU18 + data$SU26

# su_um = SU05 + SU13 + SU21 + SU29
su_um <- data$SU05 + data$SU13 + data$SU21 + data$SU29

# su_sb = SU08 + SU16 + SU24 + SU32
su_sb <- data$SU08 + data$SU16 + data$SU24 + data$SU32

# Estimate variable surf
surf <- su_lp + su_um + su_sb
length(surf)

# Scaling all combination variables by dividing with the number of variables combined in each case
deep <- deep / 3
stra <- stra / 2
surf <- surf / 3

max(surf)
min(surf)

# Creating analysis dataset
andata <- data.frame(data$gender, data$Age, data$Attitude, deep, stra, surf, data$Points)
str(andata)

# Renaming some columns
colnames(andata)[1] <- "gender"
colnames(andata)[2] <- "Age"
colnames(andata)[3] <- "Attitude"
colnames(andata)[7] <- "Points"
str(andata)

# Dropping exams with zero points
andata <- andata[!(Points == 0),]
dim(andata)
head(andata)

# 4
# Write andata to csv
write.csv(andata, file = "data/andata.csv", row.names = FALSE)

# Check that we can read the data correctly
andata2 <- read.csv(file = "data/andata.csv", header = TRUE)
head(andata2)
dim(andata2)
str(andata2)
  