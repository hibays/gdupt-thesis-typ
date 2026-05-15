#import "@preview/modern-nju-thesis:0.4.1": bilingual-bibliography
#import "@preview/modern-sjtu-thesis:0.6.1": (
  algox, appendix, equate, i-figured, imagex, proof, pseudocode-list, show-theorion, subimagex, table-note, tablex,
  theorem,
)
#import "@preview/numbly:0.1.0": numbly
#import "@preview/cuti:0.4.0": show-cn-fakebold, show-cn-fakeitalic, show-fakebold, show-fakeitalic
#import "@preview/wordometer:0.1.5": utils as wordometer_utils

// 定义应用Times New Roman的SimSun字体
#let TimeSimSun = ("Times New Roman", "SimSun")
#let TimeSimHei = ("Times New Roman", "SimHei")
#let TimeFanSun = ("Times New Roman", "FangSong") // 仿宋_GB2312
// 定义代码字体（等宽是等宽字体，CJK 是中文字体）
#let CodeFont = (等宽: "DejaVu Sans Mono", CJK: "Noto Sans CJK SC")

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

// 启用盲审模式
#let mask-pass(it, enable: false, fill_with: "\u{2593}") = {
  state("mask-options").update((enabled: enable, fill_with: fill_with))
  it
}

// 启用双面打印模式，根据*官方的文档要求*，自动加入占位页（有页眉页脚）占位，从而使内容页于右侧纸开始 \
// 参数：
// - `enable`：是否启用双面打印模式，在论文封面、学术诚信声明、目录、致谢和附录部分后加入占位页占位，使内容页于右侧纸开始。
// - `extend`：在 `enable` 的基础上，在章节标题后加入占位页占位，使章节标题于右侧纸开始。
// - `count-blank`：是否将占位页加入页码计数。设置为 `false` 的话会在占位页位置把页码减一，可能导致跳页，此时建议把 `keep-footer` 设为 `false` 。
// - `keep-header`：是否显示占位页的页眉。设置为 `false` 的话会把占位页的页眉设为空。
// - `keep-footer`：是否显示占位页的页脚。设置为 `false` 的话会把占位页的页脚设为空。
#let twoside-pass(it, enable: false, extend: false, count-blank: true, keep-header: true, keep-footer: true) = {
  // 论文封面（底）、学术诚信声明、目录、致谢和附录部分应与正文部分分开，另起页书写；
  // 中英文摘要及关键词、目录、正文、参考文献、附录实行双面打印。
  state("twoside-options").update((
    enabled: enable,
    extend: extend,
    count-blank: count-blank,
    keep-header: keep-header,
    keep-footer: keep-footer,
  ))
  it
}

// 双面打印节断页：根据*官方的文档要求*，在节之间自动加入占位页（有页眉页脚）占位，使内容页于右侧纸开始
#let twoside-section-pagebreak() = context {
  let opts = state("twoside-options").get()
  if not opts.enabled {
    pagebreak(weak: true)
    return
  }

  // 进入下一奇数页（从偶数页直接进入，从奇数页跳过一空白偶数页）
  pagebreak(weak: true, to: "odd")
}

