<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5">
        <title>Array::Diff - Find the differences between two arrays - metacpan.org</title>
        <link rel="alternate" type="application/rss+xml" title="Recent CPAN Uploads of Array-Diff - MetaCPAN" href="/feed/distribution/Array-Diff" />
        <link href="/_assets/09a20e39bc03ec6c8fbc017562af3184c4c5b48e.css" rel="stylesheet" type="text/css">
        <link rel="search" href="/static/opensearch.xml" type="application/opensearchdescription+xml" title="MetaCPAN">
        <link rel="canonical" href="https://metacpan.org/pod/Array::Diff" />
        <meta name="description" content="Find the differences between two arrays" />
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
<meta name="twitter:url"         content="https://metacpan.org/pod/release/TYPESTER/Array-Diff-0.05002/lib/Array/Diff.pm" />
<meta name="twitter:title"       content="Array::Diff" />
<meta name="twitter:description" content="Find the differences between two arrays" />
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
    <a itemprop="url"  data-keyboard-shortcut="g a" rel="author" href="/author/TYPESTER" title="" class="author-name"><span itemprop="name" >Daisuke Murase</span></a>
  </span>
  <span>&nbsp;/&nbsp;</span>
  <div class="release status-cpan maturity-released">
    <span class="dropdown"><b class="caret"></b></span>
    <select class="" onchange="document.location.href=this.value">

  <option  value="/module/NEILB/Array-Diff-0.09/lib/Array/Diff.pm">
    0.09
      (NEILB on 2019-05-10)
      
  </option>

  <option  value="/module/NEILB/Array-Diff-0.08/lib/Array/Diff.pm">
    0.08
      (NEILB on 2019-05-08)
      
  </option>

  <option  value="/module/NEILB/Array-Diff-0.07_03/lib/Array/Diff.pm">
    0.07_03 DEV
      (NEILB on 2019-05-08)
      
  </option>

  <option  value="/module/NEILB/Array-Diff-0.07_02/lib/Array/Diff.pm">
    0.07_02 DEV
      (NEILB on 2019-05-07)
      
  </option>

  <option  value="/module/NEILB/Array-Diff-0.07_01/lib/Array/Diff.pm">
    0.07_01 DEV
      (NEILB on 2019-05-06)
      
  </option>

  <option  value="/module/TYPESTER/Array-Diff-0.07/lib/Array/Diff.pm">
    0.07
      (TYPESTER on 2010-10-08)
      
  </option>

  <option  value="/module/TYPESTER/Array-Diff-0.06/lib/Array/Diff.pm">
    0.06
      (TYPESTER on 2010-10-07)
      
  </option>

  <option selected value="/module/TYPESTER/Array-Diff-0.05002/lib/Array/Diff.pm">
    0.05002
      (TYPESTER on 2009-05-12)
      
  </option>

  <option  value="/module/TYPESTER/Array-Diff-0.05001/lib/Array/Diff.pm">
    0.05001
      (TYPESTER on 2009-05-11)
      
  </option>

  <option  value="/module/TYPESTER/Array-Diff-0.05/lib/Array/Diff.pm">
    0.05
      (TYPESTER on 2008-10-23)
      
  </option>

  <option  value="/module/TYPESTER/Array-Diff-0.04/lib/Array/Diff.pm">
    0.04
      (TYPESTER on 2006-09-02)
      
  </option>

  <option  value="/module/TYPESTER/Array-Diff-0.03/lib/Array/Diff.pm">
    0.03
      (TYPESTER on 2006-05-24)
      
  </option>

  <option  value="/module/TYPESTER/Array-Diff-0.02/lib/Array/Diff.pm">
    0.02
      (TYPESTER on 2006-04-04)
      
  </option>

  <option  value="/module/TYPESTER/Array-Diff-0.01/lib/Array/Diff.pm">
    0.01
      (TYPESTER on 2006-04-04)
      
  </option>
