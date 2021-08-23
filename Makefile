source_scripts := $(wildcard src/*.sh)
source_doc_scripts := $(wildcard src-doc/*.sh)
build_dir := target
cleanup_paths := docs $(build_dir)

.PHONY: all clean doc lint test package purge

all: lint test doc package

clean:
	rm -rf $(cleanup_paths)

purge: clean
	rm -f shell-utilities-*.tar.gz

doc:
	doxygen Doxyfile

lint:
	shellcheck -s sh -e SC2039 $(source_scripts)
	shellcheck -s sh -e SC2034,SC2039 $(source_doc_scripts)

test:
	shellspec -s bash -f tap --kcov

package: shell-utilities.tar.gz ;

$(build_dir):
	mkdir -p $@

$(build_dir)/shell-utilities: $(build_dir) $(source_scripts)
	mkdir -p $(build_dir)/shell-utilities
	cp $(source_scripts) $(build_dir)/shell-utilities

shell-utilities.tar.gz: $(build_dir)/shell-utilities
	tar -czf $@ -C $(build_dir) shell-utilities
