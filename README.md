
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/polyglot)](https://CRAN.R-project.org/package=polyglot)
[![Grand
total](https://cranlogs.r-pkg.org/badges/grand-total/polyglot)](https://cran.r-project.org/package=polyglot)
[![pipeline
status](https://gitlab.com/lgnbhl/polyglot/badges/master/pipeline.svg)](https://gitlab.com/lgnbhl/polyglot/pipelines)
<!-- badges: end -->

# polyglot <img src="man/figures/logo.png" align="right" />

> Use the R console as an interactive learning environment

The package `polyglot` helps you learn foreign language vocabulary or
any [flashcards](https://en.wikipedia.org/wiki/Flashcard) using R as an
interactive learning environment. The package implements a simplified
version of the
[SuperMemo-2](https://www.supermemo.com/en/archives1990-2015/english/ol/sm2)
learning algorithm which optimizes intervals between repetitions,
minimizes the time you spend on learning, and helps you achieve your
learning goals in a more effective way.

### Installation

``` r
# Install the released version from CRAN
install.packages("polyglot")
```

To get a bug fix, or use a feature from the development version, you can
install polyglot from GitHub.

``` r
# install from Github
devtools::install_github("lgnbhl/polyglot")
```

### Create a spreadsheet to study

This package works with spreadsheets. You can create any spreadsheet to
study in a [CSV
format](https://en.wikipedia.org/wiki/Comma-separated_values) with a
`question` column, an `answer` column and an `hint/example` column
(optional).

For example, you could make a spreadsheet of 30 basic expressions in
French you want to study.

![](man/figures/screenshot1.png)

To try this spreadsheet, just type the following:

``` r
polyglot::get_examples()
```

This function copies CSV spreadsheets in your folder of reference, where
you should add all the spreadsheets you want to study with polyglot.

To open this folder, simply run `learn_dir()`.

``` r
polyglot::learn_dir()
```

To launch the learning environment, run the `learn()` function. Then
choose in the interactive menu the file you want to study.

``` r
polyglot::learn() # to launch the interactive learning environment
```

The GIF below shows the learning of the CSV spreadsheet file
`French_30_Basic_Expressions.csv`.

![](man/figures/screenshot2.gif)

### Learn with images

You can add images by putting the Web URL or the [full
path](https://en.wikipedia.org/wiki/Path_\(computing\)) of your images
into the spreadsheet rows.

For example, you can study the locations, flags and capitals of [all the
sovereign
states](https://en.wikipedia.org/wiki/List_of_sovereign_states) around
the world. Note that the images into the 3rd column `Hint` are displayed
into your Web browser.

![](man/figures/polyglot_world.gif)

You could also memorize the recipes of the [74 official
cocktails](https://en.wikipedia.org/wiki/List_of_IBA_official_cocktails)
of the International Bartenders Association (IBA).

![](man/figures/polyglot_cocktails.gif)

The CSV spreadsheet files given as examples are
[here](https://github.com/lgnbhl/polyglot/tree/master/inst/extdata).

Happy learning\!
