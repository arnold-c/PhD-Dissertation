#import "../appendix_template.typ": article

#show: article.with(
  title: "Supplementary Material for Chapter 4",
  header-title: "true",
  line-numbers: false,
  word-count: false,
  article_label: "outbreak-detection_appendix"
)

== Tables

#let accuracy = csv("supplemental_files/tables/optimal-thresholds_accuracy.csv")
#figure(
    table(
    columns: 9,
    fill: (x, y) => {
      if y == 0 {gray}
      if y == 1 {gray}
    },
    align: center,
    [], table.cell(colspan: 2, align: center, "Test Characteristic"), table.cell(colspan: 6, align: center, "Testing Rate"),
    ..accuracy.flatten()
  ),
  caption: [Mean outbreak detection accuracy for imperfect and perfect diagnostic tests, at their respective optimal alert thresholds, under dynamical and Poisson noise structures where the average daily noise incidence is 8 times the average daily measles incidence $Lambda(8)$. The test sensitivity equals the test specificity for all diagnostic tests.]
)
<tbl-optimal-thresholds-accuracy>

#let delays = csv("supplemental_files/tables/optimal-thresholds_detection-delays.csv")
#figure(
    table(
    columns: 9,
    fill: (x, y) => {
      if y == 0 {gray}
      if y == 1 {gray}
    },
    align: center,
    [], table.cell(colspan: 2, align: center, "Test Characteristic"), table.cell(colspan: 6, align: center, "Testing Rate"),
    ..delays.flatten()
  ),
  caption: [Mean outbreak detection delays (days) for imperfect and perfect diagnostic tests, at their respective optimal alert thresholds, under dynamical and Poisson noise structures where the average daily noise incidence is 8 times the average daily measles incidence $Lambda(8)$. The test sensitivity equals the test specificity for all diagnostic tests.]
)
<tbl-optimal-thresholds-delays>

#let unavoidable = csv("supplemental_files/tables/optimal-thresholds_unavoidable-cases.csv")
#figure(
    table(
    columns: 9,
    fill: (x, y) => {
      if y == 0 {gray}
      if y == 1 {gray}
    },
    align: center,
    [], table.cell(colspan: 2, align: center, "Test Characteristic"), table.cell(colspan: 6, align: center, "Testing Rate"),
    ..unavoidable.flatten()
  ),
  caption: [Mean unavoidable cases per annum (scaled to Ghana's 2022 population) for imperfect and perfect diagnostic tests, at their respective optimal alert thresholds, under dynamical and Poisson noise structures where the average daily noise incidence is 8 times the average daily measles incidence $Lambda(8)$. The test sensitivity equals the test specificity for all diagnostic tests.]
)
<tbl-optimal-thresholds-unavoidable>


== Figures

#figure(
  image("supplemental_files/plots/optimal-thresholds_n-alerts-plot.svg"),
  caption: [The number of alerts of outbreak detection systems under different testing rates and noise structures, at their respective optimal alert thresholds. The shaded bands illustrate the 80% central interval, and the solid/dashed lines represent the mean estimate. Imperfect tests have the same values for sensitivity and specificity. Solid lines represent tests with 0-day turnaround times, and dashed lines represent tests with result delays. $Lambda(4)$ indicates the mean noise incidence is 4 times higher than the mean measles incidence, for example.]
)
<fig-num-alerts>

#figure(
  image("supplemental_files/plots/optimal-thresholds_alert-duration-plot.svg"),
  caption: [The duration of alerts of outbreak detection systems under different testing rates and noise structures, at their respective optimal alert thresholds. The shaded bands illustrate the 80% central interval, and the solid/dashed lines represent the mean estimate. Imperfect tests have the same values for sensitivity and specificity. Solid lines represent tests with 0-day turnaround times, and dashed lines represent tests with result delays. $Lambda(4)$ indicates the mean noise incidence is 4 times higher than the mean measles incidence, for example.]
)
<fig-alert-duration>
