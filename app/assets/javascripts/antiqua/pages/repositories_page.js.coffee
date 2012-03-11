class RepositoriesPage extends Antiqua.GenericPage
  init: ->
    @deferred = new $.Deferred
    @poller   = new Antiqua.RepositoriesPoller( callback: @pollerCallback )
    @deferred.resolve()

  pollerCallback: ( poller_response ) => @updateRepositories poller_response

  queueArchive: ( $archive_button ) ->
    target        = $archive_button
    repository_id = target.data 'repository-id'
    call          = $.ajax
      data:
        github_repository_id:      repository_id
        github_repository_name:    target.data 'repository-name'
        github_repository_ssh_url: target.data 'repository-ssh-url'
      type: 'POST'
      url: target.data 'archive-url'
    call.error ( response ) ->
      response_data = JSON.parse response.responseText
      user_name = response_data.user_name
      alert_data =
        class:     'error'
        user_name: user_name
      alert = HoganTemplates[ 'antiqua/templates/user/subscription_alert' ].render alert_data
      $( 'div.container.main' ).prepend alert
    call.success =>
      @togglePoller $( '#toggle-poller' )
      @renderLoader $archive_button
      $window = $ 'html,body'
      $scroll_to = $ "#repo-#{ repository_id }-header"
      $window.animate
        scrollTop: $scroll_to.offset().top - $window.offset().top + $window.scrollTop() - 50
      , 1000

  renderArchives: ( repository ) ->
    if repository.archives.length > 0
      presented = ( new Antiqua.RepositoryPresenter( repository ) ).present()
      rendered = HoganTemplates[ 'antiqua/templates/repository/archives' ].render presented
    else
      rendered = HoganTemplates[ 'antiqua/templates/repository/archives_empty' ].render()
    $( "div#repository-#{ repository.id }-archives" ).html rendered

  renderLoader: ( $archive_button ) ->
    $loader = $ HoganTemplates[ 'antiqua/templates/repository/archive_loader' ].render()
    $archive_button.hide().after $loader
    animation_props = width: '100%'
    animation_callback = ->
      $loader.remove()
      $archive_button.show()
    $loader.find( '.bar' ).animate animation_props , 3000 , 'linear' , animation_callback

  startPoller: ( $btn ) ->
    if not @poller_running
      @poller_running = true
      @poller.start()
      new_btn = HoganTemplates[ 'antiqua/templates/repository/stop_poller_button' ].render()
      $btn.replaceWith new_btn

  stopPoller: ( $btn ) ->
    if @poller_running
      @poller_running = false
      @poller.stop()
      new_btn = HoganTemplates[ 'antiqua/templates/repository/start_poller_button' ].render()
      $btn.replaceWith new_btn

  togglePoller: ( $btn ) ->
    $btn = if $btn.is( 'i' ) then $btn.parent() else $btn
    return @stopPoller( $btn ) if @poller_running
    @startPoller $btn

  updateRepositories: ( poller_response ) ->
    @renderArchives repository for repository in poller_response

Antiqua.registerPage 'Repositories' , RepositoriesPage
