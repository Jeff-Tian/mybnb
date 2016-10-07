# $('img[src^="https://z2.muscache.com/ac"]').each(function(x, y){console.log(x, y.src);})

from urlparse import urlsplit
from os.path import basename
import urllib2
import re
import os

url = 'https://zh.airbnb.com/rooms/14047326'

dir_name = 'houses/'
if not os.path.exists(dir_name):
    os.mkdir(dir_name)

offset = 0
f = open('./houses/source.txt')
url_content = f.read()
answers = re.findall('z2\.muscache\.com\/ac\/pictures\/([^\.]+)\.jpg', url_content)
img_count = 0

print len(answers)

while offset < len(answers):
    post_url = "https://z2.muscache.com/ac/pictures/" + answers[offset] + ".jpg"
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
