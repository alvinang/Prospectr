root = global ? window
angular = root.angular

filters = angular.module 'prospectorFilters', []

filters.filter 'tweetError', ->
  (result) ->
    result.status == 403

filters.filter 'pagination', ->
  (array, pageSize, pageNumber) ->
    if array
      start_index = pageSize * pageNumber
      end_index = start_index + pageSize

      result_array = array.slice start_index, end_index
      result_array


