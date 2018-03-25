
The {polyglot} package lets you use the R console as an interactive learning environment in order to memorize any dataset you want. Its main goal is to put foreign language vocabulary learning in the R workflow, so R can also be used to study languages or anything related to flashcards.

### Install polyglot

To install and run polyglot, type the following in the R console:

```
install.packages("polyglot")
library(polyglot)
learn() # to launch the interactive learning environment
```

### Set the appropriate encoding

Before launching the interactive environment, be sure to have the appropriate locale settings.

To study French for instance, type the following in the R console:

```
Sys.setlocale("LC_TIME", "French")      # for Windows
Sys.setlocale("LC_TIME", "fr_FR")       # for macOS
Sys.setlocale("LC_TIME", "fr_FR.utf8")  # for Modern Linux etc.
```

### Add your own datasets

If you want to open the directory containing the datasets to add yours, type the following:

```
library(polyglot)
learnDir()
```

Go [here](https://lgnbhl.github.io) to read a blog post describing the package with more development. 

Happy learning!
