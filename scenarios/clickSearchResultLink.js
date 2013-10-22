exports.run = function (casper, scenario,step, c, p, t, x) {

    c.logWithTime(scenario, step, ' inside run');

    casper.waitForSelector(c.selectors.googleSearchResultLink,
        function () {
            casper.click(c.selectors.googleSearchResultLink);
            casper.then(function () {
                c.logWithTime(scenario, step, ' about to call passed');
                p(casper, step);
            });
        },
        function () {
            c.logWithTime(scenario, step, ' about to call timeout');
            t(casper, step);
        });
};