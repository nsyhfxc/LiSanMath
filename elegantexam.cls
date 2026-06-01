% elegantexam.cls - 优雅的往年题整理模板
% 核心特性：
% 1. [配色] 内置 6 款设计师级学术配色
% 2. [开关] 水印、免责声明可独立控制
% 3. [排版] 支持智能填空、三种选项布局、底层防盗水印

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{elegantexam}[2023/12/22 Elegant Exam Class Ultimate]

\LoadClass[a4paper,12pt]{article}

% ==================================================
% 1. 核心宏包
% ==================================================
\RequirePackage[UTF8]{ctex}
\RequirePackage{geometry}
\RequirePackage{xcolor}
\RequirePackage{fancyhdr}
\RequirePackage{amsmath,amssymb}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{lastpage}
\RequirePackage{tabularx}
\RequirePackage{float}
\RequirePackage{tikz}
\usetikzlibrary{calc}
\RequirePackage{tcolorbox}
\tcbuselibrary{breakable} 
\RequirePackage{eso-pic}
\RequirePackage{graphicx}
\RequirePackage{xstring}

% ==================================================
% 2. 配色方案
% ==================================================
\definecolor{elegant_blue}{RGB}{0, 85, 165}
\definecolor{elegant_red}{RGB}{145, 20, 20}
\definecolor{elegant_green}{RGB}{25, 100, 60}
\definecolor{elegant_purple}{RGB}{102, 51, 153}
\definecolor{elegant_black}{RGB}{60, 60, 60}
\definecolor{elegant_orange}{RGB}{215, 90, 30}

\colorlet{maintheme}{elegant_blue}
\colorlet{softtheme}{maintheme!8}

\newcommand{\settheme}[1]{%
    \IfStrEqCase{#1}{%
        {blue}{\colorlet{maintheme}{elegant_blue}}%
        {red}{\colorlet{maintheme}{elegant_red}}%
        {green}{\colorlet{maintheme}{elegant_green}}%
        {purple}{\colorlet{maintheme}{elegant_purple}}%
        {black}{\colorlet{maintheme}{elegant_black}}%
        {orange}{\colorlet{maintheme}{elegant_orange}}%
    }[%
        \colorlet{maintheme}{elegant_blue}%
    ]%
    \colorlet{softtheme}{maintheme!8}%
}

% ==================================================
% 3. 全局样式
% ==================================================
\geometry{top=2.0cm, bottom=2.0cm, left=1.8cm, right=1.8cm}
\setlist[enumerate]{label=\arabic*., itemsep=0.5em, topsep=0.5em, leftmargin=2.5em}

% ==================================================
% 4. 接口与开关
% ==================================================
\newcommand{\orgname}[1]{\def\@orgname{#1}}
\newcommand{\course}[1]{\def\@course{#1}}
\newcommand{\term}[1]{\def\@term{#1}}
\newcommand{\editor}[1]{\def\@editor{#1}}
\newcommand{\setlogo}[1]{\def\@logofile{#1}}

\orgname{学术部}
\course{未命名课程}
\term{真题整理}
\editor{匿名}

\newif\ifshowdisclaimer \showdisclaimertrue
\newif\ifshowwatermark  \showwatermarktrue

% ==================================================
% 5. 水印
% ==================================================
\AddToShipoutPictureBG{%
    \ifshowwatermark
        \begin{tikzpicture}[remember picture, overlay]
            \foreach \x in {0.2, 0.5, 0.8} {
                \foreach \y in {0.15, 0.35, 0.55, 0.75, 0.95} {
                    \node[opacity=0.07, color=maintheme, rotate=30, scale=2.2, font=\heiti\bfseries, anchor=center] at ($(current page.south west) + (\x\paperwidth, \y\paperheight)$) {\@orgname};
                }
            }
        \end{tikzpicture}%
    \fi
}

% ==================================================
% 6. 页眉页脚
% ==================================================
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\small \color{maintheme} \@orgname \ · \@course}
\fancyhead[R]{\small \color{maintheme} 内部资料 \ · \ \@term}
\fancyfoot[C]{\small 第 \thepage 页 \ / \ 共 \pageref{LastPage} 页}
\renewcommand{\headrule}{\color{maintheme}\hrule height 0.5pt}

% ==================================================
% 7. 标题区
% ==================================================
\renewcommand{\maketitle}{
    \begin{center}
        \vspace*{-1cm}
        \ifdefined\@logofile
            \noindent
            \begin{minipage}[c]{0.18\textwidth}
                \includegraphics[width=\linewidth]{\@logofile}
            \end{minipage}\hfill
            \begin{minipage}[c]{0.80\textwidth}
                \centering
                {\color{maintheme}\heiti\zihao{2} \@course \quad \@term}\\[0.5em]
                {\color{black!70}\kaishu 整理：\@editor \quad | \quad 出品：\@orgname}
            \end{minipage}
        \else
            {\color{maintheme}\heiti\zihao{2} \@course \quad \@term}\\[0.5em]
            {\color{black!70}\kaishu 整理：\@editor \quad | \quad 出品：\@orgname}
        \fi
        \ifshowdisclaimer
            \vspace{0.8em}
            \begin{tcolorbox}[colback=yellow!5, colframe=orange!50, width=0.98\linewidth, arc=2pt, boxrule=0.5pt]
                \centering \footnotesize \color{black!60} \textbf{声明}：本资料仅供内部交流学习使用，严禁用于商业用途。
            \end{tcolorbox}
        \else \vspace{0.5em} \fi
    \end{center}
    \vspace{0.5cm}
}

% ==================================================
% 8. 题型组件
% ==================================================
\titleformat{\section}{\color{maintheme}\zihao{4}\heiti}{\chinese{section}、}{0em}{}

\newcommand{\kh}[1][]{%
    \hfill \textcolor{maintheme}{( \quad \phantom{A} \quad )}
}
\newsavebox{\tkbox}
\newlength{\tkwidth}

% --- 填空 ---
\newcommand{\tk}[2][2cm]{%
    \leavevmode%
    \textcolor{maintheme}{\underline{\makebox[#1]{}}}%
}

% --- 选项 ---
\newcommand{\choicelow}[4]{\par\nopagebreak\begin{tabular*}{\linewidth}{@{}*{4}{p{0.23\linewidth}@{}}}A.~#1 & B.~#2 & C.~#3 & D.~#4\end{tabular*}}
\newcommand{\choicemid}[4]{\par\nopagebreak\begin{tabular*}{\linewidth}{@{}*{2}{p{0.48\linewidth}@{}}}A.~#1 & B.~#2 \\ C.~#3 & D.~#4\end{tabular*}}
\newcommand{\choicehigh}[4]{%
    \par
    \begin{enumerate}[label=\Alph*., leftmargin=2.5em, itemsep=0pt, topsep=0pt, partopsep=0pt, parsep=0pt]
        \item #1 \item #2 \item #3 \item #4
    \end{enumerate}
}

% --- 解析框 ---
\newenvironment{solution}{
    \par\vspace{0.5em}
    \begin{tcolorbox}[
        breakable, colback=softtheme, colframe=maintheme!50,
        title={\textbf{【参考解析】}}, coltitle=maintheme, fonttitle=\small,
        arc=1pt, boxrule=0.5pt, left=2pt, right=2pt, top=2pt, bottom=2pt
    ]
    \small \color{black!80}
}{
    \end{tcolorbox}
}

\endinput
