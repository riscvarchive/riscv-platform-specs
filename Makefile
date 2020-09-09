#
#	Build usable docs
#

ASCIIDOCTOR = asciidoctor
OSPS_SPEC = riscv-osps
PANDOC = pandoc
PARTS = licensing.adoc contributors.adoc changelog.adoc

# Build the OSPS
all: $(OSPS_SPEC).md $(OSPS_SPEC).pdf $(OSPS_SPEC).html

$(OSPS_SPEC).md: $(OSPS_SPEC).xml
	$(PANDOC) -f docbook -t markdown_strict $< -o $@ 

$(OSPS_SPEC).xml: $(OSPS_SPEC).adoc
	$(ASCIIDOCTOR) -d book -b docbook $<

$(OSPS_SPEC).pdf: $(OSPS_SPEC).adoc
	$(ASCIIDOCTOR) -d book -r asciidoctor-pdf -b pdf $<

$(OSPS_SPEC).html: $(OSPS_SPEC).adoc
	$(ASCIIDOCTOR) -d book -b html $<

$(OSPS_SPEC).adoc: $(PARTS)
	touch $@

clean:
	rm -f $(OSPS_SPEC).xml
	rm -f $(OSPS_SPEC).md
	rm -f $(OSPS_SPEC).pdf
	rm -f $(OSPS_SPEC).html

install-debs:
	sudo apt-get install pandoc asciidoctor ruby-asciidoctor-pdf

install-rpms:
	sudo dnf install pandoc rubygem-asciidoctor rubygem-asciidoctor-pdf

