IN_FILE            = many-headings.md
GIST_REQUEST_FILE  = gist_request.json
GIST_RESPONSE_FILE = gist_response.json
GIST_URI_FILE      = rendered_uri.txt
RENDERED_FILE      = many-headings.html
TESTS_FILE         = tests.json
TEST_SCRIPT        = test.js

RENDER_TIME = 5

all default help:
	@echo "Usage:"
	@echo ""
	@echo "    make test      test the slugify function in $(TEST_SCRIPT)"
	@echo ""
	@echo "    make input     generate $(IN_FILE)"
	@echo "    make render    generate $(RENDERED_FILE) from $(IN_FILE)"
	@echo "    make tests     generate JSON test cases ($(TESTS_FILE)) from $(RENDERED_FILE)"
	@echo ""
	@echo "    make clean     remove generated files"
	@echo "    make nuke      same as 'clean', but also remove cached gist files"
	@echo "    make help      print this help text"

test: $(TEST_SCRIPT) $(TESTS_FILE)
	node $(TEST_SCRIPT) $(TESTS_FILE)

input: $(IN_FILE)
render: $(RENDERED_FILE)
tests: $(TESTS_FILE)

$(TESTS_FILE): $(RENDERED_FILE) make-tests.py
	python make-tests.py < $(RENDERED_FILE) > $@

$(RENDERED_FILE): $(GIST_URI_FILE)
# NOTE: -L means to follow redirects
	curl -L `cat $(GIST_URI_FILE)` > $@

$(GIST_URI_FILE): $(GIST_RESPONSE_FILE) Makefile
	grep "\"html_url\": \"https://gist.github.com/" $(GIST_RESPONSE_FILE) | cut -c 16-71 > $@

$(GIST_RESPONSE_FILE): $(GIST_REQUEST_FILE)
# NOTE: --data strips whitespace, and --data-binary doesn't
	curl -X POST -H "Content-Type: application/json" --data-binary "@$(GIST_REQUEST_FILE)" "https://api.github.com/gists" > $@
	@echo Waiting $(RENDER_TIME) seconds for the page to render...
	sleep $(RENDER_TIME)

$(GIST_REQUEST_FILE): $(IN_FILE)
	printf "{\"description\":\"A file with many headings.\",\"public\":true,\"files\":{\"reghmd.md\":{\n" > $@
	printf "\"content\":" >> $@
	python -c "import sys, json; sys.stdout.write(json.dumps(sys.stdin.read()))" < $(IN_FILE) >> $@
	printf "\n}}}" >> $@

$(IN_FILE): headings.py
	python headings.py > $@

clean:
	$(RM) $(RENDERED_FILE)
	$(RM) $(TESTS_FILE)

nuke: clean
	$(RM) $(IN_FILE)
	$(RM) $(GIST_REQUEST_FILE)
	$(RM) $(GIST_RESPONSE_FILE)
	$(RM) $(GIST_URI_FILE)
