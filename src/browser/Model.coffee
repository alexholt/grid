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

  setTexture: (texture) ->
    cubeTexture = @gl.createTexture()
    cubeImage = new Image()
    cubeImage.onload = =>
      @_handleTextureLoaded cubeImage, cubeTexture
    cubeImage.src = "cubetexture.png"

  _handleTextureLoaded: (image, texture) ->
    @gl.bindTexture @gl.TEXTURE_2D, texture
    @gl.texImage2D @gl.TEXTURE_2D, 0, @gl.RGBA, @gl.RGBA, @gl.UNSIGNED_BYTE, image
    @gl.texParameteri @gl.TEXTURE_2D, @gl.TEXTURE_MAG_FILTER, @gl.LINEAR
    @gl.texParameteri @gl.TEXTURE_2D, @gl.TEXTURE_MIN_FILTER, @gl.LINEAR_MIPMAP_NEAREST
    @gl.generateMipmap @gl.TEXTURE_2D
    @gl.bindTexture @gl.TEXTURE_2D, null

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
