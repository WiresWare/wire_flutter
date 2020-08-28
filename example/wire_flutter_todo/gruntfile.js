module.exports = function(grunt) {

	// load all grunt tasks matching the ['grunt-*', '@*/grunt-*'] patterns
	require('load-grunt-tasks')(grunt);
	require('time-grunt')(grunt);

	grunt.loadNpmTasks('grunt-exec');

	// Project configuration.
	grunt.initConfig({
		watch: {
			dart: {
				files: ['**/*.dart'],
				tasks: ['exec:rebuild_and_run_reload'],
				options: {
					interrupt: true,
					livereload: true
				}
			},
			html: {
				files: 'web/*.html',
				options: {
					livereload: true
				}
			},
			configGrunt: {
				files: ['Gruntfile.js'],
				options: {
					reload: true
				}
			}
		},
		exec: {
			copy_assets_for_web: '[[ -d web ]] && rm -rf web & mkdir web & cp -r assets/web ./',
			rebuild_and_run_reload: 'sh ./build_web.sh && ((echo >/dev/tcp/localhost/8889) &>/dev/null && echo "TCP port 8889 open" || reload -p 8889 -b -d ./web &)'
		}
	});

	// Default task(s).
	grunt.registerTask('default', [
		'exec',
		'watch'
	]);
};