</select>
    
    <a data-keyboard-shortcut="g d" class="release-name" href="/release/TYPESTER/Array-Diff-0.05002">Array-Diff-0.05002</a>
    
    
  </div>
    <a class="latest" href="/pod/Array::Diff" title="go to latest"><span class="fa fa-step-forward"></span></a>
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
      <title>River stage three &#10;• 9 direct dependents &#10;• 856 total dependents</title>

      <!-- 5 bars, 4x15px, 1px apart, colored #e4e2e2 or #7ea3f2 -->
      <rect x="0"  y="0" width="4" height="15" fill="#7ea3f2" />
      <rect x="5"  y="0" width="4" height="15" fill="#7ea3f2" />
      <rect x="10" y="0" width="4" height="15" fill="#7ea3f2" />
      <rect x="15" y="0" width="4" height="15" fill="#e4e2e2" />
      <rect x="20" y="0" width="4" height="15" fill="#e4e2e2" />
    </g>
  </svg>


</span>
<div id="Array-Diff-fav" class="logged_in">
<form action="/account/favorite/add" style="display: inline" onsubmit="return favDistribution(this)">
    <input type="hidden" name="remove" value="0">
    <input type="hidden" name="release" value="Array-Diff-0.05002">
    <input type="hidden" name="author" value="TYPESTER">
    <input type="hidden" name="distribution" value="Array-Diff">
    <button type="submit" class="favorite highlight"><span>5</span> ++</button>
</form>
</div>
<div class="logged_out">
<a href="" onclick="alert('Please sign in to add favorites'); return false" class="favorite highlight">
<span>5</span> ++</a>
</div>

  &nbsp;/&nbsp;<span itemprop="name" >Array::Diff</span>
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
    <li class="nav-header">      <time class="relatize" itemprop="dateModified" datetime="2009-05-12">12 May 2009 02:57:08 UTC</time>
    </li>
    
    <li>
      Distribution: Array-Diff</span>
    </li>
    
    <li>
      Module version: <span itemprop="softwareVersion">0.05002</span>
    </li>
    
        <li>
      <a data-keyboard-shortcut="g s" href="/source/TYPESTER/Array-Diff-0.05002/lib/Array/Diff.pm"><i class="fa fa-fw fa-file-code-o black"></i>Source</a>
      (<a href="/source/TYPESTER/Array-Diff-0.05002/lib/Array/Diff.pm?raw=1">raw</a>)
    </li>
    
    <li>
      <a data-keyboard-shortcut="g b" href="/source/TYPESTER/Array-Diff-0.05002/lib/Array"><i class="fa fa-fw fa-folder-open black"></i>Browse</a>
      (<a href="/source/TYPESTER/Array-Diff-0.05002/lib/Array?raw=1">raw</a>)
    </li>
    <li>
    <a data-keyboard-shortcut="g c" href="/changes/release/TYPESTER/Array-Diff-0.05002"><i class="fa fa-fw fa-cogs black"></i>Changes</a>
</li>

<li>
    <a class="nopopup" href="/contributing-to/TYPESTER/Array-Diff-0.05002"><i class="fa fa-fw fa-plus-circle black"></i>How to Contribute</a>
</li>

<li>
    <a rel="noopener nofollow" data-keyboard-shortcut="g i" href="https://rt.cpan.org/Public/Dist/Display.html?Name=Array-Diff"><i class="fa fa-fw fa-info-circle black"></i>Issues</a>
    (0)
</li>
<li>
    
    <a rel="noopener nofollow" href="http://matrix.cpantesters.org/?dist=Array-Diff+0.05002" title="Matrix"><i class="fa fa-fw fa-check-circle black"></i>Testers</a>
    <span title="(pass / fail / na)">(<a rel="noopener nofollow" href="https://www.cpantesters.org/distro/A/Array-Diff.html?oncpan=1&amp;distmat=1&amp;version=0.05002&amp;grade=2" style="color: #090">1008</a> / <a rel="noopener nofollow" href="https://www.cpantesters.org/distro/A/Array-Diff.html?oncpan=1&amp;distmat=1&amp;version=0.05002&amp;grade=3" style="color: #900">1</a> / <a rel="noopener nofollow" href="https://www.cpantesters.org/distro/A/Array-Diff.html?oncpan=1&amp;distmat=1&amp;version=0.05002&amp;grade=4">0</a>)</span>
</li>
<li>
    <a rel="noopener nofollow" href="http://cpants.cpanauthors.org/release/TYPESTER/Array-Diff-0.05002"><i class="fa fa-fw fa-line-chart black"></i>Kwalitee</a>
</li>



<li><i class="fa fa-fw fa-gavel black"></i>License: perl_5</li>





    <li class="nav-header">Activity</li>
    <li><div class="activity-graph">
  <img src="/activity?res=month&amp;distribution=Array-Diff" width="170" height="22" />
  <div align="right"><small class="comment">24 month</small></div>
