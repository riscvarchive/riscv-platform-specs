#
#	Build usable docs
#

ASCIIDOCTOR = asciidoctor
PLATFORM_SPEC = riscv-platform-spec
PANDOC = pandoc
PARTS = licensing.adoc

# Build the platform spec in several formats
all: $(PLATFORM_SPEC).md $(PLATFORM_SPEC).pdf $(PLATFORM_SPEC).html

$(PLATFORM_SPEC).md: $(PLATFORM_SPEC).xml
	$(PANDOC) -f docbook -t markdown_strict $< -o $@ 

$(PLATFORM_SPEC).xml: $(PLATFORM_SPEC).adoc
	$(ASCIIDOCTOR) -d book -b docbook $<

$(PLATFORM_SPEC).pdf: $(PLATFORM_SPEC).adoc
	$(ASCIIDOCTOR) -d book -r asciidoctor-pdf -b pdf $<

$(PLATFORM_SPEC).html: $(PLATFORM_SPEC).adoc
	$(ASCIIDOCTOR) -d book -b html $<

$(PLATFORM_SPEC).adoc: $(PARTS)
	touch $@

clean:
	rm -f $(PLATFORM_SPEC).xml
	rm -f $(PLATFORM_SPEC).md
	rm -f $(PLATFORM_SPEC).pdf
	rm -f $(PLATFORM_SPEC).html

# handy shortcuts for installing necessary packages: YMMV
install-debs:
	sudo apt-get install pandoc asciidoctor ruby-asciidoctor-pdf

install-rpms:
	sudo dnf install pandoc rubygem-asciidoctor rubygem-asciidoctor-pdf

