global._ = require('../assets/js/lib/lodash.min.js')
global.do_variants_analysis = true

CaffeNetwork    = require './caffe/caffe.coffee'
Loader          = require './loader.coffee'
Analyzer        = require './analyzer.coffee'

analyzer = new Analyzer()
loader = new Loader(CaffeNetwork)
glob = require('glob')
path = require('path')
fs = require('fs');

files = glob.sync('/home/aknahs/Development/gaugeNN/data/apps/caffe/**/*.prototxt')

files.forEach (file) -> 
    
    fun = (err, data) -> 
        console.log file 
        try
            net = loader.parser.parse data.toString()
            total = net.nodes.reduce (acc, x) -> 
                perf = x.analysis.comp
                acc.macc += perf.macc
                acc.comp += perf.comp
                acc.add += perf.add
                acc.div += perf.div
                acc.exp += perf.exp
                acc
            , {macc: 0, comp: 0, add: 0, div: 0, exp: 0}
            
            console.log JSON.stringify total
        catch e
            console.log e

    fs.readFile(file, fun)

