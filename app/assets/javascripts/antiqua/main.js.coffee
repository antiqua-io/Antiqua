Antiqua =
  current_page: null
  pages:   {}

  changePage: ( page_name , params ) ->
    @current_page = page = new @pages[ page_name ]( params )
    page.load()

  registerPage: ( page , o ) -> @pages[ page ] = o

Antiqua.Helpers =
  getUrlParameterByName: ( name ) ->
    name    = name.replace( /[\[]/ , "\\\[" ).replace /[\]]/ , "\\\]"
    regexS  = "[\\?&]" + name + "=([^&#]*)"
    regex   = new RegExp( regexS )
    results = regex.exec window.location.search
    if results is null
      ""
    else
      decodeURIComponent results[ 1 ].replace /\+/g , " "

window.Antiqua = Antiqua
