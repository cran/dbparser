context("test drugbank database metadata")

library(testthat)

biotech <- "drugbank_record_biotech.xml"
test_that(
  desc = "Read database",
  code = {
    expect_true(!is.null(read_drugbank_xml_db(
      system.file("extdata", biotech, package = "dbparser")
    )))
  }
)

test_that(
  desc = "Read dvobject metadata",
  code = {
    db_location <- system.file("extdata",
                               biotech,
                               package = "dbparser")

    dvobj    <- parseDrugBank(db_location)
    metadata <- dbparser::show_dvobject_metadata(dvobj)

    expect_match(metadata$Value[[1]], "DrugBank")
    expect_match(metadata$Value[[2]], "5.1")
    expect_match(metadata$Value[[3]], "2018-07-03")
    expect_match(metadata$Value[[4]], "dvobject")
  }
)
