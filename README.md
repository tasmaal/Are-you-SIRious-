# Modeling and Simulation of Social Systems Fall 2018 – Research Plan

> * Group Name: Ebola SIRum
> * Group participants names: Arthur Couteau, Marco Torredimare
> * Project Title: Ebola Simulation using Networks
> * Programming language: MATLAB

## General Introduction

At the end of 2013, the largest Ebola outbreak took place in West Africa. On March 2016, it was not considered an emergency anymore, but in this lapse of time it caused over 11 thousands deaths and almost 30 thousands cases of infection.
More recently, in 2017 and in 2018, new outbreaks happened mainly in the Democratic Republic of Congo. Even thought the disease was identified in 1976 and it was largely studied, especially since 2013, the models present in the scientific literature could not predict the most recent outbreaks of the past two years.
For these reasons, we have decided to study the behaviour of Ebola, starting from a simplified model, and adding more information regarding its peculiarities and ways of transmission.

## The Model

To study the Ebola outbreaks, we have initially used a SIRPD model, an implemen-tation of the SIR model.  This system considers various states, which are accountedin the transmission of the Ebola virus, but the resolution of the ordinary differentialequations reaches an asymptotic behaviour after a certain time.  For this reason andto take into account more properties of the Ebola virus, we changed our model to anetwork system.Using an activity driven network, we managed to simulate the interactions betweenindividuals, considered as nodes, and study the development of their state.  Fittingthe  parameters  of  the  latest  outbreak,  we  were  able  to  simulate  the  transmissionof  the  Ebola  virus  in  a  complex  system,  considering  also  the  medical  proceduresadopted for this disease.

## Fundamental Questions

Which model approximates, in the most accurate way, the Ebola virus?
Are there stochastic parameters in the outbreaks?
Can we obtain a model which can predict accurately the behaviour of Ebolaoutbreaks?

## Expected Results

Complete simulation will fit with the latest Ebola outbreak.

## References 

Anonymous. Outbreak of ebola haemorrhagic fever, uganda, august 2000-january2001.Weekly Epidemiological Record, 76:41–46, 2001.

T.  Berge,  J.-S.  Lubuma,  G.  Moremedi,  N.  Morris,  and  R.  Kondera-Shava.   A simple mathematical model for ebola in africa.Journal of Biological Dynamics,11(1):42–74, 2017.

W. Kermack and A. McKendrick.  Contribution to the mathematical theory ofepidemics.Proceedings of the Royal Society of London Series A-Containing Papers of a Mathematical and Physical Character, 115(772):700–721, 1927.

J.  Legrand,  R.  F.  Grais,  P.  Y.  Boelle,  A.  J.  Valleron,  and  A.  Flahault.   Un-derstanding the dynamics of ebola epidemics.Epidemiol. Infect.,  135:610–621,2007.

W.  H.  Organization.Ebola  outbreak  in  drc  ends:   Who  calls  for  interna-tional  efforts  to  stop  other  deadly  outbreaks  in  the  country,   2018.URLhttp://www.who.int/news-room/detail/24-07-2018-ebola-outbreak-in-drc-ends--who-calls-for-international-efforts-to-stop-other-deadly-outbreaks-in-the-country.

A.  Rizzo,  B.  Pedalino,  and  M.  Porfiri.   A  network  model  for  ebola  spreading.Journal of Theoretical Biology, 394:212–222, 2016


## Research Methods

SIR Model; Network systems


## Other

W. H. Organization.  Dr congo north-kivu - ebola cases and deaths, 2018.  URLhttps://data.humdata.org/dataset/ebola-cases-and-deaths-drc-north-kivu.

W.  H.  Organization.Dr  congo  -  ebola  cases  and  deaths,   2018.URLhttps://data.humdata.org/dataset/ebola-cases-and-deaths-drc.

# Reproducibility
To perform the light test, follow the instructions:

-Verify  that  all  the  functions  detailed  in  Appendix  C  are  in  the  same  folder,along with the data files DataMay2018.mat and DataAug2018.mat.

-In the command window, enter the following command line:
>> maxNumCompThreads 
This will allow Matlab to use the maximum number of threads.  If you want to limit the number of cores Matlab will use, type:
>> LASTN = maxNumCompThreads(N)
Where N is the number of threads, and LASTN the previous maximum number.

-Open functionBatch.m.

-Make sure the parameters defined in part 1 have the same value as in AppendixC.

-Make sure the part 2 of the function is uncommented (CTRL + T to uncomment selected text) and that the part 3 is commented (CTRL + R to comment selected text).

-Run functionBatch.m.  The light test computes the evolution of populations over time, and compares it to data coming from WHO. This will take≈4 min on 4 cores.

-A folder named OutputEbola is created by the program.  It contains text files of the different trials of the simulation.

-The graph depicted in Figure 3 will appear.

