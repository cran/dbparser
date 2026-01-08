## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "docs/articles/",
  out.width = "100%",
  warning = FALSE,
  message = FALSE
)

## ----load_data----------------------------------------------------------------
suppressPackageStartupMessages({
  library(tidyr)
  library(dplyr)
  library(tibble)
  library(canvasXpress)
  library(dbparser)
})

# Load sample tables representing parts of the parsed dvobject
drugs <- readRDS(system.file("drugs.RDS", package = "dbparser"))
drug_groups <- readRDS(system.file("drug_groups.RDS", package = "dbparser"))
drug_targets_actions <- readRDS(system.file("targets_actions.RDS", package = "dbparser"))

## ----analysis_type------------------------------------------------------------
# Prepare data: Count drugs by type
type_stat <- drugs %>% 
  group_by(type) %>% 
  summarise(Count = n()) %>% 
  arrange(desc(Count)) %>% 
  column_to_rownames("type")

# Visualize
canvasXpress(
  data             = type_stat,
  graphType        = "Bar",
  title            = "Composition of DrugBank: Drug Types",
  showSampleNames  = FALSE,
  legendPosition   = "right"
)

## ----analysis_groups----------------------------------------------------------
# Prepare data: Cross-tabulate Type vs Group
group_stat <- drugs %>% 
  full_join(drug_groups, by = "drugbank_id") %>% 
  group_by(type, group) %>% 
  summarise(count = n(), .groups = 'drop') %>% 
  pivot_wider(names_from = group, values_from = count, values_fill = 0) %>% 
  column_to_rownames("type")

# Visualize with a Stacked Bar Chart
canvasXpress(
  data           = group_stat,
  graphType      = "Stacked",
  graphOrientation = "horizontal",
  title          = "Drug Types by Approval Status",
  xAxisTitle     = "Number of Drugs",
  legendPosition = "bottom",
  xAxis2Show     = FALSE
)

## ----analysis_targets---------------------------------------------------------
# Prepare data: Top 10 most common Mechanisms of Action
targetActionCounts <- drug_targets_actions %>% 
    group_by(action) %>% 
    summarise(Count = n()) %>% 
    arrange(desc(Count)) %>% 
    slice_head(n = 10) %>% 
    column_to_rownames("action")

# Visualize
canvasXpress(
  data            = targetActionCounts,
  graphType       = "Bar",
  graphOrientation = "vertical",
  colorBy         = "Count",
  title           = "Top 10 Mechanisms of Action",
  xAxisTitle      = "Number of Interactions",
  showSampleNames = FALSE,
  legendPosition  = "none"
)

