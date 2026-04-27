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




# Analysis
dbGetQuery(con, "
           SELECT COUNT(*) AS total_managers
           FROM datascience_employees
           INNER JOIN datascience_testscores
            ON datascience_employees.employee_id = datascience_testscores.employee_id
           WHERE manager_hire = 'Y';
           ")
# The duplicate id coloumn bugs me, but used inner joins in sql the same way i did in the other document used table.coloumn referencing. So only data with test scores

dbGetQuery(con, "
           SELECT COUNT(DISTINCT datascience_employees.employee_id) AS unique_managers
           FROM datascience_employees
           INNER JOIN datascience_testscores
            ON datascience_employees.employee_id = datascience_testscores.employee_id
           WHERE manager_hire = 'Y';
           ")

dbGetQuery(con, "
           SELECT city, COUNT(*) AS num_managers
           FROM datascience_employees
           INNER JOIN datascience_testscores
            ON datascience_employees.employee_id = datascience_testscores.employee_id
           WHERE manager_hire = 'N'
           GROUP BY city;
           ")


