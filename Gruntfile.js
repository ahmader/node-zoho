module.exports = function(grunt) {
  grunt.initConfig({
    watch: {
      all: {
        files: ['src/lib/**/*', 'src/spec/**/*'],
        tasks: ['coffeelint:app', 'coffeelint:spec', 'coffee', 'jasmine_node']
      }
    },
    coffee: {
      compile: {
        files: [
          {
          expand: true,
          flatten: false,
          cwd: 'src/',
          src: ['**/*.coffee'],
          dest: 'build/',
          ext: '.js'
          }
        ]
      }
    },
    jasmine_node: {
      projectRoot: "./src/spec",
      source: './src/lib',
      verbose: false,
      useHelpers: true,
      useCoffee: true,
      extensions: 'coffee',
      jUnit: {
        report: true,
        savePath: "./reports/jasmine/"
      }
    },
    coffeelint: {
      options: {
        max_line_length: {
          level: 'ignore'
        }
      },
      app: ['src/lib/**/*.coffee'],
      spec: {
        files: {
          src: ['src/spec/**/*.coffee']
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-jasmine-node');

  grunt.registerTask('default', ['coffeelint', 'jasmine_node'] );
  grunt.registerTask('release', ['bump_version','do_release'] );
};
