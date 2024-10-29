// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): block.with(
    fill: luma(230), 
    width: 100%, 
    inset: 8pt, 
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    new_title_block +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}

#let article(
  // Article's Title
  title: "Article Title",
  header-title: none,

  // A dictionary of authors.
  // Dictionary keys are authors' names.
  // Dictionary values are meta data of every author, including
  // label(s) of affiliation(s), email, contact address,
  // or a self-defined name (to avoid name conflicts).
  // Once the email or address exists, the author(s) will be labelled
  // as the corresponding author(s), and their address will show in footnotes.
  //
  // Example:
  // (
  //   "Author Name": (
  //     "affiliation": "affil-1",
  //     "email": "author.name@example.com", // Optional
  //     "address": "Mail address",  // Optional
  //     "name": "Alias Name" // Optional
  //   )
  // )
  authors: (),

  // A dictionary of affiliation.
  // Dictionary keys are affiliations' labels.
  // These labels show be constent with those used in authors' meta data.
  // Dictionary values are addresses of every affiliation.
  //
  // Example:
  // (
  //   "affil-1": "Institution Name, University Name, Road, Post Code, Country"
  // )
  affiliations: (),

  // The paper's abstract.
  abstract: [],

  // The paper's keywords.
  keywords: (),

  // The path to a bibliography file if you want to cite some external
  // works.
  bib: none,
  bib-title: "References",

  // Word count
  word-count: false,

  // Line numbers
  line-numbers: false,

  // Paper's content
  body
) = {
  // Set document properties
  set bibliography(title: bib-title)

  // Line numbers have not yet been implemented in a release version, but are coming soon
  // https://github.com/typst/typst/issues/352
  // https://github.com/typst/typst/pull/4516
  //if line-numbers {
  //  set par.line(numbering: "1")
  //  show figure: set par.line(numbering: none)
  //}

  set document(title: title, author: authors.keys())
  set page(numbering: "1", number-align: center)
  set text(font: ("Linux Libertine", "STIX Two Text", "serif"), lang: "en")
  show footnote.entry: it => [
    #set par(hanging-indent: 0.7em)
    #set align(left)
    #numbering(it.note.numbering, ..counter(footnote).at(it.note.location())) #it.note.body
  ]
  show figure.caption: emph
  set table(
    fill: (x, y) => {
      if y == 0 {gray}
    }
  )
  show table.cell: it => {
    if it.y == 0 {
      strong(it)
    } else {
      it
    }
  }

  // Title block
  align(center)[
    #block(text(size: 14pt, weight: "bold", title))

    #v(1em)

    // Authors and affiliations

    // Restore affiliations' keys for looking up later
    // to show superscript labels of affiliations for each author.
    #let inst_keys = affiliations.keys()

    // Authors' block
    #block([
      // Process the text for each author one by one
      #for (ai, au) in authors.keys().enumerate() {
        let au_meta = authors.at(au)
        // Don't put comma before the first author
        if ai != 0 {
          text([, ])
        }
        // Write auther's name
        let au_name = if au_meta.keys().contains("name") {au_meta.name} else {au}
        text([#au_name])

        // Get labels of author's affiliation
        let au_inst_id = au_meta.affiliation
        let au_inst_primary = ""
        // Test whether the author belongs to multiple affiliations
        if type(au_inst_id) == "array" {
          // If the author belongs to multiple affiliations,
          // record the first affiliation as the primary affiliation,
          au_inst_primary = affiliations.at(au_inst_id.first())
          // and convert each affiliation's label to index
          let au_inst_index = au_inst_id.map(id => inst_keys.position(key => key == id) + 1)
          // Output affiliation
          super([#(au_inst_index.map(id => [#id]).join([,]))])
        } else if (type(au_inst_id) == "string") {
          // If the author belongs to only one affiliation,
          // set this as the primary affiliation
          au_inst_primary = affiliations.at(au_inst_id)
          // convert the affiliation's label to index
          let au_inst_index = inst_keys.position(key => key == au_inst_id) + 1
          // Output affiliation
          super([#au_inst_index])
        }

        // Corresponding author
        if au_meta.keys().contains("corresponding") and (au_meta.corresponding == "true" or au_meta.corresponding == true) {
          [#super[,]#footnote(numbering: "*")[
            Corresponding author. #au_name. Address:
            #if not au_meta.keys().contains("address") or au_meta.address == "" {
              [#au_inst_primary.]
            }
            #if au_meta.keys().contains("email") {
              [Email: #link("mailto:" + au_meta.email.replace("\\", "")).]
            }
          ]]
        }

        if au_meta.keys().contains("equal-contributor") and (au_meta.equal-contributor == "true" or au_meta.equal-contributor == true){
          if ai == 0 {
            [#super[,]#footnote(numbering: "*")[Equal contributors.]<ec_footnote>]
          } else {
            [#super[,]#footnote(numbering: "*", <ec_footnote>)]
          }
        }
      }
    ])

    #v(1em)

    // Affiliation block
    #align(left)[#block([
      #set par(leading: 0.4em)
      #for (ik, key) in inst_keys.enumerate() {
        text(size: 0.8em, [#super([#(ik+1)]) #(affiliations.at(key))])
        linebreak()
      }
    ])]
  ]

  if header-title == "true" {
    header-title = title
  }

  set page(
    header: [
      #set text(8pt)
      #align(right)[#header-title]
    ],
  )
  if word-count {
    import "@preview/wordometer:0.1.2": word-count, total-words
    show: word-count.with(exclude: (heading, table, figure.caption))
  }

  // Abstract and keyword block
  if abstract != [] {
    pagebreak()

    block([
        #if word-count {
        import "@preview/wordometer:0.1.2": word-count, word-count-of, total-words
        text(weight: "bold", [Word count: ])
        text([#word-count-of(exclude: (heading))[#abstract].words])
      }
      #heading([Abstract])
      #abstract

      #if keywords.len() > 0 {
        linebreak()
        text(weight: "bold", [Key words: ])
        text([#keywords.join([; ]).])
      }
    ])

    v(1em)
  }

  // Display contents

  pagebreak()

  show heading.where(level: 1): it => block(above: 1.5em, below: 1.5em)[
    #set pad(bottom: 2em, top: 1em)
    #it.body
  ]

  set par(first-line-indent: 0em)

  if word-count {
      import "@preview/wordometer:0.1.2": word-count, word-count-of, total-words
      text(weight: "bold", [Word count: ])
      text([#word-count-of(exclude: (heading, table, figure.caption))[#body].words])
  }

  body

}

 // title: "Title",
 // header-title: "Header Title",
 // authors: (
 //   "Author 1": (
 //     "affiliation": ("affil-1", "affil-2"),
 //     "email": "a1-email",
 //   ),
 //   "Author 2": (
 //     "affiliation": ("affil-1", "affil-3"),
 //     "email": "a2-email",
 //   ),
 // ),
 // affiliations: (
 //   "affil-1": "Affiliation 1",
 //   "affil-2": "Affiliation 2",
 //   "affil-3": "Affiliation 3",
 // ),
 // abstract: [
 //   == Background
 //   Abstract Background
 //
 //   == Methods
 //   Abstract Methods
 //
 //   == Result
 //   Abstract Results
 //
 //   == Conclusions
 //   Abstract Conclusions
 // ],
 // keywords: (),
 // bib: "refs.bib",
 // bib-title: "Refs",
 // word-count: false,
 // line-numbers: false,

#show: body => article(
      title: "The Maximal Expected Benefit of SARS-CoV-2 Interventions Among University Students: A Simulation Study Using Latent Class Analysis",
        header-title: "The Maximal Expected Benefit of SARS-CoV-2 Interventions Among University Students",
        authors: (
                    "Callum R.K. Arnold": (
            affiliation: ("PSU-Bio", "CIDD"),
            corresponding: "true",
            
            email: "cfa5228\@psu.edu",
      ),                    "Nita Bharti": (
            affiliation: ("PSU-Bio", "CIDD"),
            
            
            
      ),                    "Cara Exten": (
            affiliation: ("PSU-Nursing"),
            
            
            
      ),                    "Meg Small": (
            affiliation: ("PSU-HHD", "PSU-SSRI"),
            
            
            
      ),                    "Sreenidhi Srinivasan": (
            affiliation: ("CIDD", "Huck"),
            
            
            
      ),                    "Connie J. Rogers": (
            affiliation: ("PSU-Nutrition"),
            
            
            
      ),                    "Suresh V. Kuchipudi": (
            affiliation: ("CIDD", "PSU-Vet"),
            
            
            
      ),                    "Vivek Kapur": (
            affiliation: ("CIDD", "Huck", "PSU-Animal-Sci"),
            
            
            
      ),                    "Matthew J. Ferrari": (
            affiliation: ("PSU-Bio", "CIDD"),
            
            
            
      ),        ),
        affiliations: (
          "PSU-Bio": "Department of Biology, Pennsylvania State University, University Park, PA, USA 16802",
          "CIDD": "Center for Infectious Disease Dynamics, Pennsylvania State University, University Park, PA, USA 16802",
          "PSU-Nursing": "Ross & Carole Nese College of Nursing, Pennsylvania State University, University Park, PA, USA 16802",
          "PSU-HHD": "College of Health and Human Development, Pennsylvania State University, University Park, PA, USA 16802",
          "PSU-SSRI": "Social Science Research Institute, Pennsylvania State University, University Park, PA, USA 16802",
          "Huck": "Huck Institutes of the Life Sciences, Pennsylvania State University, University Park, PA, USA 16802",
          "PSU-Vet": "Department of Veterinary and Biomedical Sciences, Pennsylvania State University, University Park, PA, USA 16802",
          "PSU-Nutrition": "Department of Nutritional Sciences, Pennsylvania State University, University Park, PA, USA 16802",
          "PSU-Animal-Sci": "Department of Animal Science, Pennsylvania State University, University Park, PA, USA 16802"    ),
          bib: "LCA.bib",
            keywords: ("Latent Class Analysis","SIR Model","Approximate Bayesian Computation","Behavioral Survey","IgG Serosurvey"),
        abstract: [Non-pharmaceutical public health measures (PHMs) were central to pre-vaccination efforts to reduce Severe Acute Respiratory Syndrome Coronavirus 2 (SARS-CoV-2) exposure risk; heterogeneity in their adherence placed bounds on their potential effectiveness, and correlation in their adoption makes it hard to assess the impact attributable to any individual PHM. During the Fall 2020 semester, we used a longitudinal cohort design in a university student population to conduct a behavioral survey of intention to adhere to PHMs, paired with an IgG serosurvey to quantify SARS-CoV-2 exposure at the end of the semester. Using Latent Class Analysis on behavioral survey responses, we identified three distinct groups among the 673 students with IgG samples: 256 (38.04%) students were in the most adherent group, intending to follow all guidelines, 306 (46.21%) in the moderately-adherent group, and 111 (15.75%) in the least-adherent group, rarely intending to follow any measure, with adherence negatively correlated with seropositivity of 25.4%, 32.2% and 37.7%, respectively. Moving all individuals in an SIR model into the most adherent group resulted in a 76-93% reduction in seroprevalence, dependent on assumed assortativity. The potential impact of increasing PHM adherence was limited by the substantial exposure risk in the large proportion of students already following all PHMs.

],
        word-count: true,
        line-numbers: true,
    body,
)


= Background
<background>
Within epidemiology, the importance of heterogeneity, whether that host, population, statistical, or environmental, has long been recognized @fletcherWhatHeterogeneityIt2007@noldHeterogeneityDiseasetransmissionModeling1980@trauerImportanceHeterogeneityEpidemiology2019@zhangMonitoringRealtimeTransmission2022@lloyd-smithSuperspreadingEffectIndividual2005. For example, when designing targeted interventions, it is crucial to understand and account for differences that may exist within populations @woolhouseHeterogeneitiesTransmissionInfectious1997@wangHeterogeneousInterventionsReduce2021@mcdonaldImpactIndividuallevelHeterogeneity2016. These differences can present in a variety of forms: heterogeneity in susceptibility, transmission, response to guidance etc.; all of which affect the dynamics of an infectious disease @fletcherWhatHeterogeneityIt2007@noldHeterogeneityDiseasetransmissionModeling1980@woolhouseHeterogeneitiesTransmissionInfectious1997@seveliusBarriersFacilitatorsEngagement2014@tuschhoffDetectingQuantifyingHeterogeneity2023@delaneyStrategiesAdoptedGay2022@andersonQuantifyingIndividuallevelHeterogeneity2022@macdonaldInfluenceHLASupertypes2000@elieSourceIndividualHeterogeneity2022. While heterogeneity may exist on a continuous spectrum, it can be difficult to incorporate into analysis and interpretation, so individuals are often placed in discrete groups according to a characteristic that aims to represent the true differences @mossongSocialContactsMixing2008@klepacContagionBBCFour2018@daviesAgedependentEffectsTransmission2020@haySerodynamicsReviewMethods2024@yangLifeCourseExposures2020. When examining optimal influenza vaccination policy in the United Kingdom, Baguelin et al. @baguelinAssessingOptimalTarget2013 classified individuals as one of seven age groups. Explicitly accounting for, and grouping, individuals by whether they inject drugs can help target interventions to reduce human immunodeficiency virus (HIV) and Hepatitis C Virus incidence @levittInfectiousDiseasesInjection2020. Similarly, epidemiological models have demonstrated the potential for HIV pre-exposure prophylaxis to reduce racial disparities in HIV incidence @jennessAddressingGapsHIV2019.

When discretizing a population for the purposes of inclusion within a mechanistic model, three properties need to be defined: 1) the number of groups, 2) the size of the groups, and 3) the differences between the groups. Typically, as seen in the examples above, demographic data is used e.g., age, sex, race, ethnicity, socio-economic status, etc., often in conjunction with the contact patterns and rates @wangHeterogeneousInterventionsReduce2021@seveliusBarriersFacilitatorsEngagement2014@mossongSocialContactsMixing2008@daviesAgedependentEffectsTransmission2020@baguelinAssessingOptimalTarget2013@jennessAddressingGapsHIV2019@foxDisproportionateImpactsCOVID192023. There are many reasons for this: it is widely available, and therefore can be applied almost universally; it is easily understandable; and there are clear demarcations of the groups, addressing properties 1) and 2). However, epidemiological models often aim to assess the effects of heterogeneity with respect to infection, e.g., "how does an individual’s risk tolerance affect their risk of infection for influenza?". When addressing questions such as these, demographic data does not necessarily provide a direct link between the discretization method and the heterogeneous nature of the exposure and outcome. Instead, it relies on assumptions and proxy measures e.g., an individual’s age approximates their contact rates, which in turn approximates their risk of transmission. This paper demonstrates an alternative approach to discretizing populations for use within mechanistic models, highlighting the benefits of an interdisciplinary approach to characterize heterogeneity in a manner more closely related to the risk of infection.

