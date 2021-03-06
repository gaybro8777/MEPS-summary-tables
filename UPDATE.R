# -----------------------------------------------------------------------------
# Emily Mitchell
# Updated: 12/22/2020
# 
# MEPS tables creation
#  - Run this code to update MEPS tables for new data years
# -----------------------------------------------------------------------------

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(survey)
library(MEPS)
library(readxl)
library(htmltools)
#library(haven) -- included in tidyverse

source("functions.R")

apps <- c(
  "hc_use", "hc_ins", "hc_pmed", 
  "hc_care_access", "hc_care_diab", "hc_care_qual",
  "hc_cond_icd9",   "hc_cond_icd10") 


# Year (or years) that needs to be run
  #year_list <- c(2014, 2018)
  year_list = 2018
  hc_year <- max(year_list)

  
# Define grouping variables ---------------------------------------------------
  
  demo_grps <- c(
    "ind", "agegrps", "region", "married", "race", "sex", "education",
    "employed", "insurance", "poverty", "health", "mnhlth")
  
  pmed_grps <- c("TC1name", "RXDRGNAM")
  
  ins_grps  <- c("insurance", "ins_lt65", "ins_ge65")

  
# Create tables for new data year ---------------------------------------------

  ## !! For hc_cond icd10 versions (2016, 2017), need to build tables on secure
  ## !! LAN, since CCSR codes are not on PUFs 

  # Create new tables for data year -- takes about 3 hours
 
  source("run_ins.R")  # ~ 4 min
  source("run_pmed.R") # ~ 2 min 
  
  source("run_care_access.R") # Shift in variables in 2018
  source("run_care_diab.R")   
  source("run_care_qual.R")   # Only odd years, starting 2017 (2002-2017, 2019, 2021,...)
  
  source("run_cond.R") # do NOT run for 2016/2017 -- only available on Secure LAN
  source("run_use.R")  # ~ 1 hr 

  
  # QC tables for new year -- need to update for hc_cond_icd10 to include more years
    log_file <- "update_files/update_log.txt"
    source("qc/UPDATE_check.R")
  
  ## STOP!! CHECK LOG (qc/update_files/update_log.txt) before proceeding
  
  ## Transfer 2016/2017 hc_cond_icd10 tables here before formatting
    
  
# Format tables --------------------------------------------------------------
    
  # Output to formatted_tables folder
  # totPOP for 'Any event' is updated -- old version was including all people, including those with no events

  source("functions_format.R")  
  
  format_tables(appKey = "hc_ins",  years = 1996:2018)
  format_tables(appKey = "hc_pmed", years = 1996:2018)
  format_tables(appKey = "hc_use",  years = 1996:2018)
  
  format_tables(appKey = "hc_cond_icd9",  years = 1996:2015)
  format_tables(appKey = "hc_cond_icd10", years = 2016:2018)
  
  format_tables(appKey = "hc_care_access", years = 2002:2018)
  format_tables(appKey = "hc_care_diab",   years = 2002:2018)
  format_tables(appKey = "hc_care_qual",   years = 2002:2017)
  
    