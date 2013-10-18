exports.run = function (casper, scenario, step, c, p, t) {
    // google search for 'bleacher report'
    c.logWithTime(scenario, step, ' inside run');
    casper.waitForSelector(c.selectors.googleSearchForm,
        function () {
            casper.fill(c.selectors.googleSearchForm, { q: "bleacher report" }, true);
            casper.then(function () {
                c.logWithTime(scenario, step, ' about to call passed');
                p(casper, step);
            });
        },
        function () {
            c.logWithTime(scenario, step, ' about to call failed');
            t(casper, step);
        });
};
