#import "../fmt-req.typ": TimeSimHei, TimeSimSun, fmt-pass1, show-cn-fakebold, 字号

// 开题报告
#let thesis-initiation-report = (
  大标题: [毕业论文（设计）],
  题目: [],
  学院: [],
  年级: [],
  专业: [],
  学号: [],
  姓名: [],
  指导教师: [],
  封面日期: datetime.today(),
  启动日期: [],
  终止日期: [],
  本课题的目的意义: [],
  基本条件: [],
  主要内容: [],
  预期结果目的: [],
  计划进度: [],
  教师意见: [],
  教师签名: [],
  教研室意见: [],
  教研室主任签名: [],
) => {
  set par(spacing: 0.5em, leading: 0.5em)
  // 放入学校的 title 图片
  align(center)[
    #set par(spacing: 0pt, leading: 0pt)
    #v(0.5em)
    #image("../assets/header.png", height: 1.84cm, width: 9.73cm)
    #v(3.5em)
  ]
  align(center, text(
    size: 字号.一号,
    font: TimeSimHei,
    weight: "bold",
    tracking: 4pt,
  )[#大标题\u{200b}开题报告])

  // 3个小一号的换行
  v(字号.小一 * 4.35)

  show grid: set align(center)
  grid(
    align: top,
    row-gutter: 1em,
    grid(
      align: top,
      rows: (0.85cm * 2, 0.85cm * 1.3),
      columns: (2.39cm, 9.64cm),
      text(size: 字号.小三, font: TimeSimHei, tracking: 1.5em)[题目],
      text(size: 字号.小三, font: TimeSimHei)[#underline(题目, offset: .15em, stroke: .05em, evade: false)],

      [], [],
    ),
    grid(
      align: top,
      rows: (0.85cm, 0.85cm),
      row-gutter: 1em,
      columns: (2.39cm, 9.64cm - 2.39cm - 2.39cm - 0.5cm, 2.39cm, 2.39cm + 0.5cm),
      text(size: 字号.小三, font: TimeSimHei, tracking: 2em)[学院],
      text(size: 字号.小三, font: TimeSimHei)[#underline(学院, offset: .15em, stroke: .05em, evade: false)],
      text(size: 字号.小三, font: TimeSimHei, tracking: 2em)[年级],
      text(size: 字号.小三, font: TimeSimHei)[#underline(年级, offset: .15em, stroke: .05em, evade: false)],

      text(size: 字号.小三, font: TimeSimHei, tracking: 2em)[专业],
      text(size: 字号.小三, font: TimeSimHei)[#underline(专业, offset: .15em, stroke: .05em, evade: false)],
      text(size: 字号.小三, font: TimeSimHei, tracking: 2em)[学号],
      text(size: 字号.小三, font: TimeSimHei)[#underline(学号, offset: .15em, stroke: .05em, evade: false)],
    ),
    grid(
      align: top,
      rows: (0.85cm, 0.85cm),
      row-gutter: 1em,
      columns: (2.39cm, 9.64cm),
      text(size: 字号.小三, font: TimeSimHei, tracking: 2em)[姓名],
      text(size: 字号.小三, font: TimeSimHei)[#underline(姓名, offset: .15em, stroke: .05em, evade: false)],

      text(size: 字号.小三, font: TimeSimHei)[指导教师],
      text(size: 字号.小三, font: TimeSimHei)[#underline(指导教师, offset: .15em, stroke: .05em, evade: false)],
    ),
  )
  grid(
    align: bottom,
    {
      v(7fr)
      set text(font: TimeSimHei, size: 字号.小三)
      封面日期.display("[year]年[month padding:none]月[day padding:none]日")
      v(1fr)
    },
  )

  // 第二页表格
  pagebreak()
  set page(margin: (left: 3cm, right: 1.94cm, top: 2.67cm, bottom: 2.54cm)) // Word默认页边距
  align(center, text(
    size: 字号.小一,
    font: TimeSimHei,
    tracking: 2pt,
  )[#h(0em)#v(-0.35em)#大标题\u{200b}开题报告])
  v(-0.35em)
  table(
    stroke: .5pt,
    align: center + horizon,
    columns: (1.46cm, 6.25fr, 1.08cm, 7.27fr),
    rows: (1.18cm, 1fr, 1fr, 1fr),
    text(font: TimeSimHei, size: 字号.小四)[题目],
    text(font: TimeSimHei, size: 字号.小四)[#题目],
    text(font: TimeSimHei, size: 字号.小四)[时间],
    [],
    // NOTE: Typst v0.14 暂不支持竖排
    text(
      features: ("vert",),
      region: "tw",
      font: TimeSimHei,
      size: 字号.小四,
    )[本课题的目的意义\ （含国内外的研究现状分析）],
    table.cell(colspan: 3, text(size: 字号.小四, font: TimeSimSun)[
      #set align(left + top)
      #set par(first-line-indent: (amount: 2em, all: true))
      #本课题的目的意义
      #set align(right + bottom)
    ]),
    text(
      features: ("vert",),
      region: "tw",
      font: TimeSimHei,
      size: 字号.小四,
    )[设计(论文)的基本条件 \ 及设计(论文)依据],
    table.cell(colspan: 3, text(size: 字号.小四, font: TimeSimSun)[
      #set align(left + top)
      #set par(first-line-indent: (amount: 2em, all: true))
      #基本条件
      #set align(right + bottom)
    ]),
    text(
      features: ("vert",),
      region: "tw",
      font: TimeSimHei,
      size: 字号.小四,
    )[本课题的主要内容\ 重点解决的问题],
    table.cell(colspan: 3, text(size: 字号.小四, font: TimeSimSun)[
      #set align(left + top)
      #set par(first-line-indent: (amount: 2em, all: true))
      #主要内容
      #set align(right + bottom)
    ]),
  )

  // 第三页表格
  pagebreak()
  set page(margin: (left: 3cm, right: 1.94cm, top: 2.55cm, bottom: 2.54cm)) // Word默认页边距
  grid(
    align: center + horizon,
    row-gutter: 0pt,
    rows: 6,
    columns: 1fr,
    column-gutter: 0pt,
    table(
      stroke: .5pt,
      rows: 4.94cm,
      columns: (1.45cm, 1fr),
      text(
        features: ("vert",),
        region: "tw",
        font: TimeSimHei,
        size: 字号.小四,
      )[本课题欲达到的目的\ 或预期研究的结果],
      text(size: 字号.小四, font: TimeSimSun)[
        #set align(left + top)
        #set par(first-line-indent: (amount: 2em, all: true))
        #预期结果目的
        #set align(right + bottom)
      ],
    ),
    table(
      stroke: .5pt,
      rows: 2.02cm,
      columns: 1fr,
      text(
        font: TimeSimHei,
        size: 字号.小四,
        tracking: 18pt,
      )[计划进度],
    ),
    table(
      stroke: .5pt,
      rows: 1.3cm,
      columns: (1fr, 2.4fr, 1fr),
      text(
        font: TimeSimHei,
        size: 字号.小四,
        tracking: 12pt,
      )[时间],
      text(
        font: TimeSimHei,
        size: 字号.小四,
        tracking: 18pt,
      )[工作内容],
      text(
        font: TimeSimHei,
        size: 字号.小四,
        tracking: 12pt,
      )[备注],
    ),
    table(
      stroke: .5pt,
      rows: 6.89cm,
      columns: 1fr,
      text(size: 字号.小四, font: TimeSimSun)[
        #set align(left + top)
        #set par(first-line-indent: (amount: 2em, all: true))
        #计划进度
        #set align(right + bottom)
      ],
    ),
    table(
      stroke: .5pt,
      rows: 4.42cm,
      columns: (1.45cm, 1fr),
      text(
        features: ("vert",),
        region: "tw",
        font: TimeSimHei,
        size: 字号.小四,
      )[指导老师意见],
      text(size: 字号.小四, font: TimeSimSun)[
        #set align(left + top)
        #set par(first-line-indent: (amount: 2em, all: true))
        #教师意见
        #set align(left + bottom)
        #h(11.25em)指导教师签名：#教师签名
        #set align(right + bottom)
        年#h(1.5em)月#h(1.5em)日#h(1em)
      ],
    ),
    table(
      stroke: .5pt,
      rows: 4.42cm,
      columns: (1.45cm, 1fr),
      text(
        features: ("vert",),
        region: "tw",
        font: TimeSimHei,
        size: 字号.小四,
      )[专业教研室意见],
      text(size: 字号.小四, font: TimeSimSun)[
        #set align(left + top)
        #set par(first-line-indent: (amount: 2em, all: true))
        #教研室意见
        #set align(left + bottom)
        #h(11.8em)教研室主任签名：#教研室主任签名
        #set align(right + bottom)
        年#h(1.5em)月#h(1.5em)日#h(1em)
      ],
    ),
  )
}
//table.cell(colspan: 2, text(size: 字号.三号, font: TimeSimSun)[题目：#题目]),
#set page(
  paper: "a4",
  margin: (left: 3.18cm, right: 3.18cm, top: 2.54cm, bottom: 2.54cm), // Word默认页边距
  numbering: none, // 开头页不编号页码
  number-align: center + bottom, // 底端居中
  header-ascent: 15%,
  footer-descent: 15%,
)

#show: show-cn-fakebold

#thesis-initiation-report()
