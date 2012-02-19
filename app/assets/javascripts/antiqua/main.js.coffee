Antiqua =
  VERSION: "0.1.0.pre"
  current_page: null
  pages:   {}
  router:  {}

  changePage: ( page_name , params ) ->
    @current_page = page = new @pages[ page_name ]( params )
    page.load()

  registerPage: ( page , o ) -> @pages[ page ] = o

window.Antiqua = Antiqua
