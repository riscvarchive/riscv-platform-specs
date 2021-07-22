#
#	Build usable docs
#

ASCIIDOCTOR = asciidoctor
DITAA = ditaa
IMAGES = pcie-topology.png
PLATFORM_SPEC = riscv-platform-spec
PANDOC = pandoc
PARTS = changelog.adoc contributors.adoc introduction.adoc licensing.adoc

# Build the platform spec in several formats
all: $(IMAGES) $(PLATFORM_SPEC).md $(PLATFORM_SPEC).pdf $(PLATFORM_SPEC).html

%.png: %.ditaa
	rm -f $@
	$(DITAA) $<

$(PLATFORM_SPEC).md: $(PLATFORM_SPEC).xml
	$(PANDOC) -f docbook -t markdown_strict $< -o $@ 

$(PLATFORM_SPEC).xml: $(PLATFORM_SPEC).adoc
	$(ASCIIDOCTOR) -d book -b docbook $<

$(PLATFORM_SPEC).pdf: $(PLATFORM_SPEC).adoc $(IMAGES)
	$(ASCIIDOCTOR) -d book -r asciidoctor-pdf -b pdf $<

$(PLATFORM_SPEC).html: $(PLATFORM_SPEC).adoc $(IMAGES)
	$(ASCIIDOCTOR) -d book -b html $<

$(PLATFORM_SPEC).adoc: $(PARTS)
	touch $@

clean:
	rm -f $(PLATFORM_SPEC).xml
	rm -f $(PLATFORM_SPEC).md
	rm -f $(PLATFORM_SPEC).pdf
	rm -f $(PLATFORM_SPEC).html
	rm -f $(IMAGES)

# handy shortcuts for installing necessary packages: YMMV
install-debs:
	sudo apt-get install pandoc asciidoctor ditaa ruby-asciidoctor-pdf

install-rpms:
	sudo dnf install ditaa pandoc rubygem-asciidoctor rubygem-asciidoctor-pdf
