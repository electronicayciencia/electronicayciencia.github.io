<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5">
        <title>Graphics::ColorUtils - Easy-to-use color space conversions and more. - metacpan.org</title>
        <link rel="alternate" type="application/rss+xml" title="Recent CPAN Uploads of Graphics-ColorUtils - MetaCPAN" href="/feed/distribution/Graphics-ColorUtils" />
        <link href="/_assets/09a20e39bc03ec6c8fbc017562af3184c4c5b48e.css" rel="stylesheet" type="text/css">
        <link rel="search" href="/static/opensearch.xml" type="application/opensearchdescription+xml" title="MetaCPAN">
        <link rel="canonical" href="https://metacpan.org/pod/Graphics::ColorUtils" />
        <meta name="description" content="Easy-to-use color space conversions and more." />
        <link rel="shortcut icon" href="/static/icons/favicon.ico">
        <link rel="apple-touch-icon" sizes="152x152" href="/static/icons/apple-touch-icon.png">
        <script src="/_assets/fd5168e65900c25667cf67492768981b6ae747ea.js" type="text/javascript" defer></script>
        <link rel="preload" href="/static/fonts/fa-regular-400.woff2" as="font" type="font/woff2" crossorigin />
        <link rel="preload" href="/static/fonts/fa-brands-400.woff2" as="font" type="font/woff2" crossorigin />
        <link rel="preload" href="/static/fonts/fa-solid-900.woff2" as="font" type="font/woff2" crossorigin />
        <script>
          (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
          (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
          m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
          })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

          ga('create', 'UA-27829474-1', {
              siteSpeedSampleRate : 100
          });
          ga('send', 'pageview');
        </script>
        
        <meta name="twitter:card"        content="summary" />
<meta name="twitter:url"         content="https://metacpan.org/pod/release/JANERT/Graphics-ColorUtils-0.17/lib/Graphics/ColorUtils.pm" />
<meta name="twitter:title"       content="Graphics::ColorUtils" />
<meta name="twitter:description" content="Easy-to-use color space conversions and more." />
<meta name="twitter:site"        content="metacpan" />

        
    </head>
    <body>
        <nav class="navbar navbar-default" role="navigation">
            <div class="container-fluid">
                <ul class="nav navbar-nav">
                <li class="visible-xs">
                <a href="#" data-toggle="slidepanel" data-target=".slidepanel">
                  <i class="fa fa-bars icon-slidepanel"></i>
                </a>
                </li>
            
                    <li class="">
                        <a href="/"><img src="/static/icons/metacpan-icon.png"  alt="MetaCPAN icon"/>                            Home                        </a>
                    </li>
                    <li class="">
                        <a href="https://grep.metacpan.org"><i class="fa fa-search"></i>                            grep::cpan                        </a>
                    </li>
                    <li class="">
                        <a href="/recent"><i class="fa fa-history"></i>                            Recent                        </a>
                    </li>
                    <li class="hidden-xs">
                        <a href="/about"><i class="fa fa-info"></i>                            About                        </a>
                    </li>
                    <li class="hidden-xs">
                        <a href="/about/faq"><i class="fa fa-question"></i>                            FAQ                        </a>
                    </li>
                    <li class="hidden-xs">
                        <a href="https://github.com/metacpan/metacpan-web/issues"><i class="fa fa-github-alt"></i>                            GitHub Issues                        </a>
                    </li>
                    <li class="hidden-xs">
                        <a href="/news"><i class="fa fa-newspaper-o"></i>                            News                        </a>
                    </li>
                    <li class="hidden-xs">
                        <a href="/tools"><i class="fa fa-wrench"></i>                            Tools                        </a>
                    </li>
                    <li class="hidden-xs">
                        <a href="https://fastapi.metacpan.org"><i class="fa fa-database"></i>                            API                        </a>
                    </li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <form action="/account/logout" method="POST" id="metacpan-logout"></form>
                    <li class="dropdown logged_in" style="display: none;">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        Account
                        <b class="caret"></b>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="/account/identities">Identities</a></li>
                            <li><a href="/account/profile">Profile</a></li>
                            <li><a href="/account/favorite/list">Favorites</a></li>
                            <li>
                                <a href="#" onclick="$('#metacpan-logout').submit(); return false">Logout</a>
                            </li>
                        </ul>
                    </li>
                    <li class="dropdown logged_out" style="display: none;">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        Sign in
                        <b class="caret"></b>
                        </a>
                        <ul class="dropdown-menu">
                            <li>
                                <a href="https://fastapi.metacpan.org/oauth2/authorize?client_id=metacpan.org&amp;choice=github" onclick="return logInPAUSE(this)">
                                <i class="fa fa-github fa-fw"></i>
                                GitHub
                                </a>
                            </li>
                            <li>
                                <a href="https://fastapi.metacpan.org/oauth2/authorize?client_id=metacpan.org&amp;choice=twitter" onclick="return logInPAUSE(this)">
                                <i class="fa fa-twitter fa-fw"></i>
                                Twitter
                                </a>
                            </li>
                            <li>
                                <a href="https://fastapi.metacpan.org/oauth2/authorize?client_id=metacpan.org&amp;choice=google" onclick="return logInPAUSE(this)">
                                <i class="fa fa-google fa-fw"></i>
                                Google
                                </a>
                            </li>
                            <li>
                                <a href="/login/openid">
                                <i class="fa fa-openid fa-fw"></i>
                                OpenID
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>

        <div class="container-fluid">

        

            
            <div class="row hidden-phone">
                <div class="head-small-logo col-md-3">
                    <a href="/" class="small-logo"></a>
                </div>
                <div class="col-md-9">
                    <form action="/search" class="search-form form-horizontal">
                        <div class="form-group">
                            <div class="input-group">
                                <input type="text" name="q" size="41" id="search-input" class="form-control" value="">
                                <span class="input-group-btn">
                                    <button class="btn search-btn" type="submit">Search</button>
                                </span>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            

            <div class="row">
                <div class="main-content col-md-12">
                    




