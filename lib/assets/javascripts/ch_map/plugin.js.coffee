(($) ->
  $.fn.ch_map = (callbacks) ->
    map = new ChMap($(this), callbacks)

    load = ->
      map.load()
) jQuery