</div>
</li>
    <li class="nav-header">Tools</li>
<li>
    <a itemprop="downloadUrl" href="https://cpan.metacpan.org/authors/id/T/TY/TYPESTER/Array-Diff-0.05002.tar.gz">
    <i class="fa fa-download fa-fw black"></i>Download (<span itemprop="fileSize" >44.74Kb</span>)</a>
    
    <span class="invisible" itemprop="offers" itemscope itemtype="http://schema.org/Offer">
      <span itemprop="price">0</span>
    </span>
    
</li>
<li>
    <a href="https://explorer.metacpan.org/?url=/module/TYPESTER/Array-Diff-0.05002/lib%2FArray%2FDiff.pm">
    <i class="fa fa-list-alt fa-fw black"></i>MetaCPAN Explorer
    </a>
</li>
<li>
  <a href="/permission/distribution/Array-Diff">
    <i class="fa fa-key fa-fw black"></i>Permissions
  </a>
</li>
<li>
    <a href="/feed/distribution/Array-Diff">
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
        <input type="hidden" name="q" value="dist:Array-Diff">
        <input type="search" name="q" placeholder="Search distribution" style="width: 153px" class="form-control tool-bar-form">
        <input type="submit" style="display: none">
    </form>
</li>
<li>
    <form action="https://grep.metacpan.org/search">
        <input type="hidden" name="qd" value="Array-Diff">
        <input type="hidden" name="source" value="metacpan">
         <input type="search" name="q" placeholder="grep distribution" style="width: 153px" class="form-control tool-bar-form">
         <input type="submit" style="display: none">
     </form>
</li>
<li>
    <select onchange="document.location.href='/module/'+this.value" class="form-control tool-bar-form">
        <option>Jump to version</option>
    <option value="NEILB/Array-Diff-0.09/lib/Array/Diff.pm">0.09 (NEILB on 2019-05-10)</option>

    <option value="NEILB/Array-Diff-0.08/lib/Array/Diff.pm">0.08 (NEILB on 2019-05-08)</option>

    <option value="NEILB/Array-Diff-0.07_03/lib/Array/Diff.pm">0.07_03 DEV (NEILB on 2019-05-08)</option>

    <option value="NEILB/Array-Diff-0.07_02/lib/Array/Diff.pm">0.07_02 DEV (NEILB on 2019-05-07)</option>

    <option value="NEILB/Array-Diff-0.07_01/lib/Array/Diff.pm">0.07_01 DEV (NEILB on 2019-05-06)</option>

    <option value="TYPESTER/Array-Diff-0.07/lib/Array/Diff.pm">0.07 (TYPESTER on 2010-10-08)</option>

    <option value="TYPESTER/Array-Diff-0.06/lib/Array/Diff.pm">0.06 (TYPESTER on 2010-10-07)</option>

    <option value="TYPESTER/Array-Diff-0.05001/lib/Array/Diff.pm">0.05001 (TYPESTER on 2009-05-11)</option>

    <option value="TYPESTER/Array-Diff-0.05/lib/Array/Diff.pm">0.05 (TYPESTER on 2008-10-23)</option>

    <option value="TYPESTER/Array-Diff-0.04/lib/Array/Diff.pm">0.04 (TYPESTER on 2006-09-02)</option>

    <option value="TYPESTER/Array-Diff-0.03/lib/Array/Diff.pm">0.03 (TYPESTER on 2006-05-24)</option>

    <option value="TYPESTER/Array-Diff-0.02/lib/Array/Diff.pm">0.02 (TYPESTER on 2006-04-04)</option>

    <option value="TYPESTER/Array-Diff-0.01/lib/Array/Diff.pm">0.01 (TYPESTER on 2006-04-04)</option>

    </select>
