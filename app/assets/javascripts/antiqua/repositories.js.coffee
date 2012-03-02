$( 'a[ id ^= "repo-" ]' ).click ( e ) -> Antiqua.current_page.queueArchive $( e.target )
Antiqua.changePage 'Repositories'
