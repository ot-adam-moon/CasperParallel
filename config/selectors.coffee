#    common selectors
exports.get = ->
  s = {}
  s.googleSearchForm = 'form[action="/search"]'
  s.googleSearchResultLink = 'ol#rso li:first-child div.rc h3.r a'
  s.bleacherReportNavToggle = "div#nav_handle a"
  s.wweNavLink = 'ul.nav_list li[data-id="wwe"] a'
