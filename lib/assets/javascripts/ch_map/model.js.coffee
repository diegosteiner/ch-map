class ChMap
  constructor: (@target, @callbacks={}, autoload=true) ->
    @src = '/assets/images/ch_map.svg'
    @aspect_ratio = 0.62
    @load() if autoload

  load: ->
    @target.load(@src, =>
      @target.addClass("svg_loaded")
      @_initialize_aspect_ratio_enforcement()
      @_load_toggleable_elements()
    )

  _get_elements: ->
    (e for e in ([].concat.apply([], [
      @target.find("#cantons>path").get()
      @target.find("#canton_names text").get()
    ])) when e?)

  enforce_aspect_ratio: ->
    @target.css('height', @target.width() * @aspect_ratio)

  _load_toggleable_elements: ->
    elements = @_get_elements()
    for event, callback of @callbacks
      for element in elements
        $(element).on(event, callback)
  return

  _initialize_aspect_ratio_enforcement: ->
    @enforce_aspect_ratio()
    $(window).resize(=>
      @enforce_aspect_ratio()
    )