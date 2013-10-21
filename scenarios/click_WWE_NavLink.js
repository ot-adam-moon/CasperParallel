exports.run = function (casper, scenario,step, c, p, t) {

    c.logWithTime(scenario, step, ' inside run');
    casper.waitForSelector(c.selectors.wweNavLink,
        function () {
            casper.click(c.selectors.wweNavLink);
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