exports.get = ->
  #    common criteria list
  criteriaList = {}
  criteriaList.googleSearch =
    bdd:
      GIVEN: 'Browsed to google.com'
      WHEN: "Searched for \'bleach report\'"
      THEN: 'Search results should be visible'
    steps: ["googleSearch"]

  criteriaList.browseToSearchResult =
    steps: ['googleSearch', 'clickSearchResultLink']

  criteriaList.navigateToBleachReportNavLink  =
      bdd:
        GIVEN: 'Browsed to site from google search result link'
        WHEN: 'Nav Toggle Button clicked'
        THEN: 'Side nav should be visible'
      forDeviceType: "phone"
      steps: ['browseToSearchResult','clickNavToggleBtn']

  criteriaList.navigateToWWEHome  =
      forDeviceType: "phone"
      steps: ['navigateToBleachReportNavLink', 'clickWWENavLink','clickWWESubNavLink']

  criteriaList

