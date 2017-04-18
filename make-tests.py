import sys
import re
import json

def main():

    tests = []

    # read stdin line by line
    for line in sys.stdin:

        # process <h1> lines
        if line.startswith('<h1>'):

            # extract the title and its fragment name
            fragment_name, title = re.match(r'^.*href="#([^"]*)".*a>(.*)</h1>$', line).groups()

            # remove digit suffix from fragment name
            match = re.match(r'^(.*)(-\d+)$', fragment_name)
            if match is not None:
                fragment_name = match.group(1)

            # remove HTML entities from title
            title = title.replace('&lt;', '<')
            title = title.replace('&gt;', '>')

            # create the test
            test = {
                'in':  title,
                'out': fragment_name
            }
            tests.append(test)

    print json.dumps(tests)

if __name__ == '__main__':
    main()
