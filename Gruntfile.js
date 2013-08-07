'use strict';

module.exports = function(grunt) {
    // load all grunt tasks
    require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

    // configurable paths
    var yeomanConfig = {
        app: 'app',
        dist: 'dist'
    };

    grunt.initConfig({
        yeoman: yeomanConfig,
        jshint: {
            options: {
                jshintrc: '.jshintrc'
            },
            all: [
                'Gruntfile.js',
                // '<%= yeoman.app %>/scripts/{,*/}*.js',
                // '!<%= yeoman.app %>/scripts/vendor/*',
                'test/spec/{,*/}*.js'
            ]
        },
        coffee: {
            dist: {
                files: [{
                    // rather than compiling multiple files here you should
                    // require them into your main .coffee file
                    expand: true,
                    cwd: '<%= yeoman.app %>/scripts',
                    src: '*.coffee',
                    dest: '.tmp/scripts',
                    ext: '.js'
                }]
            },
            app: {
                files: [{
                    // rather than compiling multiple files here you should
                    // require them into your main .coffee file
                    expand: true,
                    cwd: '<%= yeoman.app %>/scripts',
                    src: '*.coffee',
                    dest: '<%= yeoman.app %>/scripts',
                    ext: '.js'
                }]
            },
            test: {
                files: [{
                    expand: true,
                    cwd: '.tmp/spec',
                    src: '*.coffee',
                    dest: 'test/spec'
                }]
            }
        },
        less: {
            dist: {
                options: {
                    paths: ['assets/css'],
                    yuicompress: true
                },
                files: [{
                    //'.tmp/styles/index.css': '<%= yeoman.app %>/styles/*.less'
                    expand: true,
                    cwd: '<%= yeoman.app %>/styles/',
                    src: '*.less',
                    dest: '.tmp/styles',
                    ext: '.css'
                }]
            },
            app: {
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.app %>/styles/',
                    src: '*.less',
                    dest: '<%= yeoman.app %>/styles/',
                    ext: '.css'
                }]
            }
        }
    });


    grunt.registerTask('build', [
        'coffee:app',
        'less:app',
    ]);

    grunt.registerTask('default', [
        'jshint',
        'build'
    ]);
};