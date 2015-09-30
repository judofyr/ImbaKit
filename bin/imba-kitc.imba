#!/usr/bin/env imba
var webpack = require('webpack')

var compiler = webpack
	entry: "./" + process:argv[2]
	resolve:
		extensions: ['', '.js', '.imba']
	module:
		loaders: [
			{ test: /\.imba$/, loader: __dirname+'/../src/imba-loader' }
		]

compiler.watch({}) do |err, stats|
	console.log stats.toString