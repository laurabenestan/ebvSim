#' @title Analyze Replicates
#' @description Conduct analysis of all replicates for a given EBV
#'   
#' @param analysis character vector of EBV analysis to run (`ldNe`, `g2`, 
#'   `het`, or `froh`).   
#' @param label label of simulation run.
#' 
#' @return data frame of summary metrics
#'   
#' @author Eric Archer \email{eric.archer@@noaa.gov}
#' 
#' @export
#'  
analyzeReps <- function(analysis, label) {
  analysis.func <- switch(
    analysis,
    ldNe = calc_ldNe,
    g2 = calc_g2,
    het = calc_heterozygosity,
    froh = calc_froh
  )
  params <- NULL
  load(paste0(label, "_ws.rdata"))
  replicates <- expand.grid(
    scenario = 1:nrow(params$scenarios), 
    replicate = 1:params$num.rep
  )
  n <- nrow(replicates)
  purrr::map(1:n, function(i) {
    cat(i, "/", n, "\n")
    sc <- replicates$scenario[i]
    rep <- replicates$replicate[i]
    results <- loadGenotypes(label, sc, rep) %>% 
      analysis.func() 
    if(!is.null(results)) {
      results %>% 
        dplyr::mutate(
          scenario = sc,
          replicate = rep
        ) %>% 
        dplyr::select(
          .data$scenario, 
          .data$replicate, 
          .data$stratum, 
          dplyr::everything()
        )
    } else NULL
  }) %>% 
    dplyr::bind_rows() %>% 
    dplyr::arrange(.data$scenario, .data$replicate, .data$stratum)
}