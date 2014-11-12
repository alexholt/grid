class Billboard extends Model

  VERTICES: [
    -1.0, -1.0, 0.0,
     1.0, -1.0, 0.0,
     1.0,  1.0, 0.0,
    -1.0,  1.0, 0.0
  ]

  VERTEX_INDICES: [ 0, 1, 2, 0, 2, 3 ]

  constructor: (shader) ->
    super shader
