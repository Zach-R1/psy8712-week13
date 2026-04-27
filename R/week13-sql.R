# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
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


