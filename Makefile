SWIFT_PACKAGE_VERSION := $(shell swift package tools-version)

# Lint fix and format code.
.PHONY: lint-fix
lint-fix:
	mint run swiftlint --fix --quiet
	mint run swiftformat --quiet --swiftversion ${SWIFT_PACKAGE_VERSION} .
