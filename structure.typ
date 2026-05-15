#import "fmt-req.typ": (
  acknowledgement-page, algox, appendix, bibliography-page, fmt-pass1, fmt-pass2, fmt-pass3, fmt-pass4, imagex,
  mask-pass, paper-cover, paper-up, proof, pseudocode-list, subimagex, table-note, tablex, theorem, twoside-pass,
)
#import "@preview/mitex:0.2.6": mi, mitex

// 盲审模式和定制双面打印模式
// 需要使用哪个功能就把哪个 enable 设置为 true
#show: mask-pass.with(enable: false)
#show: twoside-pass.with(enable: false)

// 在 pass1 之后开始编写论文封面和前面的内容
#show: fmt-pass1

#paper-cover(
  [毕业论文（设计）], // 大标题
  [中文题目], // 中文题目
  [Title name in English], // 英文题目
  [11451466666], // 学号
  [马克思学院], // 学院
  [化学工程与工艺（卓越班）], // 专业
  [12班], // 班级
  [西门吹雪], // 学生
  [任我行], // 指导教师
  [教主], // 职称
  datetime(year: 2025, month: 2, day: 1), // 启动日期
  datetime(year: 2025, month: 12, day: 31), // 结束日期
  显示下划线: true,
  仅显示下划线: false,
)

// 在 pass123 之后开始编写论文摘要
#show: fmt-pass2
#show: fmt-pass3 // 页眉

#paper-up(
  // 中文摘要
  [
    摘要是论文内容的简要陈述，是一篇具有独立性和完整性的短文。摘要应包括本论文的基本研究内容、研究方法、创造性成果及其理论与实际意义。摘要中不宜使用公式、图表，不标注引用文献编号。避免将摘要写成目录式的内容介绍。
    摘要应有关键词，关键词数量应为3-8个。
    摘要结构要严谨、表达简明、语义确切。一般通用第三人称。建议采用“对......进行了研究”、“报告了....·.现状”、“进行了......调查”等记述方法标明学位论文的主题，不必使用“本文”、“作者”等作为主语。
    关键词后面加冒号，关键词与关键词之间用逗号或分号隔开
  ],
  // 英文摘要
  [
    An abstract is a concise statement of the content of a thesis and an independent and complete short passage. It should include the basic research content, research methods, creative achievements, as well as their theoretical and practical significance of the thesis. Formulas, charts and reference numbering should not be used in the abstract. Avoid writing the abstract as a table-of-contents-style introduction.
    An abstract should contain keywords, with the number of keywords ranging from 3 to 8.
    The structure of an abstract shall be rigorous, the expression concise and the semantics accurate. Generally, the third person is used. It is recommended to use descriptive phrases such as "conducted research on...", "reported the current status of...", "carried out an investigation on..." to indicate the theme of the dissertation, without using "this paper" or "the author" as the subject.
    Keywords should be followed by a colon and separated by commas or semicolons.
  ],
  // 关键词
  中文关键词: ([论文内容], [创造性成果], [实际意义], [记述方法]),
  英文关键词: ([Thesis Content], [Creative Achievements], [Practical Significance], [Description Method]),
)

// 在 pass1234 之后开始编写论文正文
#show: fmt-pass4

#set text(tracking: 0.051pt)

= 绪论

#([×\u{200b}] * 169)

== 系统开发的依据及意义

#([×\u{200b}] * 507)……

#([×\u{200b}] * 507)……

== 研究现状及发展趋势

#([×\u{200b}] * 729)……

#([×\u{200b}] * 729)……

== 论文主要内容及组织结构

#([×\u{200b}] * 441)……

本文第1章只有2页（偶数页结束），如果你的第1章在第3页（奇数页）结束，那么第2章必须从第4页开始，为了不乱了页眉页脚，可以这样处理：
1. 在第3页结尾继续打回车延续到下一页（既第4页）
2. 将第2章第1页 的内容往上挪到第4页
3. 第2章第2页 的内容放在原本的第2章第1页，既新的第5页
4. 后面章节如果出现类似情况则按相同方法处理
如果某一章结束页跟本文结束页同是奇数页（或者同是偶数页），则不需要做上面的修改。

= 相关技术简介

#linebreak()

#([×\u{200b}] * 235)……

== ××××××××

#([×\u{200b}] * 705)……

#([×\u{200b}] * 837)……

== ××××××××

#([×\u{200b}] * 741)……

== ××××××××

#([×\u{200b}] * 507)……

== ××××××××

#([×\u{200b}] * 319)……

