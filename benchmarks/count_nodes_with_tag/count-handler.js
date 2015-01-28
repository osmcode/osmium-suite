#!/usr/bin/env node

var osmium = require('../../../node-osmium/lib/osmium.js');

var filename = process.argv[2];

if (!filename) {
    console.log("Usage: " + process.argv[0] + " " + process.argv[1] + " OSMFILE");
    process.exit(1);
}

var file   = new osmium.File(filename);
var reader = new osmium.BasicReader(file);
var handler = new osmium.Handler;

var counter = 0;
var all = 0;

handler.on('node', function(object) {
    all++;
    if (object.type == 'node' && object.tags('amenity') == 'post_box') {
        counter++;
    }
});

handler.on('way', function(object) {
    all++;
});

handler.on('relation', function(object) {
    all++;
});

osmium.apply(reader, handler);

console.log("r_all=" + all + " r_counter=" + counter);

