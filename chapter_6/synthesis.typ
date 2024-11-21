#heading("Synthesis", supplement: "Chapter") <synthesis>

#show quote: it => {
  set par(first-line-indent: 1em,hanging-indent:1em)
  it
}

There is a growing body of literature that focusses on uncertainty in disease transmission; from incorporating viral dynamics into mechanistic models of disease @larremoreTestSensitivitySecondary2021 @middletonModelingTransmissionMitigation2024, to accounting for reporting and testing uncertainty in estimates of the _real-time_ reproduction number ($R_"t"$) @pitzerImpactChangesDiagnostic2021.
In this dissertation I demonstrate how the classification of continuous infectious disease variables is both essential to inferences about disease dynamics and their underlying systems, and results in compounding uncertainty that limits our predictive and detection abilities for outbreaks.
This work has already shown relevance and impact, helping inform the target product profile (TPP) of a potential future rapid diagnostic test (RDT) for measles in outbreak surveillance settings @20240613_tpp_measles_rubell_FV_EN.

== Discretization of Risk Groups

In the first half of my dissertation I explore mechanisms by which populations can be classified to understand the transmission of COVID-19 within and between Pennsylvania State University students and community members of its surrounding county (Center County).
Clear definitions of risk and transmission groups provide a natural mechanism to explore the heterogeneity in infection that may exist in a population, as it is conceivable that the student and community cohorts differ with respect to many drivers of infection e.g., demography, contact rates, perceptions of infection risk, willingness to take preventative actions.
However, despite expectations that the high spatial proximity of these two well-defined groups in immunologically naive populations would overwhelm differences in other drivers of infection and result in similar exposure rates, substantial variation in outcomes was observed (Chapter 2).
This, supported by evidence that the Center County community experienced lower per-capita incidence rates than its 5 surrounding counties @bhartiLargeUniversityHigh2022, implies that intervention efforts by the University were able to minimize the risk of onward transmission from the student population.
If between-group transmission did occur, it was likely transient in nature.
Within the study body, the only factors associated with infection outcome were the recent contact with a known COVID-19 positive individual, and the attendance of gatherings.

In light of these findings, we hypothesized that, in the absence of pharmaceutical interventions, seroprevalence differences were driven by heterogeneity in behavior.
We also theorized that similar differences in infection rates may exist _within_ each cohort, with each group being inhomogeneous behaviorally.
However, unlike in Chapter 2 where clearly-defined exposure groups were pre-existent, no clear demarcations within the cohorts existed.
To make inferences about the heterogeneity in transmission, I sought to categorize the student body with respect to a latent (unobservable) variable: risk behavior.
Given behavioral survey data of intentions to adhere to non-pharmaceutical public health measures (PHMs), I clustered the students using Latent Class Analysis (LCA).
Doing so returned a probability of class assignment for each individual, along with the propensity for each class (to intend) to follow or not follow each of the individual PHMs.
Evaluating the observed seroprevalence on these strata demonstrated that the behavioral survey data were able to define meaningfully different groups with respect to both the student behaviors and their infection outcomes.
Through discretizing the population, it became possible to evaluate the potential effectiveness of interventions aimed at increasing adherence to PHMs.
Defining risk behavior groups provided group-specific seroprevalence rates that could be used to parameterize a mathematical model of transmission.
Doing so placed realistic bounds on the expected benefit of an intervention, which did not rely upon _a priori_ assumptions as to the intervention's effectiveness in reducing transmission.
As a large proportion of the population were already in the most adherent group that always intended to follow public health guidance, interventions targets at them would serve no direct effect: their risk of transmission was dictated by interactions with less-adherent individuals.

