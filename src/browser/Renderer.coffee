class Renderer

  FRAMERATE_SAMPLE_SIZE: 20

  constructor: (@context) ->
    @isPlaying = yes
    @counter = 0
    @cubeColors = new CubeColors grid.config.cubeColumns

  init: (cb) ->
    @shaderManager = new ShaderManager @context.getGL(), 'color.frag', 'position.vert'
    @shaderManager.initShaders =>
      @gl = @context.getGL()
      @camera = new Camera @context.getAspectRatio()
      @shaderProgram = @shaderManager.getProgram()
      @time = @gl.getUniformLocation @shaderProgram, "time"
      @viewportWidth = @gl.getUniformLocation @shaderProgram, "viewportWidth"
      @cubeColor = @gl.getUniformLocation @shaderProgram, "cubeColor"
      cb() if cb?
  
  setScene: (@scene) ->

  getShader: ->
    @shaderManager.getProgram()

  getCamera: ->
    @camera

  trackFramerate: (timestamp) ->
    if ++@counter is @FRAMERATE_SAMPLE_SIZE
      @counter = 0
      $('#framerate').text (20 * 1000 / (timestamp - @lastTimestamp)).toFixed 2
      @lastTimestamp = timestamp

  render: (timestamp) =>
    @trackFramerate timestamp if window.grid.config.trackFramerate
    if @isPlaying
      @gl.uniform1f @viewportWidth, 2000
      @gl.uniform1f @time, Math.sin(timestamp / 1000)
    @drawScene()

  drawBackground: (background) ->
    @setBackgroundBuffers background
    @setMatrixUniforms(
      @gl, background.getShader(), @camera.getPerspectiveMatrix(), background.getMatrix()
    )
    @gl.lineWidth 1.0
    @gl.drawArrays @gl.LINES, 0, background.getIndexDataSize()

  drawScene: ->
    @gl.clear @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT
    @drawBackground @scene.getModels().background
    #@camera.rotate 0.1
    @drawCubes()

  drawCubes: ->
    models = @scene.getModels()
    @setBuffers models.cubes[0]
    total = models.cubes.length
    @cubeColors.update()
    for model, i in models.cubes
      @setMatrixUniforms @gl, model.getShader(), @camera.getPerspectiveMatrix(), model.getMatrix()
      @gl.uniform3f @cubeColor, @cubeColors.get(i)...
      @gl.drawElements @gl.TRIANGLES, model.getIndexDataSize(), @gl.UNSIGNED_SHORT, 0
    
  setBackgroundBuffers: (model) ->
    @gl.bindBuffer @gl.ARRAY_BUFFER, @gl.createBuffer()
    @gl.bufferData @gl.ARRAY_BUFFER, model.getVertexData(), @gl.STATIC_DRAW
    @gl.vertexAttribPointer @shaderManager.getVertexPositionAttribute(), 3, @gl.FLOAT, false, 0, 0

  setBuffers: (model) ->
    @gl.bindBuffer @gl.ARRAY_BUFFER, @gl.createBuffer()
    @gl.bufferData @gl.ARRAY_BUFFER, model.getVertexData(), @gl.STATIC_DRAW
    @gl.bindBuffer @gl.ELEMENT_ARRAY_BUFFER, @gl.createBuffer()
    @gl.bufferData @gl.ELEMENT_ARRAY_BUFFER, model.getIndexData(), @gl.STATIC_DRAW
    @gl.vertexAttribPointer @shaderManager.getVertexPositionAttribute(), 3, @gl.FLOAT, false, 0, 0

  setMatrixUniforms: (gl, shaderProgram, pMatrix, mvMatrix) ->
    pUniform = gl.getUniformLocation(shaderProgram, "uPMatrix")
    gl.uniformMatrix4fv(pUniform, false, new Float32Array(pMatrix.flatten()))
    mvUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix")
    gl.uniformMatrix4fv(mvUniform, false, new Float32Array(mvMatrix.flatten()))
