class Model

  constructor: (@shader) ->
    @mvMatrix = Matrix.I(4)
    @vertices = new Float32Array @VERTICES
    @indices = new Uint16Array @VERTEX_INDICES
    @up = Vector.create [0, 0, 1]
    @forward = Vector.create [0, 1, 0]

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

  setTexture: (gl, texture) ->
    cubeTexture = gl.createTexture()
    cubeImage = new Image()
    cubeImage.onload = =>
      @_handleTextureLoaded gl, cubeImage, cubeTexture
    cubeImage.src = "cubetexture.png"

  _handleTextureLoaded: (gl, image, texture) ->
    gl.bindTexture gl.TEXTURE_2D, texture
    gl.texImage2D gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image
    gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR
    gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_NEAREST
    gl.generateMipmap gl.TEXTURE_2D
    gl.bindTexture gl.TEXTURE_2D, null

  translate: (x, y, z) ->
    @mvMatrix = @mvMatrix.x Matrix.Translation($V([x, y, z])).ensure4x4()
    @

  rotate: (r) ->
    @mvMatrix = @mvMatrix.x Matrix.Rotation(r, @up).ensure4x4()
    @

  scale: (s) ->
    @mvMatrix = @mvMatrix.x(
      $M([ [s, 0, 0, 0], [0, s, 0, 0], [0, 0, s, 0], [0, 0, 0, 1 ] ]).ensure4x4()
    )
    @

  pushMatrix: ->
    @savedMatrix = $M(@mvMatrix)

  popMatrix: ->
    @mvMatrix = @savedMatrix

  draw: (gl, pMatrix) ->
    @setBuffers gl, model
    @setMatrixUniforms gl, @shader, pMatrix, @getMatrix()
    gl.drawElements gl.TRIANGLES, @getIndexDataSize(), gl.UNSIGNED_SHORT, 0

  setMatrixUniforms: (gl, shaderProgram, pMatrix, mvMatrix) ->
    pUniform = gl.getUniformLocation(shaderProgram, "uPMatrix")
    gl.uniformMatrix4fv(pUniform, false, new Float32Array(pMatrix.flatten()))
    mvUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix")
    gl.uniformMatrix4fv(mvUniform, false, new Float32Array(mvMatrix.flatten()))

  setBuffers: (gl, model) ->
    gl.bindBuffer gl.ARRAY_BUFFER, gl.createBuffer()
    gl.bufferData gl.ARRAY_BUFFER, model.getVertexData(), gl.STATIC_DRAW
    gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, gl.createBuffer()
    gl.bufferData gl.ELEMENT_ARRAY_BUFFER, model.getIndexData(), gl.STATIC_DRAW
    gl.vertexAttribPointer @shaderManager.getVertexPositionAttribute(), 3, gl.FLOAT, false, 0, 0
