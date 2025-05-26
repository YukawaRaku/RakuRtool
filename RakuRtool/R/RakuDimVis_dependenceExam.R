#' Check all Raku package dependencies and inform the user which packages are installed or missing
#' @param auto_install Logical. Whether to automatically install missing packages (default FALSE, for safety)
#' @return A list with 'installed' and 'missing' package vectors (invisible)
#' @export
check_RakuDimVis_dependencies <- function(auto_install = FALSE) {
  required <- c("ggplot2", "ggrepel", "viridis", "ggnewscale", "uwot", "Rtsne", "gridExtra")
  installed <- required[sapply(required, requireNamespace, quietly = TRUE)]
  missing <- setdiff(required, installed)
  cat("Installed dependencies: ", paste(installed, collapse = ", "), "\n")
  if(length(missing) > 0){
    cat("Missing dependencies: ", paste(missing, collapse = ", "), "\n")
    if(auto_install){
      install.packages(missing)
      cat("Attempted to install missing packages. Please re-run the check to confirm all are installed.\n")
    } else {
      cat("Please manually install the missing packages above (or set auto_install = TRUE to install automatically).\n")
    }
  } else {
    cat("All required dependencies are installed!\n")
  }
  # 一键启动已装包
  for(pkg in installed){
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  }
  invisible(list(installed = installed, missing = missing))
}