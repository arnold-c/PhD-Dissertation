#import "../appendix_template.typ": *

#show: article.with(
  title: "Supplementary Material for Chapter 3",
  line-numbers: false,
  word-count: false,
  article_label: "lca_appendix"
)

== LCA Model Fitting

#let lca_irp_table = csv("./supplemental_files/tables/lca-item-response-probs.csv")
#let lca_irp_fill_table = csv("./supplemental_files/tables/lca-item-response-probs_fill.csv")
#let lca_irp_colors_table = csv("./supplemental_files/tables/lca-item-response-probs_colors.csv")

#figure(
  table(
    // columns: 5,
    columns: (40%, auto, auto, auto, auto),
    align: (left, horizon, horizon, horizon, horizon),
    fill: (x, y) => {
      if y > 0 {
        let cell_color = lca_irp_fill_table.at(y).at(x)
        rgb(cell_color)
      }
    },
    table.cell(fill: gray)[Measure \ Intention to Always:],
    table.cell(fill: rgb("#2f0f3e"))[#text(fill: rgb("#ffffff"))[Low Adherence]],
    table.cell(fill: rgb("#911f63"))[#text(fill: rgb("#ffffff"))[Low-Medium Adherence]],
    table.cell(fill: rgb("#F7B32B"))[#text(fill: rgb("#ffffff"))[Medium-High Adherence]],
    table.cell(fill: rgb("#e05d53"))[#text(fill: rgb("#ffffff"))[High Adherence]],
    ..for ((val), (text_color)) in lca_irp_table.slice(1).flatten().zip(lca_irp_colors_table.slice(1).flatten()) {
      if text_color == "" {
        if val == "Group Size" or val == "Seroprevalence" {
        (table.cell[#text(weight: "bold")[#val]],)
        } else {
        (table.cell[#val],)
        }
      } else {
        (table.cell[#text(fill: rgb(text_color))[#val]],)
      }
    }
  ),
  caption: [Class-conditional item response probabilities shown in the main body of the table for a four-class LCA model, with footers indicating the size of the respective classes, and the class-specific seroprevalence],
)
<tbl-lca-props_4-class>


== Matrix Structure Sensitivity Analysis

In the main body of the text, we present the results for the three-class model that corresponds to a scenario where public health measures (PHMs) reduce onwards risk of transmission (@eq_lca-mixing-structure)
Two alternative were also simulated.

+ A transmission matrix that implies PHMs confer protection for the practitioner (@eq_lca-copy-rows).
+ A transmission matrix that uses a single scaled value of $beta_(L L)$, thereby all between-group interactions experience the same risk of transmission. This risk is a fraction of the transmission observed between Low Adherence individuals (@eq_lca-identical-off-diagonals).

Below are results for alternative scenarios, which show qualitatively similar results to the main body of the text, albeit with a wider distribution in the Approximate Bayesian Computation distance metrics.

=== PHMs Confer Protection

#let boldred(x) = text(fill: rgb("#8B0000"), $bold(#x)$)
$
rho mat(
  beta_(H H), beta_(H M), beta_(H L) ;
  beta_(M H), beta_(H M), beta_(M L) ;
  beta_(L H), beta_(H M), beta_(L L) ;
)
&&arrow rho mat(
  beta_(H H), phi.alt beta_(H H), phi.alt beta_(H H) ;
  phi.alt beta_(M M), beta_(M M), beta_(M M) ;
  boldred(phi.alt beta_(L L)), boldred(phi.alt beta_(L L)), boldred(beta_(L L)) ;
) &&#text[mixing structure]
$
<eq_lca-copy-rows>

#figure(
  image(
    "./supplemental_files/plots/abc-distance-whiskers_copy-rows.png",
    width: 100%
  ),
  caption: [PHMs confer protection to the practitioner. Distribution of the distance from the ABC fits, with the minimum and maximum distances illustrated by the whiskers, and the median distance by the point. Between-group mixing of 1.0 equates to between-group mixing as likely as within-group mixing],
)
<fig-abc-distance-whiskers-rows>

#figure(
  image(
    "./supplemental_files/plots/intervention-stacked-bar_copy-rows.png",
    width: 100%
  ),
  caption: [PHMs confer protection to the practitioner. A) The reduction in final infection size across a range of intervention effectiveness (1.0 is a fully effective intervention), accounting for a range of assortativity. Between-group mixing of 1.0 equates to between-group mixing as likely as within-group mixing; B) The relative distribution of group sizes at three levels of intervention effectiveness (0.0, 0.5, 1.0)],
)
<fig-intervention-rows>


#pagebreak()

=== Identical Off-Diagonal Values

$
rho mat(
  beta_(H H), beta_(H M), beta_(H L) ;
  beta_(M H), beta_(H M), beta_(M L) ;
  beta_(L H), beta_(H M), beta_(L L) ;
)
&&arrow rho mat(
  beta_(H H), boldred(phi.alt beta_(L L)), boldred(phi.alt beta_(L L)) ;
  boldred(phi.alt beta_(L L)), beta_(M M), boldred(phi.alt beta_(L L)) ;
  boldred(phi.alt beta_(L L)), boldred(phi.alt beta_(L L)), beta_(L L) ;
) &&#text[mixing structure]
$
<eq_lca-identical-off-diagonals>

#figure(
  image(
    "./supplemental_files/plots/abc-distance-whiskers_constant.png",
    width: 100%
  ),
  caption: [Identical off-diagonal values. Distribution of the distance from the ABC fits, with the minimum and maximum distances illustrated by the whiskers, and the median distance by the point. Between-group mixing of 1.0 equates to between-group mixing as likely as within-group mixing],
)
<fig-abc-distance-whiskers-constant>

#figure(
  image( "./supplemental_files/plots/intervention-stacked-bar_constant.png", width: 100% ),
  caption: [Identical off-diagonal values. A) The reduction in final infection size across a range of intervention effectiveness (1.0 is a fully effective intervention), accounting for a range of assortativity. Between-group mixing of 1.0 equates to between-group mixing as likely as within-group mixing; B) The relative distribution of group sizes at three levels of intervention effectiveness (0.0, 0.5, 1.0),
  ],
)
<fig-intervention-constant>
