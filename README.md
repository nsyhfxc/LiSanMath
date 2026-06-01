# LisanExam LaTeX 试卷模板

这是一个基于 `elegantexam.cls` 的中文试卷整理模板，适合整理离散数学等课程的复习题、期末试卷和章节练习。模板已内置中文支持、页眉页脚、水印、主题色、题型排版命令和常用数学/绘图宏包。

## 文件结构

```text
.
├── main.tex              # 编译入口，负责导入各章节/试卷文件
├── config.sty            # 模板配置：学校、课程、主题色、水印等
├── elegantexam.cls       # 模板类文件：版式、命令、宏包定义
├── chapter/
│   ├── problem.tex       # 章节测试题内容
│   ├── paper1.tex        # 试卷 1
│   └── paper2.tex        # 试卷 2
└── figure/               # 图片资源目录
```

日常使用时，主要修改 `config.sty`、`main.tex` 和 `chapter/` 下的题目文件；一般不需要改 `elegantexam.cls`。

## 快速开始

使用 XeLaTeX 编译：

```bash
xelatex main.tex
xelatex main.tex
```

也可以使用 `latexmk`：

```bash
latexmk -xelatex main.tex
```

生成的 PDF 为 `main.pdf`。建议至少编译两次，以保证总页数、引用和页脚页码正确。

## 配置模板信息

打开 `config.sty` 修改基础信息：

```tex
\orgname{河北工程大学}
\course{离散数学}
\term{期末复习参考}
\editor{计算机科学与技术系}
```

这些内容会显示在标题区、页眉和水印中。

### 设置主题色

在 `config.sty` 中选择一个主题色：

```tex
\settheme{blue}
```

可选值：

```tex
blue    % 经典蓝
red     % 典雅红
green   % 墨玉绿
purple  % 罗兰紫
black   % 极简黑
orange  % 活力橙
```

### 水印和声明

```tex
\showwatermarktrue      % 显示水印
\showdisclaimertrue     % 显示声明框
```

如需关闭，改为：

```tex
\showwatermarkfalse
\showdisclaimerfalse
```

当前模板不再设置“答案解析开关”，也不区分教师版和学生版。

## 组织试卷内容

`main.tex` 是总入口，例如：

```tex
\documentclass{elegantexam}
\usepackage{config}

\begin{document}

\maketitle
\input{chapter/problem.tex}
\newpage
\input{chapter/paper1.tex}
\newpage
\input{chapter/paper2.tex}

\end{document}
```

新增一份试卷时，把内容放到 `chapter/xxx.tex`，再在 `main.tex` 中添加：

```tex
\newpage
\input{chapter/xxx.tex}
```

注意：`chapter/` 下的文件应只写正文内容，不要写 `\documentclass`、`\usepackage`、`\begin{document}` 或 `\end{document}`。

## 常用题型写法

### 大题标题

```tex
\section{选择题（每题 2 分，共 20 分）}
```

模板会自动使用中文编号样式。

### 普通编号题目

```tex
\begin{enumerate}
    \item 设 $A=\{1,2,3\}$，则 ...
    \item 已知 $p,q$ 的真值为 ...
\end{enumerate}
```

### 短选项：`\choicelow`

选项很短时使用四栏排版：

```tex
\item 下列符号正确的是（\quad）。
\choicelow{$\subseteq$}{$\in$}{$=$}{$\notin$}
```

### 中等选项：`\choicemid`

选项较长、半行左右时使用双栏排版：

```tex
\item 下列命题正确的是（\quad）。
\choicemid
{空集是任意集合的子集}
{若 $A\subseteq B$，则 $A=B$}
{$A-B=B-A \Rightarrow A=B$}
{空集是任何集合的真子集}
```

### 长选项：`\choicehigh`

选项很长、含图、含复杂公式时使用单栏排版：

```tex
\item 下列关系能构成函数的是（\quad）。
\choicehigh
{\( f=\{\langle x,y\rangle \mid x=y^2\} \)}
{\( f=\{\langle x,|x|\rangle \mid x\in\mathbb{R}\} \)}
{\( f=\{\langle x,y\rangle \mid x+y=10\} \)}
{\( f=\{\langle x,y\rangle \mid y<x \} \)}
```

三种选择题命令都必须填写 4 个选项参数，顺序对应 A、B、C、D。

## 填空题

普通下划线：

```tex
\underline{\hspace{4cm}}
```

模板也提供 `\tk` 命令生成空白下划线：

```tex
\tk[4cm]{答案内容}
```

当前模板不显示答案，`\tk` 的第二个参数仅用于保留命令格式，PDF 中显示为空线。

## 图片和表格

图片建议放在 `figure/` 目录下：

```tex
\begin{figure}[H]
    \centering
    \includegraphics[width=0.3\linewidth]{figure/example.png}
    \caption{示意图}
    \label{fig:example}
\end{figure}
```

表格示例：

```tex
\begin{table}[H]
    \centering
    \begin{tabular}{c|ccc}
        $*$ & $a$ & $b$ & $c$ \\ \hline
        $a$ & $a$ & $b$ & $c$ \\
        $b$ & $b$ & $a$ & $c$ \\
        $c$ & $c$ & $c$ & $c$
    \end{tabular}
\end{table}
```

模板已加载 `graphicx`、`float`、`tikz`、`amsmath`、`amssymb` 等常用宏包。

## TikZ 绘图

可以直接在题目中写 TikZ：

```tex
\begin{center}
\begin{tikzpicture}[scale=1]
    \node (a) at (0,0) {$a$};
    \node (b) at (1,1) {$b$};
    \draw (a)--(b);
\end{tikzpicture}
\end{center}
```

若 TikZ 图作为选择题选项，建议使用 `\choicehigh`。

## 编写建议

- 每份试卷单独放在 `chapter/` 下，方便在 `main.tex` 中自由组合。
- 短选项用 `\choicelow`，中等选项用 `\choicemid`，长公式或图形选项用 `\choicehigh`。
- 过长公式建议单独使用展示数学环境：

```tex
\[
    \neg(p\lor(q\to(r\land \neg p)))\to(r\lor \neg s)
\]
```

- 图片路径不要带空格或中文，推荐使用 `figure/name.png`。
- 编译时优先使用 XeLaTeX，不建议使用 pdfLaTeX。

## 常见问题

### 找不到图片

确认图片文件在 `figure/` 目录中，并且路径和扩展名完全一致：

```tex
\includegraphics{figure/1-2-4.png}
```

### 选项太挤或溢出

把 `\choicelow` 改成 `\choicemid`，或把 `\choicemid` 改成 `\choicehigh`。

### 页码或总页数不对

重新编译两次：

```bash
xelatex main.tex
xelatex main.tex
```

### 章节文件无法编译

检查 `chapter/xxx.tex` 中是否误写了以下内容，章节文件里不应该包含它们：

```tex
\documentclass{...}
\begin{document}
\end{document}
```

