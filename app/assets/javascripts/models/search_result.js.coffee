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
    @doublePages = 3
    @perPage = 10
    @currentPageNumber = 1
    @loaded = true

    console.log 'LEN : ', @data
    console.log 'LEN : ', @data.length

    if @data.length % 2 == 0
      @doublePerPage = @data.length / 2
    else
      @doublePerPage = @data.length / 2 + 1

    console.log 'DBP : ', @doublePerPage

  nextPageNumber: ->
    @currentPageNumber + 1


  doubleCurrentPage: ->
    currentPageIndex = @currentPageNumber - 1
    currentPageIndex * 2


  doubleNextPage: ->
    @doubleCurrentPage() + 1





