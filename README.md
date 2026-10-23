# Stellarex LaTeX Bundle

tcolorbox poster class for Stellarex, Inc.
Derived from the IPP LaTeX bundle v2.7b by Marei Peischl (LPPL 1.3c).

## Usage

Compile from this directory with `latexmk` (the `.latexmkrc` adds `tex/` to the search path and selects `lualatex`):

```
latexmk StellarexPoster
```

`StellarexPoster.tex` is a generic 48 × 36 in template that shows every box style, figures, a table and the bibliography (`StellarexPoster.bib`). It uses `example-image` placeholders and `lipsum` text.

`examples/dpp-2025/` contains the APS-DPP 2025 poster built with this class (`latexmk dpp-2025-poster` inside that folder).

`pdflatex` and `xelatex` also work. To use the class from anywhere, copy `tex/` into `~/Library/texmf/tex/latex/stellarex/` (macOS) or `~/texmf/tex/latex/stellarex/` (Linux).

## Files

| File | Purpose |
| --- | --- |
| `tex/stellarex-poster.cls` | Poster class (`\documentclass{stellarex-poster}`) |
| `tex/stellarex-colors.sty` | Brand colors |
| `tex/stellarex-fonts.sty` | Fonts |
| `tex/img/stellarex-logo.pdf` | Standard logo |
| `tex/img/stellarex-logo-reversed.pdf` | Reversed logo on navy (cropped, without printer marks) |
| `tex/img/stellarex-icon.pdf` | Star icon |
| `logos/` | Affiliation logos used by the template (PPPL placeholder) |

## Colors

| Name | RGB | CMYK |
| --- | --- | --- |
| `Stellarex_navy` | #001B47 | 100/91/37/48 |
| `Stellarex_gold` | #FEBE24 | 0/27/95/0 |

Navy and gold come from the official logo files. The supporting colors (`Stellarex_blue`, `_blue_light`, `_orange`, `_grey_dark`, `_grey`, `_grey_light`) are not official brand colors.

## Fonts

Headings use **Montserrat**, which is close to the wordmark. Body text uses **Source Sans Pro**. Both ship with TeX Live and MiKTeX. To change them, edit `tex/stellarex-fonts.sty`.

## Poster options

- Class options: `fontsize` (title, author and box heading sizes scale with it), `paper`/`paperwidth`/`paperheight`, `margin`, `footerheight`, `logoheight` (default 60mm), `logofile`, `headlinelogos`, `affiliationlogos`, `affiliationlogoheight`.
- Affiliation logos next to the Stellarex logo, top right: `\setAffiliationLogos{logo1,logo2}`. Their height defaults to `logoheight`; set `affiliationlogoheight` to change it. The template uses `logos/pppl-logo.png` as a placeholder.
- Extra logos below the Stellarex logo: `\setHeadlineLogos{...}`.
- Box styles: `abstract` (navy title), `highlight` (gold callout by default; `highlight=blue`, `highlight=orange`, etc. pick another color), `conclusion` (navy).
- Footer: `\footergraphics{}` (logos, left), followed by left-aligned text in the footer font: the `\contact{}` addresses, `\footer{}`, and `\acknowledgement{}` (in italics).
