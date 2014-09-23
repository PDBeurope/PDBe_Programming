#!/usr/bin/env python

import urllib2
import argparse
import sys

SERVER_URL = "https://wwwdev.ebi.ac.uk/pdbe/api"

SUMMARY = "/pdb/entry/summary/"

def make_request(url, data):
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

def get_request(url, arg, pretty=True):
    full_url = "%s/%s/%s?pretty=%s" % (SERVER_URL, url, arg, str(pretty).lower())

    return make_request(full_url, None)

def post_request(url, data, pretty=True):
    full_url = "%s/%s/?pretty=%s" % (SERVER_URL, url, str(pretty).lower())

    if isinstance(data, (list, tuple)):
        data = ",".join(data)

    return make_request(full_url, data)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('-e', type=str, default=None, action='store', help='the pdbid')
    parser.add_argument('-p', type=str, default=None, action='store', help='the comma-separated list of pdbids')
    args = parser.parse_args()

    if args.e:
        response = get_request(SUMMARY, args.e)
    elif args.p:
        response = post_request(SUMMARY, args.p)
    else:
        parser.print_help()
        sys.exit(1)
    
    if response:
        print response
        
