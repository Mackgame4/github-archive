all: run

#platform = $(shell uname | tr A-Z a-z) # can be "linux" or "windows"

run: ${platform}-run

compile: ${platform}-compile

clean: ${platform}-clean

windows:
	$(eval platform = windows)
	@echo "Platform set to Windows"
	@make windows-run

linux:
	$(eval platform = linux)
	@echo "Platform set to Linux"
	@make linux-run

# Linux Commands
linux-clean:
	@printf "=====  Cleaning the project  =====\n"
	@rm -rf output
	@rm -f relatorio.pdf

linux-run: 
	@printf "=====  Live Compiling the project  =====\n"
	@make linux-compile
	@while inotifywait -e modify *.tex; do make compile; done

linux-compile:
	@printf "=====  Compiling the project  =====\n"
	@mkdir -p output 
	@pdflatex -output-directory ./output -synctex 1 -interaction nonstopmode main.tex
	@[ -f ./output/main.pdf ] && cp ./output/main.pdf relatorio.pdf

# Windows Commands
windows-clean:
	@echo off
	@echo "=====  Cleaning the project  ====="
	@rmdir /s /q output
	@del relatorio.pdf

windows-run:
	@echo off
	@echo "=====  Live Compiling the project  ====="
	@make windows-compile
	@echo "Live compiling is not available on Windows. Please use a Latex editor with live preview. Or manually open the file after compiling."

windows-compile:
	@echo off
	@echo "=====  Compiling the project  ====="
	@if not exist "output" mkdir "output"
	@pdflatex -output-directory ./output -synctex 1 -interaction nonstopmode main.tex
	@if exist "output\main.pdf" copy "output\main.pdf" relatorio.pdf

# Install Dependencies
install-deps: install-deps-${platform}

install-latex-packages:
	@tlmgr init-usertree
	@tlmgr option repository ctan
	@tlmgr update --self
	@tlmgr update --all
	@tlmgr install hyphenat amsmath
	@tlmgr install --reinstall koma-script

install-deps-linux: install-deps-ubuntu

install-deps-ubuntu:
	@printf "=====  Installing texlive & inotify-tools packages on Ubuntu  =====\n"
	@sudo apt install texlive-latex-base texlive-fonts-recommended texlive-lang-portuguese inotify-tools
	@make install-latex-packages

install-deps-arch:
	@printf "=====  Installing texlive & inotify-tools packages on Arch  =====\n"
	@sudo pacman --needed -S texlive-basic texlive-fontsrecommended inotify-tools
	@make install-latex-packages

install-deps-windows:
	@echo off
	@echo "=====  Installing TexLive on Windows ====="
	@echo "Download the installer from https://www.tug.org/texlive/acquire-netinstall.html"
	@echo "or using the mirror from https://mirror.ctan.org/systems/texlive/tlnet/install-tl-windows.exe"
	@echo "or using chocolatey: choco install texlive"
	@echo "After installing, run the command 'make install-latex-packages'"