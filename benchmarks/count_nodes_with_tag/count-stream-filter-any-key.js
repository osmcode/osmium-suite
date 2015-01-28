#!/usr/bin/env node

var osmium = require('../../../node-osmium/lib/osmium.js');

var filename = process.argv[2];

if (!filename) {
    console.log("Usage: " + process.argv[0] + " " + process.argv[1] + " OSMFILE");
    process.exit(1);
}

var file   = new osmium.File(filename);
var reader = new osmium.BasicReader(file);
var filter = new osmium.Filter();
filter.with_nodes(null);
var stream = new osmium.Stream(reader, filter);

var counter = 0;
var all = 0;

stream.on('end', function() {
    console.log("r_all=" + all + " r_counter=" + counter);
});

stream.on('data', function(object) {
    all++;
    if (object.type == 'node' && object.tags('amenity') == 'post_box') {
        counter++;
    }
});

