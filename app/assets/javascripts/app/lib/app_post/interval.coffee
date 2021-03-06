class App.Interval
  _instance = undefined

  @set: (callback, timeout, key, level) ->
    if _instance == undefined
      _instance ?= new _intervalSingleton
    _instance.set(callback, timeout, key, level)

  @clear: (key, level) ->
    if _instance == undefined
      _instance ?= new _intervalSingleton
    _instance.clear(key, level)

  @clearLevel: (level) ->
    if _instance == undefined
      _instance ?= new _intervalSingleton
    _instance.clearLevel(level)

  @reset: ->
    if _instance == undefined
      _instance ?= new _intervalSingleton
    _instance.reset()

  @_all: ->
    if _instance == undefined
      _instance ?= new _intervalSingleton
    _instance._all()

class _intervalSingleton extends Spine.Module
  @include App.LogInclude

  constructor: ->
    @levelStack = {}

  set: (callback, timeout, key, level) =>

    if !level
      level = '_all'

    if key
      @clear(key, level)

    if !key
      key = Math.floor(Math.random() * 99999)

    # setTimeout
    @log 'debug', 'set', key, timeout, level, callback
    callback()
    interval_id = setInterval(callback, timeout)

    # remember all interval
    if !@levelStack[level]
      @levelStack[level] = {}
    @levelStack[ level ][ key.toString() ] = {
      interval_id: interval_id
      timeout:     timeout
      level:       level
    }

    key.toString()

  clear: (key, level) =>

    if !level
      level = '_all'

    return if !@levelStack[ level ]

    # get global interval ids
    data = @levelStack[ level ][ key.toString() ]
    return if !data

    @log 'debug', 'clear', data
    clearInterval(data['interval_id'])

    # cleanup if needed
    delete @levelStack[ level ][ key.toString() ]
    if _.isEmpty(@levelStack[ level ])
      delete @levelStack[ level ]

  clearLevel: (level) =>
    return if !@levelStack[ level ]
    for key, data of @levelStack[ level ]
      @clear(key, level)
    delete @levelStack[level]

  reset: =>
    for level, items of @levelStack
      for key, data of items
        @clear(key, level)
      @levelStack[level] = {}
    true

  _all: =>
    @levelStack
