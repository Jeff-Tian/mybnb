# coding:utf-8

import os
import hashlib
import json

rootDir = '/Users/tianjie/百度云同步盘/HouseForRent/ShanghaiTheFuture/'
result = dict()
hashes = dict()

for dirName, subDirList, fileList in os.walk(rootDir):
    print('Found directory: %s' % dirName)
    for fname in fileList:
        print('\t%s' % fname)
        fullName = dirName + fname
        image_file = open(fullName).read()
        hash = hashlib.md5(image_file).hexdigest()
        print('\t\t%s' % hash)
        result[fname] = {'hash': hash}
        if (hash in hashes):
            hashes[hash] = hashes[hash] + 1
            os.rename(fullName, './trash/' + fname)
        else:
            hashes[hash] = 1
        result[fname]['count'] = hashes[hash]

with open('./result.txt', 'w') as fp:
    json.dump(result, fp)