In early 2020, shortly after the World Health Organization (WHO) declared the SARS-CoV-2 outbreak a public health emergency of international concern @worldhealthorganizationStatementSecondMeeting, universities across the United States began to close their campuses and accommodations, shifting to remote instruction @MapCoronavirusSchool2020@collegianTIMELINEPennState2021. By Fall 2020, academic institutions transitioned to a hybrid working environment (in-person and online), requiring students to return to campuses @adamsReturnUniversityCampuses2020@haddenWhatTop25@thenewyorktimesTrackingCoronavirusColleges2020. In a prior paper @arnoldLongitudinalStudyImpact2022 we documented the results of a large prospective serosurvey conducted in State College, home to The Pennsylvania State University (PSU) University Park (UP) campus. We examined the effect of 35,000 returning students (representing a nearly 20% increase in the county population @unitedstatescensusbureauCensusBureauQuickFacts2019) on the community infection rates, testing serum for the presence of anti-Spike Receptor Binding Domain (S/RBD) IgG, indicating prior exposure @longAntibodyResponsesSARSCoV22020. Despite widespread concern that campus re-openings would lead to substantial increases in surrounding community infections @adamsReturnUniversityCampuses2020@lopmanModelingStudyInform2021@benneyanCommunityCampusCOVID192021, very little sustained transmission was observed between the two geographically coincident populations @arnoldLongitudinalStudyImpact2022.

