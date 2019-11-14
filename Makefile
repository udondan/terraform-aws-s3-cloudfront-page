all:
	@echo "release?"

VERSION := $(shell cat VERSION)

tag:
	@git tag -a "$(VERSION)" -m 'Creates tag "$(VERSION)"'
	@git push --tags

untag:
	@echo "Are you sure you want to DELETE the current tag $(VERSION)? [y/N] " && read ans && [ $${ans:-N} == y ]
	@git push --delete origin "$(VERSION)"
	@git tag --delete "$(VERSION)"

## :
## release: Release a new version, as defined in the file VERSION
release: tag

## re-release: Replace current version
re-release: untag tag
