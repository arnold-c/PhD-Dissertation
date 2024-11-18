#let appendix(title) = {
  heading(title, supplement: "Appendix")
}

#let appendices(body) = {
  counter(heading).update(0)
  counter("appendices").update(1)

  set heading(
    numbering: (..nums) => {
      let vals = nums.pos()
      let value = "ABCDEFGHIJ".at(vals.at(0) - 1)
      if vals.len() == 1 {
        return value + ""
      }
      else {
        return value + "." + nums.pos().slice(1).map(str).join(".")
      }
    }
  );

  body
}

#let psu_thesis(
    title: "Title",
    author: (),
    committee_members: (),
    paper-size: "us-letter",
    bibliography-file: none,
    department: "Department",
    degree_type: "doctorate",
    date: (
        year: "2000",
        month: "January",
        day: "01"
    ),
    font-size: 12pt,
    line-spacing: 1em,
    abstract: [],
    acknowledgements: [],
    dedication: [],
    abbreviations: [],

    body
) = {
  // Useful variables
  let doc_title = if degree_type == "doctorate" [dissertation] else [thesis]
  let doc_title_cap = if degree_type == "doctorate" [Dissertation] else [Thesis]
  let psu = "The Pennsylvania State University"
  let degree = {
      if degree_type == "doctorate" [Doctor of Philosophy]
      else [Master of Science]
  }
  let unit = "The Graduate School"
  let front_matter_sections = (
    [List of Figures],
    [List of Tables],
    [List of Maps],
    [List of Abbreviations],
    [Acknowledgements],
  )
  let excluded_fm_sections = (
    [Abstract],
    [Table of Contents],
    [Preface],
    [Epigraph],
    [Frontispiece],
    [Dedication],

  )
  let back_matter_sections = (
    [Bibliography],
    [Vita]
  )
  let line_spacings = if line-spacing == 1 {
    (top-edge: "cap-height", bottom-edge: "baseline", leading: 0.65em, first-line-indent: 0em, spacing: 1.2em)
  } else if line-spacing == 1.5 {
    (top-edge: "cap-height", bottom-edge: "baseline", leading: 1.0em, first-line-indent: 1em, spacing: 1.8em)
  } else if line-spacing == 2{
    (top-edge: "cap-height", bottom-edge: "baseline", leading: 1.3em, first-line-indent: 2em, spacing: 2.4em)
  }


  set document(title: title, author: author)
  set page(
      paper: paper-size,
      margin: 1in,
  )
  set text(size: font-size)

  // Title page
  {
    set page (numbering: none)
    set par(leading: 2em)
    set align(center)

    v(10mm)
    [#psu \ #unit]
    v(20mm)
    text(14pt, weight: "bold", upper(title))
    v(20mm)
    [A #doc_title_cap in \ #department \ by \ #author]
    v(10mm)
    [#sym.copyright #date.year #author]
    v(10mm)
    par(leading: 0.65em, [
        Submitted in Partial Fulfilment \
        of the Requirements \
        for the Degree of
        #v(10mm)
        #degree
    ])
    v(10mm)
    [#date.month #date.year]
  }
  pagebreak(weak: true)

  // Front matter
  set page(numbering: "i")
  {

    // Committee Page
    "The " + doc_title + " of " + author + " was reviewed and approved by the following:\n"
    v(10mm)
    for member in committee_members {
        text[#member.name] + "\n"
        text[#member.title]
        v(12pt)
    }
    pagebreak(weak: true)

    {
        set text(top-edge: line_spacings.top-edge, bottom-edge: line_spacings.bottom-edge)
        set par(leading: line_spacings.leading, first-line-indent: line_spacings.first-line-indent, spacing: line_spacings.spacing)

      heading(level: 1)[Abstract]
      [#abstract]
      pagebreak(weak: true)
    }

    block(below: 2em)[#heading[Table of Contents]]

    context {
      let items = query(heading)
      let fm = items.filter(it => it.level == 1)
        .filter(it => it.body in front_matter_sections)
      for line in fm {
        let loc = line.location()
        let pnr = loc.position().page

        link(loc)[#line.body]
        box(width: 1fr, repeat[.])
        numbering("i", pnr)
        [\ ]
      }
    }
    v(1em)
    context {
      let items = query(heading)
      let lines = items.filter(it => it.level == 1)
        .filter(it => it.body not in front_matter_sections)
        .filter(it => it.body not in excluded_fm_sections)
        .filter(it => it.body not in back_matter_sections)

      let line_locs = lines.map(it => it.location())
      for (i, line) in lines.enumerate() {
        let string = [
          #if line.supplement != auto [
            #line.supplement
            #counter(heading).at(line.location()).first() |
          ]
          #line.body
          #box(width: 1fr, repeat[.])
          #counter(page).at(line.location()).first()
          \
        ]
        if line.has("label") {
          link(line.label, string)
        } else {
          string
        }

        let next_i = i+1
        let its = if next_i < lines.len() {
          query(
          heading.where(level: 2)
            .or(heading.where(level: 3))
            .after(line_locs.at(i))
            .before(line_locs.at(next_i))
          )
        }  else {
          query(
          heading.where(level: 2)
            .or(heading.where(level: 3))
            .after(line_locs.at(i))
          )
        }

        for h in its {
          if h.level == 1 {
            continue
          }
          let string = [
            #(" " * 4 * h.level)
            #h.body
            #box(width: 1fr, repeat[.])
            #counter(page).at(h.location()).first()\
          ]
          if h.has("label") {
            link(h.label, string)
          } else {
            let loc = h.location()
            link(loc)[#string]
          }
        }
        v(1em)
      }
    }
    pagebreak(weak: true)


  }

    show heading: it => [
      #set align(center)
      #block(below: 2em)[#text(size: 14pt)[#upper(it)]]
    ]

    // We have to add headings to these lists to include them in the overall ToC
    heading[List of Figures]
    context {
      let figures = query(figure.where(kind: image))
      for fig in figures {
        let loc = fig.location()
        let pnr = numbering(
          loc.page-numbering(),
          ..counter(page).at(loc),
        )

        [#link(loc)[#fig.caption] #box(width: 1fr, repeat[.]) #pnr \ ]
        v(0.5em)
      }
    }
    pagebreak(weak: true)

    heading[List of Tables]
    context {
      let tables = query(figure.where(kind: table))
      for tbl in tables {
        let loc = tbl.location()
        let pnr = numbering(
          loc.page-numbering(),
          ..counter(page).at(loc),
        )

        [#link(loc)[#tbl.caption] #box(width: 1fr, repeat[.]) #pnr \ ]
        v(0.5em)
      }
    }
    pagebreak(weak: true)

    if abbreviations != [] {
      heading(level: 1)[List of Abbreviations]
      [#abbreviations]
      pagebreak(weak: true)
    }


    set text(top-edge: line_spacings.top-edge, bottom-edge: line_spacings.bottom-edge)
    set par(leading: line_spacings.leading, first-line-indent: line_spacings.first-line-indent, spacing: line_spacings.spacing)

    if acknowledgements != [] {
      heading(level: 1)[Acknowledgements]
      [#acknowledgements]
      pagebreak(weak: true)
    }

    if dedication != [] {
      heading(level: 1)[Dedication]
      [#dedication]
      pagebreak(weak: true)
    }


  show heading.where(level: 1): it => {
    set text(18pt)
    if it.supplement != auto [
      #it.supplement
      #counter(heading).display() |
      #it.body
    ] else [
      #it.body
    ]
    v(0.5em)
  }

  set page(numbering: "1")
  set heading(numbering: "1.1")
  counter(page).update(1)

  body
}
