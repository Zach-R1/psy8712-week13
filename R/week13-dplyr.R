# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(DBI)
library(RPostgres)

con <- dbConnect( # I'm considering connecting to the db Resources, but if thats not standard convention let me know
  Postgres(),
  user = Sys.getenv("NEON_USER"), 
  password = Sys.getenv("NEON_PW"), 
  dbname = "neondb",
  host = "ep-billowing-union-am14lcnh-pooler.c-5.us-east-1.aws.neon.tech",
  port = 5432,
  sslmode = "require")

# Data Import and Cleaning
employees_tbl <- dbGetQuery(con, "SELECT * FROM datascience_employees") # selected all(*) from specified table in db
testscores_tbl <- dbGetQuery(con, "SELECT * FROM datascience_testscores")  # selected all(*) from specified table in db
offices_tbl <- dbGetQuery(con, "SELECT * FROM datascience_offices")  # selected all(*) from specified table in db

write.csv(employees_tbl, "../data/employees.csv", row.names = FALSE) # Save csv to data file
write.csv(testscores_tbl, "../data/testscores.csv", row.names = FALSE) # Save csv to data file
write.csv(offices_tbl, "../data/offices.csv", row.names = FALSE) # Save csv to data file

week13_tbl <- employees_tbl %>%
  inner_join(testscores_tbl, by = "employee_id") %>% # join employees w/ test scors using their id removing employees w/o test scores
  inner_join(offices_tbl, by = c("city" = "office")) # join offices dataset, matches city to office and adds appropriate office type 

write.csv(week13_tbl, "../out/week13.csv", row.names = FALSE) # Save as csv to out

# Analysis
week13_tbl %>%
  filter(manager_hire == "Y") %>% # Filter down to manager hires
  summarise(total_managers = n()) # Summarize down to one row to obtain manager count

week13_tbl %>%
  filter(manager_hire == "Y") %>% # Filter down to manager hires
  summarise(unique_managers = n_distinct(employee_id)) # Summarize down to one row to obtain manager count

week13_tbl %>%
  filter(manager_hire == "N") %>% # Filter down to not originally manager hires
  group_by(city) %>% # Group by the city
  summarise(num_managers = n()) # Provide summary

week13_tbl %>%
  group_by(performance_group) %>% # This was shorter than using factor and got the same result
  summarise(
    mean_years = mean(yrs_employed, na.rm = TRUE), # Calculate mean years employed
    sd_years = sd(yrs_employed, na.rm = TRUE) # Calculate sd years employed
  )

week13_tbl %>%
  filter(manager_hire == "Y") %>% # Filter for manager hire
  select(office_type, employee_id, test_score) %>% # Select relevant variables
  arrange(office_type, desc(test_score)) # Arrange first alphabetically by office type then by test score in desc order