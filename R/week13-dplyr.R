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
employees_tbl <- dbGetQuery(con, "SELECT * FROM datascience_employees")
testscores_tbl <- dbGetQuery(con, "SELECT * FROM datascience_testscores")
offices_tbl <- dbGetQuery(con, "SELECT * FROM datascience_offices")

write.csv(employees_tbl, "../data/employees.csv", row.names = FALSE)
write.csv(testscores_tbl, "../data/testscores.csv", row.names = FALSE)
write.csv(offices_tbl, "../data/offices.csv", row.names = FALSE)






