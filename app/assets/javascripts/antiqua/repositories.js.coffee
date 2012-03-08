$ ->
  Antiqua.changePage 'Repositories'
  $( document ).on 'click' , 'a[ id ^= "repo-" ]' , ( e ) -> Antiqua.current_page.queueArchive $( e.target )
  $( document ).on 'click' , '#toggle-poller'     , ( e ) -> Antiqua.current_page.togglePoller $( e.target )
