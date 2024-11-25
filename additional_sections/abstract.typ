// Aim for 1-1.5 pages for the abstract. Right now you're at <300 words, which is the length of a paper abstract. This is a more substantial document and warrants a more substantial abstract. Building upon the text you have:
// Infectious diseases are a big deal. Control (at least efficient control) requires explicit decisions and the targeted application of effort, which requires that we discretize continuous phenomena into actionable groups.
// Opportunities and challenges in groups (it's not a useless phrase, just an over-used title). Groups allow efficient targeting and prioritization. Assuming group structure based on proxies can lead you astray. Groups put hard boundaries on continuous phenomena and therefore get things wrong at the edges.
// You illustrate this in the context of two outbreak settings: COVID and measles. Each highlights different uncertainties. The novelty of COVID meant that risk groups were not well characterized. The episodic nature of measles outbreaks and imperfect observation make detection and reaction imprecise.
// State that in chapters 2-3 you analyze empirical data from a real outbreak. In chapters 4-5 you use simulation models.
// Then do a short paragraph for each chapter. 2-3 high level sentences on each chapter
// Groups emerged, we were shocked!
// We found groups where they weren't apparent
// Classifying outbreaks at the population level, when there is uncertainty at the individual level is imperfect, but possible
//  Anticipating outbreaks is even harder and depends critically on the background
// You need a wrap up paragraph, perhaps reiterating the practical constraints of action/control and the need for discrete groups. While any discretization is an imperfect representation of the underlying heterogeneity, transparent and repeatable methods for creating and evaluating discretization schemes allows for objective evaluation
Infectious diseases have impacted civilisations throughout history, shaping interactions between individuals, and influencing the growth of populations.
Despite advances in the control of disease, often stemming from the development and deployment of vaccines, they still pose a substantial threat to human life.
To minimize disease burden it is essential to gain a greater understanding of the underlying dynamics of disease within populations, and efficient control efforts require explicit decisions and the targeted application of resources, both of which are aided by clear definitions of groups.
I consider how the classification of 3 axes of infectious disease data (risk of exposure, infection status, and accumulation of cases to form outbreaks), provides opportunities and challenges to these aims.
I illustrate this in the context of two outbreak settings: COVID-19, and measles.
Due to the novelty of COVID-19, disease spread rapidly, but infection risk groups were not well characterized.
For measles, however, the episodic nature of cases, combined with partial observations of the system, make outbreak detection and response uncertain and imprecise.
In @d4a & @lca, I use empirical data to characterize the emergent risk classes.
For @outbreak-detection and @ews, I use mathematical models of transmission to simulate infections and quantify the outbreak detection and predictive ability of surveillance systems.

The COVID-19 pandemic threw the world into a state of uncertainty, shutting down university campuses, towns, and cities across the United States and wider world.
With the return of students to the Pennsylvania State University in the Fall of 2020, two exposure groups emerged: students and the surrounding community members.
Contrary to the assumptions at the time that the spatial proximity would overwhelm other drivers of disease transmission, resulting in similar infection rates between the cohorts, the students experienced far higher infection rates than the county residents (@d4a).
To evaluate the potential for within-cohort variation in exposure rates, I used clustering techniques on behavioral survey data to uncover latent groups of within the student body, with respect to risk behavior (@lca).
Doing so provided a mechanism to examine the effects and limits of targeted interventions to improve adherence to public health measures.
This demonstrated that only 63% of the students could have their risk of exposure reduced, but due to the non-linear nature of outbreaks, a fully effective intervention could reduce total infection rates by 90%.

In @outbreak-detection, I simulate co-circulating pathogens (measles and rubella) to investigate the role of diagnostic uncertainty in case identification and generation of alerts in an outbreak detection system.
When the non-target disease does not experience large peaks and troughs in incidence, imperfect diagnostic tests can perform as well in detecting outbreaks as perfect diagnostic tests, particularly if a perfect test is associated with a test result delay.
However, the performance of an outbreak detection system based upon results from an imperfect diagnostic tests degrades substantially with increasing magnitudes of background dynamical noise, like from uncontrolled rubella.

Designing _proactive_ rather than _reactive_ outbreak detection systems requires the calculation of summary statistics that are correlated with emergence of an outbreak.
In @ews, I show that anticipating outbreaks with imperfect diagnostic tests is as context-dependant as reactive systems.
When there are low levels of background noise, imperfect diagnostics can provide advanced warning of outbreak emergence.
However, when the incidence of measles is small relative to the incidence of rubella, false positive test results dominate the time series used to compute the summary statistics, rendering them unable to discriminate between emergent and non-emergent time periods.

While discretizations are associated with a loss of information, the process of creating categories can often provide necessary context to understanding infectious disease data.
Categorization can allow for decision-making in the face of overwhelming volumes of information.
Creating dynamically-relevant, explicit, groups is the key to tackling these problems in a transparent and objective fashion.
