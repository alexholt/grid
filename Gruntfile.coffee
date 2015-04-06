module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.initConfig
    mochaTest:
      test:
        options:
          reporter: 'spec'
        src: ['spec/**/*.coffee', 'src/**/*.coffee']

    watch:
      scripts:
        files: ['spec/**/*.coffee', 'src/**/*.coffee']
        tasks: ['coffee', 'mochaTest']

    coffee:
      compileWithMaps:
        options:
          sourceMap: true
        files:
          'public/index.js': ['src/browser/Model.coffee', 'src/browser/*.coffee']

  grunt.registerTask 'default', 'watch'
  grunt.registerTask 'build', 'coffee'
  grunt.registerTask 'help', ->
    console.info '''

      Available Commands
      ------------------
      [watch] Watches files and recompiles
      [build] Compiles
      [help] Prints this helpful message
    '''
