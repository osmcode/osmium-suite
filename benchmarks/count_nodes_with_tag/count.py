#!/usr/bin/env python

import osmium as o
import sys

class FileStatsHandler(o.SimpleHandler):
    def __init__(self):
        o.SimpleHandler.__init__(self)
        self.all = 0
        self.counter = 0

    def node(self, n):
        self.all += 1
        if n.tags['amenity'] == 'post_box':
            self.counter += 1

    def way(self, w):
        self.all += 1

    def relation(self, r):
        self.all += 1


h = FileStatsHandler()
h.apply_file(sys.argv[1])

print("r_all=%d r_counter=%d" % (h.all, h.counter))

