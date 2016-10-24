# coding:utf-8

# url("http://image.xiaozhustatic3.com/00,241,180/7,0,68,14153,1334,1000,54515c0f.jpg")"

from urlparse import urlsplit
from os.path import basename
import urllib2
import re
import os

dir_name = 'houses/'
if not os.path.exists(dir_name):
    os.mkdir(dir_name)

offset = 0
f = open('./houses/source.txt')
url_content = f.read()
answers = re.findall('http.+?\/(.+?\.jpg)', url_content)
img_count = 0

print len(answers)

while offset < len(answers):
    post_url = 'http://image2.xiaozhustatic1.com/00,1440,960/' + answers[offset]
    print post_url
    try:
        img_data = urllib2.urlopen(post_url).read()
        file_name = basename(urlsplit(post_url)[2])
        output = open(dir_name + file_name, 'wb')
        output.write(img_data)
        output.close()
        print "Saved {} images".format(img_count)
        # print "Saved {} images at url {}".format(img_count, img_url)
        img_count += 1
    except KeyboardInterrupt:
        print "Exit on user prompt"
        exit(1)
    except:
        pass
    finally:
        offset += 1
        print "Page down - offset {}".format(offset)
