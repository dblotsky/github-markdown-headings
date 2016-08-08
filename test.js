var fs = require('fs');

function slugifyLikeGitHub(originalText) {

    var text = originalText;

    // convert to lowercase
    text = text.toLowerCase();

    // replace spaces with dashes
    text = text.replace(/ /g, '-');

    // remove unaccepted characters
    // NOTE:
    //      a better regex would have been /[^\d\s\w-_]/ug, but the 'u' flag
    //      (Unicode) is not supported in some browsers, and we support
    //      many languages that use Unicode characters
    text = text.replace(/[\[\]\(\)\=\;\:\+\?\!\.\,\{\}\\\/\>\<\"\']/g, '');

    // trim remaining whitespace
    text = text.trim();

    return text;
}

function main() {

    // get tests
    var tests_file = process.argv[2];
    var tests      = JSON.parse(fs.readFileSync(tests_file));

    console.log("running " + tests.length + " tests");
    for (var i = 0; i < tests.length; i++) {
        var test = tests[i];

        // replace HTML in title
        var title = test.in
            .replace(/<[^>]+>/, '')
            .replace(/<\/[^>]+>/, '')
            .replace(/&amp;/, '&')
            .replace(/&gt;/, '<')
            .replace(/&lt;/, '>')
            ;

        // test the function
        var slug = slugifyLikeGitHub(title);

        if (test.out !== slug) {
            console.error("'" + test.in + "' became '" + slug + "', but should be '" + test.out + "'");
        }
    }
}

if (require.main === module) {
    main();
}
