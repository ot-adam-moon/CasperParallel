exports.run = function (casper, scenario, step, c, p, t, x) {

    c.logWithTime(scenario, step, ' inside run');

    casper.mouse.move(c.selectors.bleacherReportNavToggle);
    casper.click(c.selectors.bleacherReportNavToggle);

    casper.wait(1000, function () {
        c.logWithTime(scenario, step, ' about to call passed');
        p(casper, step);
    });
};


