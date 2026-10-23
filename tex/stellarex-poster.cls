%% This is file `stellarex-poster.cls',
%% it is part of the Stellarex LaTeX bundle
%% tcolorbox posters for Stellarex, Inc.
%% ----------------------------------------------------------------------------
%%
%%  Derived from the IPP bundle v2.7b,
%%  Copyright (C) 2020–2023 by Marei Peischl <marei@peitex.de>
%%
%% ============================================================================
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3c
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%% http://www.latex-project.org/lppl.txt
%% ============================================================================
%%
\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass{stellarex-poster}{2026-10-22}{1.0}{Scientific poster layout for Stellarex}

\RequirePackage{l3keys2e}
\RequirePackage{graphicx}
\RequirePackage[cmyk]{stellarex-colors}

\prop_new:N \g_stx_clsopts_prop

\box_new:N \l_stx_headline_logo_box
\box_new:N \g_stx_main_logo_box

\clist_new:N \g__stx_headlinelogo_clist
\clist_new:N \g__stx_affiliationlogo_clist
\box_new:N \g_stx_affiliation_logo_box
\bool_new:N \g__stx_in_document_bool

\keys_define:nn {Stellarex/poster} {
	unknown .code:n = {\prop_gput:NVn \g_stx_clsopts_prop \l_keys_key_tl {#1}},
	fontsize .tl_gset:N = \g_stx_fontsize_tl,
	fontsize .initial:n = 26bp,
	logofile .tl_gset:N = \g_stx_logofile_tl,
	logofile .initial:n = img/stellarex-logo,
	logoheight .dim_gset:N = \g_stx_logoheight_dim,
	logoheight .initial:n = 60mm,
	headlinelogos .code:n = {
		\clist_gset:Nn \g__stx_headlinelogo_clist {#1}
		\cs_if_exist_use:NT \__stx_setup_headline_logo:NV {\l_stx_headline_logo_box  \g__stx_headlinelogo_clist}
	},
	% affiliation logos at the top right, left of the Stellarex logo
	affiliationlogos .code:n = {
		\clist_gset:Nn \g__stx_affiliationlogo_clist {#1}
		\bool_if:NT \g__stx_in_document_bool {\__stx_setup_affiliation_logos:}
	},
	affiliationlogoheight .dim_gset:N = \g_stx_affiliationlogoheight_dim,
	affiliationlogoheight .initial:n = 0pt,% 0pt: same as logoheight
	paper .code:n = \PassOptionsToPackage{paper=#1}{geometry},
	paper .initial:n = a0paper,
	papersize .code:n = \PassOptionsToPackage{papersize=#1}{geometry},
	paperheight .code:n = \PassOptionsToPackage{paperheight=#1}{geometry},
	paperwidth .code:n = \PassOptionsToPackage{paperwidth=#1}{geometry},
	margin .dim_gset:N =  \g_stx_margin_dim,
	margin .initial:n = 20mm,
	footerheight .dim_gset:N = \g_stx_footerheight_dim,
	footerheight .initial:n = 30mm,
}

\ProcessKeysOptions{Stellarex/poster}

\newcommand*{\StellarexPosterSetup}[1]{\keys_set:nn {Stellarex/poster} {#1}}
\newcommand*{\setHeadlineLogos}[1]{\keys_set:nn {Stellarex/poster}{headlinelogos={#1}}}
\newcommand*{\setAffiliationLogos}[1]{\keys_set:nn {Stellarex/poster}{affiliationlogos={#1}}}

\tl_new:N \g_stx_footnote_label_tl
\tl_gset:Nn \g_stx_footnote_label_tl {arabic*}

\prop_gput:NnV \g_stx_clsopts_prop {fontsize} \g_stx_fontsize_tl



\prop_map_inline:Nn \g_stx_clsopts_prop {
	\tl_if_empty:nTF {#2}
	{\exp_args:NnV\PassOptionsToClass{#1}\l_tmpa_tl}
	{\clist_map_inline:nn {#2} {\PassOptionsToClass{#1=##1}{scrartcl}}}
}



\ExplSyntaxOff
\PassOptionsToPackage{typeareawarninfolimit=-1,DIV=10}{typearea}
\LoadClass[parskip=half-]{scrartcl}
\RequirePackage{tikz}
\usetikzlibrary{calc}
\RequirePackage{tcolorbox}
\tcbuselibrary{poster}

%font setup
\RequirePackage{iftex}

\RequirePackage{anyfontsize}
\ExplSyntaxOn

\RequirePackage{stellarex-fonts}

\PassOptionsToPackage{margin=\g_stx_margin_dim}{geometry}
\RequirePackage{geometry}


%Font adjusments
\renewcommand*{\familydefault}{\sfdefault}

% Heading sizes scale with the base font size (values match the IPP design at fontsize=26bp)
\tl_new:N \g__stx_basesize_tl
\cs_new_protected:Npn \stx_scaled_fontsize:nn #1#2 {
	\group_begin: \normalsize \tl_gset:Nx \g__stx_basesize_tl {\f@size} \group_end:
	\fontsize{\fp_eval:n {#1*\g__stx_basesize_tl}pt}{\fp_eval:n {#2*\g__stx_basesize_tl}pt}\selectfont
}

\setkomafont{disposition}{\Stellarex@headingfont\bfseries}

\setkomafont{title}{
	\color{titlefgcolor}
	\stx_scaled_fontsize:nn {3.08} {3.69}
	\bfseries
}

\setkomafont{section}{
	\stx_scaled_fontsize:nn {1.62} {1.96}
}

\RedeclareSectionCommand[afterskip=1sp]{section}


\setkomafont{pageheadfoot}{
	\color{Stellarex_grey_dark}\small
}

\setkomafont{publishers}{
	\stx_scaled_fontsize:nn {1.69} {1.88}
}

\setkomafont{author}{\normalcolor\stx_scaled_fontsize:nn {1.23} {1.46}}
\setkomafont{captionlabel}{\bfseries}


\tl_new:N \g_stx_thanks_tl
\newcommand*{\Stellarex@title@footnote}[2][1]{
	\begingroup
	\stx_def_footnotelabel:
	\footnotemark[#1]\,#2\quad
	\endgroup
}

\tl_greplace_all:Nnn \g_stx_footnote_label_tl {*} {{footnote}}
\clist_map_inline:nn {alph, arabic, fnsymbol, Alph, roman, Roman} {
	\tl_greplace_all:Nnn \g_stx_footnote_label_tl {#1} {\use:c {#1}}
}

\cs_set:Nn \stx_def_footnotelabel: {
	\renewcommand*{\thefootnote}{\g_stx_footnote_label_tl}
}

\pagestyle{empty}
\renewcommand*{\title}[1]{\gdef \@title {#1}}

\tl_new:N \g_stx_poster_foot_tl

\newcommand{\footer}[1]{
	\tl_gset:Nn \g_stx_poster_foot_tl {#1}
}

\box_new:N \g_stx_footergraphics_box
\newcommand*{\footergraphics}[1]{
	\begingroup
	\let\height\g_stx_footerheight_dim
	\hbox_gset:Nn \g_stx_footergraphics_box {#1}
	\endgroup
}

%redefine \author to manage \and and \thanks
\seq_new:N \g_stx_author_seq

\renewcommand*\author[1]{
	\seq_gset_split:Nnn \g_stx_author_seq {\and} {#1}
}

\renewcommand*{\@author}{
	\seq_use:Nn \g_stx_author_seq {,~}
}

\seq_new:N \g_stx_institute_seq
\newcommand*{\institute}[1]{
	\seq_gset_split:Nnn \g_stx_institute_seq {\and} {#1}}
\newcommand*{\@institute}{
	\seq_use:Nn \g_stx_institute_seq {,~}
}


\newcommand*{\inst}[1]{
	\clist_set:Nn \l_tmpa_clist {#1}
	\clist_pop:NN \l_tmpa_clist \l_tmpa_tl
	\footnotemark[\l_tmpa_tl]
	\clist_map_inline:Nn \l_tmpa_clist {\textsuperscript{,}\footnotemark[##1]}
}

\seq_new:N  \g_stx_contact_address_seq
\newcommand*{\contact}[1]{
	\@contactaddressmark
	\seq_gput_right:Nn  \g_stx_contact_address_seq {#1}
}

\int_new:N \g_stx_contact_address_int
\def\@contactaddressmark{
	\int_gincr:N \g_stx_contact_address_int
	\protected@xdef\@thefnmark{\@fnsymbol\g_stx_contact_address_int}\@footnotemark
}
\newcommand*{\contactaddressname}{Corresponding~author\int_compare:nT {\seq_count:N  \g_stx_contact_address_seq > 1} {s}}
\newcommand*{\contactaddresssep}{:\space}

\newcommand\titlegraphic[1]{\def\@titlegraphic{#1}}
\titlegraphic{}

% Funding statement, printed in italics below the footer text
\tl_new:N \g_stx_acknowledgement_tl
\newcommand{\acknowledgement}[1]{
	\tl_gset:Nn \g_stx_acknowledgement_tl {#1}
}

\newlength{\contentwidth}
\setlength{\contentwidth}{\textwidth}
\newlength{\contentheight}

%initialize headline logos
\cs_set:Nn \__stx_setup_headline_logo:Nn {
		\tl_if_blank:nTF {#2}  {
			\box_gclear:N #1
		}{
		\bool_set_false:N \l_tmpa_bool
		\hbox_gset:Nn #1 {
			\clist_map_inline:nn {#2} {
				\bool_if:NT \l_tmpa_bool {\rule{1ex}{0pt}}
				\bool_set_true:N \l_tmpa_bool
				\includegraphics[height=.5\g_stx_logoheight_dim]{##1}
			}
		}
	}
}

\cs_generate_variant:Nn \__stx_setup_headline_logo:Nn {NV}

\__stx_setup_headline_logo:NV \l_stx_headline_logo_box  \g__stx_headlinelogo_clist

% gap between the affiliation logos and the Stellarex logo
\dim_const:Nn \c_stx_affiliationlogo_sep_dim {15mm}
\cs_new_protected:Nn \__stx_setup_affiliation_logos: {
	\clist_if_empty:NTF \g__stx_affiliationlogo_clist {
		\box_gclear:N \g_stx_affiliation_logo_box
	} {
		\dim_set:Nn \l_tmpa_dim {\dim_compare:nNnTF {\g_stx_affiliationlogoheight_dim} = {\c_zero_dim} {\g_stx_logoheight_dim} {\g_stx_affiliationlogoheight_dim}}
		\bool_set_false:N \l_tmpa_bool
		\hbox_gset:Nn \g_stx_affiliation_logo_box {
			\clist_map_inline:Nn \g__stx_affiliationlogo_clist {
				\bool_if:NT \l_tmpa_bool {\hspace{10mm}}
				\bool_set_true:N \l_tmpa_bool
				\includegraphics[height=\l_tmpa_dim]{##1}
			}
		}
	}
}

\def\raggedfooter{\raggedright}

\colorlet{poster-base}{Stellarex_navy}
% Background Colors
\colorlet{backgroundcolor}{white}
\colorlet{framecolor}{Stellarex_navy}
\colorlet{frameaccentcolor}{Stellarex_gold}
\colorlet{titlefgcolor}{Stellarex_navy}
\colorlet{titlebgcolor}{white}
% Block Colors
\colorlet{blocktitlebgcolor}{white}
\colorlet{blocktitlefgcolor}{poster-base}
\colorlet{blockbodybgcolor}{white}
\colorlet{blockbodyfgcolor}{black}
% Innerblock Colors
\colorlet{innerblocktitlebgcolor}{black!15}
\colorlet{innerblocktitlefgcolor}{black}
\colorlet{innerblockbodybgcolor}{white}
\colorlet{innerblockbodyfgcolor}{black}

%%%%%%%%%%%%%%%%%%%%%%
%Declare TCBstyles for stellarex-poster
% Unify header spacing

\dim_new:N \g_stx_section@afterskip_dim
\skip_set:Nn \l_tmpa_skip {\scr@section@afterskip}
\dim_gset:Nn \g_stx_section@afterskip_dim  {\l_tmpa_skip}

%Adjust section to match block header
\renewcommand{\sectionlinesformat}[4]{%
	\@hangfrom{\hskip #2#3}{\__stx_internal_modify_title:n {#4}}%
}

\cs_new:Nn \__stx_internal_modify_title:n {\text_uppercase:n {#1}}

\tcbset {
	parbox=false,
	Stellarex/.style = {
		parbox=false,
		colbacktitle=Stellarex_grey_light,
		coltitle=Stellarex_navy,
		halign~title=flush~left,
		colback=white,
		coltext=black,
		fonttitle=\usekomafont{disposition}\usekomafont{section}\tl_gset:Nx \kvtcb@title {\exp_not:N \__stx_internal_modify_title:n {\exp_not:o{\kvtcb@title}}},
		toptitle=.5\g_stx_section@afterskip_dim,bottomtitle=.5\g_stx_section@afterskip_dim,	frame~hidden,
		boxrule=\z@,
		left=\z@,right=\z@,
		lefttitle=.4ex,righttitle=.4ex,
		top=\g_stx_section@afterskip_dim,
	},
	framed/.style = {%compat only
		Stellarex,
	},
	abstract/.style =
		{
		Stellarex,
		colbacktitle=Stellarex_navy,
		coltitle=white,
		},
	% highlight=<color>: <color> is one of the Stellarex_<color> names, e.g. gold, blue, orange
	highlight/.style =
		{
		Stellarex,
		colback=Stellarex_#1!20,
		colbacktitle=Stellarex_#1,
		coltitle=Stellarex_#1_contrast,
		left=.4ex,right=.4ex,
		},
	highlight/.default=gold,
	conclusion/.style =
		{
		Stellarex,
		colbacktitle=Stellarex_navy,
		colback=Stellarex_navy!10,
		coltitle=white,
		},
	section/.code =  {\expandafter\let\csname tcb@parbox@false@indent\endcsname\relax\tcbset{top=0pt}}
}

\tcbset{
	poster/.cd,
	spacing=20mm
}

\tcbposterset{
	boxes={arc=5mm},
	coverage = {
		spread,
		boxrule=\g_stx_margin_dim,
		bottomrule=3\g_stx_margin_dim,
		enhanced,
		title~code={
			\node[inner~sep=2.5mm,inner~ysep=.3\g_stx_logoheight_dim,anchor=north~east] (stellarex-logo) at (title.north~east) {\box_use:N \g_stx_main_logo_box};
			\box_if_empty:NF \g_stx_affiliation_logo_box {
				\node[inner~sep=0pt,anchor=east] (affiliation-logos) at ([xshift=2.5mm-\c_stx_affiliationlogo_sep_dim]stellarex-logo.west) {\box_use:N \g_stx_affiliation_logo_box};
			}
			\node[anchor=north~east] at (stellarex-logo.south~east) {
				\box_use:N \l_stx_headline_logo_box
			};
		},
		toptitle=20mm,
		title=\stx_poster_titlebox:n {\@title},
		top=\baselineskip,
		bottom=\g_stx_footerheight_dim-\g_stx_margin_dim,
		bottomrule=\g_stx_footerheight_dim+\g_stx_margin_dim,
		frame~code={\path[fill=framecolor]
			(frame.north~west) rectangle (title.north~east-|frame.north~east);
		\path[fill=framecolor]
		(frame.south~west) rectangle ++(\paperwidth,1cm);
		% gold accent lines, echoing the logo
		\path[fill=frameaccentcolor]
			([yshift=-.25\g_stx_margin_dim]title.north~west) rectangle ([yshift=-.5\g_stx_margin_dim]title.north~east);
		},
		overlay={
		\node [anchor=north~west, inner~ sep=\z@] (footergraphics) at ([yshift=-5mm]interior.south~west) {\box_use:N \g_stx_footergraphics_box\box_if_empty:NF \g_stx_footergraphics_box {\hspace*{3mm}}};
		\node [anchor=north~west, inner~ sep=\z@] at
		(footergraphics.north~east)
		 {
			\parbox[t]{
				\dim_eval:n {
					\dim_compare:nT {\box_wd:N \g_stx_footergraphics_box > \c_zero_dim} {-3mm}
					+ \textwidth
					-\box_wd:N \g_stx_footergraphics_box
				}
			}{
				\raggedfooter
				\usekomafont{pageheadfoot}
				\seq_if_empty:NF \g_stx_contact_address_seq {\contactaddressname\contactaddresssep
					\int_gzero:N \g_stx_contact_address_int
					\seq_map_inline:Nn  \g_stx_contact_address_seq {\@contactaddressmark
						####1;\space
					}
					\par
				}
				\g_stx_poster_foot_tl
				\tl_if_empty:NF \g_stx_acknowledgement_tl {\par\itshape\g_stx_acknowledgement_tl}
			}
		};
		}
	},
	%select default block style
	boxes = Stellarex,
}

%backwards compat for TeX Live 2020
\cs_if_exist:NF \box_ht_plus_dp:N  {
	\cs_new:Nn \box_ht_plus_dp:N  {\dim_eval:n {\box_ht:N #1 + \box_dp:N #1}}
}

\cs_new:Nn \stx_poster_titlebox:n {
	\rule[\dim_eval:n {
		\box_if_empty:NF \l_stx_headline_logo_box {
			-\box_ht_plus_dp:N \l_stx_headline_logo_box -.15\g_stx_logoheight_dim}
		-1.15\g_stx_logoheight_dim}
	]{0pt}{0pt}
	\parbox[t]{\dimexpr\linewidth-\dim_max:nn {\box_wd:N \l_stx_headline_logo_box} {\box_wd:N \g_stx_main_logo_box}-20mm
		\box_if_empty:NF \g_stx_affiliation_logo_box {-\box_wd:N \g_stx_affiliation_logo_box - \c_stx_affiliationlogo_sep_dim}\relax}{
		\raggedright
		{\usekomafont{disposition}\usekomafont{title}\@title\par}
		\par\vspace{15mm}
		{\usekomafont{author}\@author\par}
		\tl_gset:No \g_stx_thanks_tl {\@thanks}
		\par
		\usekomafont{author}
		\@institute\par
		\let\footnotetext\Stellarex@title@footnote
		\g_stx_thanks_tl
	}
	\par
}

\AtBeginDocument{
	\hbox_gset:Nn \g_stx_main_logo_box {\includegraphics[height=\g_stx_logoheight_dim]{\g_stx_logofile_tl}}
	\bool_gset_true:N \g__stx_in_document_bool
	\__stx_setup_affiliation_logos:
	\skip_set:Nn \l_tmpa_skip {\scr@section@afterskip}
	\dim_add:Nn \l_tmpa_skip {\parskip}
	\dim_gset:Nn \g_stx_section@afterskip_dim {\l_tmpa_skip}
}


\ExplSyntaxOff

\setcounter{secnumdepth}{-1}

\def\@listi{\leftmargin1em
	\parsep 4\p@ \@plus2\p@ \@minus\p@
	\topsep 8\p@ \@plus2\p@ \@minus4\p@
	\itemsep4\p@ \@plus2\p@ \@minus\p@}
\let\@listI\@listi

\endinput
%end of stellarex-poster.cls
