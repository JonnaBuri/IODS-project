# Ioanna Bouri
# 11/11/20
# Week 3: Data wrangling
# data reference: https://archive.ics.uci.edu/ml/datasets/Student+Performance

# 3 
# Reading the data
mat <- read.csv(file = "data/student-mat.csv", header = TRUE, sep = ';')
dim(mat)
str(mat)

por <- read.csv(file = "data/student-por.csv", header = TRUE, sep = ';')
dim(por)
str(por)

# 4
# Joining the datasets
library(dplyr)

por_id <- por %>% mutate(id=1000+row_number())
math_id <- math %>% mutate(id=2000+row_number())

free_cols <- c("id","failures","paid","absences","G1","G2","G3")
join_cols <- setdiff(colnames(por_id),free_cols)
pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

# Combine datasets to one long data
#   NOTE! There are NO 382 but 370 students that belong to both datasets
#         Original joining/merging example is erroneous!
pormath <- por_id %>% 
  bind_rows(math_id) %>%
  # Aggregate data (more joining variables than in the example)  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
  # Remove lines that do not have exactly one obs from both datasets
  #   There must be exactly 2 observations found in order to joining be succesful
  #   In addition, 2 obs to be joined must be 1 from por and 1 from math
  #     (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  # Calculate other required variables  
  ungroup %>% mutate(
    alc_use = (Dalc + Walc) / 2,
    high_use = alc_use > 2,
    cid=3000+row_number()
  )

dim(pormath)

# 5
# Combine the 'duplicated' answers in the joined data
alc <- select(pormath, one_of(join_by))
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(pormath, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column  vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

dim(alc)

# 6
# Create column alc_use by averaging weekday and weekend alcohol consumption
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# Create column high_use
alc <- mutate(alc, high_use = alc_use > 2)

# 7
# Glimpse and save dataframe
glimpse(alc)
dim(alc)
# Per updated instruction the shape of the array should be 370x35, not 382x35 as mentioned in the exercise.
write.csv(alc, file = "data/w3.csv", row.names = FALSE)

# Check that we can read the data correctly
alc2 <- read.csv(file = "data/w3.csv", header = TRUE)
head(alc2)
dim(alc2)
str(alc2)
