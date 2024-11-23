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

  show figure.where(kind: table): set figure(supplement: [Supplemental Table])
  show figure.where(kind: image): set figure(supplement: [Supplemental Figure])

  show figure.caption: it => [
      #set text(top-edge: "cap-height", bottom-edge: "baseline")
      #set par(leading: 0.65em, first-line-indent: 0em, spacing: 1.2em)
      #it
  ]

  set table(fill: (x, y) => if y == 0 { gray })
  show table.cell.where(y: 0): strong

  // Add header titles to all pages after the 1st (which contains the title)
  set page(header: context {
    let next_h1 = query(selector(heading.where(level: 1))
      .after(here()))
      .at(0)
      .location()
      .page()

    if here().page() < next_h1 {
      let header-title = if header-title == "true" { title }
      align(right)[#header-title]
    }
  })

  block([
    #set text(top-edge: "cap-height", bottom-edge: "baseline")
    #set par(leading: 0.65em, first-line-indent: 0em, spacing: 1.2em)
    #heading(title, supplement: "Appendix") #label(article_label)
  ])

  body
}

#let two_header_table(..args) = table(
  ..args,
  fill: (x, y) => { if y == 0 or y == 1 {gray}}
)
