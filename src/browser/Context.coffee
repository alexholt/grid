class Context

  constructor: (@$element) ->
    @isInit = no
    @isFullscreen = no
    @init()
    @$element.on 'contextmenu', (event) -> event.preventDefault()

  init: ->
    @resizeCanvas()
    @initWebGL @$element[0]
    @gl.clearColor 0.0, 0.0, 0.0, 1.0
    @gl.enable @gl.DEPTH_TEST
    @gl.depthFunc @gl.LEQUAL
    @gl.clear @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT
    @gl.blendFunc @gl.SRC_ALPHA, @gl.ONE
    @resizeViewport()
    @isInit = yes

  resizeCanvas: ->
    @$element.width window.innderWidth
    @$element.height window.innderHeight
    @$element.attr 'width', window.innerWidth
    @$element.attr 'height', window.innerHeight

  handleResize: =>
    @init() if @isInit

  attachClickHandlers: ->
    @$element.off 'mousedown mousemove mouseup'
    [gridX, gridY] = [@$element.width(), @$element.height()]
    @$element.on 'mousedown', (event) =>
      @startingCoords = [ event.offsetX, event.offsetY ]
    @$element.on 'mouseup mousemove mouseout', (event) =>
      return unless @startingCoords?
      endingCoords = [ event.offsetX, event.offsetY ]
      deltaX = endingCoords[0] - @startingCoords[0]
      deltaY = endingCoords[1] - @startingCoords[1]
      @control.getPerspectiveMatrix()
      @control.translate deltaX / 3, -deltaY / 3, 0
      if event.type == 'mousemove'
        @startingCoords = endingCoords
      else
        @startingCoords = null

  attachFullscreenHandler: ->
    $('button.fullscreen').off('click').on 'click', =>
      @isFullscreen = not @isFullscreen
      element = @$element[0]
      if @isFullscreen
        if element.requestFullscreen
          element.requestFullscreen()
        else if element.msRequestFullscreen
          element.msRequestFullscreen()
        else if element.mozRequestFullScreen
          element.mozRequestFullScreen()
        else if element.webkitRequestFullscreen
          element.webkitRequestFullscreen()
        @resizeCanvas()
        @resizeViewport()

  attachKeyboardHandlers: ->
    $(window).on 'keydown', (event) =>
      if event.keyCode == 38 # Up
        if event.altKey
          @control.rotate 0.1
        else if event.shiftKey
          @control.translate 0, 0, 1
        else
          @control.translate 0, -1, 0
      else if event.keyCode == 40 # Down
        if event.altKey
          @control.rotate -0.1
        else if event.shiftKey
          @control.translate 0, 0, -1
        else
          @control.translate 0, 1, 0
      else if event.keyCode == 39 # Right
        @control.translate -1, 0, 0
      else if event.keyCode == 37 # Left
        @control.translate 1, 0, 0

  attachMouseWheelHandler: ->
    $(window).on 'mousewheel', (event) =>
      event.preventDefault()
      { deltaX, deltaY } = event.originalEvent
      [ deltaX, deltaY ] = [ deltaX, deltaY ].map (delta) ->
        delta /= -100
      @control.translate 0, 0, deltaY

  resizeViewport: ->
    width = window.innerWidth
    height = window.innerHeight
    @aspectRatio = width / height
    @gl.viewport 0, 0, width, height

  getGL: ->
    @gl

  getAspectRatio: ->
    @aspectRatio

  initWebGL: (canvas) ->
    return if @gl?
    try
      @gl = canvas.getContext 'webgl'
    catch e
      throw new Error "WebGL failed to initialize #{e.message}"

  setControllable: (model) ->
    @control = model
    @attachClickHandlers()
    @attachKeyboardHandlers()
    @attachFullscreenHandler()
    @attachMouseWheelHandler()
  
module.exports = Context if module?