</li>
<li>
    <select name="release" onchange="document.location.href='/diff/file/?target=TYPESTER/Array-Diff-0.05002/lib%2FArray%2FDiff.pm&amp;source=' + encodeURIComponent(this.value)" class="form-control tool-bar-form">
        <option>Diff with version</option>
    <option value="NEILB/Array-Diff-0.09/lib/Array/Diff.pm">0.09 (NEILB on 2019-05-10)</option>

    <option value="NEILB/Array-Diff-0.08/lib/Array/Diff.pm">0.08 (NEILB on 2019-05-08)</option>

    <option value="NEILB/Array-Diff-0.07_03/lib/Array/Diff.pm">0.07_03 DEV (NEILB on 2019-05-08)</option>

    <option value="NEILB/Array-Diff-0.07_02/lib/Array/Diff.pm">0.07_02 DEV (NEILB on 2019-05-07)</option>

    <option value="NEILB/Array-Diff-0.07_01/lib/Array/Diff.pm">0.07_01 DEV (NEILB on 2019-05-06)</option>

    <option value="TYPESTER/Array-Diff-0.07/lib/Array/Diff.pm">0.07 (TYPESTER on 2010-10-08)</option>

    <option value="TYPESTER/Array-Diff-0.06/lib/Array/Diff.pm">0.06 (TYPESTER on 2010-10-07)</option>

    <option value="TYPESTER/Array-Diff-0.05001/lib/Array/Diff.pm">0.05001 (TYPESTER on 2009-05-11)</option>

    <option value="TYPESTER/Array-Diff-0.05/lib/Array/Diff.pm">0.05 (TYPESTER on 2008-10-23)</option>

    <option value="TYPESTER/Array-Diff-0.04/lib/Array/Diff.pm">0.04 (TYPESTER on 2006-09-02)</option>

    <option value="TYPESTER/Array-Diff-0.03/lib/Array/Diff.pm">0.03 (TYPESTER on 2006-05-24)</option>

    <option value="TYPESTER/Array-Diff-0.02/lib/Array/Diff.pm">0.02 (TYPESTER on 2006-04-04)</option>

    <option value="TYPESTER/Array-Diff-0.01/lib/Array/Diff.pm">0.01 (TYPESTER on 2006-04-04)</option>

    </select>
</li>

<li class="nav-header">Permalinks</li>
<li>
    <a href="/pod/release/TYPESTER/Array-Diff-0.05002/lib/Array/Diff.pm">This version</a>
</li>
<li>
    <a itemprop="url" href="/pod/Array::Diff">Latest version</a>
</li>

  </ul>

  <button id="right-panel-toggle" class="btn-link" onclick="togglePanel('right'); return false;"><span class="panel-hidden">Show</span><span class="panel-visible">Hide</span> Right Panel</button>
  <div id="right-panel" class="pull-right">
  <div class="box-right">
  <!-- For plussers -->

<div class="plussers hidden-phone">
<div><b>++ed by:</b></div>




<a class="display-all" href="/author/TAPPER"><img src="https://www.gravatar.com/avatar/fea43bfe62aabfe66f2f2fb9313c166c?s=20&amp;d=identicon" title="TAPPER" alt="TAPPER"></a>



<a class="display-all" href="/author/KES"><img src="https://www.gravatar.com/avatar/e8530f00b43b4f6a056f8ad4ee52ea47?s=20&amp;d=identicon" title="KES" alt="KES"></a>



<!-- Display counts of plussers-->
<p>

<a href="/release/Array-Diff/plussers">2 PAUSE users</a><br>


3 non-PAUSE users.

</p>
</div>


<div class="author-pic">
<a href="/author/TYPESTER">
  <img src="https://www.gravatar.com/avatar/0d2a86f4099d096a4a6a9d1eb977bf38?s=130&amp;d=identicon" alt="Author image">
</a>
<strong>
  <a rel="author" href="/author/TYPESTER">TYPESTER</a>
</strong>
<span title="">Daisuke Murase</span>
</div>

  

  </div>
  <ul class="nav-list box-right hidden-phone dependencies">
    <li class="nav-header">Dependencies</li>
    <li><a href="/pod/Algorithm::Diff" title="Algorithm::Diff" class="ellipsis">Algorithm::Diff</a></li>
    <li><a href="/pod/Class::Accessor::Fast" title="Class::Accessor::Fast" class="ellipsis">Class::Accessor::Fast</a></li>
    <li><i class="ttip" title="dynamic_config enabled">and possibly others</i></li>
    <li><hr /></li>
    <li>
        <a href="http://deps.cpantesters.org/?module=Array::Diff">
        <i class="fa fa-retweet fa-fw black"></i>CPAN Testers List</a>
    </li>
    <li>        <a href="/requires/module/Array::Diff">        <i class="fa fa-share fa-fw black"></i>Reverse dependencies</a>
    </li>
    <li>
        <a href="https://cpandeps.grinnz.com/?dist=Array-Diff&dist_version=0.05002">
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
  <li><a href="#METHODS">METHODS</a></li>
  <li><a href="#SEE-ALSO">SEE ALSO</a></li>
  <li><a href="#AUTHOR">AUTHOR</a></li>
  <li><a href="#COPYRIGHT-AND-LICENSE">COPYRIGHT AND LICENSE</a></li>
