archives_to_poll = []

fetch_and_update_archive = ( archive_id ) ->
  $.ajax
    success: ( response ) -> update_archive response
    type: 'GET'
    url: "/archives/#{ archive_id }"

poll_for_archive_status = ->
  if archives_to_poll.length > 0
    fetch_and_update_archive archive_id for archive_id in archives_to_poll
    setTimeout poll_for_archive_status , 1000

update_archive = ( raw_archive ) ->
  row = $ "#repository-#{ raw_archive.repository_id }-row"
  console.log row

  # New Status Data
  new_status_class = if raw_archive.state is 'finished' then 'label label-success' else 'label label-info'
  new_status_props =
    class: new_status_class
  new_status = $ '<span />' , new_status_props
  new_status.text raw_archive.pretty_state
  row.find( 'td.repo-table-status-cell' ).html new_status

  # New Action Data
  # <a class="btn btn-success" id="repo-<%= repo.id %>" href="<%= repo.archives.first[ "download_url" ] %>">Download</a>
  if raw_archive.state is 'finished'
    new_btn_class = 'btn btn-success'
    new_btn_text = 'Download'
  else
    new_btn_class = 'btn disabled'
    new_btn_text = 'Working'
  new_btn_props =
    class: new_btn_class
    href: raw_archive.download_url
    id: "repo-#{ raw_archive.repository_id }"
  new_btn = $ '<a />' , new_btn_props
  new_btn.text new_btn_text
  row.find( 'td.repo-table-action-cell' ).html new_btn

$( 'a[ id ^= "repo-" ]' ).click ( e ) ->
  target = $ e.target
  $.ajax
    data:
      github_repository_id:      target.data 'repository-id'
      github_repository_name:    target.data 'repository-name'
      github_repository_ssh_url: target.data 'repository-ssh-url'
    success: ( response ) ->
      archives_to_poll.push response.id
      setTimeout poll_for_archive_status , 1000
    type: 'POST'
    url: target.data 'archive-url'
