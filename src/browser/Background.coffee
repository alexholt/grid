class Background extends Model

  constructor: (shader) ->
    @VERTICES = []
    @VERTEX_INDICES = []
    @createVerticalLines 0, -500, 20
    @createHorizontalLines 0, -100, 20
    super shader

  createVerticalLines: (startingY, verticalSpan, separation) ->
    lines = 20
    for i in [0...lines]
      @VERTICES = @VERTICES.concat [
        separation * i, 0, -1,
        separation * i, verticalSpan, -1
      ]
    @VERTEX_INDICES = @VERTEX_INDICES.concat [0...lines * 2]

  createHorizontalLines: (startingY, horizontalSpan, separation) ->
    lines = 20
    for i in [0...lines]
      @VERTICES = @VERTICES.concat [
        500, -separation * i + startingY, -1,
        horizontalSpan, -separation * i + startingY, -1
      ]
    @VERTEX_INDICES = @VERTEX_INDICES.concat [0...lines * 2]