If we are to design effective interventions, it is essential to first characterize the limits of what can realistically be achieved.
For example, it is well known that supplemental immunization activities aimed to minimize the effects of an outbreak, reactively or prospectively, are partially limited by the vaccination coverage that can be achieved: those who are able to access the care are more likely to also be individuals who can attend routine immunizations _*[Portnoy REF]*_.
Incorporating access and dose redundancy data can provide more realistic estimates on the effectiveness of future efforts.
Similarly, incorporating behavioral information into epidemiological models can shed light on the potential effectiveness of vaccination campaigns.
Defining latent groups of individuals by vaccine-seeking or hesitancy behaviors, it would be possible to calculate an expected uptake, augmenting estimates provided through access data.
This could allow for a more realistic estimate of intervention effectiveness at reducing disease burden, characterizing a limit for coverage that incorporates previously observed aggregate information (the number of redundant doses provided), and individual intention behavior; there will be situations where individuals will choose not to be vaccinated, despite access expanding to incorporate them.
It is possible that vaccine-intentions differ between groups with and without access, so efforts improve access alone may overestimate the protection benefits gained.
Modeling these latent sentiments offers a mechanism to account for these discrepancies.
Not only does this approach potentially provide more accurate projections of the limits of vaccination coverage, but may also improve disease burden estimates by describing _who_ can be immunized; overlap between access and healthcare-seeking behavior with disease vulnerability will highlight gaps that need to be overcome.

This approach can also shed light on effectiveness of non-pharmaceutical interventions in heterogeneous populations, where traditional measures derived from demographic data, such as age-based mixing matrices, may over-simplify the dynamics.
Characterizing complex network structures has been a point of focus in the study and prevention of sexually transmitted infections (STIs) _*[REF]*_.
However, the process if often laborious, disease-specific, and subject to change _*[REF]*_.
In such systems heterogeneity exists across multiple facets, which may not be adequately captured by standard discretizations.
The incorporation of different data sources and categorization approaches may serve as a beneficial middle ground, allowing for a more accurate depiction of the true heterogeneity in disease risk than age classes, while also requiring less hands-on data collection than mapping contact networks; behavioral surveys can be implemented online, and pose potentially less sensitive questions that may otherwise act as a barrier to participation.
This is particularly important when designing interventions for novel pathogens, where the most at-risk groups, and therefore most beneficial to target, might not translate to previously observed pathogens and outbreaks and may change over time, and urgent actions are necessary to minimize the impact _*[REF]*_.

== Discretization of Infection Status

It is imperative to evaluate the effects of discretizing not only exposure classes, but also the outcomes of an infectious disease system.
In public health surveillance programs, incidence of disease occurrence must be tabulated before the need for and level of action can be decided upon.
Uncertainty in the observational process can occur through two mechanisms: uncertainty in who and how many individuals are counted (observed and tested), and uncertainty in the underlying test results.
Incorporating uncertainty in the reporting of cases has been of increasing interest in the parameterization of mathematical models, particularly for the estimation of $R_"t"$ @pitzerImpactChangesDiagnostic2021 @gosticPracticalConsiderationsMeasuring2020 @abbottEstimatingTimevaryingReproduction2020 @larremoreTestSensitivitySecondary2021 and disease burden _*[REF]*_.
However, the accuracy of the diagnostic used to make this determination affects the incidence, necessarily turning a quantitative input (pathogen load/host response) into a binary value, with associated classification errors.
Previous inclusions of diagnostic uncertainty amount to under-reporting as only one pathogen is simulated, removing the opportunity for false-positive test results @pitzerImpactChangesDiagnostic2021 @gosticPracticalConsiderationsMeasuring2020 @abbottEstimatingTimevaryingReproduction2020 @larremoreTestSensitivitySecondary2021 @middletonModelingTransmissionMitigation2024.