= ××系统分析

#linebreak()

#([×\u{200b}] * 301)

== 可行性分析（问题定义和可行性分析）

#([×\u{200b}] * 491)……

#([×\u{200b}] * 491)……

== ×××系统需求分析

#([×\u{200b}] * 298)

=== ×××功能需求分析

=== ×××数据需求分析

=== ×××性能需求分析

= ××系统总体设计

== ×××××××××××

=== ××××××××

=== ××××××××

=== ××××××××

== ×××××××××××

=== ××××××××

=== ××××××××

=== ××××××××

= ××系统详细设计

== ×××××××××××

=== ××××××××

=== ××××××××

=== ××××××××

== ×××××××××××

=== ××××××××

=== ××××××××

=== ××××××××

=== ××××××××

= ××系统实现与测试

== ×××××××××实现

=== ××××××××

=== ××××××××

=== ××××××××

== ××××××××测试

=== ××××××××

=== ××××××××

= 总结与展望

== ×××××××总结

== ×××××××展望


// <---------------- 参考文献 ---------------->

#bibliography-page(
  bibfunc: bibliography.with("refs.bib"),
  full: true,
) // full: false 表示只显示已引用的文献，不显示未引用的文献；true 表示显示所有文献

// <---------------- 编写致谢 ---------------->

#acknowledgement-page[
  致谢主要感谢导师和对论文工作有直接贡献和帮助的人士和单位。致谢言语应谦虚诚恳，实事求是。
]

// <---------------- 编写附录 ---------------->

#show: appendix

= Gauss-Jordan Elimination

== 介绍

高斯-约旦消元法（Gauss-Jordan Elimination）是一种用于求解线性方程组的算法，它是高斯消元法的改进版本。该方法通过将系数矩阵化为行最简形（简化行阶梯形）来求解方程组。

考虑一个线性方程组：
#mitex(
  `
  \begin{cases}
    a_{11}x_1 + a_{12}x_2 + \cdots + a_{1n}x_n = b_1 \\
    a_{21}x_1 + a_{22}x_2 + \cdots + a_{2n}x_n = b_2 \\
    \vdots \\
    a_{m1}x_1 + a_{m2}x_2 + \cdots + a_{mn}x_n = b_m
  \end{cases}
`,
)

对应的增广矩阵为：
#mitex(
  `
  \begin{pmatrix}
    a_{11} & a_{12} & \cdots & a_{1n} & | & b_1 \\
    a_{21} & a_{22} & \cdots & a_{2n} & | & b_2 \\
    \vdots & \vdots & \ddots & \vdots & | & \vdots \\
    a_{m1} & a_{m2} & \cdots & a_{mn} & | & b_m
  \end{pmatrix}
`,
)

高斯-约旦消元法的基本步骤如下：

1. *前向消元*：将矩阵化为行阶梯形
  - 从第一行开始，选择主元（通常选择绝对值最大的元素）
  - 将主元所在行交换到当前行
  - 将主元化为 1（除以主元值）
  - 用当前行消去下方所有行的对应列元素
2. *后向消元*：将矩阵化为行最简形
  - 从最后一行开始，向上消去上方所有行的对应列元素
  - 确保每个主元列中，主元为 1，其他元素为 0

== 示例

考虑线性方程组：
#mitex(
  `
  \begin{cases}
    2x + y - z = 8 \\
    -3x - y + 2z = -11 \\
    -2x + y + 2z = -3
  \end{cases}
`,
)

对应的增广矩阵为：
#mitex(
  `
  \begin{pmatrix}
    2 & 1 & -1 & | & 8 \\
    -3 & -1 & 2 & | & -11 \\
    -2 & 1 & 2 & | & -3
  \end{pmatrix}
`,
)

经过高斯-约旦消元后，得到行最简形：
#mitex(
  `
  \begin{pmatrix}
    1 & 0 & 0 & | & 2 \\
    0 & 1 & 0 & | & 3 \\
    0 & 0 & 1 & | & -1
  \end{pmatrix}
`,
)

因此解为：#mi("x = 2")，#mi("y = 3")，#mi("z = -1")。

== 复杂度分析

高斯-约旦消元法的时间复杂度为 #mi("O(n^3)")，其中 #mi("n") 是方程的数量。空间复杂度为 #mi("O(n^2)")，用于存储系数矩阵。

== 应用

高斯-约旦消元法广泛应用于：
- 求解线性方程组
- 计算矩阵的逆
- 计算矩阵的秩
- 求解线性规划问题
