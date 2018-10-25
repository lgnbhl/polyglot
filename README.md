
# polyglot <img src="man/figures/logo.png" align="right" />

The **polyglot** package helps you learn foreign language vocabulary or
any [flashcards](https://en.wikipedia.org/wiki/Flashcard) using R as an
interactive learning environment. The package implements the popular
[SuperMemo-2](https://en.wikipedia.org/wiki/SuperMemo) learning
algorithm which optimizes intervals between repetitions, minimizes the
time you spend on learning, and helps you achieve your learning goals in
the most effective way.

### Installation

``` r
devtools::install_github("lgnbhl/polyglot")
# BEWARE that a new installation overwrites existing CSV files
```

### Minimal examples

Create a spreadsheet in a [CSV
format](https://en.wikipedia.org/wiki/Comma-separated_values) with a
`question` column, an `answer` column and an `hint/example` column
(optional).

For example, you could make a spreadsheet of 30 basic expressions in
French (the CSV file is already into the package).

![](man/figures/screenshot1.png)

The spreadsheet should be saved into the `extdata` directory of the
package.

To open the directory, simply run the `learn_dir()` function.

``` r
library(polyglot)

learn_dir()
```

To launch the learning environment, run the `learn()` function. Then
choose in the interactive menu the file you want to study.

``` r
learn() # to launch the interactive learning environment
```

The GIF below shows the learning of the CSV file
`French_30_Basic_Expressions.csv`.

![](man/figures/screenshot2.gif)

For more information on how to use **polyglot**, please read the
vignette.

Happy learning\!
