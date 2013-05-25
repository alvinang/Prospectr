root = global ? window
angular = root.angular

HomeCtrl = ($scope, $http) ->
  $scope.company = ""
  $scope.job_title = ""
  $scope.name = ""
  $scope.results = []
  $scope.twitterSearchResultsLoaded = true
  $scope.linkedInResultsLoaded = true
  $scope.googleNewsFeedResultsLoaded = true

  $scope.search = ->
    console.log "searching"
    $scope.twitterSearchResultsLoaded = false
    $scope.linkedInResultsLoaded = false
    $scope.googleNewsFeedResultsLoaded = false

    $http(
      url: "/home/linked_in_search?query=" + $scope.company
      method: "GET"
    ).success (data, status, headers, config) ->
      $scope.linkedInResults = data
      $scope.linkedInResultsLoaded = true

    $http(
      url: "/home/google_news_feed?query=" + $scope.company
      method: "GET"
    ).success (data, status, headers, config) ->
      $scope.googleNewsFeedResults = data
      $scope.googleNewsFeedResultsLoaded = true

    $http(
      url: "/home/twitter_search?query=" + $scope.company
      method: "GET"
    ).success (data, status, headers, config) ->
      $scope.twitterSearchResults = data
      $scope.twitterSearchResultsLoaded = true


HomeCtrl.$inject = ['$scope', "$http"];

# exports
root.HomeCtrl = HomeCtrl
