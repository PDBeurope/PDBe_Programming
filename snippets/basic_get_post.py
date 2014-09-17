#!/usr/bin/env python

import urllib2
import argparse
import os
import sys

SERVER_URL = "https://wwwdev.ebi.ac.uk/pdbe/api"
REQUEST_URL = SERVER_URL + "/pdb/entry/summary/%s?pretty=true"

def make_request(url, data=None):
    request = urllib2.Request(url)

    try:
        url_file = urllib2.urlopen(request, data)
    except urllib2.HTTPError as e:
        if e.code == 404:
            print "[NOTFOUND %d] %s" % (e.code, url)
        else:
            print "[ERROR %d] %s" % (e.code, url)

        return None

    return url_file.read()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('-e', type=str, default=None, action='store', help='the pdbid')
    parser.add_argument('-p', type=str, default=None, action='store', help='the comma-separated list of pdbids')
    args = parser.parse_args()

    if args.e:
        response = make_request(REQUEST_URL % args.e)
    elif args.p:
        response = make_request(REQUEST_URL % "", args.p)
    else:
        parser.print_help()
        sys.exit(1)
    
    if response:
        print response
        
