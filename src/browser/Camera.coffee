class Camera extends Model

  constructor: (aspectRatio) ->
    super
    @location = $V([0, 0, 0])
    @mvMatrix = @makePerspective 60, aspectRatio, 0.01, 500

  makePerspective: (fovy, aspect, znear, zfar) ->
    ymax = znear * Math.tan fovy * Math.PI / 360
    ymin = -ymax
    xmin = ymin * aspect
    xmax = ymax * aspect
    @mvMatrix = @makeFrustum xmin, xmax, ymin, ymax, znear, zfar

  makeFrustum: (left, right, bottom, top, znear, zfar) ->
    X = 2 * znear / (right - left)
    Y = 2 * znear / (top - bottom)
    A = (right + left) / (right - left)
    B = (top + bottom) / (top - bottom)
    C = -(zfar + znear) / (zfar - znear)
    D = -2 * zfar * znear / (zfar - znear)
    $M([ [X,  0,  A,  0]
         [0,  Y,  B,  0]
         [0,  0,  C,  D]
         [0,  0, -1,  0] ])
 
  getPerspectiveMatrix: ->
    @mvMatrix

  getLocation: ->
    @location

module.exports = Camera if module?
