#    common selectors
exports.get = ->
  s = {}
  s.googleSearchForm = 'form[action="/search"]'
  s.googleSearchResultLink = 'ol#rso li:first-child div.rc h3 a'
  s.bleacherReportNavToggle = "div#nav_handle a"
  s.globalNav_WWE_link = 'ul.nav_list li[data-id="wwe"] > a'
  s.subNav_WWE_link = '#sub-nav-region > ul > li:first-child > a'
  s