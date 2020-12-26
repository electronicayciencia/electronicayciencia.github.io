#!/bin/bash

ruby -r rubygems -e 'require "jekyll-import";
    JekyllImport::Importers::Blogger.run({
      "source"                => "./blog-12-05-2020.xml",
      "no-blogger-info"       => false, # not to leave blogger-URL info (id and old URL) in the front matter
      "replace-internal-link" => false, # replace internal links using the post_url liquid tag.
    })'


for file in _posts/*
do 
  echo $i;
  name=`basename $file .html`

  echo "Processing $name..."
  perl post_process.pl $file > ../_posts/$name.md

done