To account for diagnostic uncertainty, in Chapters 4 & 5 I simulated both a target pathogen and background noise, using representative parameters of measles and rubella, respectively.
Through variations to the rubella vaccination coverage, I was able to evaluate the degradation of outbreak detection performance with tests of decreasingly sensitivity and specificity.
When the background noise did not exhibit large peaks and troughs i.e., was drawn from a Poisson distribution or when there was sufficiently high vaccination coverage in the rubella dynamical noise simulations, both imperfect and perfect diagnostic tests could adequately discriminate between outbreak and non-outbreak periods.
However, this was not the case at higher levels of dynamical noise ($approx$ 6 times, or greater, than the average incidence of measles).
In these situations the reduced diagnostic accuracy of imperfect tests could not be alleviated through increasing the testing rate.
Across the WHO's African Region, there is typically far more circulating measles than rubella; in 2023, the average incidence of measles was 60.3 cases per 1M population, in contrast to 5.2 rubella cases per 1M population @masreshaTrackingMeaslesRubella2024.
In general, this would point to the widespread viability of imperfect diagnostic tests within infectious disease surveillance systems for the purposes of outbreak detection.
However, there is great variability in these incidence rates by country.
At the one end, countries like Burkina Faso experienced measles incidence of 69.7 measles cases per 1M population, relative to 0.4 rubella cases per 1M; testing 80% of reported cases, there were 4.2 times as many IgM positive and epidemiologically-linked measles cases as other clinically-compatible infections (i.e. rubella or otherwise) @masreshaTrackingMeaslesRubella2024.
As a result, imperfect diagnostics would likely be able to accurately discriminate between outbreaks of measles from changes in the incidence of other sources of febrile rash.
In contrast, Zimbabwe reported rubella incidence that was approximately 7.3 times higher than measles incidence, presenting a location where the increased uncertainty of imperfect diagnostics would result in poor outbreak detection @masreshaTrackingMeaslesRubella2024.
Lastly, Eritrea experienced 5.0 measles cases, and 1.3 rubella cases, per 1M population @masreshaTrackingMeaslesRubella2024.
While this may appear to be a good candidate for the use of imperfect tests, the incidence rate for clinically compatible cases that were not measles or rubella, was 21.3 cases per 1M population @masreshaTrackingMeaslesRubella2024.
As a result, before imperfect diagnostic tests could be implemented with confidence, a careful evaluation of the dynamics of the non-rubella background noise cases would be required; if it demonstrated large episodic outbreaks, its scale in relation to the expected measles incidence would necessitate the use of high-accuracy diagnostic tests.

In Chapter 5, I build off the work in the previous chapter to explore the effects of the outlined diagnostic uncertainty on our ability to predict risk of future outbreaks.
Traditional outbreak detection that utilizes the exceedance of an incidence threshold is necessarily reactive in nature.
Under ideal circumstances, it would be possible to measure trends in summary statistics derived from infection data to infer the emergence of outbreaks before they occur.
This would allow proactive actions that could avert the most cases, reducing the morbidity and mortality resulting from a pathogen.
Prior work has demonstrated the viability of early warning signals (EWS), albeit only accounting for errors stemming from testing rates, not diagnostic uncertainty @brettAnticipatingEpidemicTransitions2018 @southallEarlyWarningSignals2021 @brettDetectingCriticalSlowing2020 @brettAnticipatingEmergenceInfectious2017.
I demonstrate that, similar to reactive outbreak detection, predictive systems can be designed around the use of RDTs for case identification, so long as the magnitude of dynamical noise is low relative to the incidence of the target pathogen.
Not all EWS metrics performed well, but, aligning with the literature, the mean, variance, autocovariance, and index of dispersion were able to discriminate between emergent and non-emergent time series in these situations.
Additionally, the evaluation of EWS performance required the alert in emergent simulations to occur before the tipping point $R_"E" = 1$, which indicates the potential for a future outbreak.
As this tipping point essentially acts as a necessary precursor to an outbreak (though exceptions can occur due to the stochastic nature of infectious disease transmission), each warning would be provided with sufficient time for action to potentially avert an outbreak.

The primary focus of this section of work (Chapters 4 & 5) has been to motivate new approaches to the design of surveillance systems at large, not any one specific implementation.

Chapter 4 highlights the need to consider all sources of uncertainty arising from discretization when designing an infection surveillance program.

#quote[These two chapters illustrate the complexity in evaluating the performance (accuracy) of a detection system because the outcome depends on multiple interacting axes (% tested, test characteristics, threshold, shape and magnitude of noise). We found that similar accuracy could be achieved for a range of setting by trading off characteristics of these axes of the surveillance system. Further, we identified regions of dynamics where accuracy was fundamentally limited — which can only be illustrated by considering the performance across all these axes.]


Trade-offs and the balance of priorities must be evaluated on a context-specific basis.
There has long been a tension in designing disease surveillance programs: the needs of an individual may be at odds with those of the wider population.
During the early stages of the COVID-19 pandemic, when vaccines were first being developed and their potential effectiveness unknown, there were discussions around who should be prioritized during initial roll-outs: the elderly and those with known co-morbidities, who would most likely receive the largest direct benefit from immunization; or younger individuals with larger numbers of contacts, whose vaccination would most likely result in the largest reduction in incidence, with an indirect benefit to vulnerable individuals @bubarModelinformedCOVID19Vaccine2021.
For infectious disease outbreak surveillance, a similar conflict exists.
Systems are often built upon routine, passive, surveillance that uses health facility visits for case identification @craggOutbreakResponse2018 @gieseckeRoutineSurveillanceInfectious2016.
As a result, reducing the accuracy of the diagnostic test used may be associated with a corresponding reduction in cost and technical requirements, allowing for a greater proportion of the population to be tested.
This, in turn, may improve outbreak detection, providing an indirect effect to any specific individual, but at the expense of a more accurate diagnosis and care provided to the patient seeking treatment at a healthcare facility.

