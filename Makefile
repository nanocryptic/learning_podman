.phony : start install_jupyter_tools trust markdown markdown_no_color

NB_EXPORT_FORMAT ?= markdown

start: trust
	jupyter notebook

trust:
	jupyter trust *.ipynb


install_jupyter_tools:
	pip3 install -r jupyter_tools/requirements.txt

markdown:
	jupyter nbconvert *.ipynb --to markdown
	mkdir -p doc
	mv *_*.md doc

markdown_no_color: markdown
	./scripts/clean_color_escape_chars.sh
