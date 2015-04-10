if window?
  if window.grid?
    throw '[window.grid] already defined?!'
  window.grid =
    config:
      trackFramerate: on
      cubeColumns: 32
      cubeRows: 32

start = ->
  context = new Context $('#glcanvas')
  renderer = new Renderer context
  scene = new Scene
  renderer.init ->
    scene.createCubes renderer.getShader()
    context.setControllable renderer.getCamera()
    renderer.render scene
    window.grid.context = context
    window.grid.scene = scene
    window.grid.renderer = renderer

if window?
  window.addEventListener 'DOMContentLoaded', start
