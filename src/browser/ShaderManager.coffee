class ShaderManager

  DEFAULT_SHADER_DIR: 'assets/shaders/'

  constructor: (@gl, @filenames...) ->
    @shaderDir = @DEFAULT_SHADER_DIR

  initShaders: (cb) ->
    @getShader "#{@shaderDir}/color.frag", (frag) =>
      fragShader = @gl.createShader @gl.FRAGMENT_SHADER
      @gl.shaderSource fragShader, frag.toString()
      @gl.compileShader fragShader
      @checkShaderCompilationStatus fragShader
      @getShader "#{@shaderDir}/position.vert", (vert) =>
        vertShader = @gl.createShader @gl.VERTEX_SHADER
        @gl.shaderSource vertShader, vert.toString()
        @gl.compileShader vertShader
        @checkShaderCompilationStatus vertShader
        @loadShaders fragShader, vertShader
        cb @shaderProgram

  getShader: (filename, cb) ->
    $.get filename, (data) ->
      cb data
    .fail ->
      err = new Error "Error in retrieving #{filename}"
      cb err

  loadShaders: (frag, vert) ->
    @shaderProgram = @gl.createProgram()
    @gl.attachShader @shaderProgram, vert
    @gl.attachShader @shaderProgram, frag
    @gl.linkProgram @shaderProgram
    if not @gl.getProgramParameter @shaderProgram, @gl.LINK_STATUS
      console.error "Unable to initialize the shader program."
    @gl.useProgram @shaderProgram
    @vertexPositionAttribute = @gl.getAttribLocation @shaderProgram, "aVertexPosition"
    @gl.enableVertexAttribArray @vertexPositionAttribute
    @shaderProgram

  getVertexPositionAttribute: ->
    @vertexPositionAttribute

  checkShaderCompilationStatus: (shader) ->
    if not @gl.getShaderParameter shader, @gl.COMPILE_STATUS
      log = @gl.getShaderInfoLog shader
      throw new Error "Shader compilation not successful: #{log}"

  getProgram: ->
    @shaderProgram

if module?
  module.exports = ShaderManager