<div itemscope itemtype="http://schema.org/SoftwareApplication">
  


<div class="breadcrumbs">
  <span itemprop="author" itemscope itemtype="http://schema.org/Person" >
    <a itemprop="url"  data-keyboard-shortcut="g a" rel="author" href="/author/JANERT" title="" class="author-name"><span itemprop="name" >Philipp K. Janert</span></a>
  </span>
  <span>&nbsp;/&nbsp;</span>
  <div class="release status-latest maturity-released">
    <span class="dropdown"><b class="caret"></b></span>
    <select class="" onchange="document.location.href=this.value">

  <option selected value="/module/JANERT/Graphics-ColorUtils-0.17/lib/Graphics/ColorUtils.pm">
    0.17
      (JANERT on 2007-05-21)
      
  </option>

  <option  value="/module/JANERT/Graphics-ColorUtils-0.15/lib/Graphics/ColorUtils.pm">
    0.15
      (JANERT on 2007-04-12)
      
  </option>

  <option  value="/module/JANERT/Graphics-ColorUtils-0.11/lib/Graphics/ColorUtils.pm">
    0.11
      (JANERT on 2007-04-09)
      
  </option>

  <option  value="/module/JANERT/Graphics-ColorUtils-0.09/lib/Graphics/ColorUtils.pm">
    0.09
      (JANERT on 2007-03-19)
      
  </option>
        <optgroup label="BackPAN">
          

  <option  value="/module/JANERT/Graphics-ColorUtils-0.07/lib/Graphics/ColorUtils.pm">
    0.07
      (JANERT on 2007-03-17)
      
  </option>

  <option  value="/module/JANERT/Graphics-ColorUtils-0.05/lib/Graphics/ColorUtils.pm">
    0.05
      (JANERT on 2007-03-16)
      
  </option>

  <option  value="/module/JANERT/Graphics-ColorUtils-0.03/lib/Graphics/ColorUtils.pm">
    0.03
      (JANERT on 2006-11-14)
      
  </option>
        </optgroup>
    
</select>
    
    <a data-keyboard-shortcut="g d" class="release-name" href="/release/JANERT/Graphics-ColorUtils-0.17">Graphics-ColorUtils-0.17</a>
    
    
  </div>
  <!--
  Unlike an <img>, an <object> grafts the SVG document into the DOM, which
  means browsers will display the <title> elements of the SVG.  Yay!
-->
<span class="river-gauge-gauge">

  <svg width="24px"
       height="15px"
       version="1.1"
       xmlns="http://www.w3.org/2000/svg"
       xmlns:xlink="http://www.w3.org/1999/xlink">

    <g>
      <!--
        There is some careful attention below to the resulting whitespace
        after template interpolation, ensuring that the tooltip looks good on
        both Chrome and Firefox. Please don't adjust it blithely, thanks!
      -->
      <title>River stage two &#10;• 4 direct dependents &#10;• 15 total dependents</title>

      <!-- 5 bars, 4x15px, 1px apart, colored #e4e2e2 or #7ea3f2 -->
      <rect x="0"  y="0" width="4" height="15" fill="#7ea3f2" />
      <rect x="5"  y="0" width="4" height="15" fill="#7ea3f2" />
      <rect x="10" y="0" width="4" height="15" fill="#e4e2e2" />
      <rect x="15" y="0" width="4" height="15" fill="#e4e2e2" />
      <rect x="20" y="0" width="4" height="15" fill="#e4e2e2" />
    </g>
  </svg>


</span>
<div id="Graphics-ColorUtils-fav" class="logged_in">
<form action="/account/favorite/add" style="display: inline" onsubmit="return favDistribution(this)">
    <input type="hidden" name="remove" value="0">
    <input type="hidden" name="release" value="Graphics-ColorUtils-0.17">
    <input type="hidden" name="author" value="JANERT">
    <input type="hidden" name="distribution" value="Graphics-ColorUtils">
    <button type="submit" class="favorite highlight"><span>2</span> ++</button>
</form>
</div>
<div class="logged_out">
<a href="" onclick="alert('Please sign in to add favorites'); return false" class="favorite highlight">
<span>2</span> ++</a>
</div>

  &nbsp;/&nbsp;<span itemprop="name" >Graphics::ColorUtils</span>
</div>

  <ul class="nav-list slidepanel">
    <li class="visible-xs">
      <div>
    <form action="/search">
        <input type="search" class="form-control tool-bar-form" placeholder="Search" name="q">
        <input type="submit" class="hidden">
    </form>
</div>

    </li>
    <li class="nav-header">      <time class="relatize" itemprop="dateModified" datetime="2007-05-21">21 May 2007 00:14:11 UTC</time>
    </li>
    
    <li>
      Distribution: Graphics-ColorUtils</span>
    </li>
    
    <li>
      Module version: <span itemprop="softwareVersion">0.17</span>
    </li>
    
        <li>
      <a data-keyboard-shortcut="g s" href="/source/JANERT/Graphics-ColorUtils-0.17/lib/Graphics/ColorUtils.pm"><i class="fa fa-fw fa-file-code-o black"></i>Source</a>
      (<a href="/source/JANERT/Graphics-ColorUtils-0.17/lib/Graphics/ColorUtils.pm?raw=1">raw</a>)
    </li>
    
    <li>
      <a data-keyboard-shortcut="g b" href="/source/JANERT/Graphics-ColorUtils-0.17/lib/Graphics"><i class="fa fa-fw fa-folder-open black"></i>Browse</a>
      (<a href="/source/JANERT/Graphics-ColorUtils-0.17/lib/Graphics?raw=1">raw</a>)
    </li>
    <li>
    <a data-keyboard-shortcut="g c" href="/changes/release/JANERT/Graphics-ColorUtils-0.17"><i class="fa fa-fw fa-cogs black"></i>Changes</a>
