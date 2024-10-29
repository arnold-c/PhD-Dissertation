#set page(numbering: "1/1")
#set quote(block: true)
#show quote: set text(style: "italic", weight: "bold")
#show quote: set align(center)
#show quote: set pad(x: 5em)

#let title = "Synthesis Plan"

#set document(title: title)
#align(center, text(size: 18pt, weight: "bold")[#title])

= Overarching Summary

- There is a growing body of literature focused on uncertainty in disease transmission measurements and incorporation into models
- Thesis demonstrates how heterogeneity can drive infection dynamics & introduce uncertainty at each level the outbreak and observation process, and the importance of acknowledging the interaction between the levels.

= Chapter Summaries

== Chapter 2: D4A

- Despite clear expectations that spatial proximity and moderate-high R0 disease in immunologically naive population would result in similar exposure rates, outcome heterogeneity is observed
    - Indicates underlying differences (heterogeneity) in behavior, given the absence of pharmaceutical interventions
- Large differences in seroprevalence rates indicate no sustained between-group transmission (though possible intermittent, transient, transmission events)
- Intervention efforts by the University were likely able to minimize the risk of onward transmission to the surrounding community
    - High testing rates & quarantine measures
    - Regular messaging campaigns
    - Infection rates of SC community lower than 5 surrounding counties (Bharti et al.)

== Chapter 3: LCA

- Results from Chapter 2 led us to believe that, in the absence of pharmaceutical interventions, seroprevalence difference were driven by heterogeneity in behavior
- Much like the student and community populations were suspected to have different behaviors, similar differences expected within the student population
- Were able to use behavioral data to model latent groups within the student body, which were independently correlated with exposure rates
    - Student body demographically homogeneous and demographic factors previously shown in Chapter 2 not to be correlated with infection
- Modeling the heterogeneity allowed for an explicit characterization of the expected benefit of interventions aimed at modifying behavior, which for a novel pathogen is all that is possible (without making correlations to, and inferences from other, similar, disease systems)


== Chapter 4: Outbreak detection

- Heterogeneity doesn't only exist at the individual level; it is important to think about the interaction with uncertainty at the population scale
    - Uncertainties will compound on another
- There has always been a tension in designing disease surveillance systems that most benefit a population, and allocating resources and capital in manners that may not be optimal for individual patients that are seeking healthcare and providing the data for these systems
    - This is an ethical and moral conflict that is present throughout all of public health: during the early stages of the COVID-19 pandemic when vaccines were first being developed and their potential effectiveness was unknown, large discussions about who should be prioritized during staged roll-outs
        - Vaccinate those with the highest transmission potential and potentially produce the fewest number of total cases, vs. those at greatest risk of severe morbidity and mortality, maximizing effectiveness for any given individual when viewed from a patient-centered frame of reference
- A patient-centric approach would maximize the use of "perfect" diagnostic tests, to most benefit healthcare-seeking individuals
- Here we showed that under particular circumstances where there was not expected to be large amounts of dynamical background noise, this trade-off may not exist and ELISAs could be replaced with RDTs without concern
- With an uncertain observation process and background noise state, RDTs may not give you enough confidence to provide a sufficient chance of a public health benefit to consider replacing ELISAs
    - RDTs can give the correct answers for the wrong reasons in the face of background noise
- Partially observed Markov process means we have to make decisions with incomplete information - can never truly optimize our outcomes
- Not a true optimization as requires from prior decision making about the relative importance of parameters, much like the decisions required when first designing and deciding on the characteristics of a diagnostic test at the individual level (better to return a false positive or negative?):
    - Financial cost of test deployment
    - Speed of response
    - PPV of alert and cost of false alert
- This work identified this as a unrecognized challenge in outbreak detection and response and provided a roadmap/framework for how to approach this problem given a decisions-makers specific context, values, and constraints

== Chapter 5: Early Warning Systems

- Prior work by Drake et al has illustrated that, theoretically, it is possible to calculate EWS metrics that can indicate an approach of the critical threshold
    - The majority of work has focused on Kendall's tau as a metric, which indicates the monotonicity of a time series i.e., the EWS that monotonically increases towards the threshold, but is closer to random in a null simulation series
    - Some work has been done by Southall, Clements, O'Dea etc that indicate an consecutive threshold approach can be predictive in an outbreak setting (Drake and Boettiger have similar work in Ecology)
