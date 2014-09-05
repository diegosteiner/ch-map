(($) ->
  NAMESPACE = 'chmap_objects'

  class CHMap
    constructor: (element, options) ->
      @element = element
      @options = $.extend({
          value: 0
          autoload: false
          extend_SVGElement: true
          aspect_ratio: 0.62
          callbacks: {
            click: []
            mouseenter: []
            mouseleave: []
            element_loaded: []
          }
          toggleable_elements: (element) ->
            return [
              $(element).find("#cantons>path").get()
              $(element).find("#canton_names text").get()
            ]
        }, options)

      @callbacks = {
        click: $.Callbacks()
        mouseenter: $.Callbacks()
        mouseleave: $.Callbacks()
        element_loaded: $.Callbacks()
      }

      for type, callbacks of @options.callbacks
        callbacks = [callbacks] unless $.isArray(callbacks)
        for callback in callbacks
          @callbacks[type].add callback

      @extend_SVGElement() if @options.extend_SVGElement == true
      @load() if @options.autoload == true

    _initialize_aspect_ratio_enforcement: ->
      @enforce_aspect_ratio()
      $(window).resize =>
        @enforce_aspect_ratio()

    _initialize_callbacks: ->
      for element in @_toggleable_elements()
        for type, callback of @callbacks
          continue if type == 'element_loaded'
          continue if callback.length == 0
          ((type, callback) ->
            $(element).on type, ->
              callback.fire(this)
          )(type, callback)
        @callbacks['element_loaded'].fire(element) if @callbacks['element_loaded']?

    _toggleable_elements: ->
      te = @options.toggleable_elements
      elements = te(@element) if $.isFunction(te)
      elements = te if $.isArray(te)
      return (e for e in ([].concat.apply([], elements)) when e?)

    extend_SVGElement: ->
      unless SVGElement.hasClass == 'function'
        SVGElement.prototype.hasClass = (className) ->
          new RegExp('(\\s|^)' + className + '(\\s|$)').test(@getAttribute('class'))

      unless SVGElement.addClass == 'function'
        SVGElement.prototype.addClass = (className) ->
          @setAttribute('class', @getAttribute('class') + ' ' + className) if !@hasClass(className)

      unless SVGElement.removeClass == 'function'
        SVGElement.prototype.removeClass = (className) ->
          c = @getAttribute('class')
          c ||= " "
          removedClass = c.replace(new RegExp('(\\s|^)' + className + '(\\s|$)', 'g'), '$2')
          @setAttribute('class', removedClass) if @hasClass(className)

      unless SVGElement.toggleClass == 'function'
        SVGElement.prototype.toggleClass = (className) ->
          if @hasClass(className)
            @removeClass(className)
          else
            @addClass(className)

    enforce_aspect_ratio: ->
      $(@element).css('height', $(@element).width() * @options.aspect_ratio)

    load: ->
      $(@element).addClass('loading')
      $(@element).load 'images/ch_map.svg', =>
        $(@element).addClass('loaded')
        @_initialize_aspect_ratio_enforcement()
        @_initialize_callbacks()
      $(@element).removeClass('loading')

    loaded: ->
      return $(@element).hasClass('loaded')

    loading: ->
      return $(@element).hasClass('loading')

  $.fn.chmap = (param) ->
    window[NAMESPACE] ||= {}

    methods =
      initialize: ->
        window[NAMESPACE][this.selector] = new CHMap(this, param)
        return this
      loaded: ->
        return window[NAMESPACE][this.selector].loaded()
      loading: ->
        return window[NAMESPACE][this.selector].loading()
      load: ->
        window[NAMESPACE][this.selector].load()
        return window[NAMESPACE][this.selector].loaded()
      enforce_aspect_ratio: ->
        window[NAMESPACE][this.selector].enforce_aspect_ratio()
        return window[NAMESPACE][this.selector]['options']['aspect_ratio']

    if methods[param]
      return methods[param].apply this, Array::slice.call(arguments, 1)
    else if typeof param is "object" or not param
      return methods.initialize.apply this, arguments
    else
      return $.error "Method " + param + " does not exist on chmap"
) jQuery
