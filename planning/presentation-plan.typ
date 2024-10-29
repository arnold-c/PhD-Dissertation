#set page(numbering: "1/1")
#set quote(block: true)
#show quote: set text(style: "italic", weight: "bold")
#show quote: set align(center)
#show quote: set pad(x: 5em)

#let title = "Defense Presentation Plan"

#set document(title: title)
#align(center, text(size: 18pt, weight: "bold")[#title])

= Main Sections

- About my research
- D4A
- LCA
- Outbreak Detection
- CSD

= About My Research

== Overview

- Focus on heterogeneity and uncertainty from discretization
    - Define two terms
- Heterogeneity & discretization can exists on multiple scales
    - Going to think about 2 levels for this talk:
        - Individual
        - Population

== Individual

- IgG OD distribution
    - Imagine we are developing a test for a novel pathogen, and we have some sera from pre-pandemic times, and from individuals we are sure were recently infected
    - We want a test to be able to discriminate between two infection statuses, but overlap between the distributions means there will be false positives/negative.
        - Will need to make a judgement call about which is better/more important (foreshadow outbreak detection projects)

== Population

- Much like individual, heterogeneity and discretization exist on a population level
- Infection time series often need to be broken up into outbreak/non-outbreak times for resource allocation

== How does it present in epi models?

- Classical SIR model introduces categories - without them you couldn't model infections
- Often taken further to introduce subcategories for particular groups and model interactions e.g., age classes and traditional POLYMOD mixing matrix

== Does it matter for epi models?

- Yes:
    - During COVID-19 we saw phenomenon called overdispersion - some individuals were drivers of outbreaks (colloquially called superspreaders)
        - Some estimates indicate c. 10% infections caused 80% onward transmission (see references in https://www.pnas.org/doi/10.1073/pnas.2016623118; https://www.nature.com/articles/s41591-020-1092-0)

- If you don't account for heterogeneity, hard to create models with accurate forecasts or realistic projections
- When designing targeted interventions, important to know where to allocate resources to get the largest impact and do the most good

== What do we need to know?

- Number of groups
- Size of groups
- How groups differ with respect to an outcome
    - Risk of onwards transmission

= Presentation Outline

- This talk is going to look at each of these two scales, first the individual, and then transition to population

= D4A & LCA

== Background

- COVID-19 novel pathogen & forced campus closure in March 2020
- 35k returning students for Fall semester
    - Accounts for 20% increase in county pop
- Two well defined (discretized) groups, with different behaviors and (assumed) risk of infection and onwards transmission (heterogeneity)
- Conventional wisdom would indicate return would increase students' contact rates and lead to large increases in students exposure rates
    - Subsequent high risk of increasing community transmission

== What Was Done

- D4A study set up to examine effect
    - Paired behavioral and serological surveys for both community members and students
- Sampled community during summer (without students), then students in Fall semester, and community again during Winter break

== Initial Results

- 684 students and 1313 community residents participated in the longitudinal cohort study
- 30.4%  seroprevalence among students, 3.2% & 7.3% among community residents
- Despite clear expectations of significant between-group transmission, not observed
- Heterogeneity in behavior?

== What about the students?

- Expect that there were differences within the student population as well
- Unlike prior analysis, no clear way to separate our students into groups that can be modeled
- Believe that we can use behavioral data to 'discover' latent groups within student body
    - Behavior should be related to infection outcomes

== Discovering latent groups

- LCA is a method to define latent groups according to the behavioral survey responses of individuals, and assign a probability of group membership to each individual based on their responses
- Based on the results, saw that an LCA model with 3 classes was best fit to the data

== Are the classes associated with outcome?

- Yes, with classes that did the least exhibiting the highest seroprevalence, and with OR > 1 when compared to the class that were the most adherent

== Incorporating classes into a model

- Now we have classes that map behavior to infection rates as expected, we estimated transmission parameters to allow exploration of interventions
- Explain fitting process (only did structure $bold(A)$)

#set math.equation(numbering: "1")
#let boldred(x) = text(fill: rgb("#8B0000"), $bold(#x)$)

$
rho mat(
  beta_(H H), beta_(H M), beta_(H L) ;
  beta_(M H), beta_(H M), beta_(M L) ;
  beta_(L H), beta_(H M), beta_(L L) ;
)
&&arrow rho mat(
  beta_(H H), phi.alt beta_(M M), boldred(phi.alt beta_(L L)) ;
  phi.alt beta_(H H), beta_(M M), boldred(phi.alt beta_(L L)) ;
  phi.alt beta_(H H), phi.alt beta_(M M), boldred(beta_(L L)) ;
) &&#text[mixing structure] bold(A)\
&&arrow rho mat(
  beta_(H H), phi.alt beta_(H H), phi.alt beta_(H H) ;
  phi.alt beta_(M M), beta_(M M), beta_(M M) ;
  boldred(phi.alt beta_(L L)), boldred(phi.alt beta_(L L)), boldred(beta_(L L)) ;
) &&#text[mixing structure] bold(B)\
$

== Fitting with Assortativity

- Plot of ABC distance by assortativity level


== What can we achieve through interventions?

- Modeled interventions by moving individuals from the low adherence groups to the high adherence groups
- Fully effective intervention can reduce transmission by 76-93%, depending on degree of assortativity

== LCA takeaways

- Using an interdisciplinary approach we were able to model heterogeneity in transmission risk in a manner that matched the empirical data
    - Not possible to do with traditional demographic-based approach for contact matrices
- Doing this showed that only 62% could have risk reduced, and expected benefit of behavioral-based interventions was limited in capacity to prevent an outbreak (although targeted interventions could have an outsized effect relative to scope)

= Integrating Individual Population Level Heterogeneity

- Shifting focus to population level & incorporation of individual level uncertainty
- Going to talk about outbreak detection, using measles as test case

= Outbreak Detection

== Measles epidemiology

- As becomes rarer, outbreaks make up a more significant portion of the annual incidence (Graham et al)
- Variability in year-on-year incidence increases
- Outbreaks are particularly important to detect as measles elimination approaches
    - Equally, if countries have lapses in their vaccination coverage and go the wrong way

== Outbreak detection SOP

- ELISA & CCD
- Alerts based on thresholds

== RDTs offer new opportunity for outbreak surveillance

- Tension between patient-centric and public-focussed approaches to outbreak detection
    - ELISAs are excellent for the patient, but costly and slow
    - RDTs are less accurate, so may give the patient the wrong information
        - For measles, this is less of a concern as the treatment for febrile rash doesn't depend on an accurate diagnosis of measles vs rubella
- Despite concerns that lower accuracy of the test, has been used effectively in malaria and COVID-19 surveillance systems
- Want to evaluate if RDTs can be incorporated into a measles surveillance system effectively, and the interaction between individual-level uncertainty and at the outbreak detection level

== Model structure - compartmental model for measles

== Model structure - dynamical noise

== Model structure - Poisson noise

== How testing works

== How outbreaks are defined

== How alerts are triggered & characterized

== Schematic of accuracy calculation

== Calculation of optimal threshold

== Example of one set of optimal thresholds

- Show table for Poisson noise
- Explain how thresholds increase with increased testing rate
- Slight differences between tests
- Can take this and calculate for each type and magnitude of noise, but instead going to transform this into some plots

== Accuracy plot

- For Poisson noise, RDTs can perform equivalently
- For dynamical, break down around 4:1 noise:measles ratio
    - Can't test your way out of the problem

#figure(
    image("line_accuracy_plot.png")
)

