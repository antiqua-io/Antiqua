Antiqua = window.Antiqua || {}

Antiqua.router = Backbone.Router.extend
  routes:
    'home':   'home'
    'repos':  'repos'
    '*splat': 'defaultRoute'

  defaultRoute: -> @home()
  home:         -> Antiqua.changePage 'Home'
  repos:        -> Antiqua.changePage 'Repos'

window.Antiqua = Antiqua