- However, we do not have a perfectly observed system, which must be accounted for
    - Much like Chapter 4, this work examines how uncertainty in individual-level discretization of heterogeneity can interact with the discretization at a population level (approaching $R#sub[#text[effective]] = 1$)
- Even with 100% testing, we still have a partially observed system
    - We can never observe $R#sub[#text[effective]]$, only estimate $R#sub[#text[t]]$ as an approximation, so not possible to empirically study whether EWS metrics are predictive (in simulations we can know the true state of the whole system)


#quote[
    Fill in with key results once complete
]

- In the real world, there are logistical constraints that would lead to the inability to monitor systems under the most optimal conditions
    - Likely not realistic to calculate multiple EWS metrics using different numbers of burn-in periods and percentile thresholds
    - Requires a decision to be made about whether to prioritize speed or sensitivity of an alert system
    - Given that prioritization, there may be an "optimum" approach that works in one context (e.g., noise shape & magnitude) and poorly in others, and many that are just slightly sub-optimal for that context but have a higher probability of producing acceptable results in other contexts
        - #text(style: "italic", weight: "bold")[Add specific example from results]
- This is about the approach to designing detection systems, not the design of any one surveillance system

= Future Work

- CSD work only examines perfectly observed systems:
    - To summarize and distill current methods, and then examine the interactions with imperfect tests and the concept of joint optimization is complicated enough
    - Future work should examine partial testing and the trade-offs associated with reduced resource availability
        - Outbreak detection and CSD project should provide be integrated into formal POMDP models that can explicitly characterize these trade-offs
    - Incorporate nowcasting into the outbreak detection and EWS
- Increasing focus on ML/big data-driven approaches to outbreak detection and early warning systems
    - Can only work if there is a large enough body of sufficiently high quality data
        - Imperfect tests and observation will only bias this data, even if sufficiently large quantities of time series could be collected
    - My work has shown that given imperfect diagnostic tests, even with a perfect observation process, detecting and outbreak, let alone modeling and predicting the approach of a critical transition that would indicate high risk of future outbreak, is an incredibly challenging task.
    - In surveillance systems, we never know the true state of $R#sub[#text[effective]]$, nor how to truly categorize our time series into outbreak and non-outbreak periods
        - At best we are estimating $R#sub[#text[t]]$ with imperfect tests
- Even what we believe to be perfect tests are anything but
    - A binary threshold is typically used to ascribe infectiousness/not, and susceptibility/immunity to individuals, and we know from prior work on RDT infectivity (Mina, Hay etc) that test timing is critical
        - Particularly when resources are limited, an individual who receives a negative test result (e.g., because they were tested too early in their latent/infectious period) is unlikely to be retested, which will result in under-counting, even with a "perfect test"
        - The binary threshold may be defined based on 6 s.d. above the mean optical density of known negative samples (e.g., pre-COVID-19 era samples), but this does not necessarily capture the true relationship between IgG/IgM titers and susceptibility/infectiousness
            - What about vaccinated individuals who experience faster waning of titers that previously infected individuals - are they more likely to be reinfected, or is it that the threshold must be context-specific to the population, time etc?
            - Closer to that threshold there is likely to have greater uncertainty in susceptibility/serostatus, which should be accounted for when incorporated into reconstructed test positive time series
                - Estimates of $R#sub[#text[t]]$ should try to account for this if this approach is to be used to predict $R#sub[#text[effective]]$ and risk of future outbreaks

= Concluding Thoughts

- Understanding the limits of outbreak detection and responses allows for a more intentional discussion of the associated costs and benefits of resource allocation and deployment
    - We may not always be able to adjust and optimize appropriately, but mapping the heterogeneity and root cause of uncertainty ensures we don't prematurely "optimize" our decisions and unnecessarily restrict the options available to us.
- Chapters 2 & 3 highlight the importance of modeling latent heterogeneous risk/exposure groups for placing bounds on the effects of outbreak response interventions, which, when thoughtfully integrated with the findings of Chapter 4 & 5s' work on outbreak detection, could help design more holistic surveillance systems that have feedback mechanisms:
    - If it is known that there are pockets of individuals in a population that are likely to be overrepresented in the transmission dynamics, and that given resources and current control practices, there are substantial limits on the possible changes to the infection potential in the population, more sensitive surveillance systems can be implemented.
