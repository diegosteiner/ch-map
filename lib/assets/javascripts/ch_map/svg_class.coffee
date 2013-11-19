SVGElement.prototype.hasClass = (className) ->
  new RegExp('(\\s|^)' + className + '(\\s|$)').test(@getAttribute('class'))

SVGElement.prototype.addClass = (className) ->
  @setAttribute('class', @getAttribute('class') + ' ' + className) if !@hasClass(className)

SVGElement.prototype.removeClass = (className) ->
  c = @getAttribute('class')
  c ||= " "
  removedClass = c.replace(new RegExp('(\\s|^)' + className + '(\\s|$)', 'g'), '$2')
  @setAttribute('class', removedClass) if @hasClass(className)

SVGElement.prototype.toggleClass = (className) ->
  if @hasClass(className)
    @removeClass(className)
  else
    @addClass(className)