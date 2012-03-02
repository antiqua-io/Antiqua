class Antiqua.RepositoriesPoller
  callback: null

  constructor: ( opts ) ->
    @callback = opts.callback
    @startPolling()

  fetchAndUpdateRepositories: ->
    @fetchRepositories().success ( response ) =>
      @callback response

  fetchRepositories: -> $.getJSON '/repositories.json'

  startPolling: ->
    poller = =>
      @fetchAndUpdateRepositories()
      @startPolling()
    setTimeout poller , 2000
