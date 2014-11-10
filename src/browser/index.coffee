start = ->
  context = new Context $('#glcanvas')
  renderer = new Renderer context
  scene = new Scene
  renderer.init ->
    scene.createCubes renderer.getShader()
    context.setControllable renderer.getCamera()
    renderer.render(scene)

if window?
  window.addEventListener 'load', start