</li>

<li>
    <a class="nopopup" href="/contributing-to/JANERT/Graphics-ColorUtils-0.17"><i class="fa fa-fw fa-plus-circle black"></i>How to Contribute</a>
</li>

<li>
    <a rel="noopener nofollow" data-keyboard-shortcut="g i" href="https://rt.cpan.org/Public/Dist/Display.html?Name=Graphics-ColorUtils"><i class="fa fa-fw fa-info-circle black"></i>Issues</a>
    
</li>
<li>
    
    <a rel="noopener nofollow" href="http://matrix.cpantesters.org/?dist=Graphics-ColorUtils+0.17" title="Matrix"><i class="fa fa-fw fa-check-circle black"></i>Testers</a>
    <span title="(pass / fail / na)">(<a rel="noopener nofollow" href="https://www.cpantesters.org/distro/G/Graphics-ColorUtils.html?oncpan=1&amp;distmat=1&amp;version=0.17&amp;grade=2" style="color: #090">6077</a> / <a rel="noopener nofollow" href="https://www.cpantesters.org/distro/G/Graphics-ColorUtils.html?oncpan=1&amp;distmat=1&amp;version=0.17&amp;grade=3" style="color: #900">0</a> / <a rel="noopener nofollow" href="https://www.cpantesters.org/distro/G/Graphics-ColorUtils.html?oncpan=1&amp;distmat=1&amp;version=0.17&amp;grade=4">37</a>)</span>
</li>
<li>
    <a rel="noopener nofollow" href="http://cpants.cpanauthors.org/release/JANERT/Graphics-ColorUtils-0.17"><i class="fa fa-fw fa-line-chart black"></i>Kwalitee</a>
</li>

  <li>
    <i class="fa fa-fw fa-pie-chart black"></i><a rel="noopener nofollow" href="http://cpancover.com/latest/Graphics-ColorUtils-0.17/index.html">95.22% Coverage </a>
  </li>



<li><i class="fa fa-fw fa-gavel black"></i>License: unknown</li>





    <li class="nav-header">Activity</li>
    <li><div class="activity-graph">
  <img src="/activity?res=month&amp;distribution=Graphics-ColorUtils" width="170" height="22" />
  <div align="right"><small class="comment">24 month</small></div>
</div>
</li>
    <li class="nav-header">Tools</li>
<li>
    <a itemprop="downloadUrl" href="https://cpan.metacpan.org/authors/id/J/JA/JANERT/Graphics-ColorUtils-0.17.tar.gz">
    <i class="fa fa-download fa-fw black"></i>Download (<span itemprop="fileSize" >21.45Kb</span>)</a>
    
    <span class="invisible" itemprop="offers" itemscope itemtype="http://schema.org/Offer">
      <span itemprop="price">0</span>
    </span>
    
</li>
<li>
    <a href="https://explorer.metacpan.org/?url=/module/JANERT/Graphics-ColorUtils-0.17/lib%2FGraphics%2FColorUtils.pm">
    <i class="fa fa-list-alt fa-fw black"></i>MetaCPAN Explorer
    </a>
</li>
<li>
  <a href="/permission/distribution/Graphics-ColorUtils">
    <i class="fa fa-key fa-fw black"></i>Permissions
  </a>
</li>
<li>
    <a href="/feed/distribution/Graphics-ColorUtils">
    <i class="fa fa-rss-square fa-fw black"></i>Subscribe to distribution
    </a>
</li>
<li>
    <button class="btn btn-link" data-toggle="modal" data-target="#install-instructions-dialog">
      <i class="fa fa-terminal fa-fw black"></i>Install Instructions
    </button>
</li>
<li>
    <form action="/search">
        <input type="hidden" name="q" value="dist:Graphics-ColorUtils">
        <input type="search" name="q" placeholder="Search distribution" style="width: 153px" class="form-control tool-bar-form">
        <input type="submit" style="display: none">
    </form>
</li>
<li>
    <form action="https://grep.metacpan.org/search">
        <input type="hidden" name="qd" value="Graphics-ColorUtils">
        <input type="hidden" name="source" value="metacpan">
         <input type="search" name="q" placeholder="grep distribution" style="width: 153px" class="form-control tool-bar-form">
         <input type="submit" style="display: none">
     </form>
</li>
<li>
    <select onchange="document.location.href='/module/'+this.value" class="form-control tool-bar-form">
        <option>Jump to version</option>
    <option value="JANERT/Graphics-ColorUtils-0.15/lib/Graphics/ColorUtils.pm">0.15 (JANERT on 2007-04-12)</option>

    <option value="JANERT/Graphics-ColorUtils-0.11/lib/Graphics/ColorUtils.pm">0.11 (JANERT on 2007-04-09)</option>

    <option value="JANERT/Graphics-ColorUtils-0.09/lib/Graphics/ColorUtils.pm">0.09 (JANERT on 2007-03-19)</option>

