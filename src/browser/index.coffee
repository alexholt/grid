start = ->
  context = new Context $('#glcanvas')
  renderer = new Renderer context
  scene = new Scene

  renderer.init ->
    scene.createCubes renderer.getShader()
    context.setControllable renderer.getCamera()
    renderer.setScene scene
    window.grid.context = context
    window.grid.scene = scene
    window.grid.renderer = renderer

    # Main Loop
    main = (timestamp) ->
      renderer.render timestamp
      window.requestAnimationFrame main

    window.requestAnimationFrame main

  # Handle resize
  $(window).on 'resize orientationchange', =>
    event.preventDefault()
    console.info "Resizing viewport"
    context.handleResize()
    renderer.getCamera().makePerspective 60, context.getAspectRatio()

if window?
  if window.grid?
    throw '[window.grid] already defined?!'
  window.grid =
    config:
      trackFramerate: on
      cubeColumns: 16
      cubeRows: 16

  window.addEventListener 'DOMContentLoaded', start

if navigator?
  navigator.getUserMedia = navigator.getUserMedia ?
    navigator.webkitGetUserMedia ?
    navigator.mozGetUserMedia

