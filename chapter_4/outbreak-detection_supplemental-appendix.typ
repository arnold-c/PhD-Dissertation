#import "../appendix_template.typ": article
//
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
  caption: [Mean outbreak detection accuracy of each testing scenario at their specific optimal thresholds, when the average noise incidence is 8 times higher than the average measles incidence. A) the noise structure is dynamical, and the seasonality is in-phase with the measles incidence. B) the noise structure is Poisson only.],
  supplement: [Supplemental Table]
)
<tbl-optimal-thresholds-accuracy>

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
  caption: [Mean unavoidable cases per annum of each testing scenario at their specific optimal thresholds, scaled up to Ghana’s 2022 population, when the average noise incidence is 8 times higher than the average measles incidence. A) the noise structure is dynamical, and the seasonality is in-phase with the measles incidence. B) the noise structure is Poisson only.],
  supplement: [Supplemental Table]

)
<tbl-optimal-thresholds-unavoidable>

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
  caption: [Mean outbreak alert delay (days) of each testing scenario at their specific optimal thresholds, when the average noise incidence is 8 times higher than the average measles incidence. A) the noise structure is dynamical, and the seasonality is in-phase with the measles incidence. B) the noise structure is Poisson only.],
  supplement: [Supplemental Table]

)
<tbl-optimal-thresholds-delays>


== Figures

#figure(
  image("supplemental_files/plots/optimal-thresholds_prop-outbreak-plot.svg"),
  caption: [The difference between the proportion of the time series in outbreak for outbreak detection systems under different testing rates and noise structures. The shaded bands illustrate the 80% central interval, and the solid/dashed lines represent the mean estimate. Solid lines represent tests with 0-day turnaround times, and dashed lines represent tests with result delays.],
  supplement: [Supplemental Figure]
)
<fig-outbreak-proportion>

#figure(
  image("supplemental_files/plots/optimal-thresholds_alert-duration-plot.svg"),
  caption: [The difference between the alert durations for outbreak detection systems under different testing rates and noise structures. The shaded bands illustrate the 80% central interval, and the solid/dashed lines represent the mean estimate. Solid lines represent tests with 0-day turnaround times, and dashed lines represent tests with result delays.],
  supplement: [Supplemental Figure]

)
<fig-alert-duration>

#figure(
  image("supplemental_files/plots/optimal-thresholds_n-alerts-plot.svg"),
  caption: [The difference between the number of alerts under different testing rates and noise structures. The shaded bands illustrate the 80% central interval, and the solid/dashed lines represent the mean estimate. Solid lines represent tests with 0-day turnaround times, and dashed lines represent tests with result delays.],
  supplement: [Supplemental Figure]
)
<fig-num-alerts>