<optgroup label="BackPAN"></optgroup>

    <option value="JANERT/Graphics-ColorUtils-0.07/lib/Graphics/ColorUtils.pm">0.07 (JANERT on 2007-03-17)
    </option>

    <option value="JANERT/Graphics-ColorUtils-0.05/lib/Graphics/ColorUtils.pm">0.05 (JANERT on 2007-03-16)
    </option>

    <option value="JANERT/Graphics-ColorUtils-0.03/lib/Graphics/ColorUtils.pm">0.03 (JANERT on 2006-11-14)
    </option>


    </select>
</li>
<li>
    <select name="release" onchange="document.location.href='/diff/file/?target=JANERT/Graphics-ColorUtils-0.17/lib%2FGraphics%2FColorUtils.pm&amp;source=' + encodeURIComponent(this.value)" class="form-control tool-bar-form">
        <option>Diff with version</option>
    <option value="JANERT/Graphics-ColorUtils-0.15/lib/Graphics/ColorUtils.pm">0.15 (JANERT on 2007-04-12)</option>

    <option value="JANERT/Graphics-ColorUtils-0.11/lib/Graphics/ColorUtils.pm">0.11 (JANERT on 2007-04-09)</option>

    <option value="JANERT/Graphics-ColorUtils-0.09/lib/Graphics/ColorUtils.pm">0.09 (JANERT on 2007-03-19)</option>

<optgroup label="BackPAN"></optgroup>

    <option value="JANERT/Graphics-ColorUtils-0.07/lib/Graphics/ColorUtils.pm">0.07 (JANERT on 2007-03-17)
    </option>

    <option value="JANERT/Graphics-ColorUtils-0.05/lib/Graphics/ColorUtils.pm">0.05 (JANERT on 2007-03-16)
    </option>

    <option value="JANERT/Graphics-ColorUtils-0.03/lib/Graphics/ColorUtils.pm">0.03 (JANERT on 2006-11-14)
    </option>


    </select>
</li>

<li class="nav-header">Permalinks</li>
<li>
    <a href="/pod/release/JANERT/Graphics-ColorUtils-0.17/lib/Graphics/ColorUtils.pm">This version</a>
</li>
<li>
    <a itemprop="url" href="/pod/Graphics::ColorUtils">Latest version</a>
</li>

  </ul>

  <button id="right-panel-toggle" class="btn-link" onclick="togglePanel('right'); return false;"><span class="panel-hidden">Show</span><span class="panel-visible">Hide</span> Right Panel</button>
  <div id="right-panel" class="pull-right">
  <div class="box-right">
  <!-- For plussers -->

<div class="plussers hidden-phone">
<div><b>++ed by:</b></div>




<a class="display-all" href="/author/DMOL"><img src="https://www.gravatar.com/avatar/78b28a931707c0fa696996adc7702db9?s=20&amp;d=identicon" title="DMOL" alt="DMOL"></a>



<!-- Display counts of plussers-->
<p>

<a href="/release/Graphics-ColorUtils/plussers">1 PAUSE user</a><br>


1 non-PAUSE user.

</p>
</div>


<div class="author-pic">
<a href="/author/JANERT">
  <img src="https://www.gravatar.com/avatar/7879c14732b8c0c9e94d59b8cf1712a2?s=130&amp;d=identicon" alt="Author image">
</a>
<strong>
  <a rel="author" href="/author/JANERT">JANERT</a>
</strong>
<span title="">Philipp K. Janert</span>
</div>

  

  </div>
  <ul class="nav-list box-right hidden-phone dependencies">
    <li class="nav-header">Dependencies</li>
    <li><i class="ttip" title="dynamic_config enabled">unknown</i></li>
    <li><hr /></li>
    <li>
        <a href="http://deps.cpantesters.org/?module=Graphics::ColorUtils">
        <i class="fa fa-retweet fa-fw black"></i>CPAN Testers List</a>
    </li>
    <li>        <a href="/requires/module/Graphics::ColorUtils">        <i class="fa fa-share fa-fw black"></i>Reverse dependencies</a>
    </li>
    <li>
        <a href="https://cpandeps.grinnz.com/?dist=Graphics-ColorUtils&dist_version=0.17">
        <i class="fa fa-asterisk fa-fw black"></i>Dependency graph</a>
    </li>
</ul>

  </div>
  <a name="___pod"></a>
  <div class="pod content anchors">

  
  <ul id="index">
  <li><a href="#NAME">NAME</a></li>
  <li><a href="#SYNOPSIS">SYNOPSIS</a></li>
  <li><a href="#DESCRIPTION">DESCRIPTION</a></li>
  <li><a href="#CONVENTIONS">CONVENTIONS</a></li>
  <li><a href="#METHODS">METHODS</a>
    <ul>
      <li><a href="#Color-Space-Conversions1">Color Space Conversions</a></li>
      <li><a href="#Color-Names">Color Names</a></li>
      <li><a href="#Color-Gradients1">Color Gradients</a></li>
    </ul>
  </li>
  <li><a href="#EXPORT">EXPORT</a></li>
  <li><a href="#BUGS">BUGS</a></li>
  <li><a href="#TODO">TODO</a></li>
  <li><a href="#SEE-ALSO">SEE ALSO</a>
    <ul>
      <li><a href="#Related-Modules">Related Modules</a></li>
      <li><a href="#Standard-Color-Sets">Standard Color Sets</a></li>
      <li><a href="#Websites">Websites</a></li>
      <li><a href="#Books">Books</a></li>
    </ul>
  </li>
  <li><a href="#AUTHOR">AUTHOR</a></li>
  <li><a href="#COPYRIGHT-AND-LICENSE">COPYRIGHT AND LICENSE</a></li>
