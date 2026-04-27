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
  inner_join(testscores_tbl, by = "employee_id") %>%
  inner_join(offices_tbl, by = c("city" = "office"))

write.csv(week13_tbl, "../out/week13.csv", row.names = FALSE)


