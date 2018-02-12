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
      lib: {
        files: {
          src: ['lib/**/*.coffee']
        }
      },
      spec: {
        files: {
          src: ['spec/**/*.coffee']
        }
      }
    },
    shrinkwrap: {
      dev: true, // whether the shrinkwrap dev dependencies. Defaults to false. 
      dedupe: false, // whether to run dedupe before shrinkwrapping.  Defaults to false. 
      prune: false // whether to run prune before deduping. Defaults to false. 
    },
    eslint: {
      lib: ['lib/**/*.coffee']
    },
    bump: {
      options: {
        files: ['package.json'],
        updateConfigs: [],
        commit: true,
        commitMessage: 'Release v%VERSION%',
        commitFiles: ['package.json', 'npm-shrinkwrap.json'], // ['-a'] for all files
        createTag: true,
        tagName: 'v%VERSION%',
        tagMessage: 'Version %VERSION%',
        push: false,
        // pushTo: 'origin',
        gitDescribeOptions: '--tags --always --abbrev=1 --dirty=-d'
      }
    }
  });

  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-jasmine-bundle');
  grunt.loadNpmTasks('grunt-shrinkwrap');
  grunt.loadNpmTasks("gruntify-eslint");
  grunt.loadNpmTasks('grunt-bump');

  grunt.registerTask('default', ['coffeelint', 'eslint', 'spec:unit'] );
  grunt.registerTask('integration', ['coffeelint', 'eslint', 'spec:integration']);
  grunt.registerTask('travis-ci', ['coffeelint', 'eslint', 'spec:unit'] );
  grunt.registerTask('release', ['bump:patch:bump-only', 'shrinkwrap', 'bump::commit-only'] );
};
