# Gibbs sampler and M-H for step 2, mainly for hyperparameters.

# Drew prior for log mixture normal distribtuion.
my.pPropTypeNoObs.logmixture <- function(n.G, phi.Curr,
    p.Curr, hp.param){ # , p.DrawScale = 1, p.DrawScale.prev = 1){
  # Dispatch.
  paramlog.Curr <- p.Curr
  log.phi.Curr <- log(phi.Curr)

  # Propose new mixture parameters.
  proplist <- my.propose.paramlog(paramlog.Curr, log.phi.Curr, hp.param)

  # Update prior's acceptance and adaptive.
  # my.update.acceptance("p", 1)
  # my.update.adaptive("p", 1)

  # Only nu.Phi and sigma.Phi are used.
  ret <- proplist$paramlog
  ret
} # my.pPropTypeNoObs.logmixture().