Given the high infection rate observed among the student body (30.4% seroprevalence), coupled with the substantial heterogeneity in infection rates between the two populations, we hypothesized that there may be further heterogeneity within the student body. Despite extensive messaging campaigns conducted by the University @pennsylvaniastateuniversityMaskPack2021, it is unlikely that all students equally adhered to public health guidance regarding SARS-CoV-2 transmission prevention. We use students’ responses to the behavioral survey to determine and classify their adherence to public health measures (PHMs). We then show that these latent classes are correlated with SARS-CoV-2 seroprevalence. Finally, we parameterize a mechanistic model of disease transmission within and between these groups, and explore the impact of public health guidance campaigns, such as those conducted at PSU @pennsylvaniastateuniversityMaskPack2021. We show that interventions designed to increase student compliance with PHMs would likely reduce overall transmission, but the relatively high initial compliance limits the scope for improvement via PHM adherence alone.

= Methods
<methods>
== Design, Setting, and Participants
<design-setting-and-participants>
This research was conducted with PSU Institutional Review Board approval and in accordance with the Declaration of Helsinki, and informed consent was obtained for all participants. The student population has been described in detail previously @arnoldLongitudinalStudyImpact2022, but in brief, students were eligible for the student cohort if they were: ≥ 18 years old; fluent in English; capable of providing their own consent; residing in Centre County at the time of recruitment (October 2020) with the intention to stay through April 2021; and officially enrolled as PSU UP students for the Fall 2020 term. Upon enrollment, students completed a behavioral survey in REDCap @harrisREDCapConsortiumBuilding2019 to assess adherence and attitudes towards public health guidance, such as attendance at gatherings, travel patterns, and non-pharmaceutical interventions. Shortly after, they were scheduled for a clinic visit where blood samples were collected. Students were recruited via word-of-mouth and cold-emails.

