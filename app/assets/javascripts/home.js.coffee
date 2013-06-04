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

  $scope.timeline = (screen_name) ->
    timeline_call = $http(
      url: "/home/twitter_timeline_search?screen_name=" + screen_name
      method: "GET"
    )

    timeline_call.success (data, status, headers, config) ->
      $scope.screen_names[screen_name] =
        data: data
        status: status

    timeline_call.error (data, status, header, config) ->
      $scope.screen_names[screen_name] =
        data: data
        status: status

  $scope.initialize_screen_name = (screen_name) ->
    $scope.screen_names[screen_name] =
      data: new Array()
      status: 'None'

  $scope.fetch_timelines = (results) ->
    $scope.screen_names = {}

    for result in results
      console.log result.screen_name
      console.log result.toString
      $scope.initialize_screen_name(result.screen_name)
    for result in results
      $scope.timeline(result.screen_name)

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
      $scope.linkedInFeedResultsPages = 6
      $scope.linkedInFeedResultsPageSize = 10
      $scope.linkedInFeedResultsCurrentPage = 1
      $scope.linkedInResultsLoaded = true

    $http(
      url: "/home/google_news_feed?query=" + $scope.company
      method: "GET"
    ).success (data, status, headers, config) ->
      $scope.googleNewsFeedResults = data
      $scope.googleNewsFeedResultsPages = 6
      $scope.googleNewsFeedResultsPageSize = 10
      $scope.googleNewsFeedResultsCurrentPage = 1
      $scope.googleNewsFeedResultsLoaded = true

    $http(
      url: "/home/twitter_search?query=" + $scope.company
      method: "GET"
    ).success (data, status, headers, config) ->
      $scope.fetch_timelines(data)
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
