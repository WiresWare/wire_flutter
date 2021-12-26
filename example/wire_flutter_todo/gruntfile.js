module.exports = function(grunt) {

	// load all grunt tasks matching the ['grunt-*', '@*/grunt-*'] patterns
	require('load-grunt-tasks')(grunt);
	require('time-grunt')(grunt);

	grunt.loadNpmTasks('grunt-contrib-connect');
	grunt.loadNpmTasks('grunt-exec');

	// Project configuration.
	grunt.initConfig({
	  connect: {
      server: {
        options: {
          port: 9001,
          base: './web_native',
          spawn: false,
          open: {
            target: "http://localhost:9001"
          },
          livereload: true,
        }
      }
    },
		watch: {
		  options: {
        livereload: true,
      },
			dart: {
				files: ['**/*.dart'],
				tasks: ['exec:rebuild_and_run_reload'],
				options: {
					interrupt: true,
					livereload: true
				}
			},
			html: {
				files: 'web_native/*.html',
				options: {
					livereload: true
				}
			},
			configGrunt: {
				files: ['gruntfile.js'],
				options: {
					reload: true
				}
			}
		},
		exec: {
			remove_web_if_exists: 'if [ -e "./web_native" ]; then rm -rf "./web_native"; fi',
			copy_assets_for_web: 'mkdir ./web_native & cp -r ./assets/web_native/* ./web_native',
			rebuild_and_run_reload: 'sh ./scripts/build_native_web.sh'
		}
	});

	// Default task(s).
	grunt.registerTask('default', [
		'exec',
	  'connect',
		'watch'
	]);
};
