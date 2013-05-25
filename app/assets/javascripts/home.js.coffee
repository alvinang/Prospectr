root = global ? window
angular = root.angular

HomeCtrl = ($scope, $http) ->
  $scope.company = "Microsoft"
  $scope.job_title = "SDE"
  $scope.name = "Jeff Bezos"
  $scope.results = []

  $scope.search = ->
    console.log "searching"
    $http(
      url: "/home/linked_in_search?query=" + $scope.company
      method: "GET"
    ).success (data, status, headers, config) ->
      $scope.results = data


HomeCtrl.$inject = ['$scope', "$http"];

# exports
root.HomeCtrl = HomeCtrl