</ul>

<h1 id="NAME">NAME</h1>

<p>Graphics::ColorUtils - Easy-to-use color space conversions and more.</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<pre><code>  use Graphics::ColorUtils;

  ( $y, $i, $q ) = rgb2yiq( $r, $g, $b );
  ( $r, $g, $b ) = yiq2rgb( $y, $i, $q );
  $hex_string    = yiq2rgb( $y, $i, $q );

  ( $c, $m, $y ) = rgb2cmy( $r, $g, $b );
  ( $r, $g, $b ) = cmy2rgb( $c, $m, $y );
  $hex_string    = cmy2rgb( $c, $m, $y );

  ( $h, $l, $s ) = rgb2hls( $r, $g, $b );
  ( $r, $g, $b ) = hls2rgb( $h, $l, $s );
  $hex_string    = hls2rgb( $h, $l, $s );

  ( $h, $s, $v ) = rgb2hsv( $r, $g, $b );
  ( $r, $g, $b ) = hsv2rgb( $h, $s, $v );
  $hex_string    = hsv2rgb( $h, $s, $v );

  # -----

  use Graphics::ColorUtils qw( :gradients );

  ( $r, $g, $b ) = grad2rgb( $name, $f );  # where 0.0 &lt;= $f &lt; 1.0
  $hex_string    = grad2rgb( $name, $f );

  %color_count_for_gradient_name = available_gradients();
  $array_ref_of_rgb_triples      = gradient( $name );
  $array_ref_old_grad            = register_gradient( $name, $array_ref_of_rgb_triples ); 

  # -----

  use Graphics::ColorUtils qw( :names );

  ( $r, $g, $b ) = name2rgb( $name );
  $hex_string    = name2rgb( $name );

  $hash_ref_rgb_triples_for_name = available_names();
  ( $old_r, $old_g, $old_b )     = register_name( $name, $r, $g, $b );
  $old_hex_string                = register_name( $name, $r, $g, $b );
  $default_ns                    = get_default_namespace();
  $old_ns                        = set_default_namespace( $new_ns );</code></pre>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>This modules provides some utility functions to handle colors and color space conversions.</p>

<p>The interface has been kept simple, so that most functions can be called &quot;inline&quot; when making calls to graphics libraries such as GD, Tk, or when generating HTML/CSS. (E.g. for GD: <code>$c = $img-&gt;colorAllocate( hsv2rgb( 270, 0.5, 0.3 ) );</code>.)</p>

<p>Features:</p>

<dl>

<dt id="Color-Space-Conversions"><a id="Color"></a>Color Space Conversions</dt>
<dd>

<p>Color space conversions, in particular between the &quot;intuitive&quot; color spaces HSV (Hue/Saturation/Value) and HLS (Hue/Lightness/Saturation) to and from RGB (Red/Green/Blue).</p>

</dd>
<dt id="Color-Lookup"><a id="Color1"></a>Color Lookup</dt>
<dd>

<p>Color lookup by name for three standard sets of colors: WWW/CSS, SVG, and X11.</p>

</dd>
<dt id="Color-Gradients"><a id="Color2"></a>Color Gradients</dt>
<dd>

<p>Management of color gradients, which can be indexed by a floating point number in the range 0..1. (Mostly intended for false-color data visualization.)</p>

</dd>
</dl>

<h1 id="CONVENTIONS">CONVENTIONS</h1>

<p>Legal values:</p>

<pre><code>  Y, I, Q: 0..1
  C, M, Y: 0..1

  R, G, B: 0..255 (may be float on input, guaranteed int on output)

  H:       0..360 (red=0-&gt;yellow-&gt;green=120-&gt;cyan-&gt;blue=240-&gt;magenta steps of 60)
  S, V:    0..1
  L, S:    0..1</code></pre>

<p>All <code>...2rgb</code> functions return a three-element array in list context, and a string formatted according to <code>&quot;#%02x%02x%02x&quot;</code> (e.g. <code>&#39;#ff3a18&#39;</code>) in scalar context.</p>

<h1 id="METHODS">METHODS</h1>

<h2 id="Color-Space-Conversions1"><a id="Color3"></a>Color Space Conversions</h2>

<dl>

<dt id="YIQ">YIQ</dt>
<dd>

<p><code>rgb2yiq( $r, $g, $b )</code> and <code>yiq2rgb( $y, $i, $q)</code></p>

</dd>
<dt id="CMY">CMY</dt>
<dd>

<p><code>rgb2cmy( $r, $g, $b )</code> and <code>cmy2rgb( $c, $m, $y)</code></p>

</dd>
<dt id="HSV">HSV</dt>
<dd>

<p><code>rgb2hsv( $r, $g, $b )</code> and <code>hsv2rgb( $h, $s, $v)</code></p>

</dd>
<dt id="HLS">HLS</dt>
<dd>

<p><code>rgb2hls( $r, $g, $b )</code> and <code>hls2rgb( $h, $l, $s)</code></p>

</dd>
</dl>

<p>All these methods take a triple of values and return a triple of converted values. However, <b>in scalar context</b> the <code>...2rgb</code> methods return a string formatted according to <code>&quot;#%02x%02x%02x&quot;</code> (e.g. <code>&#39;#ff3a18&#39;</code>). This format is appropriate e.g. for calls to Tk routines: <code>$mw-&gt;widget( -color =</code> hls2rgb( 180, 0.2, 0.1 ) );&gt;, etc.</p>

<h2 id="Color-Names"><a id="Color4"></a>Color Names</h2>

