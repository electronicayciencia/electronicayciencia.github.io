#!/bin/bash

for file in _posts/*
do 
  name=`basename $file .html`

  #echo "Processing $name..."
  url=$(grep "^blogger_orig_url:" $file | cut -d' ' -f 2-)
  title=$(grep "^title:" $file | cut -d' ' -f 2-)
  content=$(curl -s $url)
  descr=$(echo $content | perl -ne "m{<meta content=[\"']([^\"']+)[\"'] name='description'} and print \$1")

  echo "\"$title\";\"$descr\""

done

