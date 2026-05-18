#import "../fmt-req.typ": TimeSimSun, fmt-pass1, show-cn-fakebold, 字号

// 任务书
#let task-book-table = (
  大标题: [毕业论文（设计）],
  学号: [],
  姓名: [],
  班级: [],
  指导教师及职称: [],
  题目: [],
  任务和要求: [],
  进度安排: [],
  参考文献: [],
  任务下达人: [],
  教研室主任: [],
  任务接受人: [],
) => {
  set par(spacing: 0.5em, leading: 0.5em)
  align(center, text(
    size: 字号.小二,
    font: TimeSimSun,
    weight: "bold",
  )[广东石油化工学院#大标题\u{200b}任务书])
  grid(
    align: top,
    rows: (1fr, 2.54cm),
    row-gutter: 0.5em,
    table(
      stroke: 0.5pt,
      align: center + horizon,
      columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
      rows: (1cm, 1cm, 1cm, 4.75fr, 3.73fr, 3.55fr, 1cm, 3.55fr, 1cm),
      text(size: 字号.五号, font: TimeSimSun)[学号],
      text(size: 字号.五号, font: TimeSimSun, 学号),
      text(size: 字号.五号, font: TimeSimSun)[姓名],
      text(size: 字号.五号, font: TimeSimSun, 姓名),
      text(size: 字号.五号, font: TimeSimSun)[班级],
      text(size: 字号.五号, font: TimeSimSun, 班级),
      text(size: 字号.五号, font: TimeSimSun)[指导教师及职称],
      table.cell(colspan: 5, text(size: 字号.五号, font: TimeSimSun, 指导教师及职称)),
      text(size: 字号.五号, font: TimeSimSun)[题目],
      table.cell(colspan: 5, text(size: 字号.五号, font: TimeSimSun, 题目)),
      text(size: 字号.五号, font: TimeSimSun)[任务和要求],
      table.cell(colspan: 5, text(size: 字号.五号, font: TimeSimSun)[
        #set align(left + horizon)
        #set par(first-line-indent: (amount: 2em, all: true))

        #任务和要求
      ]),
      text(size: 字号.五号, font: TimeSimSun)[进度安排],
      table.cell(colspan: 5, text(size: 字号.五号, font: TimeSimSun)[
        #set align(left + horizon)
        #set par(first-line-indent: (amount: 2em, all: true))

        #进度安排
      ]),
      text(size: 字号.五号, font: TimeSimSun)[参考文献],
      table.cell(colspan: 5, text(size: 字号.五号, font: TimeSimSun)[
        #set align(left + horizon)
        #set par(first-line-indent: (amount: 2em, all: true))

        #参考文献
      ]),
      text(size: 字号.五号, font: TimeSimSun)[任务下达人（签字）],
      table.cell(colspan: 5, text(size: 字号.五号, font: TimeSimSun)[
        #set align(left + horizon)
        #set par(first-line-indent: (amount: 2em, all: true))

        #任务下达人
      ]),
      text(size: 字号.五号, font: TimeSimSun)[教研室主任（签字）],
      table.cell(colspan: 5, text(size: 字号.五号, font: TimeSimSun)[
        #set align(left + top)
        #set par(first-line-indent: (amount: 2em, all: true))

        #教研室主任
      ]),
      text(size: 字号.五号, font: TimeSimSun)[任务接受人（签字）],
      table.cell(colspan: 5, text(size: 字号.五号, font: TimeSimSun)[
        #set align(left + horizon)
        #set par(first-line-indent: (amount: 2em, all: true))

        #任务接受人
      ]),
    ),
    text(size: 字号.五号, font: TimeSimSun, weight: "bold")[
      #set par(first-line-indent: (amount: 3.5em, all: true))

      注：1.此任务书应由指导教师填写。

      #h(2em)2.此任务书最迟必须在毕业论文（设计、创作）开始前一周下达给学生。

      #h(2em)3.参考文献不少于5篇。
    ],
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

#task-book-table()