</ul>

<h1 id="NAME">NAME</h1>

<p>Array::Diff - Find the differences between two arrays</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<pre><code>    my @old = ( &#39;a&#39;, &#39;b&#39;, &#39;c&#39; );
    my @new = ( &#39;b&#39;, &#39;c&#39;, &#39;d&#39; );
    
    my $diff = Array::Diff-&gt;diff( \@old, \@new );
    
    $diff-&gt;count   # 2
    $diff-&gt;added   # [ &#39;d&#39; ];
    $diff-&gt;deleted # [ &#39;a&#39; ];</code></pre>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>This module compares two arrays and returns the added or deleted elements in two separate arrays. It&#39;s a simple wrapper around <a href="/pod/Algorithm::Diff">Algorithm::Diff</a>.</p>

<p>And if you need more complex array tools, check <a href="/pod/Array::Compare">Array::Compare</a>.</p>

<h1 id="METHODS">METHODS</h1>

<dl>

<dt id="new-()"><a id="new"></a>new ()</dt>
<dd>

<p>Create a new <code>Array::Diff</code> object.</p>

</dd>
<dt id="diff-(-OLD,-NEW-)"><a id="diff"></a><a id="diff---OLD--NEW"></a>diff ( OLD, NEW )</dt>
<dd>

<p>Compute the differences between two arrays. The results are stored in the <code>added</code>, <code>deleted</code>, and <code>count</code> properties that may be examined using the corresponding methods.</p>

<p>This method may be invoked as an object method, in which case it will recalculate the differences and repopulate the <code>count</code>, <code>added</code>, and <code>removed</code> properties, or as a static method, in which case it will return a newly-created <code>Array::Diff</code> object with the properies set appropriately.</p>

</dd>
<dt id="added-(-[VALUES-]-)"><a id="added"></a><a id="added----VALUES"></a>added ( [VALUES ] )</dt>
<dd>

<p>Get or set the elements present in the <code>NEW</code> array and absent in the <code>OLD</code> one at the comparison performed by the last <code>diff()</code> invocation.</p>

</dd>
<dt id="deleted-(-[VALUES]-)"><a id="deleted"></a><a id="deleted----VALUES"></a>deleted ( [VALUES] )</dt>
<dd>

<p>Get or set the elements present in the <code>OLD</code> array and absent in the <code>NEW</code> one at the comparison performed by the last <code>diff()</code> invocation.</p>

</dd>
<dt id="count-(-[VALUE]-)"><a id="count"></a><a id="count----VALUE"></a>count ( [VALUE] )</dt>
<dd>

<p>Get or set the total number of added or deleted elements at the comparison performed by the last <code>diff()</code> invocation. This count should be equal to the sum of the number of elements in the <code>added</code> and <code>deleted</code> properties.</p>

</dd>
</dl>

<h1 id="SEE-ALSO"><a id="SEE"></a>SEE ALSO</h1>

<p><a href="/pod/Algorithm::Diff">Algorithm::Diff</a></p>

<h1 id="AUTHOR">AUTHOR</h1>

<p>Daisuke Murase &lt;typester@cpan.org&gt;</p>

<h1 id="COPYRIGHT-AND-LICENSE"><a id="COPYRIGHT"></a>COPYRIGHT AND LICENSE</h1>

<p>Copyright (c) 2009 by Daisuke Murase.</p>

<p>This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.</p>

<p>The full text of the license can be found in the LICENSE file included with this module.</p>
  
        <div id="install-instructions-dialog" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Module Install Instructions</h4>
            </div>
            <div class="modal-body">
                <p>To install Array::Diff, copy and paste the appropriate command in to your terminal.</p>
                <p><a href="/pod/distribution/App-cpanminus/bin/cpanm">cpanm</a></p>
                <pre>
                    cpanm Array::Diff
                </pre>
                <p><a href="/pod/CPAN">CPAN shell</a></p>
                <pre>
                    perl -MCPAN -e shell
                    install Array::Diff
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
