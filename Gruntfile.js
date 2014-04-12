module.exports = function(grunt) {
  grunt.initConfig({
    watch: {
      all: {
        files: ['lib/**/*', 'spec/**/*'],
        tasks: ['coffeelint', 'spec:unit']
      }
    },
    spec: {
      options: {
        minijasminenode: {
          showColors: true
        }
      },
      unit: {
        options: {
          specs: 'spec/unit/**/*.{js,coffee}'
        }
      },
      integration: {
        specs: 'spec/integration/**/*.{js,coffee}'
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
  grunt.loadNpmTasks('grunt-jasmine-bundle');

  grunt.registerTask('default', ['coffeelint', 'spec:unit'] );
  grunt.registerTask('integration', ['coffeelint', 'spec:integration']);
  grunt.registerTask('travis-ci', ['coffeelint', 'spec:unit'] );
  grunt.registerTask('release', ['bump_version','do_release'] );
};