== Outcomes
<outcomes>
The primary outcome was the presence of S/RBD IgG antibodies, measured using an indirect isotype-specific (IgG) screening ELISA developed at PSU @gontuQuantitativeEstimationIgM2020. An optical density (absorbance at 450 nm) higher than six standard deviations above the mean of 100 pre-SARS-CoV-2 samples collected in November 2019, determined a threshold value of 0.169 for a positive result. Comparison against virus neutralization assays and RT-PCR returned sensitivities of 98% and 90%, and specificities of 96% and 100%, respectively @gontuLimitedWindowDonation2021. Further details in the Supplement of the previous paper @arnoldLongitudinalStudyImpact2022.

== Statistical Methods
<statistical-methods>
To identify behavioral risk classes, we fit a range of latent class analysis (LCA) models (two to seven class models) to the student’s behavioral survey responses, using the poLCA package @linzerPoLCAPackagePolytomous2011 in the R programming language, version 4.3.3 (2024-02-29) @rcoreteamLanguageEnvironmentStatistical2021. We considered their answers regarding the frequency with which they intended to engage in the following behaviors to be #emph[a priori] indicators of behavioral risk tolerance: wash hands with soap and water for at least 20s; wear a mask in public; avoid touching their face with unwashed hands; cover cough and sneeze; stay home when ill; seek medical attention when experiencing symptoms and call in advance; stay at least 6 feet (about 2 arms lengths) from other people when outside of their home; and, stay out of crowded places and avoid mass gatherings of more than 25 people. The behavioral survey collected responses on the Likert scale of: Never, Rarely, Sometimes, Most of the time, and Always. For all PHMs, Always and Most of the time accounted for \> 80% of responses (with the exception of intention to stay out of crowded places and avoid mass gatherings, where Always and Most of the time accounted for 78.8% of responses). To reduce the parameter space of the LCA and minimize overfitting, the behavioral responses were recoded as Always and Not Always. Measures of SARS-CoV-2 exposure e.g., IgG status, were not included in the LCA model fitting, as they reflect the outcome of interest. We focused on responses regarding intention to follow behaviors because this information can be feasibly collected during a public health campaign for a novel or emerging outbreak; it has also been shown that intentions are well-correlated with actual behaviors for coronavirus disease 2019 (COVID-19) public health guidelines, as well as actions that have short-term benefits @connerDoesIntentionStrength2024@mcdonaldRecallingIntendingEnact2017. We examined the latent class models using Bayesian Information Criterion, which is a commonly recommended as part of LCA model evaluation @wellerLatentClassAnalysis2020@nylund-gibsonTenFrequentlyAsked20181213, to select the model that represented the best balance between parsimony and maximal likelihood fit.

Using the best-fit LCA model, we performed multivariate logistic regression of modal class assignment against IgG seropositivity to assess the association between the latent classes and infection. This "three-step" approach is recommended over the "one-step" LCA model fit that includes the outcome of interest as a covariate in the LCA model @nylund-gibsonTenFrequentlyAsked20181213@bolckEstimatingLatentStructure2004a. The following variables were determined a priori to be potential risk factors for exposure @arnoldLongitudinalStudyImpact2022: close proximity (6 feet or less) to an individual who tested positive for SARS-CoV-2; close proximity to an individual showing key COVID-19 symptoms (fever, cough, shortness of breath); lives in University housing; ate in a restaurant in the past 7 days; ate in a dining hall in the past 7 days; only ate in their room/apartment in the past 7 days; travelled in the 3 months prior to returning to campus; and travelled since returning to campus for the Fall term. Variables relating to attending gatherings were not included in the logistic regression due to overlap with intention variables of the initial LCA fit. Missing variables were deemed "Missing At Random" and imputed using the mice package @vanbuurenMiceMultivariateImputation2011, as described in the supplement of the previous paper @arnoldLongitudinalStudyImpact2022.

