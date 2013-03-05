%% Copyright 2008 Alexandre Abraham
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License version 1.3c,
% available at http://www.latex-project.org/lppl/.


%
%  Identification
%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{meetrpt}[2008/10/14 Meeting report 0.2]

%
%  Preliminary Declarations
%

\LoadClassWithOptions{article}
\RequirePackage{xcolor}
\RequirePackage{fullpage}
\RequirePackage{tocloft}
\RequirePackage{colortbl}
\RequirePackage{ifthen}

%
% Set up the people table
%

\newcommand{\people}{\@ifstar
                     \peoplestar%
                     \peoplenostar%
}

\newcommand{\listpeoplename}{List of People}
\newlistof{people}{peo}{\listpeoplename}

\protect\def\peoplenostar#1#2#3{ %
  \expandafter\def\csname #1\endcsname{#2 \relax} %
  \addcontentsline{peo}{people}{#2 \ifx*#3\else(#3)\fi} %
}

\newcommand{\peoplestar}[3]{\expandafter\def\csname #1\endcsname{#2 \relax}}

\cftpagenumbersoff{people}

% Points et numéros de page jolis dans la table des sujets
\renewcommand{\normalfont}{\fontfamily{phv}\footnotesize}

% Numéros de page jolis
\renewcommand*{\thepage}{\fontfamily{phv}\selectfont\arabic{page}}

%
% Set up business order
%

\newcommand{\listbusinessname}{Order of business}
\newlistof{business}{bor}{\listbusinessname}
\renewcommand{\cftbortitlefont}{\Large}
\renewcommand{\cftbusinessfont}{}
\setlength{\cftafterbortitleskip}{1ex}

%
%  Options
%

%
%  Field definitions
%

\newcommand*{\schedule}[1]{\def\@schedule{#1}}
\schedule{}

\newcommand*{\site}[1]{\def\@site{#1}}
\site{}

\newcommand*{\type}[1]{\def\@type{#1}}
\type{}

\newcommand*{\organizer}[1]{\def\@organizer{#1}}
\organizer{}

\newcommand*{\protractor}[1]{\def\@protractor{#1}}
\protractor{}

\newcommand*{\animator}[1]{\def\@animator{#1}}
\animator{}

%
%  More declarations
%

\definecolor{@medblue}{rgb}{0.5,0.5,1}
\definecolor{@lightgrey}{rgb}{0.9,0.9,0.9}
\def\@business{no}

\renewcommand{\contentsname}{Ordre du jour}

\def\@version{}
\newcommand{\version}[2]{\expandafter\def\expandafter\@version\expandafter{\@version \centering #1 & #2 \\ \hline }}

\renewcommand\maketitle{
  % Set font
  \fontfamily{phv}\selectfont%
  \footnotesize
  \renewcommand{\arraystretch}{1.4}
  %
  % Title
   { \noindent \Huge {\color{@medblue}\rule{\textwidth}{.5ex}} \par \vspace{-1em} \colorbox{white}{\@title} \par \vspace{.4em} }%
  %
  % Header
   \vspace{-1.4em}%
  { \raggedleft \small \@date \\ \@schedule \\[1.5em]}%
  %
  {\noindent%
   \begin{tabular}{|>{\columncolor{@lightgrey}}p{.2\textwidth}|p{.75\textwidth}|}\hline%
    \ifthenelse{\equal{\@organizer}{}}
               {}%{\ClassWarning{Organizer is note defined}}
               {\textsc{Organizer} & \@organizer \\ \hline}%
    \ifthenelse{\equal{\@type}{}}
               {}%{\ClassWarning{Type is note defined}}
               {\textsc{Meeting type} & \@type \\ \hline}%
    \ifthenelse{\equal{\@site}{}}
               {}%{\ClassWarning{Site is note defined}}
               {\textsc{Site} & \@site \\ \hline}%
    \ifthenelse{\equal{\@animator}{}}
               {\ClassWarning{meetrpt}{Animator is note defined}}
               {\textsc{Animator} & \@animator \\ \hline}%
    \ifthenelse{\equal{\@protractor}{}}
               {}%{\ClassWarning{Protractor is note defined}}
               {\textsc{Protractor} & \@protractor \\ \hline}%
               \textsc{Participants} & \vspace{-2ex}\@starttoc{peo}\vspace{-2ex}~ \\ \hline % FIXME : ugly hack to get rid of extra spaces
  \end{tabular}\vspace{1em}}%
   
  \ifx \@version \@empty
  \else
    \noindent%
    \begin{tabular}{|p{.1\textwidth}|p{.85\textwidth}|}\hline%
    \multicolumn{1}{|>{\columncolor{@lightgrey}}c|}{\textsc{Version}}&%
    \multicolumn{1}{>{\columncolor{@lightgrey}}l|}{\textsc{Comments}}\\ \hline
    \@version
    \end{tabular}
  \fi
	    
  \listofbusiness\par\vspace{3em}%
}

% Order of business is in fact a table of contents and each point is a section.
% Fixme : make sure that commands are called in the right order

\newcommand{\subject}[1]{\multicolumn{1}{|>{\columncolor{@lightgrey}}l|}%
  {\textsc{Discussion}}&\multicolumn{3}{p{.84\textwidth}|}{#1}\\\hline}%

\newcommand{\conclusion}[1]{\multicolumn{1}{|>{\columncolor{@lightgrey}}l|}{\textsc{Conclusion}}&\multicolumn{3}{p{.84\textwidth}|}{#1}\\\hline}

\newcommand{\assign}[3]{
 \ifx\@firstassign\@true
    \multicolumn{2}{|>{\columncolor{@lightgrey}}l|}{\textsc{Actions}}&%
    \multicolumn{1}{>{\columncolor{@lightgrey}}l|}{\textsc{Person in charge}}&%
    \multicolumn{1}{>{\columncolor{@lightgrey}}l|}{\textsc{Delay}}%
    {\global\def\@firstassign{0}}\\\hline \fi
    \multicolumn{2}{|p{.6\textwidth}|}{#1\vspace{\fill}}&{\renewcommand{\arraystretch}{1.2}\setlength{\tabcolsep}{0pt}\begin{tabular}{l}#2\end{tabular}}&#3\\\hline}%

\protect\newenvironment{business}[1]{%
\addcontentsline{bor}{business}{#1}%
\ifthenelse{\equal{\@business}{yes}}{\ClassError{Can't nest business}}{}%
\def\@business{yes}%
\def\@true{1}%
{\global\def\@firstassign{1}}%
\centering\large#1\\*[1ex]\normalfont\noindent\begin{tabular}{|p{.15\textwidth}|p{.4\textwidth}|p{.19\textwidth}|p{.13\textwidth}|}\hline%
}{\end{tabular}\vspace{3em}}
\endinput
%% end of file `assocr.cls'.
