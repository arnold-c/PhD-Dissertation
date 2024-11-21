// #set heading(numbering: "1.1")
// #set math.equation(numbering: "(1)" )
//
// #let title = "Thesis"
//
// #set document(title: title)
// #align(center, text(size: 18pt, weight: "bold")[#title])
//
//
// #include "chapter_3/manuscript.typ"
//
// #include "chapter_4/manuscript.typ"
//

#import "psu_template.typ": *

#show: psu_thesis.with(
    title: "Opportunities & Uncertainty in the Quest to Understand Infectious Disease Outbreaks: Consequences of Creating Categories",
  author: "Callum R. K. Arnold",
  department: "Department of Biology",
  degree_type: "doctorate", // one of "doctorate" or "masters"
  committee_members: (
    (
        name: "Dr. Katriona Shea",
        title: "Chair of Committee",
    ),
    (
        name: "Dr. Matthew J. Ferrari",
        title: "Major Field Member & Dissertation Advisor",
    ),
    (
        name: "Dr. Maciej Boni",
        title: "Major Field Member",
    ),
    (
        name: "Dr. Stephen Berg",
        title: "Outside Unit & Field Member",
    ),
  ),
  date: ( // Date of degree CONFERRAL
    year: "2024",
    month: "December",
    day: "22",
  ),
  font-size: 12pt,
  line-spacing: 2,
  // abstract: [#include("./additional_sections/abstract.typ")],
  acknowledgements: [#include("./additional_sections/acknowledgements.typ")],
  abbreviations: [#include("./additional_sections/abbreviations.typ")]
)

// Here you can include chapters (or anything) written in seperate files. One is given as an example
// #include "ch1.typ"
// #set text(top-edge: 0em, bottom-edge: -1em)
// #set par(first-line-indent: 2em, spacing: 2em)

#include "./chapter_1/introduction.typ"
#pagebreak()

#include "./chapter_2/d4a_manuscript.typ"
#pagebreak()

#include "./chapter_3/lca_manuscript.typ"
#pagebreak()

#include "./chapter_4/outbreak-detection_manuscript.typ"
#pagebreak()

#include "./chapter_5/ews_manuscript.typ"
#pagebreak()

#include "./chapter_6/synthesis.typ"
#pagebreak()

#pagebreak()

#show: appendices

#include "./chapter_3/lca_supplemental-appendix.typ"
#pagebreak()

#include "./chapter_4/outbreak-detection_supplemental-appendix.typ"

// #heading("Appendix Title", supplement: "Appendix") <app_a>

#set text(top-edge: "cap-height", bottom-edge: "baseline")
#set par(leading: 0.65em, first-line-indent: 0em, spacing: 1.2em)
#bibliography(style: "elsevier-vancouver", "./Dissertation.bib") <bibliography>

#pagebreak()

#include "./additional_sections/vita.typ"
