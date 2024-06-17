# Requirements

<!-- Não confundir plain tex (xetex, pdftex, etc) com latex (lualatex, pdflatex, etc) -->

<!-- - [MikTeX (Windows only)](https://miktex.org/) -->
- [TeX Live](https://www.tug.org/texlive/)
- [LateX](https://www.latex-project.org/)
- [LuaTeX](https://www.luatex.org/)

## Install (Ubuntu/Debian/Linux)

#### Install LateX

<!-- sudo apt install texlive-latex-base -y -->
```bash
sudo apt install texlive-latex-extra -y
```

#### Install LuaTeX

```bash
sudo apt install texlive-luatex -y
```

#### Install Portuguese Language

```bash
sudo apt install texlive-lang-portuguese -y
```

#### Install Font types (Arial, Times New Roman, etc)

```bash
sudo apt install ttf-mscorefonts-installer -y
```

## Install (Windows)

#### Install LateX

- [TeX Live](https://www.tug.org/texlive/windows.html) or directly using: [TeX Live (Windows mirror)](https://mirror.ctan.org/systems/texlive/tlnet/install-tl-windows.exe)

(Note: LuaTeX should already be included in TeX Live, but if not, you can install it using the TeX Live Manager)

If you want you can choose the "Advanced" installation and select the packages you want to install. You can also choose to install the full version or as recommended for this project, you can install the "minimal" or "basic" version and install the packages you need later.

#### Important: If you ran the installer in user mode, you need to change your PATH to include the TeX Live binaries.
"Control Panel" -> "System" -> "Advanced system settings" -> "Environment Variables" -> "System variables" -> "Path" -> "Edit" -> "New" -> "C:\texlive\<texlive_year>\bin\windows" (or the path where you installed TeX Live)

#### Install LuaTeX

```bash
tlmgr install luatex
```

or, using XeTeX:

```bash
tlmgr install xetex
```

#### Install Portuguese Language

```bash
tlmgr install babel-portuges
```

#### Install Font types (Arial, Times New Roman, etc)

```bash
tlmgr install collection-fontsrecommended
```

#### Make sure basic packages are installed (To fix some errors)

<!-- tlmgr update --system -->
```bash
tlmgr update --self
tlmgr update --all
tlmgr install fontspec babel geometry xcolor arydshln nomencl xkeyval background pgf everypage
tlmgr install --reinstall koma-script
```

- More packages can be installed using the TeX Live Manager (tlmgr) and the [CTAN](https://ctan.org/)

# Build

#### Using LuaTeX (Recommended)
```bash
lualatex -output-directory=output -synctex=1 -interaction=nonstopmode -file-line-error main.tex
```

or:

#### Using VS Code [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) (includes Hot Reload for LaTeX files)

- Intall the [extension](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)
- Install [latexmk](https://mg.readthedocs.io/latexmk.html):
```bash
sudo apt install latexmk -y
export PATH="/path/to/latexmk/directory:$PATH"
source ~/.bashrc
```

- Change your config file:
```json
{
    "latex-workshop.latex.recipes": [
        {
            "name": "lualatex",
            "tools": [
                "lualatex"
            ]
        }
    ],
    "latex-workshop.latex.tools": [
        {
            "name": "lualatex",
            "command": "lualatex",
            "args": [
                "-output-directory=output",
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "%DOC%"
            ]
        }
    ]
}
```

or:

#### Using XeTeX

```bash
xelatex -output-directory=output -synctex=1 -interaction=nonstopmode -file-line-error main.tex
```