We parameterized a deterministic compartmental SIR model using approximate Bayesian computation (ABC) against the seroprevalence within each latent class. The recovery rate was set to 8 days. Diagonal values of the transmission matrix were constrained such that $beta_(H H) lt.eq beta_(M M) lt.eq beta_(L L)$ (#emph[H] represents high-adherence to public health guidelines, and #emph[M] and #emph[L] represent medium- and low-adherence, respectively), with the following parameters fit: the transmission matrix diagonals, a scaling factor for the off-diagonal values ($phi.alt$), and a scaling factor for the whole transmission matrix ($rho$). The off-diagonal values are equal to a within-group value (diagonal) multiplied by a scaling factor ($phi.alt$). This scaling factor can either multiply the within-group beta value of the source group (e.g., $beta_(H L) = phi.alt dot.op beta_(L L)$; Eq. 1A), or the recipient group (e.g., $beta_(L H) = phi.alt dot.op beta_(L L)$; Eq. 1B), each with a different interpretation.

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
The former assumes that between-group transmission is dominated by the transmissibility of the source individuals, implying that adherence to the PHMs primarily prevents onwards transmission, rather than protecting against infection. The latter assumes that between-group transmission is dominated by the susceptibility of the recipient individuals, implying that adherence to the PHMs primarily prevents infection, rather than protecting against onwards transmission. A range of between-group scaling values ($phi.alt$) were simulated to perform sensitivity analysis for the degree of assortativity. Results are only shown for matrix structure $bold("A")$, but alternative assumptions about between-group mixing can be found in the supplement (Supplemental Figures S1-4). To examine the effect of an intervention to increase PHM adherence, we redistributed a proportion of low- and medium adherence individuals to the high adherence latent class, i.e., a fully effective intervention is equivalent to a single-group SIR model of high adherent individuals. Model fitting and simulation was conducted using the Julia programming language, version 1.10.5 @bezansonJuliaFreshApproach2017.

= Results
<results>
== Demographics
<demographics>
Full details can be found in the prior paper @arnoldLongitudinalStudyImpact2022, but briefly: 1410 returning students were recruited, 725 were enrolled, and 684 students completed clinic visits for serum collection between 26 October and 21 December 2020. Of these, 673 students also completed the behavioral survey between 23 October and 8 December 2020. The median age of the participants was 20 years (IQR: 19-21), 64.5% identified as female and 34.6% as male, and 81.9% identified as white. A large proportion (30.4%) were positive for IgG antibodies, and 93.5% (100) of the 107 students with a prior positive test reported testing positive only after their return to campus.

== LCA Fitting
<lca-fitting>
Of the 673 participants, most students intended to always mask (81.0%), always cover their coughs/sneezes (81.9%), and always stay home when ill (78.2%) (@tbl-plan-adherence). Two of the least common intentions were social distancing by maintaining a distance of at least 6 feet from others outside of their home, avoiding crowded places and mass gatherings \> 25 people (43.4% and 53.1% respectively), and avoiding face-touching with unwashed hands (43.5%).

#figure([
#figure(
  align(center)[#set text(font: ("system-ui", "Segoe UI", "Roboto", "Helvetica", "Arial", "sans-serif", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji") , size: 12pt); #table(
    columns: 3,
    align: (left,right,right,),
    table.header(table.cell(align: bottom + left, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); Intention to always:], table.cell(align: bottom + right, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); Always], table.cell(align: bottom + right, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); Not Always],),
    table.hline(),
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Avoid face-touching with unwashed hands], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[293 (43.54%)], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[380 (56.46%)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Cover cough and sneeze], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[551 (81.87%)], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[122 (18.13%)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Seek medical attention when have symptoms and call in advance], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[480 (71.32%)], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[193 (28.68%)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Stay at least 6 feet (about 2 arms lengths) from other people when outside of home.], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[292 (43.39%)], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[381 (56.61%)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Stay home when ill], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[526 (78.16%)], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[147 (21.84%)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Stay out of crowded places and avoid mass gatherings \> 25 people], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[357 (53.05%)], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[316 (46.95%)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Tested for COVID-19 twice or more], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[544 (80.83%)], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[129 (19.17%)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Wash hands often with soap and water for at least 20 seconds.], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[434 (64.49%)], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[239 (35.51%)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Wear a face cover (mask) in public], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[545 (80.98%)], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[128 (19.02%)],
  )]
  , kind: table
  )

], caption: figure.caption(
position: top, 
[
Participants’ intention to always or not always follow 8 public health measures
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-plan-adherence>


The four- and the three-class LCA models had the lowest BIC respectively (@tbl-lca-fits). Examining the four-class model, there was minimal difference in the classification of individuals, relative to the three-class model. In the four-class model, the middle class (of the three-class model) was split into two groups with qualitatively similar class-conditional item response probabilities i.e., conditional on class membership, the probability of responding "Always" to a given question, except for hand washing and avoiding face-touching with unwashed hands (Supplemental Tables S1 & S2).

We fit a logistic regression model to predict binary IgG serostatus that included inferred class membership, in addition to other predictor variables we previously identified in @arnoldLongitudinalStudyImpact2022. The mean and median BIC and AIC indicated similar predictive ability of the three- and four-class LCA models (@tbl-lca-glm-fits). Given these factors, the three-class model was selected for use in simulation for parsimony, requiring fewer assumptions and parameters to fit.

#figure([
#figure(
  align(center)[#set text(font: ("system-ui", "Segoe UI", "Roboto", "Helvetica", "Arial", "sans-serif", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji") , size: 12pt); #table(
    columns: 4,
    align: (right,right,right,right,),
    table.header(table.cell(align: bottom + right, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); Classes], table.cell(align: bottom + right, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); Log Likelihood], table.cell(align: bottom + right, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); Akaike Information Criterion], table.cell(align: bottom + right, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); Bayesian Information Criterion],),
    table.hline(),
    table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[2], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[-2895.40], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5828.81], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5914.53],
    table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[3], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[-2715.67], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5489.35], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5620.19],
    table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[4], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[-2673.50], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5425.00], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5600.96],
    table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[-2658.46], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5414.93], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5636.00],
    table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[6], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[-2647.01], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5412.03], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5678.22],
    table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[7], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[-2636.05], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5410.10], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5721.41],
  )]
  , kind: table
  )

], caption: figure.caption(
position: top, 
[
Log likelihood, AIC, and BIC of two to seven class LCA model fits
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-lca-fits>


#figure([
#figure(
  align(center)[#set text(font: ("system-ui", "Segoe UI", "Roboto", "Helvetica", "Arial", "sans-serif", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji") , size: 12pt); #table(
    columns: 5,
    align: (right,right,right,right,right,),
    table.header(table.cell(align: bottom + right, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); Classes], table.cell(align: bottom + right, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); AIC (Mean)], table.cell(align: bottom + right, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); BIC (Mean)], table.cell(align: bottom + right, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); AIC (Median)], table.cell(align: bottom + right, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); BIC (Median)],),
    table.hline(),
    table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[2], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[794.33], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[839.44], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[794.18], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[839.29],
    table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[3], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[794.29], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[843.92], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[794.23], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[843.86],
    table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[4], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[797.52], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[851.66], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[797.50], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[851.64],
    table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[5], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[799.69], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[858.34], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[799.70], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[858.35],
    table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[6], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[796.91], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[860.08], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[796.84], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[860.00],
    table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[7], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[794.68], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[862.36], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[794.67], table.cell(align: horizon + right, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[862.35],
  )]
  , kind: table
  )

], caption: figure.caption(
position: top, 
[
Mean and median AIC and BIC of multiply-imputed logistic regressions for two to seven class LCA models against IgG serostatus
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-lca-glm-fits>


In the three-class model, approximately 15.75% of individuals were members of the group that rarely intended to always follow the PHMs, 38.04% intended to always follow all guidelines, and the remaining 46.21% mostly intended to mask, test, and manage symptoms, but not distance or avoid crowds (@tbl-lca-props). We have labelled the three classes as "Low-", "High-" and "Medium-Adherence" groups, respectively, for ease of interpretation. Examining the class-conditional item response probabilities, the Medium Adherence class had a probability of 0.88 of always wearing a mask in public, but a probability of only 0.19 of social distancing when outside of their homes, for example. Calculating the class-specific seroprevalence, the Low Adherence group had the highest infection rates (37.7%, 95% Binomial CI: 28.5-47.7%), the medium adherence the next highest (32.2%, 95% Binomial CI: 27.0-37.7%), and the most adherent group experienced the lowest infection rates (25.4%, 95% Binomial CI: 20.2-31.1%). Incorporating latent class membership into the imputed GLM model described in our previous paper (30) retained the relationship between adherence and infection. Relative to the least adherent group, the Medium Adherence group experienced a non-significant reduction in infection risk (aOR, 95% CI: 0.73, 0.45-1.18), and the most adherent group a significant reduction (aOR, 95% CI: 0.59, 0.36-0.98) (@tbl-lca-mice-fit).

#figure([
#figure(
  align(center)[#set text(font: ("system-ui", "Segoe UI", "Roboto", "Helvetica", "Arial", "sans-serif", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji") , size: 12pt); #table(
    columns: (40%, auto, auto, auto),
    align: (left,right,right,right,),
    table.header(table.cell(align: bottom + left, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); Measure \
      Intend to always:], table.cell(align: bottom + right, fill: rgb("#2f0f3e"))[#set text(size: 1.0em , fill: rgb("#ffffff")); Low Adherence], table.cell(align: bottom + right, fill: rgb("#911f63"))[#set text(size: 1.0em , fill: rgb("#ffffff")); Medium Adherence], table.cell(align: bottom + right, fill: rgb("#e05d53"))[#set text(size: 1.0em , fill: rgb("#ffffff")); High Adherence],),
    table.hline(),
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Wash my hands often with soap and water for at least 20 seconds.], table.cell(align: horizon + right, fill: rgb("#f8f8f8"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#000000")); 0.04], table.cell(align: horizon + right, fill: rgb("#999999"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.57], table.cell(align: horizon + right, fill: rgb("#2c2c2c"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.96],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Wear a face cover (mask) in public], table.cell(align: horizon + right, fill: rgb("#f4f4f4"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#000000")); 0.13], table.cell(align: horizon + right, fill: rgb("#444444"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.88], table.cell(align: horizon + right, fill: rgb("#242424"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.99],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Avoid face-touching with unwashed hands], table.cell(align: horizon + right, fill: rgb("#fafafa"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#000000")); 0.00], table.cell(align: horizon + right, fill: rgb("#efefef"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#000000")); 0.21], table.cell(align: horizon + right, fill: rgb("#4a4a4a"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.86],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Cover cough and sneeze], table.cell(align: horizon + right, fill: rgb("#eeeeee"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#000000")); 0.22], table.cell(align: horizon + right, fill: rgb("#4a4a4a"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.86], table.cell(align: horizon + right, fill: rgb("#212121"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 1.00],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Stay home when ill], table.cell(align: horizon + right, fill: rgb("#f7f7f7"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#000000")); 0.07], table.cell(align: horizon + right, fill: rgb("#525252"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.83], table.cell(align: horizon + right, fill: rgb("#212121"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 1.00],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Seek medical attention when have symptoms and call in advance], table.cell(align: horizon + right, fill: rgb("#f9f9f9"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#000000")); 0.03], table.cell(align: horizon + right, fill: rgb("#6f6f6f"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.70], table.cell(align: horizon + right, fill: rgb("#272727"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.98],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Stay at least 6 feet (about 2 arms lengths) from other people when outside of my home.], table.cell(align: horizon + right, fill: rgb("#fafafa"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#000000")); 0.00], table.cell(align: horizon + right, fill: rgb("#f0f0f0"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#000000")); 0.19], table.cell(align: horizon + right, fill: rgb("#474747"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.87],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Stay out of crowded places and avoid mass gatherings \> 25 people], table.cell(align: horizon + right, fill: rgb("#f9f9f9"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#000000")); 0.03], table.cell(align: horizon + right, fill: rgb("#cecece"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#000000")); 0.39], table.cell(align: horizon + right, fill: rgb("#444444"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.88],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Tested for COVID-19 twice or more], table.cell(align: horizon + right, fill: rgb("#646464"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.76], table.cell(align: horizon + right, fill: rgb("#555555"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.82], table.cell(align: horizon + right, fill: rgb("#585858"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(fill: rgb("#ffffff")); 0.81],
    table.cell(align: horizon + left, fill: rgb("#fde9ec"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(size: 12pt); Group Size], table.cell(align: horizon + right, fill: rgb("#2f0f3e"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(size: 12pt , fill: rgb("#ffffff")); 15.75%], table.cell(align: horizon + right, fill: rgb("#911f63"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(size: 12pt , fill: rgb("#ffffff")); 46.21%], table.cell(align: horizon + right, fill: rgb("#e05d53"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(size: 12pt , fill: rgb("#ffffff")); 38.04%],
    table.cell(align: horizon + left, fill: rgb("#fde9ec"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(size: 12pt); Seroprevalence], table.cell(align: horizon + right, fill: rgb("#2f0f3e"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(size: 12pt , fill: rgb("#ffffff")); 37.70%], table.cell(align: horizon + right, fill: rgb("#911f63"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(size: 12pt , fill: rgb("#ffffff")); 32.20%], table.cell(align: horizon + right, fill: rgb("#e05d53"), stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[#set text(size: 12pt , fill: rgb("#ffffff")); 25.40%],
  )]
  , kind: table
  )

], caption: figure.caption(
position: top, 
[
Class-conditional item response probabilities shown in the main body of the table for a three-class LCA model, with footers indicating the size of the respective classes, and the class-specific seroprevalence
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-lca-props>


#figure([
#figure(
  align(center)[#set text(font: ("system-ui", "Segoe UI", "Roboto", "Helvetica", "Arial", "sans-serif", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji") , size: 12pt); #table(
    columns: 2,
    align: (left,center,),
    table.header(table.cell(align: bottom + left, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); Covariate (response) / reference levels], table.cell(align: bottom + center, fill: rgb("#ffffff"))[#set text(size: 1.0em , fill: rgb("#333333")); aOR (multiple imputation)],),
    table.hline(),
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Close proximity to known COVID-19 positive individual (yes) / no], table.cell(align: horizon + center, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[3.41 (2.29-5.08, p\<0.001)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Close proximity to individual showing COVID-19 symptoms (yes) / no], table.cell(align: horizon + center, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[0.86 (0.58-1.29, p=0.474)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Lives in University housing (yes) / no], table.cell(align: horizon + center, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[0.9 (0.55-1.47, p=0.685)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Latent Class (medium adherence) / low adherence], table.cell(align: horizon + center, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[0.73 (0.45-1.18, p=0.203)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Latent Class (high adherence) / low adherence], table.cell(align: horizon + center, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[0.59 (0.36-0.98, p=0.043)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Travelled in the 3 months prior to campus arrival (yes) / no], table.cell(align: horizon + center, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[1.12 (0.76-1.63, p=0.57)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Travelled since campus arrival (yes) / no], table.cell(align: horizon + center, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[0.87 (0.6-1.25, p=0.447)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Ate in a dining hall in the past 7 days (yes) / no], table.cell(align: horizon + center, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[1.32 (0.76-2.29, p=0.332)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Ate in a restaurant in the past 7 days (yes) / no], table.cell(align: horizon + center, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[1.14 (0.8-1.64, p=0.465)],
    table.cell(align: horizon + left, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[Only ate in their room in the past 7 days (yes) / no], table.cell(align: horizon + center, stroke: (top: (paint: rgb("#d3d3d3"), thickness: 0.75pt)))[0.87 (0.59-1.29, p=0.499)],
  )]
  , kind: table
  )

], caption: figure.caption(
position: top, 
[
Adjusted odds ratio (aOR) for risk factors of infection among the returning PSU UP student cohort
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-lca-mice-fit>


== Compartmental Model
<compartmental-model>
The ABC distance distributions indicated that near-homogeneous levels of between-group mixing better fit the data (@fig-abc-distance-whiskers). After model parameterization, we examined the effect of increasing adherence to public health guidance. Moving all individuals into the High Adherence class resulted in a 76-93% reduction in final size; when moderate between-group mixing is simulated, a fully effective intervention results in approximately 80% reduction in final seroprevalence, and when between-group mixing is as likely as within-group mixing, a 93% reduction is observed (@fig-intervention).

#figure([
#box(image("./manuscript_files/abc-distance-whiskers_copy-columns.png"))
], caption: figure.caption(
position: bottom, 
[
Distribution of the distance from the ABC fits, with the minimum and maximum distances illustrated by the whiskers, and the median distance by the point. Between-group mixing of 1.0 equates to between-group mixing as likely as within-group mixing
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-abc-distance-whiskers>


#figure([
#box(image("./manuscript_files/intervention-stacked-bar_copy-columns.png"))
], caption: figure.caption(
position: bottom, 
[
A) The reduction in final infection size across a range of intervention effectiveness (1.0 is a fully effective intervention), accounting for a range of assortativity. Between-group mixing of 1.0 equates to between-group mixing as likely as within-group mixing; B) The relative distribution of group sizes at three levels of intervention effectiveness (0.0, 0.5, 1.0)
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-intervention>


= Discussion
<discussion>
In this interdisciplinary analysis, we collected behavioral data from surveys and integrated it with serosurveillance results. This approach allowed us to use LCA to categorize a population’s transmission potential with measures related to risk tolerance and behavior. The LCA model was fit without inclusion of infection status data, but class membership was correlated with IgG seroprevalence. The classes that were the most adherent to PHMs experienced the lowest infection rates, and the least adherent exhibited the highest seroprevalence.

Although a four-class LCA model was a marginally better fit for the data, there were not substantial differences in class assignment relative to the three-class LCA model. The three-class model was selected for use in simulation for parsimony, requiring fewer assumptions and parameters to fit. Upon parametrizing the compartmental model, smaller ABC distance values were observed for moderate to high levels of between-group mixing, implying some degree of assortativity in our population, though the exact nature cannot be determined from our data. Examining the three classes, 38% of individuals already intended to always follow all PHMs. As a result, only 62% of the study population could have their risk reduced with respect to the PHMs surveyed. Further, the infection rates observed in the High Adherence group indicates that even a perfectly effective intervention aimed at increasing adherence to non-pharmaceutical PHMs (i.e., after the intervention, all individuals always followed every measure) would not eliminate transmission in a population, an observation that aligns with prior COVID-19 research @flaxmanEstimatingEffectsNonpharmaceutical2020a@banholzerEstimatingEffectsNonpharmaceutical2021@braunerInferringEffectivenessGovernment2021@geUntanglingChangingImpact2022. The extent to which the infection in the High Adherence group is a result of mixing with lower adherence classes cannot be explicitly described, but the sensitivity analysis allows for an exploration of the effect and ABC fits suggest near-homogeneous mixing occurred. Varying the structure of the transmission matrix yielded very similar quantitative and qualitative results (Supplemental Figures S1-4).

Examining the impact of increasing adherence to PHMs (modeled as increasing the proportion of the population in the High Adherence class), a fully effective intervention saw between a 76-93% reduction in the final size of the simulation outbreak. The small but appreciable dependence of the reduction’s magnitude on the degree of between-group mixing can be explained as such: with higher levels of between-group mixing, the initial SIR parameterization results in lower transmission parameters for the High-High adherence interactions, as more infections in the High Adherence group originate from interactions with Low and Medium Adherence individuals. Increasing adherence, therefore, results in a greater reduction of the overall transmission rate than in simulations with less assortativity.

== Limitations and Strengths
<limitations-and-strengths>
The student population was recruited using convenience sampling, and therefore may not be representative of the wider population. Those participating may have been more cognizant and willing to follow public health guidelines. Similarly, because of the University’s extensive messaging campaigns and efforts to increase access to non-pharmaceutical measures @pennsylvaniastateuniversityMaskPack2021, such as lateral flow and polymerase-chain reaction diagnostic tests, the students likely had higher adherence rates than would be observed in other populations. However, these limitations are not inherent to the modeling approach laid out, and efforts to minimize them would likely result in stronger associations and conclusions due to larger differences in the latent behavioral classes and resulting group infection rates.

It is well known that classification methods, like LCA, can lead to the "naming fallacy" @wellerLatentClassAnalysis2020, whereby groups are assigned and then specific causal meaning is given to each cluster, affecting subsequent analyses and interpretation of results. In this paper, this effect is reduced by virtue of the analysis plan being pre-determined, and the relationship with the outcome showing a positive association with the classes in the mechanistically plausible direction (i.e., increasing adherence to PHMs results in reduced infection rates). Our decision to conduct the simulation analysis with the three-class model was, in part, to avoid the potential bias that would arise from naming or assigning an order to the two intermediate risk groups.

Despite these limitations, this work presents a novel application of a multidisciplinary technique, outlining how alternate data sources can guide future model parameterization and be incorporated into traditional epidemiological analysis, particularly within demographically homogeneous populations where there is expected or observed heterogeneity in transmission dynamics. This is particularly important in the design of interventions that aim to target individual behaviors, allowing the categorization of populations into dynamically-relevant risk groups and aiding in the efficient use of resources through targeted actions.

#pagebreak()
= Funding
<funding>
This work was supported by funding from the Office of the Provost and the Clinical and Translational Science Institute, Huck Life Sciences Institute, and Social Science Research Institutes at the Pennsylvania State University. The project described was supported by the National Center for Advancing Translational Sciences, National Institutes of Health, through Grant UL1 TR002014. The content is solely the responsibility of the authors and does not necessarily represent the official views of the NIH. The funding sources had no role in the collection, analysis, interpretation, or writing of the report.

= Acknowledgements
<acknowledgements>
== Author Contributions
<author-contributions>
#emph[Conceptualization:] CA, MJF

#emph[Data curation:] CA, MJF

#emph[Formal analysis:] CA, MJF

#emph[Funding acquisition:] MJF

#emph[Investigation:] NB, CE, MS, SS, CJR, SK, VS

#emph[Methodology:] CA, NB, MJF

#emph[Project administration:] MJF

#emph[Software:] CA, MJF

#emph[Supervision:] MJF

#emph[Validation:] CA, MJF

#emph[Visualization:] CA, MJF

#emph[Writing - original draft:] CA

#emph[Writing - review and editing:] all authors.

== Conflicts of Interest and Financial Disclosures
<conflicts-of-interest-and-financial-disclosures>
The authors declare no conflicts of interest.

== Data Access, Responsibility, and Analysis
<data-access-responsibility-and-analysis>
Callum Arnold and Dr.~Matthew J. Ferrari had full access to all the data in the study and take responsibility for the integrity of the data and the accuracy of the data analysis. Callum Arnold and Dr.~Matthew J. Ferrari (Department of Biology, Pennsylvania State University) conducted the data analysis.

== Data Availability
<data-availability>
The datasets generated during and/or analyzed during the current study are not publicly available as they contain personally identifiable information, but are available from the corresponding author on reasonable request.

== Collaborators
<collaborators>
+ Florian Krammer, Mount Sinai, USA for generously providing the transfection plasmid pCAGGS-RBD
+ Scott E. Lindner, Allen M. Minns, Randall Rossi produced and purified RBD
+ The D4A Research Group: Dee Bagshaw, Clinical & Translational Science Institute, Cyndi Flanagan, Clinical Research Center and the Clinical & Translational Science Institute, Thomas Gates, Social Science Research Institute, Margeaux Gray, Dept. of Biobehavioral Health, Stephanie Lanza, Dept. of Biobehavioral Health and Prevention Research Center, James Marden, Dept. of Biology and Huck Institutes of the Life Sciences, Susan McHale, Dept. of Human Development and Family Studies and the Social Science Research Institute, Glenda Palmer, Social Science Research Institute, Rachel Smith, Dept. of Communication Arts and Sciences and Huck Institutes of the Life Sciences, and Charima Young, Penn State Office of Government and Community Relations.
+ The authors thank the following for their assistance in the lab: Sophie Rodriguez, Natalie Rydzak, Liz D. Cambron, Elizabeth M. Schwartz, Devin F. Morrison, Julia Fecko, Brian Dawson, Sean Gullette, Sara Neering, Mark Signs, Nigel Deighton, Janhayi Damani, Mario Novelo, Diego Hernandez, Ester Oh, Chauncy Hinshaw, B. Joanne Power, James McGee, Riëtte van Biljon, Andrew Stephenson, Alexis Pino, Nick Heller, Rose Ni, Eleanor Jenkins, Julia Yu, Mackenzie Doyle, Alana Stracuzzi, Brielle Bellow, Abriana Cain, Jaime Farrell, Megan Kostek, Amelia Zazzera, Sara Ann Malinchak, Alex Small, Sam DeMatte, Elizabeth Morrow, Ty Somberger, Haylea Debolt, Kyle Albert, Corey Price, Nazmiye Celik

#pagebreak()
#block[
] <refs>



#set bibliography(style: "springer-vancouver")

#bibliography("LCA.bib")

