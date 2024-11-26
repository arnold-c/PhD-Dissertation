#import "psu_template.typ": *

#show: psu_thesis.with(
    title: "The Role of Categories in Shaping Our Understanding of Infectious Disease Outbreaks",
    author: "Callum R. K. Arnold",
    department: "Biology",
    degree_type: "doctorate", // one of "doctorate" or "masters"
    committee_members: (
    (
        name: "Katriona Shea",
        title: "Professor of Biology\nAlumni Professor in the Biological Sciences",
        committee-position: "Chair of Committee",
    ),
    (
        name: "Matthew J. Ferrari",
        title: "Professor of Biology\nCenter for Infectious Disease Dynamics Director",
        committee-position: "Dissertation Advisor",
    ),
    (
        name: "Maciej Boni",
        title: "Professor of Biology, Temple University",
    ),
    (
        name: "Stephen Berg",
        title: "Assistant Professor of Statistics",
    ),
    (
        name: "Elizabeth McGraw",
        title: "Professor of Biology",
        committee-position: "Department Head of Biology",
    ),
    ),
    date: ( // Date of degree CONFERRAL
    year: "2025",
    month: "May",
    day: "22",
    ),
    font-size: 12pt,
    line-spacing: 2,
    left-margin: 1.5in,
    remaining-margins: 1in,
    line-numbers: false,
    abstract: [#include("./additional_sections/abstract.typ")],
    acknowledgements: [#include("./additional_sections/acknowledgements.typ")],
    abbreviations: [#include("./additional_sections/abbreviations.typ")],
    // dedication: [#include "./additional_sections/dedication.typ"]
    epigraph: [#include("./additional_sections/epigraph.typ")]
)

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

#show: appendices

#include "./chapter_2/d4a_supplemental-appendix.typ"
#pagebreak()


#include "./chapter_3/lca_supplemental-appendix.typ"
#pagebreak()

#include "./chapter_4/outbreak-detection_supplemental-appendix.typ"
#pagebreak()

#include "./chapter_5/ews_supplemental-appendix.typ"
#pagebreak()

#show heading.where(level: 1): it => {it.body}

#show: reset_linespacing

#bibliography(
    style: "elsevier-vancouver",
    "./Dissertation.bib"
)
<bibliography>

#pagebreak()

#set page(numbering: none)
#include "./additional_sections/vita.typ"
