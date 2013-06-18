class @SearchResult
  constructor: (@name) ->
    @loaded = true
    @pages = 0
    @perPage =  0
    @currentPageNumber = 0
    @data = null

  loading: ->
    @loaded = false

  update: (result) ->
    @data = result
    @pages = 6
    @perPage = 10
    @currentPageNumber = 1
    @loaded = true

