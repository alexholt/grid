class CubeColors

  constructor: (@width) ->
    @frame = 0
    @colors = []
    Object.defineProperty @, 'length', get: -> Math.pow @width, 2
    @randomize()
    @pondDrop()

  get: (index) ->
    @colors[index]

  randomize: ->
    @mode = 'randomize'
    for i in [0...@length]
      @colors[i] = [Math.random(), Math.random(), Math.random()]

  length: ->
    Math.pow @width, 2

  pondDrop: ->
    frame = Math.floor(@frame / 16) % @width
    @mode = 'pondDrop'
    for i in [0...@colors.length]
      col = i % @width
      row = Math.floor(i / @width)
      middle = Math.floor(@width / 2) - 1
      innerSplash = middle - frame
      outerSplash = middle + frame
      if innerSplash is col or innerSplash is row
        @colors[i] = [ 0, 0, 0 ]
      else if outerSplash is col or outerSplash is row
        @colors[i] = [ 0, 0, 0 ]
      else
        @colors[i] = [ 1, 1, 1 ]

    @

  update: ->
    @frame++
    switch @mode
      when 'pondDrop' then @pondDrop()
      when 'randomize' then @randomize()
