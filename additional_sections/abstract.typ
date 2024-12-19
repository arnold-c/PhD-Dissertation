#let darkred(body) = text(fill: rgb("#8B0000"))[#body]
#let mystrike(body) = strike(stroke: 0.05em + red)[#body]

Infectious diseases have impacted civilizations throughout history, shaping human interactions and influencing the growth of populations.
Despite advances in the control of disease, they still pose a substantial threat to human life.
To minimize disease burden it is essential to gain a greater understanding of the underlying dynamics of disease within populations, and efficient control efforts require explicit decisions and the targeted application of resources. #mystrike[ , both of which are aided by clearly defined categories]
#darkred[
  The knowledge that can produce these set of actions are predicated on the careful linking of infectious disease exposures and outcomes, and becomes increasingly complicated when either, or both, are continuous in nature.
  Through discretization, it is possible to create simpler maps that retain the core properties of the data and relationships.
]
I consider how the classification of #mystrike[3 axes] #darkred[the exposures and outcomes] of infectious disease data (#mystrike[risk of exposure] #darkred[behavior into risk classes], #darkred[determination of ] infection status #darkred[into infected or not], and #mystrike[accumulation of cases in populations] #darkred[classifying a time series of individual case counts into outbreak and non-outbreak periods]), provides opportunities and challenges to these aims.
I illustrate this in the context of two outbreak settings: COVID-19, and measles.
Due to the novelty of COVID-19, disease spread rapidly but infection risk groups were not well characterized.
For measles, however, drivers of disease transmission are well documented, but the episodic nature of cases combined with imperfect surveillance systems make outbreak detection and response imprecise.
In @d4a & @lca, I use empirical data to characterize the emergent risk classes.
For @outbreak-detection and @ews, I use mathematical models to simulate infections and quantify the outbreak detection and predictive ability of surveillance systems.

The COVID-19 pandemic threw the world into a state of uncertainty, shutting down university campuses, towns, and cities across the United States and wider world.
With the return of students to the Pennsylvania State University in the Fall of 2020, two exposure groups emerged: students and the surrounding community members.
Contrary to the assumptions at the time that the spatial proximity would overwhelm other drivers of disease transmission, resulting in similar exposure rates between the cohorts, the students were infected at a far higher rate than the county residents (@d4a).
To evaluate the potential for within-cohort variation in exposure rates, I used clustering techniques on behavioral survey data to uncover latent groups of within the student body, with respect to risk behavior (@lca).
Doing so provided a mechanism to examine the effects and limits of targeted interventions to improve adherence to public health measures.
This demonstrated that only 62% of the students could have their risk of exposure reduced, but due to the non-linear nature of outbreaks, a fully effective intervention could reduce total infection rates by up to 93%.

In @outbreak-detection, I simulate co-circulating pathogens (measles and rubella) to investigate the role of diagnostic uncertainty in case identification and generation of alerts in an outbreak detection system.
When the non-target disease does not experience large peaks and troughs in incidence, imperfect diagnostic tests can perform as well in detecting outbreaks as perfect diagnostic tests, particularly if a perfect test is associated with a test result delay.
However, the performance of an outbreak detection system based upon incidence estimates from an imperfect diagnostic test degrades substantially with increasing magnitudes of background dynamical noise, like from uncontrolled rubella.

Designing _proactive_ rather than _reactive_ outbreak detection systems requires the calculation of summary statistics that are correlated with emergence of an outbreak.
In @ews, I show that anticipating outbreaks with imperfect diagnostic tests is as context-dependent as reactive systems.
When there are low levels of background noise, imperfect diagnostics can provide advanced warning of outbreak emergence.
However, when the incidence of measles is small relative to the incidence of rubella, false positive test results dominate the time series used to compute the summary statistics, rendering them unable to discriminate between emergent and non-emergent time periods.

While discretizations are associated with a loss of information, the process of creating categories can often provide necessary context to understanding infectious disease data.
Categorization can allow for decision-making in the face of overwhelming volumes of information.
Creating dynamically-relevant, explicit, groups is the key to tackling these problems in a transparent and objective fashion.
