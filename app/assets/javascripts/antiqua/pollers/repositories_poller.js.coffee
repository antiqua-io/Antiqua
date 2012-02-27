class Antiqua.RepositoriesPoller
  constructor: -> @startPolling()

  fetchAndUpdateRepositories: ->
    @fetchRepositories().success ( response ) =>
      @updateRepositories response

  fetchRepositories: -> $.getJSON '/repositories.json'

  renderArchives: ( repository ) ->
    if repository.archives.length > 0
      presented = ( new Antiqua.RepositoryPresenter( repository ) ).present()
      rendered = HoganTemplates[ 'antiqua/templates/repository/archives' ].render presented
    else
      rendered = HoganTemplates[ 'antiqua/templates/repository/archives_empty' ].render()
    $( "div#repository-#{ repository.id }-archives" ).html rendered

  startPolling: ->
    poller = =>
      @fetchAndUpdateRepositories()
      @startPolling()
    setTimeout poller , 2000

  updateRepositories: ( server_response ) ->
    @renderArchives repository for repository in server_response
