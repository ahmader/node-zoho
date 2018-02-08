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
        options: {
          specs: 'spec/integration/**/*.{js,coffee}'
        }
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
    },
    shrinkwrap: {
      dev: false, // whether the shrinkwrap dev dependencies. Defaults to false. 
      dedupe: false, // whether to run dedupe before shrinkwrapping.  Defaults to false. 
      prune: false // whether to run prune before deduping. Defaults to false. 
    },
    bump: {
      files: ['package.json'],
      updateConfigs: [],
      commit: true,
      commitMessage: 'Release v%VERSION%',
      commitFiles: ['package.json'], // '-a' for all files
      createTag: true,
      tagName: 'v%VERSION%',
      tagMessage: 'Version %VERSION%',
      push: false,
      // pushTo: 'origin',
      gitDescribeOptions: '--tags --always --abbrev=1 --dirty=-d'
    }
  });

  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-jasmine-bundle');
  grunt.loadNpmTasks('grunt-shrinkwrap');
  grunt.loadNpmTasks('grunt-bump');

  grunt.registerTask('default', ['coffeelint', 'spec:unit'] );
  grunt.registerTask('integration', ['coffeelint', 'spec:integration']);
  grunt.registerTask('travis-ci', ['coffeelint', 'spec:unit'] );
  grunt.registerTask('release', ['bump-only:patch', 'shrinkwrap', 'bump-commit'] );
};
