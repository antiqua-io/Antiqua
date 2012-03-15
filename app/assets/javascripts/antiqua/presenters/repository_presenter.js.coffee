class Antiqua.RepositoryPresenter
  constructor: ( raw_repository ) ->
    @raw_repository = raw_repository

  present: ->
    archives: @presentArchives()

  presentArchive: ( archive ) ->
    is_finished = archive.state is 'finished'
    to_return   =
      btn_class:    if is_finished then 'btn-success' else 'disabled'
      btn_href:     "/archives/#{archive.id}/tar_ball"
      btn_text:     if is_finished then 'Download' else 'Working'
      created_at:   archive.created_at
      id:           archive.id
      label_class:  if is_finished then 'label-success' else 'label-info'
      pretty_state: archive.pretty_state

  presentArchives: ->
    archives = []
    for archive in @raw_repository.archives
      archives.push @presentArchive( archive )
    archives
