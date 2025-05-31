PREFIX ?= /usr/local

install:
	install -Dm755 src/file2prompt.sh $(DESTDIR)$(PREFIX)/bin/file2prompt
	install -Dm644 man/file2prompt.1 $(DESTDIR)$(PREFIX)/share/man/man1/file2prompt.1
	gzip -f $(DESTDIR)$(PREFIX)/share/man/man1/file2prompt.1

flatpak-build:
	flatpak-builder build com.traineratwot.File2Prompt.yml --force-clean
	flatpak build-export repo build
	flatpak build-bundle repo file2prompt.flatpak com.traineratwot.File2Prompt

flatpak-run:
	flatpak run com.traineratwot.File2Prompt.yml


clean:
	rm -rf build repo *.flatpak

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/file2prompt
	rm -f $(DESTDIR)$(PREFIX)/share/man/man1/file2prompt.1.gz