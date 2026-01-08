## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE
)

## ----setup--------------------------------------------------------------------
library(dbparser)
library(dplyr)
library(tidyr)
library(canvasXpress)
library(data.table)

## ----load_drugbank------------------------------------------------------------
# Load sample DrugBank data included in the package
drugbank_path <- system.file("two_drugs.RDS", package = "dbparser")
drugbank_db <- readRDS(drugbank_path)

# Review the drugbank object structure
show_dvobject_metadata(drugbank_db)

## ----load_onside--------------------------------------------------------------
# Load sample OnSIDES data included in the package
onsides_path <- system.file("onside.RDS", package = "dbparser")
onsides_db   <- readRDS(onsides_path)

# Review the onsides_db object structure
show_dvobject_metadata(onsides_db)

## ----load_twosides------------------------------------------------------------
# Load sample TWOSIDES data included in the package
twosides_path <- system.file("twoside_raw.zip", package = "dbparser")

if(file.exists(twosides_path)) {
  twosides_db <- parseTWOSIDES(twosides_path)
} else {
  # Fallback for demonstration if file is not yet in the build
  # Mocking structure similar to actual TWOSIDES output
  twosides_db <- list(drug_drug_interactions = data.table(
    drug_1_rxnorm_id = "42375", drug_1_concept_name = "Leuprolide",
    drug_2_rxnorm_id = "1894", drug_2_concept_name = "Calcitriol",
    condition_meddra_id = "10002034", condition_concept_name = "Anaemia",
    PRR = "13.33", mean_reporting_frequency = "0.12"
  ))
  class(twosides_db) <- c("TWOSIDESDb", "dvobject", "list")
  attr(twosides_db, "original_db_info") <- list(type="TWOSIDES", version="2.0")
}

# Review structure
show_dvobject_metadata(twosides_db)

## ----merging_dbs--------------------------------------------------------------
# Step 1: Merge DrugBank + OnSIDES
db_plus_onsides <- merge_drugbank_onsides(drugbank_db, onsides_db)

# Step 2: Merge Result + TWOSIDES
# The function is chainable and automatically detects the existing data
final_db <- merge_drugbank_twosides(db_plus_onsides, twosides_db)

# Review final object structure
# Note the presence of 'drugbank', 'onsides', 'twosides', and 'integrated_data'
show_dvobject_metadata(final_db)

## ----find_link----------------------------------------------------------------
target_drug_id <- "DB00007" # Leuprolide

# 1. Get the RxNorm ID from the bridge table
mapping_df <- final_db$integrated_data$DrugBank_RxCUI_Mapping %>%
  filter(drugbank_id == target_drug_id)

target_rxcui <- mapping_df$rxcui[1]
print(paste0("DrugBank ID: ", target_drug_id, " maps to RxNorm CUI: ", target_rxcui))

## ----adverse_events-----------------------------------------------------------
# 1. Find product labels linked to this ingredient
product_rxcuis <- final_db$onsides$vocab_rxnorm_ingredient_to_product %>%
  filter(ingredient_id == target_rxcui) %>%
  pull(product_id)

target_label_ids <- final_db$onsides$product_to_rxnorm %>%
  filter(rxnorm_product_id %in% product_rxcuis) %>%
  pull(label_id)

# 2. Extract and summarize events
ae_summary <- final_db$onsides$product_adverse_effect %>%
  filter(product_label_id %in% target_label_ids) %>%
  group_by(effect_meddra_id) %>%
  summarise(Count = n()) %>%
  arrange(desc(Count)) %>%
  head(10) %>%
  left_join(final_db$onsides$vocab_meddra_adverse_effect, 
            by = c("effect_meddra_id" = "meddra_id")) %>%
  select(effect_meddra_id, meddra_name, Count)

# Fill NAs for demo purposes (if vocab is incomplete in sample)
ae_summary <- ae_summary %>%
  mutate(meddra_name = case_when(
    effect_meddra_id == 10033336 ~ "Pain",
    effect_meddra_id == 10039769 ~ "Rash", 
    effect_meddra_id == 10052995 ~ "Hot flush",
    effect_meddra_id == 10009226 ~ "Constipation",
    effect_meddra_id == 10006068 ~ "Bone pain",
    TRUE ~ meddra_name
  )) %>%
  rename(Adverse_Event = meddra_name)

print(ae_summary)

