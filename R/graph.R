#' @export
graph <- function(p0, pm, d0, dm, ds, V, Cm, Cs, state_prior, disc=0.95, size = 1){

  #tests the inputs
  stopifnot(p0>=0,p0<=1) #checks if p0 is a probability
  stopifnot(pm>=0,pm<=1) #checks if pm is a probability
  stopifnot(d0>=0,d0<=1) #checks if d0 is a probability
  stopifnot(dm>=0,dm<=1) #checks if d is a probability
  stopifnot(ds>=0,ds<=1) #checks if d is a probability
  stopifnot(V>=0, Cm >= 0, Cs >= 0) #checks if values and costs are positif
  stopifnot(sum(state_prior)==1)#checks that state_prior is a probability
  stopifnot(state_prior>=0,state_prior<= 1)#checks that state_prior is a probability

  stopifnot(disc>=0, disc <= 1) #checks if the discount factor is between 0 and 1

  #buiding the matrices of the problem
  t <- smsPOMDP::tr(p0, pm, d0, dm, ds, V, Cm, Cs) #transition matrix
  o <- smsPOMDP::obs(p0, pm, d0, dm, ds, V, Cm, Cs)#observation matrix
  r <- smsPOMDP::rew(p0, pm, d0, dm, ds, V, Cm, Cs)#reward matrix
  
  stopifnot(smsPOMDP::check_pomdp(t,o,r))
  
  if (state_prior[1] == 1){#the species is extant for sure
    tab <- smsPOMDP::tab_actions(t,o,r,state_prior,disc)
    return(smsPOMDP::minigraph(tab, tab2 = NULL, size = size))
  } else {#the probability that the species is extant is not 1
    tab <- smsPOMDP::tab_actions(t,o,r,c(1,0),disc)
    tab2 <- smsPOMDP::tab_actions(t,o,r,state_prior,disc)
    return(smsPOMDP::minigraph(tab, tab2, size))
  }

}
