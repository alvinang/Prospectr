root = global ? window
angular = root.angular

HomeCtrl = ($scope, $http) ->
  $scope.company = ""
  $scope.job_title = ""
  $scope.name = ""
  $scope.results = []

  $scope.twitterResults = new SearchResult('Twitter')
  $scope.linkedInResults = new SearchResult('LinkedIn')
  $scope.googleNewsResults = new SearchResult('GoogleNews')
  $scope.emailFormatResults = new SearchResult('EmailFormat')

  $scope.email = ''
  $scope.valid = "ban-circle"

  $scope.verify_email = ->

    $scope.email_verifier_loading = true

    check_validity = $http(
      url: "/home/email_verifier?email=" + $scope.email
      method: "GET"
    )

    check_validity.success (data, status, headers, config) ->
      $scope.valid = "ok"
      $scope.email_verifier_loading = false

    check_validity.error (data, status, headers, config) ->
      $scope.valid = "ban-circle"
      $scope.email_verifier_loading = false

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
      $scope.initialize_screen_name(result.screen_name)
    for result in results
      $scope.timeline(result.screen_name)

  $scope.search = ->
    $scope.twitterResults.loading()
    $scope.linkedInResults.loading()
    $scope.googleNewsResults.loading()
    $scope.emailFormatResults.loading()

    $http(
      url: "/home/linked_in_search?query=" + $scope.company + '&description=' + $scope.job_title
      method: "GET"
    ).success (data, status, headers, config) ->
      $scope.linkedInResults.update(data)

    $http(
      url: "/home/google_news_feed?query=" + $scope.company
      method: "GET"
    ).success (data, status, headers, config) ->
      $scope.googleNewsResults.update(data)

    $http(
      url: "/home/twitter_search?query=" + $scope.company
      method: "GET"
    ).success (data, status, headers, config) ->
      $scope.fetch_timelines(data)
      $scope.twitterResults.update(data)


    $http(
      url: "/home/email_format_search?query=" + $scope.company
      method: "GET"
    ).success (data, status, headers, config) ->
      $scope.emailFormatResults.update(data)


HomeCtrl.$inject = ['$scope', "$http"];

# exports
root.HomeCtrl = HomeCtrl
