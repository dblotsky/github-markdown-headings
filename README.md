# Description

This is a test harness to produce an HTML heading ID generator that is as functionally identical to GitHub's as possible by reverse-engineering what GitHub does. The generator itself is the function `slugifyLikeGitHub` inside [test.js](./test.js).

# Usage

1. `make test`
2. ... change `slugifyLikeGitHub` ...
3. `make test`
4. ...

# Implementation

The generator is tested by comparing its outputs with GitHub's for a large number of generated headings like so:

1. Generate `many-headings.md` using [headings.py](./headings.py)
2. Create a GitHub Gist from `many-headings.md` and download it as rendered by GitHub into `many-headings.html`
3. Generate test cases from `many-headings.html` using [make-tests.py](./make-tests.py), and put them into `tests.json`
4. Test `test.js` against `tests.json`

# Caveats

GitHub's rate-limiting on unauthenticated Gists only allows 60 requests per hour. That means that this harness lets you change your set of headings 60 times per hour. The good news are that as long as
