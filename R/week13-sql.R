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
# Counted total managers in employees with test scores (joined so that only employees with test scores are in the query) The duplicate id coloumn bugs me

dbGetQuery(con, "
           SELECT COUNT(DISTINCT datascience_employees.employee_id) AS unique_managers
           FROM datascience_employees
           INNER JOIN datascience_testscores
              ON datascience_employees.employee_id = datascience_testscores.employee_id
           WHERE manager_hire = 'Y';
           ")
# Added distinct to prior call to get unique count of managers

dbGetQuery(con, "
           SELECT city, COUNT(*) AS num_managers
           FROM datascience_employees
           INNER JOIN datascience_testscores
              ON datascience_employees.employee_id = datascience_testscores.employee_id
           WHERE manager_hire = 'N'
           GROUP BY city;
           ")
# Obtained count of hires not originally manager hires grouped by city

dbGetQuery(con, "
           SELECT performance_group,
            AVG(yrs_employed) AS mean_years,
            STDDEV(yrs_employed) AS sd_years
           FROM datascience_employees
           INNER JOIN datascience_testscores
              ON datascience_employees.employee_id = datascience_testscores.employee_id
           GROUP BY performance_group
           ORDER BY performance_group
           ")
# Obtained mean and ST of years employed, grouped and ordered by performance group. I realize that I didn't need the last line for ordering, but the default order was bottom, top, middle and it bugged me and this doesnt go again the assignment so...Also used STDDEV, but couldnt remember if it was what we discussed in class given the latter portion of the video cut out.

dbGetQuery(con, "
           SELECT datascience_offices.office_type, datascience_employees.employee_id, datascience_testscores.test_score
           From datascience_employees
           INNER JOIN datascience_testscores
              ON datascience_employees.employee_id = datascience_testscores.employee_id
           INNER JOIN datascience_offices
              ON datascience_employees.city = datascience_offices.office
           WHERE manager_hire = 'Y'
           ORDER BY datascience_offices.office_type, datascience_testscores.test_score DESC;
           ")

# Joined office data by city, ordered first alphabetically by office type then by test score in desc order.