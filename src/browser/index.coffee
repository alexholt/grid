if window?
  if window.grid?
    throw '[window.grid] already defined?!'
  window.grid =
    config:
      trackFramerate: on
      cubeColumns: 10
      cubeRows: 10

start = ->
  context = new Context $('#glcanvas')
  renderer = new Renderer context
  scene = new Scene
  renderer.init ->
    scene.createCubes renderer.getShader()
    context.setControllable renderer.getCamera()
    renderer.render(scene)

if window?
  window.addEventListener 'DOMContentLoaded', start