<p>Names can be arbitrary strings. If names contain a colon (<code>&#39;:&#39;</code>), the part of the name before the colon is considered a &quot;namespace&quot; specification. Namespaces allow to have multiple color values corresponding to the same name and to control the priority in which those values will be retrieved.</p>

<dl>

<dt id="name2rgb(-$name-)"><a id="name2rgb"></a><a id="name2rgb---name"></a><code>name2rgb( $name )</code></dt>
<dd>

<p>Returns a triple <code>( $r, $g, $b )</code> in list context or a a hex-string in scalar context if the name has been found, <code>undef</code> otherwise.</p>

<p>The name is normalized before lookup is attempted. Normalization consists of: lowercasing and elimination of whitespace. Also, &quot;gray&quot; is replaced with &quot;grey&quot;.</p>

<p>If the name is prefixed with a namespace (separated by colon a <code>&#39;:&#39;</code>), only this namespace is searched. If no namespace is specified, then the lookup occurs first in the global namespace, then in the default namespace.</p>

</dd>
<dt id="available_names()"><a id="available_names"></a><code>available_names()</code></dt>
<dd>

<p>Returns a reference to a hash, the keys of which are the color names, and the values are references to three-element arrays of RGB values.</p>

</dd>
<dt id="register_name(-$name,-$r,-$g,-$b-)"><a id="register_name"></a><a id="register_name---name---r---g---b"></a><code>register_name( $name, $r, $g, $b )</code></dt>
<dd>

<p>Takes a name and an RGB triple. Stores the triple for the given name. The name will be normalized (lowercased, whitespace eliminated, &#39;gray&#39; replaced by &#39;grey&#39;) before assignment is made.</p>

<p>If the name is not prefixed by a namespace, the color will be entered into the global namespace.</p>

<p>Returns the old value for the name, if the name already exists, <code>undef</code> otherwise.</p>

</dd>
<dt id="get_default_namespace()"><a id="get_default_namespace"></a><code>get_default_namespace()</code></dt>
<dd>

<p>Returns the current value of the default namespace. Note that the empty string <code>&#39;&#39;</code> corresponds to the <i>global</i> namespace.</p>

</dd>
<dt id="set_default_namespace()"><a id="set_default_namespace"></a><code>set_default_namespace()</code></dt>
<dd>

<p>Sets the default namespace. Returns the previous value.</p>

<p>Giving an empty string as argument makes the global namespace the default. Note that the global namespace is initially <i>empty</i>.</p>

<p>(On startup, the default namespace is <code>&#39;x11&#39;</code>.)</p>

</dd>
</dl>

<h2 id="Color-Gradients1"><a id="Color5"></a>Color Gradients</h2>

<dl>

<dt id="grad2rgb(-$name,-$f-)"><a id="grad2rgb"></a><a id="grad2rgb---name---f"></a><code>grad2rgb( $name, $f )</code></dt>
<dd>

<p>Given the name of a gradient and a floating point number between 0 and 1, returns the color (as RGB triple or formatted hex-string) corresponding to the position in the gradient given by <code>$f</code>. Returns <code>undef</code> when gradient not found or <code>$f</code> outside valid range.</p>

</dd>
<dt id="available_gradients()"><a id="available_gradients"></a><code>available_gradients()</code></dt>
<dd>

<p>Returns a hash, the keys of which are the names of the known gradients and the values being the number of colors in the corresponding gradient.</p>

</dd>
<dt id="gradient(-$name-)"><a id="gradient"></a><a id="gradient---name"></a><code>gradient( $name )</code></dt>
<dd>

<p>Given the name of a gradient, returns a reference to an array of RGB triples or <code>undef</code> if the gradient is not found.</p>

</dd>
<dt id="register_gradient(-$name,-$array_ref-)"><a id="register_gradient"></a><a id="register_gradient---name---array_ref"></a><code>register_gradient( $name, $array_ref )</code></dt>
<dd>

<p>Takes the name of a (possibly new) gradient and a reference to an array of RGB triples. Stores the array as gradient for that name. If the gradient name already existed, returns a reference to the old array, <code>undef</code> otherwise.</p>

</dd>
</dl>

<p>An introduction, together with a large number of sample gradients can be found at Paul Bourke&#39;s webpage: http://local.wasp.uwa.edu.au/~pbourke/texture_colour/colourramp/</p>

<h1 id="EXPORT">EXPORT</h1>

<p>Exports by default:</p>

<pre><code>  rgb2yiq(), yiq2rgb()
  rgb2cmy(), cmy2rgb()
  rgb2hls(), hls2rgb()
  rgb2hsv(), hsv2rgb()</code></pre>

<p>Using the export tag <code>:names</code>, exports the following additional methods:</p>

<pre><code>  name2rgb()
  available_names()
  register_name()
  set_default_namespace()
  get_default_namespace()</code></pre>

<p>Using the export tag <code>:gradients</code>, exports the following additional methods:</p>

<pre><code>  gradient()
  grad2rgb()
  available_gradients()
  register_gradient()</code></pre>

<h1 id="BUGS">BUGS</h1>

<dl>

<dt id="Input-parameter-validation"><a id="Input"></a>Input parameter validation</dt>
<dd>

<p>Most methods do <i>not</i> explicitly validate that their arguments lie in the valid range.</p>

</dd>
<dt id="Multiple-namespaces"><a id="Multiple"></a>Multiple namespaces</dt>
<dd>

<p>Names containing multiple colons may not be handled correctly.</p>

</dd>
<dt id="Hue-wrap-around"><a id="Hue"></a>Hue wrap-around</dt>
<dd>

<p>While hue should be restricted to 0..360, both <code>hsv2rgb()</code> and <code>hls2rgb()</code> tolerate &quot;moderate&quot; violation of this constraint (up to +/- 359).</p>

</dd>
</dl>

<h1 id="TODO">TODO</h1>

<dl>

<dt id="Perl-Versions"><a id="Perl"></a>Perl Versions</dt>
<dd>

<p>This module has only been explicitly tested with Perl 5.8, but nothing (should) prevent it from running fine with other versions of Perl.</p>

</dd>
<dt id="Additional-color-space-conversions"><a id="Additional"></a>Additional color space conversions</dt>
<dd>

<p>For instance to and from XYZ, CIE, Luv; <i>if desired!</i>.</p>

</dd>
<dt id="Additional-pre-defined-gradients"><a id="Additional1"></a>Additional pre-defined gradients</dt>
<dd>

<p>Suggestions welcome!</p>

</dd>
</dl>

<h1 id="SEE-ALSO"><a id="SEE"></a>SEE ALSO</h1>

<h2 id="Related-Modules"><a id="Related"></a>Related Modules</h2>

<dl>

<dt id="Color::Rgb"><a id="Color6"></a>Color::Rgb</dt>
<dd>

<p>Lookup of color values for names. Similar to the &quot;names&quot; methods in this module. Requires <i>X11/rgb.txt</i>.</p>

</dd>
<dt id="Graphics::ColorNames"><a id="Graphics"></a>Graphics::ColorNames</dt>
<dd>

<p>Lookup of color values for names. Similar to the &quot;names&quot; methods in this module. Does <i>not</i> require <i>X11/rgb.txt</i>. Comes with several sets of predefined color names (similar to this module).</p>

</dd>
<dt id="Graphics::ColorObject"><a id="Graphics1"></a>Graphics::ColorObject</dt>
<dd>

<p>Color space conversions, including conversions to and from XYZ and Luv. Object-oriented interface requires instantiation of a &quot;color-object&quot; for each color, which can then provide a representation of itself in all color spaces.</p>

</dd>
<dt id="Color::Scheme"><a id="Color7"></a>Color::Scheme</dt>
<dd>

<p>Generates pleasant color schemes (sets of colors).</p>

</dd>
</dl>

<h2 id="Standard-Color-Sets"><a id="Standard"></a>Standard Color Sets</h2>

<dl>

<dt id="WWW/CSS"><a id="WWW"></a><a id="WWW-CSS"></a>WWW/CSS</dt>
<dd>

<p>The 16 (or 17, including &quot;orange&quot;) colors defined by the W3: http://www.w3.org/TR/css3-color</p>

</dd>
<dt id="SVG">SVG</dt>
<dd>

<p>The 138 unique named colors (140 normalized unique names) defined for SVG by the W3: http://www.w3.org/TR/SVG/types.html#ColorKeywords</p>

</dd>
<dt id="X11">X11</dt>
<dd>

<p>The 502 unique named colors (549 normalized unique names) defined by the X11 libraries in /usr/lib/X11/rgb.txt on an X11 system</p>

</dd>
</dl>

<h2 id="Websites">Websites</h2>

<ul>

<li><p>Poynton&#39;s Color FAQ: http://www.poynton.com/ColorFAQ.html</p>

</li>
<li><p>Paper on Color Conversion Algorithms: http://www.poynton.com/PDFs/coloureq.pdf</p>

</li>
<li><p>Paul Bourke&#39;s Webpage with many relevant details: http://local.wasp.uwa.edu.au/~pbourke/texture_colour/</p>

</li>
</ul>

<h2 id="Books">Books</h2>

<ul>

<li><p><b>Computer Graphics - Principles and Practice</b> by James D. Foley, Andries van Dam, Steven K. Feiner, John F. Hughes (Second Edition in C, 1990, mult. print runs)</p>

<p><i>A comprehensive reference. <b>Beware of typos in the algorithms!</b></i></p>

</li>
<li><p><b>Introduction to Computer Graphics</b> by James D. Foley, Andries van Dam, Steven K. Feiner, John F. Hughes, Richard L. Phillips (1990, mult. print runs)</p>

<p><i>A textbook based on the previous title. Possibly more accessible and available.</i></p>

</li>
<li><p><b>Computer Graphics - C Version</b> by Donald Hearn and M. Pauline Baker (2nd ed, 1997)</p>

<p><i>Another textbook.</i></p>

</li>
</ul>

<h1 id="AUTHOR">AUTHOR</h1>

<p>Philipp K. Janert, &lt;janert at ieee dot org &gt;, http://www.beyondcode.org</p>

<h1 id="COPYRIGHT-AND-LICENSE"><a id="COPYRIGHT"></a>COPYRIGHT AND LICENSE</h1>

<p>Copyright (C) 2006 by Philipp K. Janert</p>

<p>This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself, either Perl version 5.8.3 or, at your option, any later version of Perl 5 you may have available.</p>
  
        <div id="install-instructions-dialog" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Module Install Instructions</h4>
            </div>
            <div class="modal-body">
                <p>To install Graphics::ColorUtils, copy and paste the appropriate command in to your terminal.</p>
                <p><a href="/pod/distribution/App-cpanminus/bin/cpanm">cpanm</a></p>
                <pre>
                    cpanm Graphics::ColorUtils
                </pre>
                <p><a href="/pod/CPAN">CPAN shell</a></p>
                <pre>
                    perl -MCPAN -e shell
                    install Graphics::ColorUtils
                </pre>
                <p>For more information on module installation, please visit <a href="https://www.cpan.org/modules/INSTALL.html">the detailed CPAN module installation guide</a>.</p>
            </div>
            <div class="modal-footer">
                <a href="#" data-dismiss="modal" class="btn">Close</a>
            </div>
        </div>
    </div>
</div>

  </div>
</div>

                </div>
            </div>

            <div class="row footer">
                <div class="hidden-xs hidden-sm col-md-2">&nbsp;</div>
                <div class="col-xs-2 col-sm-1 col-md-1" style="text-align: center">
                    <a href="https://fastapi.metacpan.org">API</a>
                </div>
                <div class="col-xs-5 col-sm-3 col-md-2" style="text-align: center">
                    <a href="/about">About MetaCPAN</a>
                </div>
                <div class="hidden-xs col-sm-2 col-md-2" style="text-align: center">
                    <a href="/mirrors">CPAN Mirrors</a>
                </div>
                <div class="hidden-xs col-sm-3 col-md-2" style="text-align: center">
                    <a href="https://github.com/metacpan/metacpan-web">Fork metacpan.org</a>
                </div>
                <div class="hidden-xs col-sm-1 col-md-1" style="text-align: center">
                    <a href="https://www.perl.org/">Perl.org</a>
                </div>
            </div>

            <div class="row" style="padding: 50px 15px 30px">
              <div class="col-xs-9 col-md-3" style="padding:25px">
                <a href="https://www.bytemark.co.uk/r/metacpan.org/" target="_blank" rel="noopener">
                  <img width="170" src="/static/images/sponsors/bytemark_logo.png" alt="Bytemark logo">
                </a>
              </div>
              <div class="col-xs-9 col-md-3" style="padding:15px">
                <a target="_blank" href="https://www.liquidweb.com/" rel="noopener">
                  <img width="170" src="/static/images/sponsors/liquidweb_color.png" alt="liquidweb logo">
                </a>
              </div>
              <div class="col-xs-9 col-md-3" style="padding:15px">
                <a target="_blank" href="https://www.yellowbot.com/" rel="noopener">
                  <img width="170" src="/static/images/sponsors/yellowbot-small.png" alt="YellowBot logo">
                </a>
              </div>
              <div class="col-xs-9 col-md-3" style="padding:15px">
                <a href="https://www.fastly.com/" target="_blank" rel="noopener">
                  <img src="/static/images/sponsors/fastly_logo.png" width=110 height=51 alt="Fastly logo">
                </a>
              </div>
            </div>
            <div class="row">
              <div class="col-xs-18 col-xs-offset-3 col-md-6" style="padding-bottom: 20px">
                As a valued partner and proud supporter of MetaCPAN, StickerYou is
                happy to offer a 10% discount on all <a href="https://www.stickeryou.com/products/custom-stickers/335/" target="_blank" rel="noopener">Custom Stickers</a>,
                <a href="https://www.stickeryou.com/products/business-labels/655" target="_blank" rel="noopener">Business Labels</a>, Roll Labels,
                Vinyl Lettering or Custom Decals.  <a href="http://StickerYou.com" target="_blank" rel="noopener">StickerYou.com</a>
                is your one-stop shop to make your business stick.
                Use code <strong>METACPAN10</strong> at checkout to apply your discount.
              </div>
            </div>
        </div>
        <div class="modal fade" tabindex="-1" role="dialog" id="keyboard-shortcuts">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h4 class="modal-title">Keyboard Shortcuts</h4>
              </div>
              <div class="modal-body row">
                <div class="col-md-6">
  <table class="table keyboard-shortcuts">
    <thead>
      <tr>
        <th></th>
        <th>Global</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td class="keys">
          <kbd>s</kbd>
        </td>
        <td>Focus search bar</td>
      </tr>
      <tr>
        <td class="keys">
          <kbd>?</kbd>
        </td>
        <td>Bring up this help dialog</td>
      </tr>
    </tbody>
  </table>

  <table class="table keyboard-shortcuts">
    <thead>
      <tr>
        <th></th>
        <th>GitHub</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td class="keys">
          <kbd>g</kbd> <kbd>p</kbd>
        </td>
        <td>Go to pull requests</td>
      </tr>
      <tr>
        <td class="keys">
          <kbd>g</kbd> <kbd>i</kbd>
        </td>
        <td>go to github issues (only if github is preferred repository)</td>
      </tr>
    </tbody>
  </table>
</div>

<div class="col-md-6">
  <table class="table keyboard-shortcuts">
    <thead>
      <tr>
        <th></th>
        <th>POD</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td class="keys">
          <kbd>g</kbd> <kbd>a</kbd>
        </td>
        <td>Go to author</td>
      </tr>
      <tr>
        <td class="keys">
          <kbd>g</kbd> <kbd>c</kbd>
        </td>
        <td>Go to changes</td>
      </tr>
      <tr>
        <td class="keys">
          <kbd>g</kbd> <kbd>i</kbd>
        </td>
        <td>Go to issues</td>
      </tr>
      <tr>
        <td class="keys">
          <kbd>g</kbd> <kbd>d</kbd>
        </td>
        <td>Go to dist</td>
      </tr>
      <tr>
        <td class="keys">
          <kbd>g</kbd> <kbd>r</kbd>
        </td>
        <td>Go to repository/SCM</td>
      </tr>
      <tr>
        <td class="keys">
          <kbd>g</kbd> <kbd>s</kbd>
        </td>
        <td>Go to source</td>
      </tr>
      <tr>
        <td class="keys">
          <kbd>g</kbd> <kbd>b</kbd>
        </td>
        <td>Go to file browse</td>
      </tr>

    </tbody>
  </table>
</div>

              </div>
              <div class="modal-footer"></div>
            </div>
          </div>
        </div>
    </body>
</html>
