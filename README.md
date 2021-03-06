# Description

This is a test harness to produce an HTML heading ID generator that is as functionally identical to GitHub's as possible by reverse-engineering what GitHub does. The generator itself is the function `slugifyLikeGitHub` inside [test.js](./test.js).

# Usage

    make test

# Implementation

The generator is tested by comparing its outputs with GitHub's for a large number of generated headings, like so:

1. Generate `many-headings.md` using [headings.py](./headings.py)
2. Create a GitHub Gist from `many-headings.md`
3. Download the rendered Gist into `many-headings.html`
3. Make `tests.json` from `many-headings.html` using [make-tests.py](./make-tests.py)
4. Test `test.js` using the cases in `tests.json`

# Caveats

GitHub's rate-limiting on unauthenticated requests only allows 60 requests per hour. That means that this harness lets you change your *set of headings* (i.e. the output of `headings.py`) at most 60 times per hour. However the harness caches the rendered result, so testing won't eat up limits unless `headings.py` is changed.
