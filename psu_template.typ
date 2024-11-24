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
  )

  body
}

#let set_linespacing(
  top-edge: "cap-height",
  bottom-edge: "baseline",
  leading: 0.65em,
  first-line-indent: 0em,
  spacing: 1.2em,

  body
) = {
  set text(
    top-edge: top-edge,
    bottom-edge: bottom-edge,
  )
  set par(
    leading: leading,
    first-line-indent: first-line-indent,
    spacing: spacing,
  )

  body
}

#let set_headings(
  top-edge: "cap-height",
  bottom-edge: "baseline",
  leading: 0.65em,
  first-line-indent: 0em,
  spacing: 1.2em,
  h2-above-adjustment: 1.5em,
  h2-below-adjustment: 0.5em,
  h3-above-adjustment: 1em,
  h3-below-adjustment: 0.5em,
  h4-above-adjustment: 1em,
  h4-below-adjustment: 0.5em,

  body
) = {
  show heading.where(level: 2): it => block(
    above: spacing + h2-above-adjustment,
    below: spacing + h2-below-adjustment
  )[
      #set text(1.03em, weight: "black")
      #it.body
  ]

  show heading.where(level: 3): it => block(
    above: spacing + h3-above-adjustment,
    below: spacing + h3-below-adjustment
  )[
      #set text(1.01em, weight: "black")
      #it.body
  ]

  show heading.where(level: 4): it => block(
    above: spacing + h4-above-adjustment,
    below: spacing + h4-below-adjustment
  )[
      #set text(1.01em, weight: "bold", style: "italic")
      #it.body
  ]

  body

}

#let reset_linespacing(body) = {
  show: set_linespacing.with(
    top-edge: "cap-height",
    bottom-edge: "baseline",
    leading: 0.65em,
    first-line-indent: 0em,
    spacing: 1.2em,
  )

  show: set_headings.with(
    top-edge: "cap-height",
    bottom-edge: "baseline",
    leading: 0.65em,
    first-line-indent: 0em,
    spacing: 1.2em,
    h2-above-adjustment: 0em,
    h2-below-adjustment: 0em,
    h3-above-adjustment: 0em,
    h3-below-adjustment: 0em,
    h4-above-adjustment: 0em,
    h4-below-adjustment: 0em,
  )

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
    left-margin: 1.5in,
    remaining-margins: 1in,
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
  )
  let excluded_bm_sections = (
    [Vita],
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
      margin: (
        left: left-margin,
        right: remaining-margins,
        top: remaining-margins,
        bottom: remaining-margins
      )
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
        text[#member.title] + "\n"
        text[#member.committee-position] + "\n"
        v(12pt)
    }

    pagebreak(weak: true)

    {
      show: set_linespacing.with(
        ..line_spacings
      )
      // set text(
      //   top-edge: line_spacings.top-edge,
      //   bottom-edge: line_spacings.bottom-edge
      // )
      // set par(
      //   leading: line_spacings.leading,
      //   first-line-indent: line_spacings.first-line-indent,
      //   spacing: line_spacings.spacing
      // )

      block(below: 2em)[#heading[Abstract]]
      [#abstract]
      pagebreak(weak: true)
    }

    block(below: 2em)[#heading[Table of Contents]]

    // Get TOC for front matter
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

    // Get TOC for chapters
    context {
      // Hack to correct appendix numbering in TOC
      let letter_nums = "ABCDEFGHIJ"
      let items = query(heading)
      let lines = items.filter(it => it.level == 1)
        .filter(it => it.body not in front_matter_sections)
        .filter(it => it.body not in excluded_fm_sections)
        .filter(it => it.body not in excluded_bm_sections)

      let line_locs = lines.map(it => it.location())
      for (i, line) in lines.enumerate() {
        let string = [

          #if line.supplement != auto and line.body not in back_matter_sections [
            #let header_num = counter(heading).at(line.location()).first()
            #let num = [
              #if line.supplement == [Appendix] {
                letter_nums.at(header_num - 1)
              } else { header_num }
            ]
            #line.supplement #num |
          ]
          #line.body
          #box(width: 1fr, repeat[.])
          #counter(page).at(line.location()).first()
          \
        ]

        if line.has("label") {
          link(line.label, string)
        } else {
          link(line.location(), string)
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

        // Skip level 1 headings to avoid re-listing in TOC
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
            link(h.location(), string)
          }
        }
        v(1em)
      }
    }

    pagebreak(weak: true)

  }

  {
    show heading.where(level: 1): it => [
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

    show: set_linespacing.with(
      ..line_spacings
    )
    // set text(
    //   top-edge: line_spacings.top-edge,
    //   bottom-edge: line_spacings.bottom-edge
    // )
    // set par(
    //   leading: line_spacings.leading,
    //   first-line-indent: line_spacings.first-line-indent,
    //   spacing: line_spacings.spacing
    // )

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
  }

  // Set up page numbering for rest of dissertation
  set page(numbering: "1")
  set heading(numbering: "1.1")
  counter(page).update(1)

  // Set up line spacing for chapters
  set text(
    top-edge: line_spacings.top-edge,
    bottom-edge: line_spacings.bottom-edge
  )
  set par(
    leading: line_spacings.leading,
    first-line-indent: line_spacings.first-line-indent,
    spacing: line_spacings.spacing
  )

  // Main Chapter Headings - reset figure counters to provide chapter-specific numbering
  show heading.where(level: 1): it => {
    set text(18pt)
    counter(math.equation).update(0)
    counter(figure.where(kind:image)).update(0)
    counter(figure.where(kind:table)).update(0)
    if it.supplement != auto [
      #it.supplement
      #counter(heading).display() |
      #it.body
    ] else [
      #it.body
    ]
    v(0.5em)
  }

  show: set_headings.with(
    ..line_spacings
  )

  // Set figure numbers equal to Chapter number `.` figure number
  set figure(numbering: n => {
      let hdr = counter(heading).get().first()
      let num = query(
              selector(heading).before(here())
      ).last().numbering
      numbering(num, hdr, n)
  })

  show figure.where(kind: table): set figure.caption(position: top)

  // Set equation numbers equal to Chapter number `.` equation number
  set math.equation(numbering: n => {
      let hdr = counter(heading).get().first()
      let num = query(
              selector(heading).before(here())
      )
      if num != () {
        let num = num.last().numbering
        numbering(num, hdr, n)
      }
  })

  body
}
