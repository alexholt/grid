class CubeColors

  $el: $('#show-select')

  SHOWS: [
    'randomize'
    'pondDrop'
    'listen'
  ]

  constructor: (@width) ->
    @frame = 0
    @colors = []
    Object.defineProperty @, 'length', get: -> Math.pow @width, 2
    @randomize()
    for show in @SHOWS
      @$el.append $("<option val=#{show}>").text show
    @$el.on 'change', => @mode = @$el.val()

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

  listen: ->
    @mic = new Microphone unless @mic
    @mic.collect()
    data = @mic.getData()
    for i in [0...@width]
      val = data[i] / 128 * @width
      val = Math.round val
      for j in [0...val]
        @colors[i * @width + j] = [ 1, 0.25, 0.25 ]
      @colors[i * @width + val] = [ 0, 0, 0 ]
      for j in [val + 1...@width]
        @colors[i * @width + j] = [ 1, 1, 1 ]
    @

  update: ->
    @frame++
    switch @mode
      when 'pondDrop' then @pondDrop()
      when 'randomize' then @randomize()
      when 'listen' then @listen()
