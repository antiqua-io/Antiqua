class RepositoriesPage extends Antiqua.GenericPage
  init: ->
    @deferred = new $.Deferred
    @startPoller()
    @deferred.resolve()

  startPoller: -> new Antiqua.RepositoriesPoller

Antiqua.registerPage 'Repositories' , RepositoriesPage