== What's causing this difference?

- Dynamical noise has rubella outbreaks that translate into peaks of false positive test results that trigger the alert
- Increasing the threshold would cause genuine measles outbreaks to be missed, lowering the sensitivity of the alert system, more than is made up for by the corresponding specificity of the system

== Delays plot

- Corresponding dynamical noise with RDTs show a more sensitive system than with ELISAs (or under Poisson noise)

#figure(
    image("line_delays_plot.png")
)

== Proportion in Alert

- Can see same picture in the proportion of the time series in alert

#figure(
    image("line_prop_alert_plot.png")
)

== Concluding Thoughts

= CSD

== Extending to Early Warning Systems

- Rather than just reacting, lots of interest in trying to detect a state of risk for future outbreak
- Prior work on matter used CSD metrics

== CSD overview

== Potential issues with measures

== Want to incorporate learning from OD project

== Background with Tycho project

- Show how they are calculated

==  Simulation

- create simulation experiment where we can discretize time series
    - Reff grows by lowering vaccination rate
- Need null to evaluate
- In CSD don't need outbreak to evaluate, unlike outbreak detection
    - Not conditional on outbreak (reactive vs proactive)
- Plot trajectory of Reff between case and control simulation
- In treatment simulation, trying to use metrics to identify that it will cross threshold, even if outbreak doesn't happen
    - Want systems that don't flag inappropriately in null case
- Explain hyperparameters optimized over
    - distribution builds threshold for flag
    - how many flags required for an alert
    - Show histogram and consecutive flags schematic
- Show accuracy heatmap
    - Just the accuracies
    - Declarative statement about low and high values of accuracy for each type of noise
        - 2 x 2 for noise structure and magnitude
        - The system affects the accuracy
    - Each cell has its own optimal value of percentile and flags
        - Learnt from prior chapter that the system has to be considered
- Within a heatmap
    - The measure that gives the best accuracy depends on the test used
- Then add in speed and specificity
    - Maybe only add in to best 2 metric for each test
        - Within a system, think about what you prefer (speed/spec) so choose a different metric
- Mostly likely just end with table, not survival plot

= Summary

- 2 & 3 about explanatory variables
- 4 & 5 about explanatory & outcome variables
- what was learnt within each section
- What was learnt across all chapters
    - Discretization is necessary evil
        - Fundamental limits on predictability as
            - categories may not map directly of explanatory variables or outcomes
- Even just identifying scope of predictability of a system, even if it's not very predictive
