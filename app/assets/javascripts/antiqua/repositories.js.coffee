$( 'a[ id ^= "repo-" ]' ).click ( e ) ->
  target = $ e.target
  $.ajax
    data:
      github_repository_id:      target.data 'repository-id'
      github_repository_name:    target.data 'repository-name'
      github_repository_ssh_url: target.data 'repository-ssh-url'
    type: 'POST'
    url: target.data 'archive-url'

Antiqua.changePage 'Repositories'
