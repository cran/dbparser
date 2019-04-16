## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE----------------------------------------------------------
#  ## load dbparser package
#  library(dbparser)
#  library(dplyr)
#  library(ggplot2)
#  library(XML)
#  
#  ## parse data from XML and save it to memory
#  get_xml_db_rows("drugbank_database.xml")
#  
#  ## load drugs data
#  drugs <- parse_drug()
#  
#  ## load drug groups data
#  drug_groups <- parse_drug_groups()
#  
#  ## load drug targets actions data
#  drug_targets_actions <- parse_drug_targets_actions()

## ----eval=FALSE----------------------------------------------------------
#  ## open a connection to the desired database engine with an already
#  ## created database
#  open_db(xml_db_name =  "drugbank.xml", driver = "SQL Server",
#  server = "MOHAMMED\\\\SQL2016", output_database = "drugbank")
#  
#  ## save 'drugs' dataframe to DB
#  parse_drug(TRUE)
#  
#  ## save 'drug_groups' dataframe to DB
#  parse_drug_groups(TRUE)
#  
#  ## save 'drug_targets_actions' dataframe to DB
#  parse_drug_targets_actions(TRUE)
#  
#  ## finally close db connection
#  close_db()

## ----eval=FALSE----------------------------------------------------------
#  ## view proportions of the different drug types (biotech vs. small molecule)
#  drugs %>%
#      select(type) %>%
#      ggplot(aes(x = type)) +
#      geom_bar() +
#      guides(fill=FALSE)     ## removes legend for the bar colors

## ----eval=FALSE----------------------------------------------------------
#  ## view proportions of the different drug types for each drug group
#  drugs %>%
#      rename(parent_key = primary_key) %>%
#      full_join(drug_groups, by = 'parent_key') %>%
#      select(type, text) %>%
#      ggplot(aes(x = text, fill = type)) +
#      geom_bar() +
#      theme(legend.position= 'bottom',
#            axis.text.x = element_text(angle=45, vjust=0.5)) +
#      labs(x = 'Drug Group',
#           y = 'Quantity',
#           caption="created by ggplot") +
#      coord_flip()

## ----eval=FALSE----------------------------------------------------------
#  ## get counts of the different target actions in the data
#  targetActionCounts <-
#      drug_targets_actions %>%
#      group_by(text) %>%
#      summarise(count = n()) %>%
#      arrange(desc(count))
#  
#  ## get bar chart of the 10 most occurring target actions in the data
#  p <-
#      ggplot(targetActionCounts[1:10,],
#             aes(x = reorder(text,count), y = count, fill = letters[1:10])) +
#      geom_bar(stat = 'identity') +
#      labs(fill = 'action',
#           x = 'Target Action',
#           y = 'Quantity',
#           caption = 'created by ggplot') +
#      guides(fill = FALSE) +    ## removes legend for the bar colors
#      coord_flip()              ## switches the X and Y axes
#  
#  ## display plot
#  p

