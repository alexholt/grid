class Context

  constructor: (@$element) ->
    @init()

  init: ->
    @resizeCanvas()
    @initWebGL @$element[0]
    @gl.clearColor 0.0, 0.0, 0.0, 1.0
    @gl.enable @gl.DEPTH_TEST
    @gl.depthFunc @gl.LEQUAL
    @gl.clear @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT
    @gl.blendFunc @gl.SRC_ALPHA, @gl.ONE
    @resizeViewport()

  resizeCanvas: ->
    width = $('body').width()
    height = $('body').height()
    @$element.attr 'width', width
    @$element.attr 'height', height

  attachClickHandlers: ->
    @$element.off 'mousedown mousemove mouseup'
    [gridX, gridY] = [@$element.width(), @$element.height()]
    @$element.on 'mousedown', (event) =>
      @startingCoords = [ event.offsetX, event.offsetY ]
    @$element.on 'mouseup mousemove', (event) =>
      return unless @startingCoords?
      endingCoords = [ event.offsetX, event.offsetY ]
      deltaX = endingCoords[0] - @startingCoords[0]
      deltaY = endingCoords[1] - @startingCoords[1]
      @control.translate deltaX / 3, -deltaY / 3, 0
      if event.type == 'mousemove'
        @startingCoords = endingCoords
      else
        @startingCoords = null

  attachKeyboardHandlers: ->
    $(window).on 'keydown', (event) =>
      if event.keyCode == 38 # Up
        if event.shiftKey
          @control.translate 0, 0, 1
        else
          @control.translate 0, -1, 0
      else if event.keyCode == 40 # Down
        if event.shiftKey
          @control.translate 0, 0, -1
        else
          @control.translate 0, 1, 0
      else if event.keyCode == 39 # Right
        @control.translate -1, 0, 0
      else if event.keyCode == 37 # Left
        @control.translate 1, 0, 0

  resizeViewport: ->
    width = $('body').width()
    height = $('body').height()
    @aspectRatio = width / height
    @gl.viewport 0, 0, width, height

  getGL: ->
    @gl

  getAspectRatio: ->
    @aspectRatio

  initWebGL: (canvas) ->
    try
      @gl = canvas.getContext 'webgl'
    catch e
      throw new Error "WebGL failed to initialize #{e.message()}"

  setControllable: (model) ->
    @control = model
    @attachClickHandlers()
    @attachKeyboardHandlers()
  
if module?
  module.exports = Context
