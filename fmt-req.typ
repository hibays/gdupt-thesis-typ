#import "@preview/modern-nju-thesis:0.4.1": bilingual-bibliography
#import "@preview/modern-sjtu-thesis:0.6.1": (
  algox, appendix, equate, i-figured, imagex, proof, pseudocode-list, show-theorion, subimagex, table-note, tablex,
  theorem,
)
#import "@preview/numbly:0.1.0": numbly
#import "@preview/cuti:0.4.0": show-fakebold, show-fakeitalic
#import "@preview/wordometer:0.1.5": utils as wordometer_utils

// 定义应用Times New Roman的SimSun字体
#let TimeSimSun = ("Times New Roman", "SimSun")
#let TimeSimHei = ("Times New Roman", "SimHei")

#let 字号 = (
  初号: 42pt,
  小初: 36pt,
  一号: 26pt,
  小一: 24pt,
  二号: 22pt,
  小二: 18pt,
  三号: 16pt,
  小三: 15pt,
  四号: 14pt,
  小四: 12pt,
  五号: 10.5pt,
  小五: 9pt,
  六号: 7.5pt,
  小六: 6.5pt,
  七号: 5.5pt,
  八号: 5pt,
)

#let my-show-table(it) = {
  // 从 sjtu 模板中复制的设置
  // 用于对 tablex 生效
  // 经过修改，对 subimagex 等等也生效
  show figure: set align(center)
  show table: set align(center)
  show figure.caption: set par(leading: 10pt, justify: false)

  set list(indent: 1em, body-indent: 0.65em)
  // 设置有序列表编号：a.1.i)
  // 文件只规定了 a.1) 这种编号，i 是自拟的
  set enum(numbering: "a.1.i)")
  set enum(indent: 0.83em, body-indent: 0.45em)

  show figure: i-figured.show-figure.with(extra-prefixes: (image: "img:", algorithm: "algo:"), numbering: "1.1")
  // 公式编号：只有公式的编号是用短横线(-)连接的
  set math.equation(numbering: (..nums) => numbering(
    "(1-1a)",
    counter(heading).get().first(),
    ..nums,
  ))
  show: equate.with(breakable: true, sub-numbering: false)

  show figure.where(kind: "subimage"): it => {
    if it.kind == "subimage" {
      let q = query(figure.where(outlined: true).before(it.location())).last()
      [
        #figure(
          it.body,
          caption: it.counter.display("(a)") + " " + it.caption.body,
          kind: it.kind + "_",
          supplement: it.supplement,
          outlined: it.outlined,
          numbering: "(a)",
          gap: 1em,
        )#label(str(q.label) + ":" + str(it.label))
      ]
    }
  }

  show figure.where(kind: "subimage-en"): it => {
    if it.kind == "subimage-en" {
      let q = query(figure.where(outlined: true).before(it.location())).last()
      [
        #figure(
          it.body,
          caption: if it.caption != none { it.counter.display("(a)") + " " + it.caption.body } else { none },
          kind: it.kind + "_",
          supplement: it.supplement,
          outlined: it.outlined,
          numbering: "(a)",
          gap: 1em,
        )
      ]
      v(0.5em)
    }
  }

  set figure.caption(separator: [#h(1em)])
  show figure.caption: it => {
    set text(size: 12pt, weight: "bold")
    it
  }
  show figure.where(kind: "table"): set figure.caption(position: bottom)
  show figure.where(kind: "table-en"): set figure.caption(position: bottom)
  show figure.where(kind: "algorithm"): set figure.caption(position: bottom)
  show figure: set block(breakable: true)
  // show figure.where(kind: "image"): set block(sticky: true)
  // show figure.where(kind: "image-en"): set block(sticky: true)

  show table: set text(size: 12pt, weight: "regular")
  show table: set par(leading: 14pt)
  show table: it => state("xubiao").update(false) + it

  it
}

#let fmt-pass1(it) = {
  // pass1 之后是封面和保证书
  // 导入 sjtu 模板的设置
  show: my-show-table

  // 设置页面格式
  // 页边距：下面这个是封面页的页边距，不是正文的页边距（正文的页边距由 pass2 设置）
  set page(
    paper: "a4",
    margin: (left: 3.18cm, right: 3.18cm, top: 2.54cm, bottom: 2.54cm),
    numbering: none, // 开头页不编号页码
    number-align: center + bottom, // 底端居中
  )

  // 显示中文字体的伪粗体和伪斜体
  show: show-fakebold
  show: show-fakeitalic

  // 设置正文样式
  set text(font: TimeSimSun, size: 字号.小四, lang: "zh") // 小四号=12pt
  set text(top-edge: "cap-height", bottom-edge: "baseline")
  set par(first-line-indent: (amount: 2em, all: true)) // 段落首行缩进
  // 行距：全文固定值20磅，按照Word的行距设置相当于Typst的两倍，所以是10pt
  // 文档：https://typst.app/docs/reference/model/par/#leading
  set par(leading: 10pt)
  set par(spacing: 20pt) // 段距：没说，默认20磅
  set par(justify: true) // 设置段落两端对齐

  // 设置标题自动编号格式（for cover part）
  set heading(
    numbering: none,
    supplement: [leading],
  )

  show heading.where(level: 1): it => {
    // 正文第一级标题（章节）
    // 三号粗黑体居中必须换页
    set align(center)
    set text(font: TimeSimHei, size: 字号.三号, weight: "bold")
    pagebreak(weak: true)
    it
    v(1em)
  }

  show heading.where(level: 2): it => {
    // 正文第二级标题
    // 小三黑体，靠左上下空一行
    set text(font: TimeSimHei, size: 字号.小三, weight: "regular")

    // 在当前页检查上一个元素是否是一级标题，如果是则不添加垂直间距
    let elems = query(selector(heading).before(here())).filter(it => (
      it.location().page() == here().page()
    ))
    // 如果有(1, oo)个heading，说明当前页可能有章节标题，query第一个heading是当前页的章节标题，最后一个是it自己，所以返回倒数第二个项目
    let elem = none
    if elems.len() > 1 {
      elem = elems.at(-2)
    }
    // 如果上一个元素是一级标题，不添加垂直间距
    if elem != none and elem.func() == heading and elem.level == 1 {} else {
      v(1em)
    }
    it
    v(1em)
  }

  show heading.where(level: 3): it => {
    // 正文第三级标题
    // 四号黑体，靠左本身不空行
    set text(font: TimeSimHei, size: 字号.四号, weight: "regular")
    // TRICK: 如果不缩一下换段会导致空隔
    v(-字号.四号 * 1.65 + 字号.小三)
    it
  }

  show heading.where(level: 4): it => {
    // 正文第四级标题
    // 文件没有规定，手动设置一个：小四号黑体，靠左本身不空行
    set text(font: TimeSimHei, size: 字号.小四, weight: "regular")
    it
  }

  show heading.where(level: 5): it => {
    // 正文第五级标题
    // 文件没有规定，直接报错，不支持第五级标题
    panic("标题级数大于4的不受支持")
  }

  show: show-theorion

  it
}

