
The {polyglot} package lets you use the R console as an interactive learning environment in order to memorize any dataset you want. Its main goal is to put foreign language vocabulary learning in the R workflow, so R can also be used to study languages or anything related to flashcards.

### Install polyglot

To install and run polyglot, type the following in the R console:

``` r
install.packages("polyglot")
library(polyglot)
learn() # to launch the interactive learning environment
```

### Set the appropriate encoding

Before launching the interactive environment, be sure to have the appropriate locale settings.

To study French for instance, type the following in the R console:

``` r
Sys.setlocale("LC_TIME", "French")      # for Windows
Sys.setlocale("LC_TIME", "fr_FR")       # for macOS
Sys.setlocale("LC_TIME", "fr_FR.utf8")  # for Modern Linux etc.
```

### Add your own datasets

If you want to open the directory containing the datasets to add yours, type the following:

``` r
library(polyglot)
learnDir()
```

### Development version

You can also try the [development version](https://github.com/lgnbhl/polyglot) of the package, which implements a simplified [spaced repetition](https://en.wikipedia.org/wiki/Spaced_repetition) learning algorithm.

``` r
# install.packages("devtools")
devtools::install_github("lgnbhl/polyglot")
library(polyglot)
learn()
```

![](https://raw.githubusercontent.com/lgnbhl/lgnbhl.github.io/master/images/polyglot_dev.gif)


Go [here](https://lgnbhl.github.io/polyglot) to read a blog post describing the package with more development. 

Happy learning!
