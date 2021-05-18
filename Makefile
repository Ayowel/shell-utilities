source_scripts = $(wildcard src/*.sh)
source_doc_scripts = $(wildcard src-doc/*.sh)

.PHONY: all clean doc lint

all: lint doc

clean:
	rm -rf docs

doc:
	doxygen Doxyfile

lint:
	shellcheck -s bash src/*
	shellcheck --shell bash -e 2034 $(source_doc_scripts)
