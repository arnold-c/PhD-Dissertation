#import "psu_template.typ": *

#show: psu_thesis.with(
    title: "Constructing Categories in Infectious Disease Outbreaks: Opportunities, Uncertainty, and Consequences",
    author: "Callum R. K. Arnold",
    department: "Department of Biology",
    degree_type: "doctorate", // one of "doctorate" or "masters"
    committee_members: (
    (
        name: "Dr. Katriona Shea",
        title: "Professor of Biology\nAlumni Professor in the Biological Sciences",
        committee-position: "Chair of Committee",
    ),
    (
        name: "Dr. Matthew J. Ferrari",
        title: "Professor of Biology\nCenter for Infectious Disease Dynamics Director",
        committee-position: "Major Field Member & Dissertation Advisor",
    ),
    (
        name: "Dr. Maciej Boni",
        title: "Professor of Biology, Temple University",
        committee-position: "Major Field Member",
    ),
    (
        name: "Dr. Stephen Berg",
        title: "Assistant Professor of Statistics",
        committee-position: "Outside Unit & Field Member",
    ),
    ),
    date: ( // Date of degree CONFERRAL
    year: "2024",
    month: "December",
    day: "22",
    ),
    font-size: 12pt,
    line-spacing: 2,
    left-margin: 1.5in,
    remaining-margins: 1in,
    abstract: [#include("./additional_sections/abstract.typ")],
    acknowledgements: [#include("./additional_sections/acknowledgements.typ")],
    abbreviations: [#include("./additional_sections/abbreviations.typ")],
    // dedication: [#include "./additional_sections/dedication.typ"]
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
