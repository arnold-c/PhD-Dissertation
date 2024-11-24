#heading("Introduction", supplement: "Chapter") <intro>

Much of the world is complex, and in seeking to understand it we must often make simplifying aggregations and assumptions, often to create groups @boxScienceStatistics1976 @mervisCategorizationNaturalObjects1981 @rhodesDevelopmentSocialCategorization2019.
When quantifying a student's academic achievements, or measuring distances, for example, decisions are made to create discrete categories from the underlying continuous data.
Categorization is essential to the synthesis and interpretation of information, particularly for action; grades are utilized as it would be impractical to simultaneously evaluate every score a student achieved during school.
Infectious diseases are no different.
Rather than tracking pathogen loads in a population, for example, individuals are typically categorized as either susceptible, exposed/latent, infected, or removed @vynnyckyIntroductionInfectiousDisease2010a @kermackContributionMathematicalTheory1997.
Cases are counted, providing estimates of the number of new and cumulative infected individuals at any one time; labeling individuals as infected is integral to calculation of disease burden @hesselBurdenDiseaseBurdenofDiseases2008, and the equitable and efficient allocation of vaccinations @bubarModelinformedCOVID19Vaccine2021.
This approach, however, leaves us with some questions; namely, how many groups are appropriate, how should the breakpoints between groups be defined, and are there meaningful differences between the groups that allow for inferences about the system in question?
At every scale in an infectious disease system, from variability of infectivity within an individual's infection cycle, to defining outbreaks in a population from the accumulation of infections, these questions must be addressed.
In this dissertation I explore how variability in continuous measures can be discretized, and the interactions that arise from the compounding uncertainty of these categorization decisions.

The use of discretization is prevalent throughout the history of infectious disease biology and epidemiology; to produce more accurate mathematical models of disease transmission, detailed maps of contact rates have been generated that categorize a population into age groups and log the relative frequency of the interactions within and between these groups @mossongSocialContactsMixing2008 @klepacContagionBBCFour2018 @daviesAgedependentEffectsTransmission2020.
Extending this work, networks of individuals and animals have been created to provide a more granular picture of interactions that can exist within an infectious disease system (human or animal), characterizing nodes, vertices, and edges to represent individuals, locations, movement patterns, and connection @kretzschmarMeasuresConcurrencyNetworks1996 @herrera-diestraCattleTransportNetwork2022.
Furthermore, there is variation that exists between the infectious properties of a population.
The (basic) reproduction number is defined as the expected number of secondary cases generated from one infectious individual (in a completely susceptible population) @vynnyckyIntroductionInfectiousDisease2010a.
While often used to describe the transmissibility of a disease within a population, it is a discretization of the underlying, continuous, infectiousness associated with each individual.
As a consequence of variability in the pathogen load in an individual, the number of their contacts (and the susceptibility of those contacts), and the length of their infectious period, there is a distribution of secondary infection numbers that exists, and the reproduction number is the mean of this distribution.
Individuals at the tail of the distribution can be categorized as super-spreaders and super-shedders @lloyd-smithSuperspreadingEffectIndividual2005, providing additional insight when compiling summary information about the spread of disease.
Descriptions of heterogeneity also aid in the design of targeted interventions.
By identifying the most at-risk groups in a population, limited resources can be most appropriately allocated @bryanBehaviouralScienceUnlikely2021.
For example, accounting for injection drug use status can help target interventions to reduce human immunodeficiency virus (HIV) and Hepatitis C Virus incidence @levittInfectiousDiseasesInjection2020.

Throughout my dissertation I specifically address the discretization of 3 categories of continuous phenomena: risk classes, infection status, and outbreaks.
Chapters 2 & 3 address the definition of exposure and risk classes in the context of the COVID-19 pandemic and the implications for intervention effectiveness.
In Chapters 4 & 5 I examine the impact of uncertainty in the binary classification of an individual's infection status via diagnostics on the determination of outbreak status, and consequentially, outbreak response and prediction.

In the first half of my dissertation (Chapters 2 & 3), I explore how differences in infection rates between geographically co-incident groups can be evaluated in the context of the categorization process.
In the spring of 2020, the COVID-19 pandemic resulted in many university campuses across the US shutting down, requiring their students to return to their respective homes @mackCollegesUniversitiesUS2020.
When students were re-introduced to the Pennsylvania State University campus during the start of the Fall 2020 semester, two spatially entwined but demographically and behaviorally disparate groups were defined: returning students and the surrounding community members.
Through this grouping, it is possible to characterize the burden of SARS-CoV-2 infection (the underlying virus that causes the disease COVID-19).
Without discrete categories, there is no denominator for use in calculations of seroprevalence (the proportion of a population that have sufficiently high levels of antibodies, indicating past exposure to a pathogen); a key metric in the evaluation of disease burden.
In Chapter 2 I show that substantial, unexpected, differences in infection rates can be observed between the student and community populations, highlighting that opportunities exist for infection mitigation efforts to minimize spread between spatially-linked subgroups of a population.
To examine differences in COVID-19 infections that may exist in the student body, it was, once again, imperative to define groups to compare.
However, with no clear differences in traditional demographic measures that could be used to categorize individuals, such as age, I use Latent Class Analysis (LCA) to define these group from behavioral survey data @wellerLatentClassAnalysis2020 @nylund-gibsonTenFrequentlyAsked20181213.
The process of discovering categories with unsupervised clustering methods provides a mechanism to quantify the variation in risk perception and behavior, that cannot be directly measured.
In Chapter 3, I map the association between these emergent risk groups with infection rates from serological data to parameterize a mechanistic model of infection, and demonstrate the limits of solely using non-pharmaceutical interventions to reduce infections within the student population.