// 符号说明/缩略词表页面
#let notation-page(title: [符号说明], body) = {
  heading(level: 1, numbering: none, outlined: false)[#title]
  body
}

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

  // 如果希望单数字则自己改 i-figured 的源码
  show heading: i-figured.reset-counters.with(extra-kinds: (
    "image",
    "image-en",
    "table",
    "table-en",
    "algorithm",
    "algorithm-en",
  ))
  show figure: i-figured.show-figure.with(extra-prefixes: (image: "img:", algorithm: "algo:"), numbering: "1.1")
  // 公式编号：公式的编号也用点连接
  set math.equation(numbering: (..nums) => numbering(
    "(1.1a)",
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
  // 图题及图中文字用5号宋体
  show figure.caption: it => {
    set text(size: 字号.五号, weight: "bold")
    it
  }
  show figure.where(kind: "table"): set figure.caption(position: top)
  show figure.where(kind: "table-en"): set figure.caption(position: top)
  show figure.where(kind: "algorithm"): set figure.caption(position: bottom)
  show figure: set block(breakable: true)
  show figure.where(kind: "image"): set block(sticky: true)
  show figure.where(kind: "image-en"): set block(sticky: true)

  // 设置表格字体和排版样式
  // 图题及图中文字用5号宋体 -> 表格同
  show table: set text(size: 字号.五号, weight: "regular")
  show table: set par(leading: 字号.小四)
  show table: set par(spacing: 字号.小二) // note: 修复设置段距过小会导致表注错位
  show table: it => state("xubiao").update(false) + it

  it
}

#let fmt-pass1(it) = {
  // pass1 之后是封面和保证书
  // 导入 sjtu 模板的设置
  show: my-show-table

  // 设置页面格式
  // 页边距：下面这个是封面页和承诺书的页边距，不是正文的页边距（正文的页边距由 pass2 设置）
  set page(
    paper: "a4",
    margin: (left: 3.18cm, right: 3.18cm, top: 2.54cm, bottom: 2.54cm), // 封面页和承诺书的页边距
    numbering: none, // 开头页不编号页码
    number-align: center + bottom, // 底端居中
    header-ascent: 15%,
    footer-descent: 15%,
  )

  // 显示中文字体的伪粗体和伪斜体
  show: show-cn-fakebold
  show: show-fakeitalic

  // 设置代码字体
  show raw: set text(
    font: (
      (name: CodeFont.等宽, covers: "latin-in-cjk"),
      CodeFont.CJK,
    ),
    size: 字号.五号,
  )
  // 设置正文字体（宋体小四号/12pt）
  set text(
    font: TimeSimSun,
    size: 字号.小四,
    lang: "zh",
    region: "cn",
  )
  // set text(top-edge: "cap-height", bottom-edge: "baseline") // 西文习惯（默认）
  //set text(top-edge: "ascender", bottom-edge: "descender") // 接近中文习惯
  // 设置正文样式
  set par(first-line-indent: (amount: 2em, all: true)) // 段落首行缩进
  // 行距：全文固定值20磅=段间距
  // Word的行距在Typst相当于 leading - text.size = 20pt-1em
  // 但经过严格对齐（用尺子量）得出上面计算出这个行距是有差别的，正确的应该是20pt-0.81em
  // 文档：https://typst.app/docs/reference/model/par/#leading 和 中文FAQ
  set par(leading: 20pt - 0.81em) // 行距
  set par(spacing: 20pt - 0.81em) // 段距
  set par(justify: true) // 设置段落两端对齐

  // 设置标题自动编号格式（for cover part）
  set heading(
    numbering: none,
    supplement: [leading],
  )

  show heading.where(level: 1): it => {
    // 正文第一级标题（章节）
    // 正文第一级标题用三号粗黑体，章序号采用阿拉伯数字，居中上下空一行
    context {
      let _opts = state("twoside-options").get()
      if _opts.enabled and _opts.extend {
        twoside-section-pagebreak()
      } else {
        pagebreak(weak: true)
      }
    }
    set align(center)
    set block(above: 2em, below: 2em)
    set text(font: TimeSimHei, size: 字号.三号, weight: "bold")
    v(1.3em)
    it
  }

  show heading.where(level: 2): it => {
    // 正文第二级标题
    // 小三黑体，靠左上下空一行
    set block(above: 2em, below: 2em)
    set text(font: TimeSimHei, size: 字号.小三, weight: "regular")
    it
  }

  show heading.where(level: 3): it => {
    // 正文第三级标题
    // 四号黑体，靠左本身不空行
    set block(above: 0.9em, below: 0.9em)
    set text(font: TimeSimHei, size: 字号.四号, weight: "regular")
    it
  }

  show heading.where(level: 4): it => {
    // 正文第四级标题
    // 文件没有规定，手动设置一个：小四号黑体，靠左本身不空行
    set block(above: 0.9em, below: 0.9em)
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
    // 使用罗马数字编号页码
    numbering: "I",
    footer: context {
      // 设置页脚（页码）字体大小
      set align(center)
      set text(size: 字号.五号)
      counter(page).display()
    },
  )
  it
}

