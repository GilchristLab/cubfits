rm(list = ls())

suppressMessages(library(cubfits, quietly = TRUE))

### Load environment and set data.
source("00-set_env.r")
source(paste(prefix$code.plot, "u0-get_case_main.r", sep = ""))
fn.in <- paste(prefix$data, "pre_process.rda", sep = "")
load(fn.in)

### Arrange data.
phi.Obs.lim <- range(phi.Obs)
aa.names <- names(reu13.df.obs)
ret.phi.Obs <- prop.bin.roc(reu13.df.obs, phi.Obs)

for(i.case in case.names){
  ### Subset of mcmc output.
  fn.in <- paste(prefix$subset, i.case, "_PM.rda", sep = "")
  if(!file.exists(fn.in)){
    cat("File not found: ", fn.in, "\n", sep = "")
    next
  }
  load(fn.in)
  # fn.in <- paste(prefix$subset, i.case, "_PM_scaling.rda", sep = "")
  # if(!file.exists(fn.in)){
  #   cat("File not found: ", fn.in, "\n", sep = "")
  #   next
  # }
  # load(fn.in)

  ### To adjust to similar range of phi.Obs.
  ret.EPhi <- prop.bin.roc(reu13.df.obs, phi.PM)
  b.PM <- convert.bVec.to.b(b.PM, aa.names)
  predict.roc <- prop.model.roc(b.PM, phi.Obs.lim)

  ### Fix xlim.
  lim.bin <- range(ret.phi.Obs[[1]]$center)
  lim.model <- range(predict.roc[[1]]$center)
  x.lim <- c((lim.bin[1] + lim.model[1]) / 2,
              max(lim.bin[2], lim.model[2]))

  ### Plot bin and model for measurements.
  fn.out <- paste(prefix$plot.ns.diag, "bin_pred_phiObs_", i.case, ".pdf", sep = "")
  pdf(fn.out, width = 14, height = 11)
    mat <- matrix(c(rep(1, 5), 2:21, rep(22, 5)),
                  nrow = 6, ncol = 5, byrow = TRUE)
    mat <- cbind(rep(23, 6), mat)
    nf <- layout(mat, c(1, rep(8, 5)), c(1, 8, 8, 8, 8, 1), respect = FALSE)
    ### Plot title.
    par(mar = c(0, 0, 0, 0))
    plot(NULL, NULL, xlim = c(0, 1), ylim = c(0, 1), axes = FALSE)
    text(0.5, 0.8,
         paste(workflow.name, ", ", get.case.main(i.case, model), sep = ""))
    text(0.5, 0.4, "bin: observed phi")
    par(mar = c(0, 0, 0, 0))

    ### Plot results.
    for(i.aa in 1:length(aa.names)){
      tmp.obs <- ret.phi.Obs[[i.aa]]
      tmp.roc <- predict.roc[[i.aa]]
      plotbin(tmp.obs, tmp.roc, main = "", xlab = "", ylab = "",
              lty = 3, axes = FALSE, xlim = xlim)
      box()
      text(0, 1, aa.names[i.aa], cex = 1.5)
      if(i.aa %in% c(1, 6, 11, 16)){
        axis(2)
      }
      if(i.aa %in% 17:19){
        axis(1)
      }
    }
    model.label <- c("MCMC Posterior")
    model.lty <- 1
    plot(NULL, NULL, axes = FALSE, main = "", xlab = "", ylab = "",
         xlim = c(0, 1), ylim = c(0, 1))
    legend(0, 0.9, model.label, lty = model.lty, box.lty = 0)

    ### Plot xlab.
    plot(NULL, NULL, xlim = c(0, 1), ylim = c(0, 1), axes = FALSE)
    text(0.5, 0.5, "Estimated Production Rate (log10)")

    ### Plot ylab.
    plot(NULL, NULL, xlim = c(0, 1), ylim = c(0, 1), axes = FALSE)
    text(0.5, 0.5, "Propotion", srt = 90)
  dev.off()

  ### Plot bin and model for predictions.
  fn.out <- paste(prefix$plot.ns.diag, "bin_pred_EPhi_", i.case, ".pdf", sep = "")
  pdf(fn.out, width = 14, height = 11)
    mat <- matrix(c(rep(1, 5), 2:21, rep(22, 5)),
                  nrow = 6, ncol = 5, byrow = TRUE)
    mat <- cbind(rep(23, 6), mat)
    nf <- layout(mat, c(1, rep(8, 5)), c(1, 8, 8, 8, 8, 1), respect = FALSE)
    ### Plot title.
    par(mar = c(0, 0, 0, 0))
    plot(NULL, NULL, xlim = c(0, 1), ylim = c(0, 1), axes = FALSE)
    text(0.5, 0.8,
         paste(workflow.name, ", ", get.case.main(i.case, model), sep = ""))
    text(0.5, 0.4, "bin: posterior mean of Phi")
    par(mar = c(0, 0, 0, 0))

    ### Plot results.
    for(i.aa in 1:length(aa.names)){
      tmp.obs <- ret.EPhi[[i.aa]]
      tmp.roc <- predict.roc[[i.aa]]
      plotbin(tmp.obs, tmp.roc, main = "", xlab = "", ylab = "",
              lty = 3, axes = FALSE, xlim = xlim)
      box()
      text(0, 1, aa.names[i.aa], cex = 1.5)
      if(i.aa %in% c(1, 6, 11, 16)){
        axis(2)
      }
      if(i.aa %in% 17:19){
        axis(1)
      }
    }
    model.label <- c("MCMC Posterior")
    model.lty <- 1
    plot(NULL, NULL, axes = FALSE, main = "", xlab = "", ylab = "",
         xlim = c(0, 1), ylim = c(0, 1))
    legend(0, 0.9, model.label, lty = model.lty, box.lty = 0)

    ### Plot xlab.
    plot(NULL, NULL, xlim = c(0, 1), ylim = c(0, 1), axes = FALSE)
    text(0.5, 0.5, "Estimated Production Rate (log10)")

    ### Plot ylab.
    plot(NULL, NULL, xlim = c(0, 1), ylim = c(0, 1), axes = FALSE)
    text(0.5, 0.5, "Propotion", srt = 90)
  dev.off()
}