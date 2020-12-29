all: style dialyzer test docs
.PHONY: update-deps style dialyzer test
update-deps:
	mix deps.update --all
style:
	mix format --check-formatted
	mix credo --strict
dialyzer:
	mix dialyzer
test:
	mix coveralls.html
docs:
	mix docs