#let fmt-pass3(it) = {
  // pass3-4 之后是正文
  // pass3仅设置页眉样式
  // 页眉字体中文用小五号宋体，英文用Times New Roman，上加0.5磅双线。
  // 奇数页：章名，偶数页：广东石油化工学院毕业论文（设计）：题目名。居中；
  let sign_up_case(it) = {
    align(center)[
      #set text(font: TimeSimSun, size: 字号.小五)
      #set par(spacing: 3pt)  // 设置距离
      #it
      #v(1pt)
      #line(length: 100%, stroke: 0.5pt) // 画线
      #line(length: 100%, stroke: 0.5pt, start: (0pt, -2pt)) // 画线
      #v(1em) // 空一行
    ]
  }
  set page(
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
        if elems.len() != 0 {
          headingTitle = elems.last().body
          headingNumber = elem-num-handler(elems.last(), counter(heading).get().first() - 1)
        }
      }

      let show_case = if headingTitle == none { [#headingNumber] } else { [#headingNumber #headingTitle] }

      let ex_show_case = wordometer_utils.extract-text(show_case)
      // 去掉中间的水平间距
      // 因为extract-text后中间会有空格所以要replace掉
      if regex("(目.*?录)|(摘.*?要)|(致.*?谢)") in ex_show_case {
        show_case = ex_show_case.replace(" ", "")
      }
      // 在附录X[]名称之间加入中英文空隔
      if regex("(附录[\w].*)") in ex_show_case {
        show_case = ex_show_case
      }

      sign_up_case(show_case)
    } else {
      let chinese-title = state("chinese-title").get()
      let big-title = state("big-title").get()
      // 偶数页
      sign_up_case([广东石油化工学院#big-title：#chinese-title])
    },
  )

  it
}

#let fmt-pass4(it) = {
  // pass3-4 之后是正文
  // pass4设置正文页脚（即页码）和heading样式
  set page(numbering: "1")

  // 设置正文标题的 supplement 和 numbering
  // 如果想要第一章的话改成第{1:一}章
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
  大标题,
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
  显示下划线: false,
  仅显示下划线: false,
) = context {
  let 学号 = 学号
  let 学院 = 学院
  let 专业 = 专业
  let 班级 = 班级
  let 学生 = 学生
  let 指导教师 = 指导教师
  let 职称 = 职称
  if state("mask-options").get().enabled {
    let block = state("mask-options").get().fill_with
    学号 = block * 8
    学院 = block * 5
    专业 = block * 8
    班级 = block * 2
    学生 = block * 5
    指导教师 = block * 3
    职称 = block * 3
  }
  set align(left)
  text(size: 字号.小五)[#h(49em * 0.53)]
  text(size: 字号.四号)[
    #if 仅显示下划线 {
      [学号：*#underline([\u{20}] * 12 * 2)*]
    } else {
      [学号：*#underline(学号)*]
    }
  ]
  v(字号.五号 + 9.5pt)

  // 放入学校的 title 图片
  align(center)[
    #set par(spacing: 0pt, leading: 0pt)
    #image("assets/header.png", height: 1.83cm, width: 9.69cm)

    // 手搓的调整距离
    #v(1.85em)
    // 一个28磅的换行
    #set text(size: 28pt)
    #linebreak()
  ]

  align(center)[
    #set text(size: 40pt, weight: "bold", font: TimeSimHei, tracking: 6pt) // 40磅黑体加黑居中
    #大标题

    // 调整距离
    #v(137pt)
  ]

  // 设置中文题目状态，用于页眉等
  state("chinese-title").update(中文题目)
  state("big-title").update(大标题)
  if type(学生) != str {
    学生 = wordometer_utils.extract-text(学生)
  }
  set document(
    title: 中文题目,
    author: 学生,
  )

  let underline-warpper = (it, extent: 0pt, offset: 0pt) => {
    if 显示下划线 {
      [
        // See: https://typst.dev/guide/FAQ/underline-misplace.html
        #set underline(offset: offset + .15em, stroke: .05em, evade: false, extent: extent)
        #underline(it)
      ]
    } else {
      it
    }
  }

  align(center)[
    #set text(size: 字号.小二, weight: "bold", font: TimeSimHei, tracking: 2pt) // 小二号黑体加黑居中
    #set par(leading: 1em)

    #underline-warpper(中文题目)

    #text(size: 字号.五号, linebreak())

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
    // 设置行距为Word的36磅
    #set par(leading: 36pt - 1em) // 行距
    #set par(spacing: 36pt - 1em) // 段距

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
        align(center + horizon)[#block(
          width: width,
          body,
        )]
      }
      let cjk_len = it => {
        let count = wordometer_utils.extract-text(it).matches(regex("[\p{Han}]")).len()
        count += wordometer_utils.extract-text(it).matches(regex("[\p{Latin}'’.,\-]")).len() / 2.3
        count += wordometer_utils.extract-text(it).matches(regex("[（）]+")).len() / 1.999
        count += wordometer_utils.extract-text(it).matches(regex("\d")).len() / 1.999
        count += wordometer_utils.extract-text(it).matches(regex("[\u{2580}-\u{259F}]")).len() * 0.75 // block
        count
      }
      let min = (a, b) => {
        if a < b {
          a
        } else {
          b
        }
      }
      let max = (a, b) => {
        if a > b {
          a
        } else {
          b
        }
      }
      let std-info = (cjk-width: 0, di-width: none, cjk-text) => {
        if di-width == none {
          di-width = 1em * cjk-width
        }
        distr(width: di-width, underline-warpper(
          text(size: 1em * cjk-width / max(cjk_len(cjk-text), cjk-width), cjk-text),
          extent: (cjk-width * 1em - 1em * min(cjk_len(cjk-text), cjk-width)) / 2,
          offset: 1em * (max(cjk_len(cjk-text), cjk-width) - cjk-width) / max(cjk_len(cjk-text), cjk-width) / 2.5,
        ))
      }
      place(left + bottom, dx: -8pt, dy: -字号.五号 * 4.5)[
        #set text(top-edge: "ascender", bottom-edge: "descender") // 接近中文习惯

        #grid(
          align: center + bottom,
          [#h(2em)学院],
          std-info(cjk-width: 7, 学院),
          [专业],
          std-info(cjk-width: 8, 专业),
          [班级],
          std-info(cjk-width: 2, di-width: 2.5em, 班级),

          columns: (4.3em, 7em, 2.3em, 1fr, 2.3em, 2.5em),
        )
        #grid(
          align: center + bottom,
          [#h(2em)学生],
          std-info(cjk-width: 7, 学生),
          [指导教师（职称）],
          distr(width: 9em, underline-warpper(
            text(size: 1em * 9 / max(cjk_len(ZT), 9), ZT),
            extent: (9em - 1em * min(cjk_len(ZT) + 0.5, 9)) / 2,
            offset: 1em * (max(cjk_len(ZT), 9) - 9) / max(cjk_len(ZT), 9) / 2.5,
          )),

          columns: (4.3em, 7em, 7.3em, 1fr),
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
  ]

  // 诚信承诺保证书
  twoside-section-pagebreak()
  align(center)[
    #set text(size: 字号.三号, weight: "bold", font: TimeSimHei) // 三号黑体加粗
    #set text(top-edge: "ascender", bottom-edge: "descender") // 接近中文习惯
    *广东石油化工学院本科#大标题\u{200b}诚信承诺保证书*
  ]

  linebreak()
  v(1em)

  {
    set text(size: 字号.三号, lang: "zh", font: TimeFanSun)
    set par(leading: 1em) // 行距
    set par(spacing: 1em) // 段距
    set par(justify: true) // 设置段落两端对齐
    set text(top-edge: "ascender", bottom-edge: "descender") // 接近中文习惯

    h(0.5em)
    [
      本人郑重承诺：《#中文题目》#大标题\u{200b}的内容真实、可靠，是本人在 #指导教师 的指导下，独立进行研究所完成。#大标题\u{200b}中引用他人已经发表或未发表的成果、数据、观点等，均已明确注明出处，如果存在弄虚作假、抄袭、剽窃的情况，本人愿承担全部责任。
    ]
    linebreak()
    linebreak()
    linebreak()
    linebreak()
    linebreak()

    // 签和年对齐
    align(right)[学生签名：#h(7em)]
    align(right)[年#h(2em)月#h(2em)日#h(3em)]
  }

  twoside-section-pagebreak()
}

// 卷头信息样式函数
#let paper-up(
  中文摘要,
  英文摘要,
  中文关键词: (),
  英文关键词: (),
  插图清单: false,
  附表清单: false,
  符号说明: none,
) = context {
  counter(page).update(1)
  if 中文摘要 != none {
    [
      #heading(level: 1)[摘#h(1em)要]

      #中文摘要 \
      \
      #if 中文关键词.len() > 0 {
        text(font: TimeSimHei)[*关键词*：] + 中文关键词.join("；")
      }
    ]
  }

  if 英文摘要 != none {
    twoside-section-pagebreak()
    [
      #heading(level: 1)[Abstract]

      #英文摘要 \
      \
      #if 英文关键词.len() > 0 {
        [*Keywords*: ] + 英文关键词.join(", ")
      }
    ]
  }

  // 设置目录样式
  twoside-section-pagebreak()

  show outline.entry: set text(
    size: 字号.五号,
  )
  show outline.entry.where(level: 1): set text(
    //font: TimeSimHei,
    //weight: "semibold",
  )
  // show outline.entry.where(level: 1): set block(above: 1.25em, below: 1em)
  let _outline_par_size = 0.75em
  show outline.entry.where(level: 1): set block(above: _outline_par_size)
  show outline.entry.where(level: 2): set block(above: _outline_par_size)
  show outline.entry.where(level: 3): set block(above: _outline_par_size)

  outline(
    title: [目#h(1em)录],
    indent: 2em,
    depth: 3,
  )

  // 筛选出所有 footnote 并清除
  // 使图表 caption 里可以使用 footnote 而不影响目录显示
  let fitter-body(body) = {
    if body.func() == footnote {
      // 筛选出所有 footnote 并清除
      none
    } else if body.func() == [].func() {
      // sequence: 过滤 children 后 join 重建
      let cleaned = body.children.map(fitter-body).filter(c => c != none)
      cleaned.join()
    } else if body.has("children") {
      // 其他有 children 的元素（par、strong 等）
      let cleaned = body.children.map(fitter-body).filter(c => c != none)
      body.with(children: cleaned)
    } else {
      // 纯文字、数字、box、repeat 等直接保留，不递归
      body
    }
  }
  // 重建 outline inner，清除目录清单中的 footnote
  show outline.entry: it => {
    show footnote: it => none // 阻止脚注计数
    link(it.element.location(), it.indented(it.prefix(), fitter-body(it.inner())))
  }

  // 插图清单
  if 插图清单 {
    twoside-section-pagebreak()
    i-figured.outline(title: [插图清单], target-kind: "image")
  }

  // 附表清单
  if 附表清单 {
    twoside-section-pagebreak()
    i-figured.outline(title: [附表清单], target-kind: "table")
  }

  // 符号说明/缩略词等汇集表
  if 符号说明 != none {
    twoside-section-pagebreak()
    notation-page(title: [符号说明], 符号说明)
  }

  twoside-section-pagebreak()

  counter(page).update(1)
}

// 参考文献样式
// 标题用三号黑体，居中上下空一行
// 参考文献正文为五号宋体
#let bibliography-page(
  bibfunc: none,
  full: false,
) = context {
  twoside-section-pagebreak()

  show bibliography: set text(font: TimeSimSun, size: 字号.五号) // 五号宋体

  {
    set heading(supplement: [引文])
    bilingual-bibliography(
      bibliography: bibfunc,
      title: [参考文献], // 三号黑体 = heading.level == 1
      full: full,
    )
  }
  twoside-section-pagebreak()
}

// 附录样式
#let appendix-first-heading(
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
  // 除一级标题外不显示于目录，样式继承自正文heading样式
  show heading.where(level: 2): set heading(outlined: if appendix { false } else { true })
  show heading.where(level: 3): set heading(outlined: if appendix { false } else { true })
  show heading.where(level: 4): set heading(outlined: if appendix { false } else { true })

  body
}
#let appendix(
  doctype: "master",
  body,
) = {
  show: appendix-first-heading
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
#let acknowledgement-page(
  body,
) = context {
  twoside-section-pagebreak()

  if state("mask-options").get().enabled {
    return
  }

  show heading: set par(justify: false)
  set heading(numbering: none, supplement: [致谢], bookmarked: true)

  heading(level: 1)[致#h(1em)谢]

  body

  twoside-section-pagebreak()
}
