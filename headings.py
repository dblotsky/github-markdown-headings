import cgi

# special characters
SYMBOLS = '.,/\\!?=+-_<>[]{}():;\'\"'

# plain text to insert
TEXT = 'TestText'

# generate a bunch of heading permutations
def headings(symbol):
    for whitespace in [' ', '\t', '  ', '\t ']:
        for s in [symbol, symbol + symbol]:
            yield '{s}'.format(s=s, t=TEXT, w=whitespace)
            yield '{w}{s}{w}'.format(s=s, t=TEXT, w=whitespace)
            yield '{t}{s}{t}'.format(s=s, t=TEXT, w=whitespace)
            yield '{t}{w}{s}{w}{t}'.format(s=s, t=TEXT, w=whitespace)
            yield '{w}{s}{w}{t}{w}{s}{w}'.format(s=s, t=TEXT, w=whitespace)

def main():

    # print generated headings
    for symbol in SYMBOLS:
        for heading in headings(symbol):
            print '#' + heading
            print '<h1>' + cgi.escape(heading) + '</h1>'

    # print manually crafted headings
    print '#   -hello'
    print '#    hello'
    print '# &nbsp;-hello'
    print '# &nbsp;hello'
    print '# &nbsp; -hello'
    print '# &nbsp;  hello'
    print '# &nbsp;  -hello'
    print '# &nbsp;   hello'
    print '<h1>  hello  </h1>'
    print '<h1>  -hello  </h1>'
    print '<h1>  - hello  </h1>'

if __name__ == '__main__':
    main()
