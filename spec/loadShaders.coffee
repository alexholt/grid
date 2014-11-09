ShaderManager = require '../src/browser/ShaderManager.coffee'

describe 'ShaderProgram', ->
  beforeEach ->
    gl = sinon.stub()
    @shaderMan = new ShaderManager gl, 'color.frag', 'position.vert'

  it 'loads shader files from the server', ->
    expect(@shaderMan.filenames.length).to.equal(2)
