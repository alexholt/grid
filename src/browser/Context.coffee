class Context

  constructor: (@$element) ->
    @init()

  init: ->
    @resizeCanvas()
    @attachClickHandler()
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

  attachClickHandler: ->
    [gridX, gridY] = [@$element.width(), @$element.height()]
    @$element.on 'mouseup', (event) =>
      console.log "(#{event.offsetX}, #{event.offsetY})"

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

if module?
  module.exports = Context