#let fmt-pass2(it) = {
  // pass2 之后是 paper-up，包括摘要和目录
  // 设置页面格式
  // 页边距：严格统一为上2.8cm，下2.2cm，左2.8cm，右2.2cm
  set page(
    paper: "a4",
    margin: (left: 2.8cm, right: 2.2cm, top: 2.8cm, bottom: 2.2cm),
    numbering: "I", // 使用罗马数字编号
  )
  it
}

#let fmt-pass3(it) = {
  // pass3 之后是正文
  // 设置页眉和header样式
  // 页眉字体中文用小五号宋体，英文用Times New Roman，上加0.5磅双线。
  let sign_up_case(it) = {
    align(center)[
      #set text(font: TimeSimSun, size: 字号.小五)
      #it
      #v(-1.8em) // 缩一下位置
      #line(length: 100%, stroke: 1.5pt) // 画线
      #v(1em) // 空一行
    ]
  }
  set page(
    numbering: "1",
    header: context if calc.odd(counter(page).get().first()) {
      // 奇数页
      // 获取当前标题内容
      let headingTitle = ""
      let headingNumber = ""

      // 对章节第一页做特殊处理，因为制作章节第一页的页眉时，当前章节标题还没出现
      // 所以 query 中使用 after(here())
      // 同时要 filter 出当前页的，不能把后面章节标题弄进来了
      let elems = query(selector(heading.where(level: 1)).after(here())).filter(it => (
        it.location().page() == here().page()
      ))

      let elem-num-handler(it, num) = {
        if it.func() == heading and it.supplement == [附录] {
          [附录#str.from-unicode("A".to-unicode() + num)]
        } else if it.func() == heading and it.supplement == [正文] {
          [第 #(num + 1) 章]
        } else {
          []
        }
      }

      if elems.len() != 0 {
        // 如果 filter 出来的结果非空，意味着我们就在章节首页
        // 在制作页眉时当前章节标题还没出现，因此章节编号要加上 1
        headingTitle = elems.last().body
        headingNumber = elem-num-handler(elems.last(), counter(heading).get().first())
      } else {
        // 如果 filter 出来的结果为空，意味着我们就在章节中间
        // 重新使用 before(here()) 进行 query 来查询章节标题
        elems = query(selector(heading.where(level: 1)).before(here()))
        headingTitle = elems.last().body
        headingNumber = elem-num-handler(elems.last(), counter(heading).get().first() - 1)
      }

      sign_up_case(if headingTitle == none { [#headingNumber] } else { [#headingNumber #headingTitle] })
    } else {
      let chinese-title = state("chinese-title").get()
      // 偶数页
      sign_up_case([广东石油化工学院毕业论文(设计)：#chinese-title])
    },
  )

  // 设置正文标题的 supplement 和 numbering
  set heading(
    numbering: numbly(
      "第{1}章",
      "{1}.{2}",
      "{1}.{2}.{3}",
      "{1}.{2}.{3}.{4}",
    ),
    supplement: [正文],
  )
  // 重置章节编号（after cover part）
  counter(heading).update(0)

  it
}

#let datetime-display(date) = {
  date.display("[year]年[month padding:none]月[day padding:none]日")
}

#let paper-cover(
  中文题目,
  英文题目,
  学号,
  学院,
  专业,
  班级,
  学生,
  指导教师,
  职称,
  启动时间,
  结束时间,
  双面打印: true,
  显示下划线: false,
  仅显示下划线: false,
) = {
  set align(left)
  text(size: 字号.五号)[\u{20}] * 49 * 2
  text(size: 字号.四号)[
    #if 仅显示下划线 {
      [学号：*#underline([\u{20}] * 12 * 2)*]
    } else {
      [学号：*#underline(学号)*]
    }
  ]
  v(字号.五号)

  // 放入学校的 title
  align(center)[
    #set par(spacing: 0pt, leading: 0pt)
    #image("assets/header.png", height: 1.83cm, width: 9.72cm)

    // 28磅的换行
    #set text(size: 28pt)
    #linebreak()
  ]

  align(center)[
    #set text(size: 40pt, weight: "bold", font: TimeSimHei, tracking: 10pt) // 40磅黑体加黑居中
    毕业论文（设计）

    // 6行五号+1行二号+1行小二号
    #set text(size: 字号.五号)
    #linebreak()
    #linebreak()
    #linebreak()
    #linebreak()
    #linebreak()
    #linebreak()

    #set text(size: 字号.二号)
    #linebreak()

    #set text(size: 字号.小二)
    #linebreak()
  ]

  // 设置中文题目状态，用于页眉
  state("chinese-title").update(中文题目)
  if type(学生) != str {
    学生 = wordometer_utils.extract-text(学生)
  }
  set document(
    title: 中文题目,
    author: 学生,
  )

  let underline-warpper = (it, extent: 0pt) => {
    if 显示下划线 {
      [
        // See: https://typst.dev/guide/FAQ/underline-misplace.html
        #set underline(offset: .15em, stroke: .05em, evade: false, extent: extent)
        #underline(it)
      ]
    } else {
      it
    }
  }

  align(center)[
    #set text(size: 字号.小二, weight: "bold", font: TimeSimHei, tracking: 2pt) // 小二号黑体加黑居中
    #underline-warpper(中文题目)
    #v(字号.五号)
    #underline-warpper(英文题目)
  ]

  let ZT = none
  if 职称 != none {
    ZT = [#指导教师（#职称）]
  } else {
    ZT = 指导教师
  }

  // 放入个人信息
  align(left + bottom)[
    #set text(size: 字号.小三, weight: "bold", font: TimeSimSun) // 小三号宋体加黑

    #if 仅显示下划线 {
      [
        学院 #underline([\u{20}] * 11 * 2)
        专业 #underline([\u{20}] * 11 * 2)
        班级 #underline([\u{20}] * 11 * 2)

        学生 #underline([\u{20}] * 11 * 2)
        指导教师（职称）#underline([\u{20}] * 15 * 2)

        起止时间 #underline([\u{20}] * 6 * 2)年#underline([\u{20}] * 3 * 2)月#underline([\u{20}] * 3 * 2)日至 #underline([\u{20}] * 6 * 2)年#underline([\u{20}] * 3 * 2)月#underline([\u{20}] * 3 * 2)日
      ]
    } else {
      let distr(width: auto, body) = {
        block(
          width: width,
          align(center, body),
        )
      }
      let cjk_len = it => {
        wordometer_utils.extract-text(it).matches(regex("[\p{Han}]|[\p{Latin}'’.,\-]+")).len()
      }
      [
        #grid(
          align: center + bottom,
          [#h(2em)学院],
          distr(width: 7em, underline-warpper(学院, extent: (7em - 1em * cjk_len(学院)) / 2)),
          [专业],
          distr(width: 8em, underline-warpper(专业, extent: (8em - 1em * cjk_len(专业)) / 2)),
          [班级],
          distr(width: 2.5em, underline-warpper(班级, extent: (2em - 1em * cjk_len(班级)) / 2)),

          columns: (4.3em, 7em, 2.3em, 1fr, 2.3em, 2.5em),
        )
        #grid(
          align: center + bottom,
          [#h(2em)学生],
          distr(width: 7em, underline-warpper(学生, extent: (7em - 1em * cjk_len(学生)) / 2)),
          [指导教师（职称）],
          distr(width: 9em, underline-warpper(ZT, extent: (9em - 1em * (cjk_len(指导教师) + cjk_len(职称) + 2)) / 2)),

          columns: (4.3em, 7em, 8em, 1fr),
        )

        #grid(
          align: center + bottom,
          [#h(2em)起止时间],
          underline-warpper(
            str(启动时间.year()),
            extent: ((2.7em - 1em * str(启动时间.year()).len() * 0.3) / 2),
          ),
          [年],
          underline-warpper(
            str(启动时间.month()),
            extent: ((1.5em - 1em * str(启动时间.month()).len() * 0.3) / 2),
          ),
          [月],
          underline-warpper(
            str(启动时间.day()),
            extent: ((1.5em - 1em * str(启动时间.day()).len() * 0.3) / 2),
          ),
          [日至],
          underline-warpper(
            str(结束时间.year()),
            extent: ((2.7em - 1em * str(结束时间.year()).len() * 0.3) / 2),
          ),
          [年],
          underline-warpper(
            str(结束时间.month()),
            extent: ((1.5em - 1em * str(结束时间.month()).len() * 0.3) / 2),
          ),
          [月],
          underline-warpper(
            str(结束时间.day()),
            extent: ((1.5em - 1em * str(结束时间.day()).len() * 0.3) / 2),
          ),
          [日],

          columns: (6.3em, 3.6em, 1em, 1.8em, 1em, 1.8em, 2em, 3.6em, 1em, 1.8em, 1em, 1.8em, 1em),
        )
      ]
    }

    // fit
    #set text(size: 字号.五号)
    \
    \
  ]

  if 双面打印 {
    pagebreak(weak: false)
    pagebreak(weak: false)
  }

  // 诚信承诺保证书
  pagebreak(weak: true)
  align(center)[
    #set text(size: 字号.三号, weight: "bold", font: TimeSimHei) // 三号黑体加粗
    *广东石油化工学院本科毕业论文（设计）诚信承诺保证书*
  ]

  linebreak()

  [
    #h(2em)
    #set text(size: 字号.三号, lang: "zh", font: TimeSimSun) // 三号宋体
    本人郑重承诺：《#中文题目》毕业论文（设计）的内容真实、可靠，是本人在 #指导教师 的指导下，独立进行研究所完成。毕业论文（设计）中引用他人已经发表或未发表的成果、数据、观点等，均已明确注明出处，如果存在弄虚作假、抄袭、剽窃的情况，本人愿承担全部责任。
    #v(4em)
    #align(right)[学生签名：#h(5em)]
    #align(right)[年#h(1.5em)月#h(1.5em)日#h(2.5em)]
  ]

  if 双面打印 {
    pagebreak(weak: false)
    pagebreak(weak: false)
  }
  pagebreak(weak: true)
}

// 卷头信息样式函数
#let paper-up(中文摘要, 英文摘要, 中文关键词: (), 英文关键词: (), 尾随空页: true) = {
  counter(page).update(1)

  [
    #heading(level: 1)[摘要]

    #中文摘要 \
    \
    #text(font: TimeSimHei)[*关键词*]：#中文关键词.join("；")
  ]

  pagebreak(weak: true)
  [
    #heading(level: 1)[Abstract]

    #英文摘要 \
    \
    #text(font: TimeSimHei)[*Keywords*]：#英文关键词.join(", ")
  ]

  // 设置目录样式
  pagebreak(weak: true)

  show outline.entry.where(level: 1): it => {
    set text(
      font: TimeSimHei,
      //weight: "semibold",
    )
    it
  }
  show outline.entry.where(level: 1): set block(above: 1.25em, below: 1em)
  show outline.entry.where(level: 2): set block(above: 1em)
  show outline.entry.where(level: 3): set block(above: 1em)

  outline(
    title: [目#h(1em)录],
    indent: 1em,
    depth: 3,
  )

  pagebreak(weak: true)
  if 尾随空页 {
    page([], numbering: none)
  }
  counter(page).update(1)
}

// 参考文献样式
// 标题用三号黑体，居中上下空一行
// 参考文献正文为五号宋体
#let bibliography-page(
  双面打印: false,
  bibfunc: none,
  full: false,
) = {
  // 换页到奇数页（双面打印时）
  pagebreak(
    weak: true,
    to: if 双面打印 {
      "odd"
    },
  )

  show bibliography: set text(font: TimeSimSun, size: 字号.五号) // 五号宋体
  show bibliography: set par(leading: 1em)
  show bibliography: set par(spacing: 1.5em)

  bilingual-bibliography(
    bibliography: bibfunc,
    title: [参考文献], // 三号黑体 = heading.level == 1
    full: full,
  )

  pagebreak(
    weak: true,
    to: if 双面打印 {
      "odd"
    },
  )
}

// 附录样式
#let appendix-first-heading(
  doctype: "master",
  双面打印: false,
  body,
) = {
  set heading(
    numbering: numbly(
      "附录{1:A}",
      "{1:A}.{2}",
      "{1:A}.{2}.{3}",
      "{1:A}.{2}.{3}.{4}",
    ),
    supplement: [附录],
  )
  counter(heading).update(0)
  body
}

#let other-heading(
  enable-avoid-orphan-headings: false,
  auto-section-pagebreak-space: 15%,
  appendix: false,
  body,
) = {
  show heading.where(level: 2): set heading(outlined: if appendix { false } else { true })
  show heading.where(level: 3): set heading(outlined: if appendix { false } else { true })
  show heading.where(level: 4): set heading(outlined: if appendix { false } else { true })

  show heading.where(level: 2): it => {
    set text(
      // 数字用 Times Roman，中文用黑体，均为四号字，加粗
      font: TimeSimHei,
      weight: "bold",
      size: 字号.四号,
    )
    set par(
      // 无缩进，行距18磅
      first-line-indent: 0em,
      leading: 18pt,
    )

    if enable-avoid-orphan-headings {
      let threshold = auto-section-pagebreak-space
      block(breakable: false, height: threshold)
      v(-threshold, weak: true)
    }

    //前后间距分别为24磅和6磅
    v(12pt)
    counter(heading).display() + h(1em) + it.body
    v(6pt)
  }

  // 设置三级标题
  show heading.where(level: 3): it => {
    set text(
      // 数字用 Times Roman，中文用黑体，均为小四号字，加粗
      font: TimeSimHei,
      weight: "bold",
      size: 字号.小四,
    )
    set par(
      // 无缩进，行距16磅
      first-line-indent: 0em,
      leading: 16pt,
    )

    if enable-avoid-orphan-headings {
      let threshold = auto-section-pagebreak-space
      block(breakable: false, height: threshold)
      v(-threshold, weak: true)
    }

    //前后间距分别为12磅和6磅
    v(9pt)
    counter(heading).display() + h(1em) + it.body
    v(6pt)
  }

  // 设置四级标题
  show heading.where(level: 4): it => {
    set text(
      // 小四号字，不加粗，字体与正文一致
      weight: "regular",
      size: 字号.小四,
    )
    set par(
      // 无缩进，行距16磅
      first-line-indent: 0em,
      leading: 16pt,
    )

    if enable-avoid-orphan-headings {
      let threshold = auto-section-pagebreak-space
      block(breakable: false, height: threshold)
      v(-threshold, weak: true)
    }

    //前后间距分别为6磅和6磅
    v(6pt)
    counter(heading).display() + h(1em) + it.body
    v(6pt)
  }

  body
}
#let appendix(
  doctype: "master",
  双面打印: false,
  body,
) = {
  show: appendix-first-heading.with(doctype: doctype, 双面打印: 双面打印)
  show: other-heading.with(appendix: true)

  show heading: i-figured.reset-counters.with(extra-kinds: ("image", "image-en", "table", "table-en", "algorithm"))
  show figure: i-figured.show-figure.with(extra-prefixes: (image: "img:", algorithm: "algo:"), numbering: "A.1")
  set figure(outlined: false)

  // show math.equation: i-figured.show-equation.with(
  //   numbering: if doctype == "bachelor" { numbly("(A{1})", "(A{1}-{2})") } else { "(A.1)" },
  // )

  set math.equation(numbering: (..nums) => numbering(
    "(A.1a)",
    counter(heading).get().first(),
    ..nums,
  ))
  show: equate.with(breakable: true, sub-numbering: false)
  let equation-label(
    heading,
    equation,
  ) = [(#numbering("A", heading)#h(0em)#if doctype == "bachelor" [-] else [.]#equation)]
  let mainmatter-equation-label(
    heading,
    equation,
  ) = [(#numbering("1", heading)#h(0em)#if doctype == "bachelor" [-] else [.]#equation)]
  show ref: it => {
    if it.element == none {
      return it
    }
    let f = it.element.func()
    let h1 = counter(heading.where(level: 1, supplement: [附录]).before(it.target)).get().first()
    let main-h1 = counter(heading.where(level: 1).before(it.target)).get().first()
    let h1-last = query(heading.where().before(it.target)).last()
    if f == math.equation {
      let equation-location = query(it.target).first().location()
      let heading-index = counter(heading).at(equation-location).at(0)
      let equation-index = counter(math.equation).at(equation-location).at(0)
      link(
        it.target,
        it.element.supplement
          + [ ]
          + if h1-last.supplement == [附录] {
            equation-label(heading-index, equation-index)
          } else {
            mainmatter-equation-label(heading-index, equation-index)
          },
      )
    } else if it.element.supplement == [公式] {
      let equation-location = query(it.target).first().location()
      let heading-index = counter(heading).at(equation-location).at(0)
      let equation-index = counter(math.equation).at(equation-location).at(0) - 1
      let eq = query(it.target).first().body.value
      link(
        it.target,
        it.element.supplement
          + [ ]
          + if h1-last.supplement == [附录] {
            equation-label(heading-index, equation-index)
          } else {
            mainmatter-equation-label(heading-index, equation-index)
          },
      )
    } else {
      it
    }
  }

  show figure.where(kind: "subimage"): it => {
    if it.kind == "subimage" {
      let q = query(figure.where(outlined: true).before(it.location())).last()
      [
        #figure(
          it.body,
          caption: it.counter.display("(a)") + " " + it.caption.body,
          kind: it.kind + "_",
          supplement: it.supplement,
          outlined: it.outlined,
          numbering: "(a)",
          gap: 1em,
        )#label(str(q.label) + ":" + str(it.label))
      ]
    }
  }

  show figure.where(kind: "subimage-en"): it => {
    if it.kind == "subimage-en" {
      let q = query(figure.where(outlined: true).before(it.location())).last()
      [
        #figure(
          it.body,
          caption: if it.caption != none { it.counter.display("(a)") + " " + it.caption.body } else { none },
          kind: it.kind + "_",
          supplement: it.supplement,
          outlined: it.outlined,
          numbering: "(a)",
          gap: 1em,
        )
      ]
    }
  }

  body
}

// 致谢样式
#let no-numbering-first-heading(
  body,
) = {
  show heading: set par(justify: false)
  set heading(numbering: none, supplement: auto, bookmarked: true)
  show heading.where(level: 1): it => {
    // 正文第一级标题（章节）
    // 三号粗黑体居中必须换页
    set align(center)
    set text(font: TimeSimHei, size: 字号.三号, weight: "bold")
    pagebreak(weak: true)
    it.body
    v(1em)
  }
  body
}
#let acknowledgement-page(
  doctype: "master",
  twoside: false,
  anonymous: false,
  body,
) = {
  pagebreak(
    weak: true,
    to: if twoside {
      "odd"
    },
  )

  if anonymous {
    return
  }

  show: no-numbering-first-heading.with()

  heading(level: 1)[致#h(1em)谢]

  body

  pagebreak(
    weak: true,
    to: if twoside {
      "odd"
    },
  )
}
