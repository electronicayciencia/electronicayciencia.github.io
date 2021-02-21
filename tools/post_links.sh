#!/bin/bash
# Create references for all the posts

dir="../_posts"

for file in `ls -r $dir`
do
    title=`grep ^title: $dir/$file | tr -d '\r\n' | cut -d' ' -f 2- | tr -d "'"`
	name=`basename $file .md`
    echo "- [Electrónica y Ciencia - $title]({{site.baseurl}}{% post_url $name %})"
done


