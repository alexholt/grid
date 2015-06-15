class Microphone

  constructor: (@fftSize = 32) ->
    @context = new AudioContext
    @analyser = @context.createAnalyser()
    @analyser.fftSize = @fftSize
    navigator.getUserMedia audio: yes, @userMediaCallback, console.error
      
  userMediaCallback: (stream) =>
    @source = @context.createMediaStreamSource(stream)
    @source.connect @analyser

  collect: ->
    @dataArray = new Uint8Array @analyser.frequencyBinCount
    @analyser.getByteTimeDomainData @dataArray

  getData: ->
    @dataArray
