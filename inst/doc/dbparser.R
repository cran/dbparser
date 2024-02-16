## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "docs/articles/",
  out.width = "100%"
)

## ----eval=T-------------------------------------------------------------------
## load dbparser package
suppressPackageStartupMessages({
  library(tidyr)
  library(dplyr)
  library(canvasXpress)
  library(tibble)
  library(dbparser)
})


## load drugs data
drugs <- readRDS(system.file("drugs.RDS", package = "dbparser"))

## load drug groups data
drug_groups <- readRDS(system.file("drug_groups.RDS", package = "dbparser"))

## load drug targets actions data
drug_targets_actions <- readRDS(system.file("targets_actions.RDS", package = "dbparser"))

## ----eval=T-------------------------------------------------------------------
## view proportions of the different drug types (biotech vs. small molecule)
type_stat <- drugs %>% 
  select(type) %>% 
  group_by(type) %>% 
  summarise(count = n()) %>% 
  column_to_rownames("type")

canvasXpress(
  data             = type_stat,
  graphOrientation = "vertical",
  graphType        = "Bar",
  showSampleNames  = FALSE,
  title            ="Drugs Type Distribution",
  xAxisTitle       = "Count"
)

## ----eval=T-------------------------------------------------------------------
## view proportions of the different drug types for each drug group
type_stat <- drugs %>% 
  full_join(drug_groups, by = c("drugbank_id")) %>% 
  select(type, group) %>% 
  group_by(type, group) %>% 
  summarise(count = n()) %>% 
  pivot_wider(names_from = group, values_from = count) %>% 
  column_to_rownames("type")

canvasXpress(
  data           = type_stat,
  graphType      = "Stacked",
  legendColumns  = 2,
  legendPosition = "bottom",
  title          ="Drug Type Distribution per Drug Group",
  xAxisTitle     = "Quantity",
  xAxis2Show     = TRUE,
  xAxisShow      = FALSE,
  smpTitle      = "Drug Group")

## ----eval=T-------------------------------------------------------------------
## get counts of the different target actions in the data
targetActionCounts <- 
    drug_targets_actions %>% 
    group_by(action) %>% 
    summarise(count = n()) %>% 
    arrange(desc(count)) %>% 
    top_n(10) %>% 
    column_to_rownames("action")

## get bar chart of the 10 most occurring target actions in the data
canvasXpress(
  data            = targetActionCounts,
  graphType       = "Bar",
  legendColumns   = 2,
  legendPosition  = "bottom",
  title           = "Target Actions Distribution",
  showSampleNames = FALSE,
  xAxis2Show      = TRUE,
  xAxisShow       = FALSE)