## ----second_case--------------------------------------------------------------
target_drug_id_2 <- "DB00136"

# Get RxCUI
mapping_df_2 <- final_db$integrated_data$DrugBank_RxCUI_Mapping %>%
  filter(drugbank_id == target_drug_id_2)
target_rxcui_2 <- mapping_df_2$rxcui[1]

# Get Products & Labels
product_rxcuis_2 <- final_db$onsides$vocab_rxnorm_ingredient_to_product %>%
  filter(ingredient_id == target_rxcui_2) %>%
  pull(product_id)
target_label_ids_2 <- final_db$onsides$product_to_rxnorm %>%
  filter(rxnorm_product_id %in% product_rxcuis_2) %>%
  pull(label_id)

# Summarize Events
ae_summary_2 <- final_db$onsides$product_adverse_effect %>%
  filter(product_label_id %in% target_label_ids_2) %>%
  group_by(effect_meddra_id) %>%
  summarise(Count = n()) %>%
  arrange(desc(Count)) %>%
  head(10) %>%
  left_join(final_db$onsides$vocab_meddra_adverse_effect, 
            by = c("effect_meddra_id" = "meddra_id")) %>%
  select(effect_meddra_id, meddra_name, Count) %>%
  mutate(meddra_name = ifelse(is.na(meddra_name), paste0("MedDRA_", effect_meddra_id), meddra_name)) %>%
  rename(Adverse_Event = meddra_name)

## ----interaction_analysis-----------------------------------------------------
# Look for interactions where Drug 1 is Leuprolide AND Drug 2 is Calcitriol (or vice versa)
interaction_data <- final_db$integrated_data$drug_drug_interactions %>%
  filter(
    (drugbank_id_1 == target_drug_id & drugbank_id_2 == target_drug_id_2) |
    (drugbank_id_1 == target_drug_id_2 & drugbank_id_2 == target_drug_id)
  ) %>%
  arrange(desc(as.numeric(PRR))) %>%
  select(drug_name_1, drug_name_2, condition_concept_name, PRR, mean_reporting_frequency)

print(interaction_data)

## ----viz_interaction----------------------------------------------------------
if(nrow(interaction_data) > 0) {
  # Prepare data for canvasXpress
  cx_int_data <- data.frame(PRR = as.numeric(interaction_data$PRR))
  rownames(cx_int_data) <- interaction_data$condition_concept_name
  
  canvasXpress(
    data = t(cx_int_data),
    graphType = "Bar",
    title = "Polypharmacy Risks: Leuprolide + Calcitriol",
    subtitle = "Data from TWOSIDES",
    xAxisTitle = "Signal Strength (PRR)",
    yAxisTitle = "Adverse Event",
    showLegend = FALSE
  )
} else {
  print("No interaction data found for this specific pair in the sample dataset.")
}

## ----comparative_analysis-----------------------------------------------------
# 1. Prepare Single Drug Data
s1 <- ae_summary %>% 
  mutate(Type = "Leuprolide (Alone)") %>% 
  select(Adverse_Event, Value=Count, Type)

s2 <- ae_summary_2 %>% 
  mutate(Type = "Calcitriol (Alone)") %>% 
  select(Adverse_Event, Value=Count, Type)

# 2. Prepare Interaction Data (Show Top 5)
# Note: Comparing Frequency (Count) vs PRR (Ratio) directly is tricky, 
# so we visualize them to show relative importance within their own context.
s3 <- interaction_data %>% 
  head(5) %>%
  mutate(Type = "Interaction (PRR)", Value = as.numeric(PRR)) %>% 
  select(Adverse_Event = condition_concept_name, Value, Type)

# 3. Combine
combined_data <- bind_rows(s1, s2, s3) %>%
  group_by(Type) %>%
  slice_max(Value, n = 5) %>%
  ungroup()

# 4. Reshape for Matrix
comparison_matrix <- combined_data %>%
  pivot_wider(names_from = Type, values_from = Value, values_fill = 0)

cx_compare <- as.data.frame(comparison_matrix[, -1])
rownames(cx_compare) <- comparison_matrix$Adverse_Event

# 5. Plot
canvasXpress(
  data = cx_compare,
  graphType = "Bar",
  title = "Safety Profile Comparison",
  subtitle = "Single Drug Frequencies vs. Interaction PRR",
  xAxisTitle = "Value",
  yAxisTitle = "Adverse Event",
  legendPosition = "right"
)

