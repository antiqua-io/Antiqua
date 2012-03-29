class Antiqua.RepositoriesPoller
  callback: null
  stop_flag: false

  constructor: ( opts ) ->
    @callback = opts.callback

  fetchAndUpdateRepositories: ->
    @fetchRepositories().success ( response ) =>
      @callback response

  fetchRepositories: ->
    org  = Antiqua.Helpers.getUrlParameterByName 'org'
    path = '/repositories.json?type=local'
    path = if org.length > 0 then "#{ path }&org=#{ org }" else path
    $.getJSON path

  start: ->
    @stop_flag = false
    poller = =>
      unless @stop_flag
        @fetchAndUpdateRepositories()
        @start()
    setTimeout poller , 2000

  stop: -> @stop_flag = true
