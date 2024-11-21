#let article(
  // Article's Title
  title: "Article Title",
  header-title: none,

  // Word count
  word-count: false,

  // Line numbers
  line-numbers: false,

  article_label: "",

  // Paper's content
  body
) = {
  if header-title == "true" {
    header-title = title
  }


  set page(
    header: [
      #set text(8pt)
      #align(right)[#header-title]
    ]
  )

  set math.equation(numbering: "1", supplement: "Supplemental")


  show heading.where(level: 2): it => {
    let key = lower(it.body.text.replace(" ", "-"))
    [#it #label(key)]
  }

  show heading.where(level: 2): it => block(above: 1.5em, below: 0.5em)[
      #set text(1.03em, weight: "black")
      #it.body
  ]

  show heading.where(level: 3): it => block(above: 1em, below: 0.5em)[
      #set text(1.01em, weight: "black")
      #it.body
  ]

  show heading.where(level: 4): it => block(above: 1em, below: 0.5em)[
      #set text(1.01em, weight: "bold", style: "italic")
      #it.body
  ]

  show figure.caption: it => [
      #set text(style: "italic", top-edge: "cap-height", bottom-edge: "baseline")
      #set par(leading: 0.65em, first-line-indent: 0em, spacing: 1.2em)
      #it
  ]

  set table(fill: (x, y) => if y == 0 { gray })
  show table.cell.where(y: 0): strong

  block([
      #set text(top-edge: "cap-height", bottom-edge: "baseline")
      #set par(leading: 0.65em, first-line-indent: 0em, spacing: 1.2em)
      // #set heading(numbering: "A")
      #heading(title, supplement: "Appendix") #label(article_label)
  ])

  body
}

#let two_header_table(..args) = table(
  ..args,
  fill: (x, y) => { if y == 0 or y == 1 {gray}}
)
