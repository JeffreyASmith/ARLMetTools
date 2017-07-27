# NAME: --------------------------------------------------------------------
#   createMetConfigFile.R

# PURPOSE: -----------------------------------------------------------------
#   Create an R object from an excel spreadsheet that contains the
#   configuration data for the MET point-stat, grid-stat, and ensemble-stat
#   tools. This function takes the spreadsheet and creates an R object in
#   the R folder called sysdata.rda which, after building and loading the
#   ARLMetTools library, makes the configuration available to the user.

# AUTHOR: ------------------------------------------------------------------
#   Jeffrey A. Smith, Ph.D.
#   U.S. Army Research Laboratory
#   RDRL-CIE-M
#   WSMR, NM, 88002-5501
#   jeffrey.a.smith1.civ@mail.mil

# REFERENCES: -------_------------------------------------------------------
#   1.  National Center for Atmospheric Research, 2017: Model Evaluation
#       Tools Version 5.2 (Metv5.2). User's Guide 6.0. Available from:
#       http://www.dtcenter.org/met/users/

# FUNCTION: createMetConfigFile --------------------------------------------
createMetConfigFile <-
  function() {
    # HISTORY --------------------------------------------------------------
    #   1.0 December 05, 2016   : Script creation
    #   1.1 July 27, 2017       : Adapted for MET 6.0, and ARLMetTools package.

    # USAGE: ---------------------------------------------------------------
    #   createMetConfigFile()

    # ARGUMENTS: -----------------------------------------------------------
    #   None.

    # RETURNS: -------------------------------------------------------------
    #   A data frame containing the table data from ref. [1] corresponding
    #   to the approriate version of either grid_stat, point_stat,
    #   or ensemble_stat.
    #
    #   The following columns are available in the data frame:
    #     1.  VERSION         : The specific version of met that included
    #                           a given LINETYPE.  For example, a MPR header
    #                           produced by met 5.0 would contain the COMMAN
    #                           and MPR NAMES where version is 5.0 or less.
    #     2.  TOOL            : Point for point_stat,
    #                         : Grid for grid_stat, and
    #                         : Ensemble for ensemble_stat.
    #     3.  TABLE           : Specific table number in Ref. [1] for the data.
    #     4.  LINETYPE        : Codes that indicate a specific met output file.
    #     5.  NAME            : Name of the met output file column.
    #     6.  MULTI_COLUMN    : TRUE indicates that NAME data spans multiple
    #                           columns. FALSE indicates that NAME data is scalar.
    #     7.  DESCRIPTION     : Data column description
    #     8.  SUPPORTED       : Boolean to if this file type is supported. A file
    #                           consists of the common elements plus the data
    #                           for a specific linetype.
    #     9.  DATATYPE        : the R data type for the data given by
    #                           LINETYPE
    #
    #   Data description
    #     1.  VERSION         : numeric
    #     2.  TOOL            : character
    #     3.  TABLE           : character
    #     4.  LINETYPE        : character
    #     5.  NAME            : character
    #     6.  MULTI_COLUMN    : logical
    #     7.  DESCRIPTION     : character
    #     8.  SUPPORTED       : logical
    #     9.  DATATYPE        : character

    # GLOBALS: -------------------------------------------------------------
    #   None.

    # ASSUMPTIONS: ---------------------------------------------------------
    #   None.

    # LIBRARIES: -----------------------------------------------------------
    library(rJava, quietly = TRUE)
    library(xlsxjars, quietly =  TRUE)
    library(xlsx, quietly = TRUE)

    # CONSTANTS: -----------------------------------------------------------
    basePath <- "D:/R Projects/ARLMetTools"
    workbookSource <- "met_tables.xlsx"
    workbookSheet <- "MET_Tables"
    dataHeader <- 16

    # LOAD FILE: ---------------------------------------------------
    # Save current directory state.
    currentDir <- getwd()
    setwd(basePath)

    # Read the config file from an xlsx spreadsheet as a data frame with
    # columns of a given data type (see comments above).  The first rows
    # of the spreadsheet contains explanatory descriptions that can
    # be safely ignored.
    metConfig <- read.xlsx2(
      file = paste(basePath, "data-raw", workbookSource, sep = "/"),
      sheetName = workbookSheet,
      startRow =  dataHeader,
      header = TRUE,
      as.data.frame = TRUE,
      colClasses = c(
        VERSION = "numeric",
        TOOL = "character",
        TABLE = "character",
        LINETYPE = "character",
        NAME = "character",
        MULTI_COLUMN = "logical",
        DESCRIPTION = "character",
        SUPPORTED = "logical",
        DATATYPE = "character"
      ),
      stringsAsFactors = FALSE
    )

    # convert NA strings to true R NA's.
    metConfig[metConfig == "NA"] <- NA

    # unload the libraries used and return the data frame
    detach("package:xlsx")
    detach("package:xlsxjars")
    detach("package:rJava")

    devtools::use_data(metConfig,internal = TRUE, overwrite = TRUE)

    setwd(currentDir)
  }
