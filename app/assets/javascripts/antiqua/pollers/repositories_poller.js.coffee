class Antiqua.RepositoriesPoller
  callback: null
  stop_flag: false

  constructor: ( opts ) ->
    @callback = opts.callback

  fetchAndUpdateRepositories: ->
    @fetchRepositories().success ( response ) =>
      @callback response

  fetchRepositories: -> $.getJSON '/repositories.json?type=local'

  start: ->
    @stop_flag = false
    poller = =>
      unless @stop_flag
        @fetchAndUpdateRepositories()
        @start()
    setTimeout poller , 2000

  stop: -> @stop_flag = true
