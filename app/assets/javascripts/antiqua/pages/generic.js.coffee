class Antiqua.GenericPage
  deferred: null
  params: null

  constructor: ( params ) -> @params = params

  init: ->
    @deferred = new $.Deferred()
    @deferred.resolve()
    @deferred

  load: -> @init().done => @render()

  render: -> null
