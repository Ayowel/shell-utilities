source_scripts := $(wildcard src/*.sh)
source_doc_scripts := $(wildcard src-doc/*.sh)
build_dir := target
cleanup_paths := docs $(build_dir)

.PHONY: all clean doc lint package purge
.PRECIOUS: shell-utilities-%.tar.gz

all: lint doc package

clean:
	rm -rf $(cleanup_paths)

purge: clean
	rm -f shell-utilities-*.tar.gz

doc:
	doxygen Doxyfile

lint:
	shellcheck -s bash $(source_scripts)
	shellcheck --shell bash -e 2034 $(source_doc_scripts)

package: package-dev

package-%: shell-utilities-%.tar.gz ;

$(build_dir):
	mkdir -p $@

$(build_dir)/shell-utilities: $(build_dir)
	test -e $@ || ( cd $(build_dir) && ln -sf ../src shell-utilities )

shell-utilities-%.tar.gz: $(build_dir)/shell-utilities
	tar -czf $@ -C $(build_dir) shell-utilities
