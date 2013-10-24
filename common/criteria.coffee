exports.get = ->
  #    common criteria list
  criteriaList = {}
  criteriaList.googleSearch =
    steps: ["googleSearch"]

  criteriaList.browseToSearchResult =
    steps: ['googleSearch', 'clickSearchResultLink']

  criteriaList.navigateToBleachReportNavLink  =
      forDeviceType: "phone"
      steps: ['browseToSearchResult','clickNavToggleBtn']

  criteriaList.navigateToWWEHome  =
      forDeviceType: "phone"
      steps: ['navigateToBleachReportNavLink', 'clickWWENavLink','clickWWESubNavLink']

  criteriaList