In the second half of my dissertation (Chapters 4 & 5), I examine the necessity and implications of categorizations for action in regions with persistent and emerging infection dynamics.
Infectious disease surveillance has 3 primary objectives: to observe and quantify the burden of disease, monitor trends in prevalence, and detect and inform response to outbreaks @murrayInfectiousDiseaseSurveillance2017 @DiseaseSurveillance.
In pursuit of these goals, numerous continuous values must be discretized.
Firstly, cases must be counted, which requires a set of criteria to convert the underlying infection dynamics within an individual into a binary status: infected or not.
This criteria often comes in the form of a diagnostic test, like an enzyme linked immunosorbent assay (ELISA).
ELISAs measure the presence and quantity of antibodies in a biological sample that are produced by a person's immune system in response to pathogen exposure, and attempts to discriminate between two hypothetical infection/exposure states @alhajjEnzymeLinkedImmunosorbent2024.
In practice, no threshold will be able to perfectly discriminate between these groups of individuals, leading to classification errors @hiebertEvaluationDiagnosticAccuracy2021.
The sensitivity of a test refers to its ability to correctly detect the presence of infection when an infectious individual is tested, also called the true positive rate @westreichDiagnosticTestingScreening2019 @shrefflerDiagnosticTestingAccuracy2024 @parikhUnderstandingUsingSensitivity2008.
The specificity is the opposite: the ability to correct detect the _lack_ of infection in an uninfected individual, also called the true negative rate @westreichDiagnosticTestingScreening2019 @shrefflerDiagnosticTestingAccuracy2024 @parikhUnderstandingUsingSensitivity2008.
An important third characteristic of diagnostic tests that arises from the discretization of a continuous measure is the positive predictive value (PPV) of a test.
The PPV is the probability that a positive test result actually reflects a positive individual @westreichDiagnosticTestingScreening2019 @shrefflerDiagnosticTestingAccuracy2024.
Unlike the sensitivity, it is not preconditioned on the assumption that the individual tested is truly positive.
The complement to the PPV is the negative predictive value (NPV); the probability that a negative test result accurately reflects reality.
When counting for infectious disease surveillance, decisions are made on the basis of these imperfect categorizations.

In my 4th chapter I explore how fallible diagnostic tests interact with non-target background infections (that change the PPV of test results), producing different time series that are used to detect outbreaks.
Additionally, the very notion of an outbreak is itself a categorization of a continuous phenomenon, separating a time series of test positive cases by suspected outbreak status, and faces similar issues of sensitivity/specificity/PPV/NPV @kanindaEffectivenessIncidenceThresholds2000 @trotterResponseThresholdsEpidemic2015 @guidelinesworkinggroupUpdatedGuidelinesEvaluating2001.
My work demonstrates how uncertainty that arises at each step of the outbreak detection process must be accounted for, highlighting contexts where different combinations of diagnostic tests and outbreak classification criteria can produce equivalent outbreak detection accuracies.

In the final chapter, I address how these discontinuity errors affect efforts to build _proactive_ rather than _reactive_ outbreak alert systems.
In contrast to traditional outbreak detection systems that require the observation of test positive cases to trigger an alert i.e., respond to the detection of an ongoing outbreak, proactive alert systems have been developed to predict the risk and potential of future outbreaks.
Instead of categorizing incidence to define a prediction target, proactive alert systems calculate summary statistics of test positive time series to predict the approach to the _tipping point_ of infectious diseases, $R_"E" = 1$.
$R_"E"$ (the effective reproduction number) is the expected number of secondary infections that would be generated by each infectious individual before they recover (given the current population size and susceptibility).
Values greater than or equal to 1 indicate transmission would be self-sustaining if a population is seeded with infection(s).
Predicting the approach to this tipping point would provide advance warning of potential outbreaks, allowing proactive decisions to be made.
I show that when imperfect diagnostic tests are utilized to create the underlying summary statistics, much like reactive outbreak detection systems, the alert performance is heavily influenced by the shape and magnitude of the non-target background infections.
Addressing the context explicitly when designing a reactive or proactive outbreak surveillance system allows public health officials and policy-makers to account for the compounding layers of uncertainty, finding zones of alert accuracy equivalence where particular objectives can be given greater prioritization e.g., speed of response vs. the number of false alerts.

When evaluated in its entirety, my dissertation provides a clear and principled approach to evaluating the effects of categorizing continuous infectious disease data.
I demonstrate that through acknowledging the imperfect nature of discretization, it is possible to identify meaningfully different clusters of individuals and outcomes that can inform our understanding of the populations most at risk of infection, and how outbreak surveillance systems can be designed to best address context-specific priorities.
