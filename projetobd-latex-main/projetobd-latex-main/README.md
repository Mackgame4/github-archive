# Projeto BD

This project is a report for the subject of "Bases de Dados", which is part of the "Engenharia Informática" course at the "University of Minho".

## Getting Started on Windows

### Requirements

- [LiveTex](https://www.tug.org/texlive/windows.html) or from the [mirror](https://ctan.org/systems/texlive/tlnet/install-tl-windows.exe)
- [Make on Windows](http://gnuwin32.sourceforge.net/packages/make.htm) or [Cygwin](https://www.cygwin.com/)

- #### ATTENTION: If you ran the installer in user mode, you need to change your PATH to include the TeX Live binaries and the "make" binaries.
###### For Live Tex go to "Control Panel" -> "System" -> "Advanced system settings" -> "Environment Variables" -> "System variables" -> "Path" -> "Edit" -> "New" -> "```C:\texlive\<texlive_year>\bin\windows```" (or the path where you installed TeX Live); or do it directly on your to your Windows PATH variables

###### And for "make" add your install folder or the default paht "```C:\Program Files (x86)\GnuWin32\bin```"

##### Follow the rest of the instructions on the [Linux](#getting-started-on-linux) section.

## Getting Started on Linux

### Requirements

- [LiveTex](https://www.tug.org/texlive/)
- [Make](https://www.gnu.org/software/make/)

To get all the requirements ready you can run the following script:

```bash
# Windows
$ make platform=windows install-deps
# or:
$ make install-deps-windows

# Ubuntu
$ make platform=linux install-deps
# or:
$ make install-deps-ubuntu

# Arch Linux
$ make install-deps-arch
```

This will install the required packages like `LiveTex` and `inotify-tools`.
And also the LaTeX packages required for the project.
###### You can have more instructions about tlmgr [here](https://www.tug.org/texlive/tlmgr.html) or [here](https://yihui.org/tinytex/)

### Run

If you are editing the file, and you want a live reload of the changes, you can use the live recompile script:

``` bash
$ make [linux|windows]
# or:
$ make platform=[linux|windows]
# or:
$ make [linux|windows]-run
```

### Build

Although if you want to compile the final PDF, use this command:

```bash
$ make platform=[linux|windows] compile
# or:
$ make [linux|windows]-compile
```

Both will export the `relatorio.pdf` at the root project path.

### Clean

If you want to clean the project, you can use the following command:

```bash
$ make platform=[linux|windows] clean
# or:
$ make [linux|windows]-clean
```
