# Importer files

The Ruby gem converts a blogger backup file into multiple posts.

Then, ```post_process.pl``` convert them from HTML to markdown and corrects some things.

After the first run, you use ```get_descriptions``` to retrieve post descriptions. They are missing in the blogger backup. Save them in ```descriptions.dat```. Edit, correct and complete the file. Preserve the blogger_orig_url header from posts until then.

Run 

    for i in _posts/*; do perl  ./get_assets.pl $i; done

to download all linked documents still online.

Once finished, run ```post_process.pl``` again to convert absolute links to relative link to downloaded assets.


