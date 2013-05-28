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
  $scope.emailFormatSearchResultsLoaded = true

  $scope.search = ->
    $scope.twitterSearchResultsLoaded = false
    $scope.linkedInResultsLoaded = false
    $scope.googleNewsFeedResultsLoaded = false
    $scope.emailFormatSearchResultsLoaded = false

    $http(
      url: "/home/linked_in_search?query=" + $scope.company + '&description=' + $scope.job_title
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

    $http(
      url: "/home/email_format_search?query=" + $scope.company
      method: "GET"
    ).success (data, status, headers, config) ->
      $scope.emailFormatSearchResults = data
      $scope.emailFormatSearchResultsLoaded = true


HomeCtrl.$inject = ['$scope', "$http"];

# exports
root.HomeCtrl = HomeCtrl
