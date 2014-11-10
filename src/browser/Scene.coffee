class Scene

  constructor: ->
    @Z = -100.0
    @X = -140.0
    @Y = 100.0

  createCubes: (shader) ->
    @background = new Background shader
    #@background.scale 0.01
    [ x, y, z ] = [ @X, @Y, @Z ]
    @background.translate x, y, z
    @cubes = []
    for i in [0...100]
      y = @Y
      z = @Z
      x += 4
      for j in [0...40]
        y -= 4
        cube = new Cube shader
        @cubes.push cube.translate(x, y, z)

  getModels: ->
    background: @background, cubes: @cubes
