#' @title Run EBV Simulations
#' @description Run a set of scenarios and replicates to generate genotypes.
#' 
#' @param scenarios data frame of scenario specifications generated by 
#'   \code{\link{makeScenarios}}.
#' @param genetics specification of genetic data to be simulated as output from 
#'   \code{\link[strataG]{fscSettingsGenetics}}.
#' @param label label of simulation run to download.
#' @param num.rep number of replicates to run for each scenario.
#' @param ploidy ploidy of genetic data.
#' @param google.drive.id id of root Google Drive to download run from.
#' @param run.rmetasim logical determining whether or not to run rmetasim for 
#'   two generations after fastsimcoal run.
#' 
#' @return vector of folders where scenario data and replicates were written.
#'   
#' @author Eric Archer \email{eric.archer@@noaa.gov}
#' 
#' @export
#'  
runEBVsim <- function(label, scenarios, genetics, num.rep, ploidy = 2, 
                   google.drive.id = NULL, run.rmetasim = TRUE) {
  folders <- writeScenarios(label, scenarios, google.drive.id)
  rep.id <- if(!is.null(folders$google)) {
    googledrive::as_id(folders$google) 
  } else NULL
               
  for(sc.i in 1:nrow(scenarios)) {
    cat(format(Sys.time()), "---- Scenario", sc.i, "----\n")
    
    sc <- scenarios[sc.i, ]
    p <- runFscSim(
      label = label, 
      sc = sc, 
      genetics = genetics,
      ploidy = ploidy, 
      num.rep = num.rep
    )
    
    for(sim.i in 1:num.rep) {
      gen.data <- strataG::fscReadArp(p, sim = c(1, sim.i), drop.mono = TRUE)
      if(run.rmetasim) {
        gen.data <- gen.data %>% 
          calcFreqs() %>% 
          runRmetasim(sc = sc) %>% 
          rmetasim::landscape.make.genind() %>% 
          strataG::genind2gtypes() %>% 
          strataG::as.data.frame()
      }
      
      fname <- repFname(label, sc$scenario, sim.i)
      out.name <- file.path(folders$out, fname)
      utils::write.csv(gen.data, file = out.name, row.names = FALSE)
      if(!is.null(rep.id)) {
        googledrive::drive_upload(
          out.name, 
          path = rep.id, 
          name = fname, 
          verbose = FALSE
        )
      }
    }
  }
  
  invisible(folders)
}