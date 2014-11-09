squareVerticesBuffer = null
cubeVerticesIndexBuffer = null
window.Z = -100.0
window.X = -140.0
window.Y = 100.0

start = ->
  context = new Context $('#glcanvas')
  shaderManager = new ShaderManager context.getGL(), 'color.frag', 'position.vert'
  shaderManager.initShaders ->
    gl = context.getGL()
    camera = new Camera context.getAspectRatio()
    shaderProgram = shaderManager.getProgram()
    time = gl.getUniformLocation shaderProgram, "time"
    initBuffers gl
    colorTime = 0.0
    isMovingUp = true
    delta = 0.01
    renderLoop = ->
      isMovingUp = false if colorTime >= 1.0
      isMovingUp = true if colorTime <= 0.0
      if isMovingUp
        colorTime += delta
      else
        colorTime -= delta
      gl.uniform1f time, colorTime
      drawScene gl, shaderManager, camera.getPerspectiveMatrix()
      setTimeout renderLoop, 15
    renderLoop()

initBuffers = (gl) ->
  squareVerticesBuffer = gl.createBuffer()
  vertices = [
      # Front face
      -1.0, -1.0,  1.0,
       1.0, -1.0,  1.0,
       1.0,  1.0,  1.0,
      -1.0,  1.0,  1.0,
      
      # Back face
      -1.0, -1.0, -1.0,
      -1.0,  1.0, -1.0,
       1.0,  1.0, -1.0,
       1.0, -1.0, -1.0,
      
      # Top face
      -1.0,  1.0, -1.0,
      -1.0,  1.0,  1.0,
       1.0,  1.0,  1.0,
       1.0,  1.0, -1.0,
      
      # Bottom face
      -1.0, -1.0, -1.0,
       1.0, -1.0, -1.0,
       1.0, -1.0,  1.0,
      -1.0, -1.0,  1.0,
      
      # Right face
       1.0, -1.0, -1.0,
       1.0,  1.0, -1.0,
       1.0,  1.0,  1.0,
       1.0, -1.0,  1.0,
      
      # Left face
      -1.0, -1.0, -1.0,
      -1.0, -1.0,  1.0,
      -1.0,  1.0,  1.0,
      -1.0,  1.0, -1.0
  ]
  gl.bindBuffer gl.ARRAY_BUFFER, squareVerticesBuffer
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW
  cubeVerticesIndexBuffer = gl.createBuffer()
  gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, cubeVerticesIndexBuffer
  cubeVertexIndices = [
    0,  1,  2,   0,  2,  3,     # front
    4,  5,  6,   4,  6,  7,     # back
    8,  9,  10,  8,  10, 11,    # top
    12, 13, 14,  12, 14, 15,    # bottom
    16, 17, 18,  16, 18, 19,    # right
    20, 21, 22,  20, 22, 23     # left
  ]
  gl.bufferData gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(cubeVertexIndices), gl.STATIC_DRAW

drawScene = (gl, shaderManager, pMatrix, mvMatrix) ->
  gl.clear gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT
  gl.vertexAttribPointer shaderManager.getVertexPositionAttribute(), 3, gl.FLOAT, false, 0, 0
  X = window.X
  for i in [0...100]
    Y = window.Y
    X += 4
    for j in [0...40]
      Y -= 4
      mvMatrix = Matrix.Translation($V([X, Y, window.Z])).ensure4x4()
      setMatrixUniforms gl, shaderManager.getProgram(), pMatrix, mvMatrix
      gl.drawElements gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0

mvRotate = (r) ->
  multMatrix(Matrix.Rotation(r, Vector.create([1, 1, 1])).ensure4x4())

setMatrixUniforms = (gl, shaderProgram, pMatrix, mvMatrix) ->
  pUniform = gl.getUniformLocation(shaderProgram, "uPMatrix")
  gl.uniformMatrix4fv(pUniform, false, new Float32Array(pMatrix.flatten()))
  mvUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix")
  gl.uniformMatrix4fv(mvUniform, false, new Float32Array(mvMatrix.flatten()))

if window?
  window.addEventListener 'load', start
