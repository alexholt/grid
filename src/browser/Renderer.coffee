class Renderer

  constructor: (@context) ->

  init: (cb) ->
    @shaderManager = new ShaderManager @context.getGL(), 'color.frag', 'position.vert'
    @shaderManager.initShaders =>
      @gl = @context.getGL()
      @camera = new Camera @context.getAspectRatio()
      @shaderProgram = @shaderManager.getProgram()
      @time = @gl.getUniformLocation @shaderProgram, "time"
      @viewportWidth = @gl.getUniformLocation @shaderProgram, "viewportWidth"
      @colorTime = 0.0
      @isMovingUp = true
      @delta = 0.01
      cb() if cb?

  render: (@scene) ->
    @renderLoop()

  getShader: ->
    @shaderManager.getProgram()

  getCamera: ->
    @camera

  renderLoop: (timestamp) =>
    @isMovingUp = false if @colorTime >= 1.0
    @isMovingUp = true if @colorTime <= 0.0
    if @isMovingUp
      @colorTime += @delta
    else
      @colorTime -= @delta
    @gl.uniform1f @viewportWidth, 2000
    @gl.uniform1f @time, @colorTime
    @drawScene()
    window.requestAnimationFrame @renderLoop

  drawBackground: (background) ->
    @setBackgroundBuffers background
    @setMatrixUniforms(
      @gl, background.getShader(), @camera.getPerspectiveMatrix(), background.getMatrix()
    )
    @gl.lineWidth 1.0
    @gl.drawArrays @gl.LINES, 0, background.getIndexDataSize()

  drawScene: ->
    @gl.clear @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT
    models = @scene.getModels()
    @drawBackground models.background
    #@camera.rotate 0.1
    #@drawCubes()

  drawCubes: ->
    models = @scene.getModels()
    for model in models.cubes
      model.pushMatrix()
      model.translate 0, 0, Math.random() * 1
      @setBuffers model
      @setMatrixUniforms @gl, model.getShader(), @camera.getPerspectiveMatrix(), model.getMatrix()
      @gl.drawElements @gl.TRIANGLES, model.getIndexDataSize(), @gl.UNSIGNED_SHORT, 0
      model.popMatrix()
    
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
