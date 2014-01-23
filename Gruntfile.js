module.exports = function(grunt) {
  grunt.initConfig({
    watch: {
      all: {
        files: ['lib/**/*', 'spec/**/*'],
        tasks: ['coffeelint:app', 'coffeelint:spec', 'jasmine_node']
      }
    },
    jasmine_node: {
      specNameMatcher: "spec",
      source: "lib",
      projectRoot: "./spec",
      requirejs: false,
      forceExit: true,
      useCoffee: true,
      extensions: 'coffee',
      jUnit: {
        report: true,
        savePath : "./reports/jasmine/",
      }
    },
    coffeelint: {
      options: {
        max_line_length: {
          level: 'ignore'
        }
      },
      app: {
        files: {
          src: ['spec/**/*.coffee']
        }
      },
      spec: {
        files: {
          src: ['spec/**/*.coffee']
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-jasmine-node');

  grunt.registerTask('default', ['coffeelint', 'jasmine_node'] );
  grunt.registerTask('release', ['bump_version','do_release'] );
};
