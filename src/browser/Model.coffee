class Model

  constructor: (@shader) ->
    @mvMatrix = Matrix.I(4)
    @vertices = new Float32Array @VERTICES
    @indices = new Uint16Array @VERTEX_INDICES

  getVertexData: ->
    @vertices

  getIndexData: ->
    @indices

  getMatrix: ->
    @mvMatrix

  getShader: ->
    @shader

  getIndexDataSize: ->
    @indices.length

  translate: (x, y, z) ->
    @mvMatrix = @mvMatrix.x Matrix.Translation($V([x, y, z])).ensure4x4()
    @

  rotate: (r) ->
    @mvMatrix = @mvMatrix.x Matrix.Rotation(r, Vector.create([1, 1, 1])).ensure4x4()
    @

  scale: (s) ->
    @mvMatrix = @mvMatrix.x(
      $M([ [s, 0, 0, 0], [0, s, 0, 0], [0, 0, s, 0], [0, 0, 0, s ] ]).ensure4x4()
    )
    @

  pushMatrix: ->
    @savedMatrix = $M(@mvMatrix)

  popMatrix: ->
    @mvMatrix = @savedMatrix
