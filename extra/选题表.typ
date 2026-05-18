#import "../fmt-req.typ": TimeSimSun, fmt-pass1, show-cn-fakebold, 字号

// 选题表
#let topic-selection-table = (
  届数: [],
  大标题: [毕业论文（设计）],
  题目名称: [],
  指导教师: [],
  题目类型: [],
  项目意义: [],
  主要内容及要求: [],
  指导老师意见: [],
  教研室意见: [],
) => {
  set par(spacing: 0.5em, leading: 0.5em)
  align(center, text(
    size: 字号.三号,
    font: TimeSimSun,
    weight: "bold",
  )[广东石油化工学院#届数\u{200b}届#大标题\u{200b}选题表])
  table(
    stroke: 0.5pt,
    align: center + horizon,
    columns: (1.59cm, 20.30309em - 1.59cm, 1fr, 1fr),
    rows: (0.99cm, 0.99cm, 4.45fr, 5.49fr, 7.12fr),
    text(size: 字号.小四, font: TimeSimSun)[题目\ 名称],
    table.cell(colspan: 3, text(size: 字号.小四, font: TimeSimSun, 题目名称)),
    text(size: 字号.小四, font: TimeSimSun)[指导\ 教师],
    align(center, text(size: 字号.小四, font: TimeSimSun, 指导教师)),
    align(center, text(size: 字号.小四, font: TimeSimSun)[题目类型]),
    [],
    text(size: 字号.小四, font: TimeSimSun)[项\ 目\ 意\ 义],
    table.cell(colspan: 3, text(size: 字号.小四, font: TimeSimSun)[
      #set align(left + horizon)
      #set par(first-line-indent: (amount: 2em, all: true))

      #项目意义
    ]),
    text(size: 字号.小四, font: TimeSimSun)[主\ 要\ 内\ 容\ 及\ 要\ 求],
    table.cell(colspan: 3, text(size: 字号.小四, font: TimeSimSun)[
      #set align(left + horizon)
      #set par(first-line-indent: (amount: 2em, all: true))

      #主要内容及要求
    ]),
    table.cell(colspan: 2, text(size: 字号.小四, font: TimeSimSun)[
      #set align(left + top)
      指导老师意见:（教师申报课题不需填写）
      #set par(first-line-indent: (amount: 2em, all: true))
      #指导老师意见
      #set align(right + bottom)
      指导教师签字：#h(5.5em)
      #v(0.3em)
      年#h(1.5em)月#h(1.5em)日
    ]),
    table.cell(colspan: 2, text(size: 字号.小四, font: TimeSimSun)[
      #set align(left + top)
      教研室意见：
      #set par(first-line-indent: (amount: 2em, all: true))
      #教研室意见
      #set align(right + bottom)
      负责人签字：#h(5.5em)
      #v(0.3em)
      年#h(1.5em)月#h(1.5em)日
    ]),
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

#topic-selection-table()
