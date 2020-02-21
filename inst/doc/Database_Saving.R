## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "docs/articles/",
  out.width = "100%"
)

## ----eval = FALSE-------------------------------------------------------------
#  # Load dbparser package
#  library(dbparser)
#  # Create SQLite database connection
#  database_connection <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
#  # DrugBank database sample name
#  biotech <- "drugbank_record_biotech.xml"
#  # Use DrugBank sample database in the library
#  read_drugbank_xml_db(system.file("extdata", biotech, package = "dbparser"))
#  # Parse all available drug tibbles
#  drug_all(save_table = TRUE, database_connection = database_connection)
#  # List saved tables
#  DBI::dbListTables(database_connection)
#  # Close SQLite connection
#  DBI::dbDisconnect(database_connection)

## ----eval=FALSE---------------------------------------------------------------
#  # Load dneeded packages
#  library(dbparser)
#  library(odbc)
#  # Create SQLServer database connection
#  con <- DBI::dbConnect(odbc::odbc(), Driver = "SQL Server", Server = "MOHAMMED\\SQL2016",
#      Database = "drugbank", Trusted_Connection = T)
#  # Use DrugBank sample database in the library
#  biotech <- "drugbank_record_biotech.xml"	
#  # DrugBank database sample name
#  read_drugbank_xml_db(system.file("extdata", biotech, package = "dbparser"))
#  # Parse all available drug tibbles
#  drug_all(save_table = TRUE, database_connection = con)
#  # List saved tables
#  DBI::dbListTables(con)
#  # Close SQLServer connection
#  DBI::dbDisconnect(con)

## ----eval=FALSE---------------------------------------------------------------
#  # Load dneeded packages
#  library(dbparser)
#  library(RMariaDB)
#  # Create SQLServer database connection
#  con <- RMariaDB::dbConnect(RMariaDB::MariaDB(), Server = "MariaDB",
#                             dbname = "drugbank", username="root",
#                             password="root")
#  # Use DrugBank sample database in the library
#  biotech <- "drugbank_record_biotech.xml"	
#  # DrugBank database sample name
#  read_drugbank_xml_db(system.file("extdata", biotech, package = "dbparser"))
#  # Parse all available drug tibbles
#  drug_all(save_table = TRUE, database_connection = con)
#  # List saved tables
#  RMariaDB::dbListTables(con)
#  # Close SQLServer connection
#  RMariaDB::dbDisconnect(con)