In addition to ethics-based decisions, countries must decide how to balance the relative costs and benefits of more sensitive versus specific alert systems.
My analysis does not represent a true optimization; the partial observation of the system necessitates decisions and actions be made on the basis of incomplete information.
Additionally, the need to prioritize the speed of outbreak detection and response against the false positive rate of alerts will change by region, and over time.
In Chapters 4 & 5 I provide equal weight to the associated alert speed and specificity metrics utilized in the system's evaluation.
In locations that experience large, devastating, outbreaks, where response mobilization may be heavily delayed, a greater premium could be placed on sensitive alert systems, if only to launch an active preliminary investigation.
Furthermore, the evaluation of each alert threshold, be that incidence-based alert triggers for reactive surveillance programs, or EWS-based approaches for proactive systems, was conducted at the 'optimal' set of hyperparameters.
This approach requires mapping the performance of each test across a wide range of possible parameter values and combinations.
While feasible in a simulation scenario, it poses a challenge for empirical use.
Careful selection of 'training data' would be required to emulate this approach in a real-world setting to ensure representative time series are utilized, producing appropriate parameter values.

Unlike in simulations, outbreak preparation and response scenarios often impose additional constraints, such as the financial resources available.
Explicitly incorporating the effects of these constraints may limit the space of attainable alert performance, potentially disproportionately for particular diagnostic tests or background noise magnitudes.
The work in Chapter 5, in particular, highlighted that not all outbreak detection scenarios are equally robust: the 'mean' EWS metric provided slightly suboptimal alert performance under most scenarios, relative to the autocovariance and variance, but was more resilient to higher levels of dynamical noise given the use of moderately accurate RDTs.
The analysis approach detailed here provides a mechanism to compare these constraints to find zones of acceptable performance.

In the future, efforts should be made to formally integrate the design and implementation of outbreak surveillance and early warning systems into partially observed Markov decision process (POMPD) models.
Doing so would provide a more complete characterization of the uncertainty that develops and propagates throughout the numerous observational and decision processes.
My work has demonstrated that even in scenarios with perfect diagnostic tests, detecting and predicting outbreaks relative to baseline infection dynamics is exceedingly difficult.
Generally, a binary threshold is used to ascribe infectious status to individuals, despite prior work demonstrating that infectiousness is not a binary state and the timing of diagnostic test within an infection cycle affects its accuracy @larremoreTestSensitivitySecondary2021 @middletonModelingTransmissionMitigation2024 @kisslerViralDynamicsAcute2021.
Incorporating this aspect of the observational process into models would generate realistic biases in data generation, and provide a meaningful extension to the analysis presented.

Further, with the rise in machine-learning and big-data driven approaches to outbreak detection, a more thorough exploration of the uncertainty resulting from discretizing the prediction target is required.
In surveillance systems, we never know the true state of $R_"E"$, or how to categorize a time series into outbreak and non-outbreak periods, both of which are the target for predictive algorithms.
It is conceivable that biases in the observational process arising from false negative, and importantly, false positive test results, impacts the ability of $R_"t"$ estimates to approximate $R_"E"$.
Exploration of these issues should be the target of future work.

== Conclusion

Without categorization, understanding disease systems and decision-making can become intractably complex; a map of everything is a map of nothing.
Through discretization we can describe trends in disease burden, discover emergent risk groups, and plan targeted actions to most efficiently use limited resources.
But the choices we make to define breakpoints and strata introduce challenges that must be addressed, particularly at the boundaries.
Through careful, intentional, investigation, it is possible to balance the trade-offs that arise from the uncertainty.
Throughout my dissertation I characterize the benefits and pitfalls of discretizing continuous phenomena, and present novel approaches to integrate across scales.
This topic presents many exciting avenues for future research, with those that address findings from all levels of the infection observation process offering the most opportunity to minimize burden and save lives.


#bibliography(style: "elsevier-vancouver", "../Dissertation.bib")
