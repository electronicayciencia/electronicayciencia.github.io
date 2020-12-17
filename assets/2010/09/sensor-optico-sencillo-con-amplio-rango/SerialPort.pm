<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5">
        <title>Device::SerialPort - Linux/POSIX emulation of Win32::SerialPort functions. - metacpan.org</title>
        <link rel="alternate" type="application/rss+xml" title="Recent CPAN Uploads of Device-SerialPort - MetaCPAN" href="/feed/distribution/Device-SerialPort" />
        <link href="/_assets/09a20e39bc03ec6c8fbc017562af3184c4c5b48e.css" rel="stylesheet" type="text/css">
        <link rel="search" href="/static/opensearch.xml" type="application/opensearchdescription+xml" title="MetaCPAN">
        <link rel="canonical" href="https://metacpan.org/pod/Device::SerialPort" />
        <meta name="description" content="Linux/POSIX emulation of Win32::SerialPort functions." />
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
<meta name="twitter:url"         content="https://metacpan.org/pod/distribution/Device-SerialPort/SerialPort.pm" />
<meta name="twitter:title"       content="Device::SerialPort" />
<meta name="twitter:description" content="Linux/POSIX emulation of Win32::SerialPort functions." />
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
    <a itemprop="url"  data-keyboard-shortcut="g a" rel="author" href="/author/COOK" title="" class="author-name"><span itemprop="name" >Kees Cook</span></a>
  </span>
  <span>&nbsp;/&nbsp;</span>
  <div class="release status-latest maturity-released">
    <span class="dropdown"><b class="caret"></b></span>
    <select class="" onchange="document.location.href=this.value">

  <option selected value="/module/COOK/Device-SerialPort-1.04/SerialPort.pm">
    1.04
      (COOK on 2007-10-24)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-1.003001/SerialPort.pm">
    1.003001
      (COOK on 2007-07-21)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-1.003/SerialPort.pm">
    1.003
      (COOK on 2007-07-20)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-1.002001/SerialPort.pm">
    1.002001
      (COOK on 2007-06-16)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-1.002/SerialPort.pm">
    1.002
      (COOK on 2004-11-09)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-1.000002/SerialPort.pm">
    1.000002
      (COOK on 2004-05-11)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-1.000001/SerialPort.pm">
    1.000001
      (COOK on 2004-03-29)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-1/SerialPort.pm">
    1
      (COOK on 2004-02-23)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-0.22/SerialPort.pm">
    0.22
      (COOK on 2003-06-18)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-0.21/SerialPort.pm">
    0.21
      (COOK on 2003-06-12)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-0.20/SerialPort.pm">
    0.20
      (COOK on 2003-06-12)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-0.12/SerialPort.pm">
    0.12
      (COOK on 2001-11-04)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-0.11/SerialPort.pm">
    0.11
      (COOK on 2001-07-18)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-0.10/SerialPort.pm">
    0.10
      (COOK on 2001-02-13)
      
  </option>

  <option  value="/module/COOK/Device-SerialPort-0.09/SerialPort.pm">
    0.09
      (COOK on 2001-01-27)
      
  </option>
        <optgroup label="BackPAN">
          

  <option  value="/module/BBIRTH/Device-SerialPort-0.070/SerialPort.pm">
    0.070
      (BBIRTH on 1999-09-08)
      
  </option>

  <option  value="/module/BBIRTH/Device-SerialPort-0.06/SerialPort.pm">
    0.06
      (BBIRTH on 1999-08-14)
      
  </option>

  <option  value="/module/BBIRTH/Device-SerialPort-0.05/SerialPort.pm">
    0.05
      (BBIRTH on 1999-08-02)
      
  </option>

  <option  value="/module/BBIRTH/Device-SerialPort-0.04/SerialPort.pm">
    0.04
      (BBIRTH on 1999-07-22)
      
  </option>
        </optgroup>
    
</select>
    
    <a data-keyboard-shortcut="g d" class="release-name" href="/release/Device-SerialPort">Device-SerialPort-1.04</a>
    
    
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
      <title>River stage two &#10;• 52 direct dependents &#10;• 65 total dependents</title>

      <!-- 5 bars, 4x15px, 1px apart, colored #e4e2e2 or #7ea3f2 -->
      <rect x="0"  y="0" width="4" height="15" fill="#7ea3f2" />
      <rect x="5"  y="0" width="4" height="15" fill="#7ea3f2" />
      <rect x="10" y="0" width="4" height="15" fill="#e4e2e2" />
      <rect x="15" y="0" width="4" height="15" fill="#e4e2e2" />
      <rect x="20" y="0" width="4" height="15" fill="#e4e2e2" />
    </g>
  </svg>


</span>
<div id="Device-SerialPort-fav" class="logged_in">
<form action="/account/favorite/add" style="display: inline" onsubmit="return favDistribution(this)">
    <input type="hidden" name="remove" value="0">
    <input type="hidden" name="release" value="Device-SerialPort-1.04">
    <input type="hidden" name="author" value="COOK">
    <input type="hidden" name="distribution" value="Device-SerialPort">
    <button type="submit" class="favorite highlight"><span>2</span> ++</button>
</form>
</div>
<div class="logged_out">
<a href="" onclick="alert('Please sign in to add favorites'); return false" class="favorite highlight">
<span>2</span> ++</a>
</div>

  &nbsp;/&nbsp;<span itemprop="name" >Device::SerialPort</span>
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
    <li class="nav-header">      <time class="relatize" itemprop="dateModified" datetime="2007-10-24">24 Oct 2007 05:59:47 UTC</time>
    </li>
    
    <li>
      Distribution: Device-SerialPort</span>
    </li>
    
    <li>
      Module version: <span itemprop="softwareVersion">1.04</span>
    </li>
    
        <li>
      <a data-keyboard-shortcut="g s" href="/release/Device-SerialPort/source/SerialPort.pm"><i class="fa fa-fw fa-file-code-o black"></i>Source</a>
      (<a href="/release/Device-SerialPort/source/SerialPort.pm?raw=1">raw</a>)
    </li>
    
    <li>
      <a data-keyboard-shortcut="g b" href="/release/Device-SerialPort/source/"><i class="fa fa-fw fa-folder-open black"></i>Browse</a>
      (<a href="/release/Device-SerialPort/source/?raw=1">raw</a>)
    </li>
    <li>
    <a data-keyboard-shortcut="g c" href="/changes/distribution/Device-SerialPort"><i class="fa fa-fw fa-cogs black"></i>Changes</a>
</li>

<li>
    <a class="nopopup" href="/contributing-to/Device-SerialPort"><i class="fa fa-fw fa-plus-circle black"></i>How to Contribute</a>
</li>

<li>
    <a rel="noopener nofollow" data-keyboard-shortcut="g i" href="https://rt.cpan.org/Public/Dist/Display.html?Name=Device-SerialPort"><i class="fa fa-fw fa-info-circle black"></i>Issues</a>
    (12)
</li>
<li>
    
    <a rel="noopener nofollow" href="http://matrix.cpantesters.org/?dist=Device-SerialPort+1.04" title="Matrix"><i class="fa fa-fw fa-check-circle black"></i>Testers</a>
    <span title="(pass / fail / na)">(<a rel="noopener nofollow" href="https://www.cpantesters.org/distro/D/Device-SerialPort.html?oncpan=1&amp;distmat=1&amp;version=1.04&amp;grade=2" style="color: #090">9427</a> / <a rel="noopener nofollow" href="https://www.cpantesters.org/distro/D/Device-SerialPort.html?oncpan=1&amp;distmat=1&amp;version=1.04&amp;grade=3" style="color: #900">362</a> / <a rel="noopener nofollow" href="https://www.cpantesters.org/distro/D/Device-SerialPort.html?oncpan=1&amp;distmat=1&amp;version=1.04&amp;grade=4">2</a>)</span>
</li>
<li>
    <a rel="noopener nofollow" href="http://cpants.cpanauthors.org/release/COOK/Device-SerialPort-1.04"><i class="fa fa-fw fa-line-chart black"></i>Kwalitee</a>
</li>

  <li>
    <i class="fa fa-fw fa-pie-chart black"></i><a rel="noopener nofollow" href="http://cpancover.com/latest/Device-SerialPort-1.04/index.html">2.92% Coverage </a>
  </li>



<li><i class="fa fa-fw fa-gavel black"></i>License: unknown</li>





    <li class="nav-header">Activity</li>
    <li><div class="activity-graph">
  <img src="/activity?res=month&amp;distribution=Device-SerialPort" width="170" height="22" />
  <div align="right"><small class="comment">24 month</small></div>
</div>
</li>
    <li class="nav-header">Tools</li>
<li>
    <a itemprop="downloadUrl" href="https://cpan.metacpan.org/authors/id/C/CO/COOK/Device-SerialPort-1.04.tar.gz">
    <i class="fa fa-download fa-fw black"></i>Download (<span itemprop="fileSize" >96.39Kb</span>)</a>
    
    <span class="invisible" itemprop="offers" itemscope itemtype="http://schema.org/Offer">
      <span itemprop="price">0</span>
    </span>
    
</li>
<li>
    <a href="https://explorer.metacpan.org/?url=/module/COOK/Device-SerialPort-1.04/SerialPort.pm">
    <i class="fa fa-list-alt fa-fw black"></i>MetaCPAN Explorer
    </a>
</li>
<li>
  <a href="/permission/distribution/Device-SerialPort">
    <i class="fa fa-key fa-fw black"></i>Permissions
  </a>
</li>
<li>
    <a href="/feed/distribution/Device-SerialPort">
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
        <input type="hidden" name="q" value="dist:Device-SerialPort">
        <input type="search" name="q" placeholder="Search distribution" style="width: 153px" class="form-control tool-bar-form">
        <input type="submit" style="display: none">
    </form>
</li>
<li>
    <form action="https://grep.metacpan.org/search">
        <input type="hidden" name="qd" value="Device-SerialPort">
        <input type="hidden" name="source" value="metacpan">
         <input type="search" name="q" placeholder="grep distribution" style="width: 153px" class="form-control tool-bar-form">
         <input type="submit" style="display: none">
     </form>
</li>
<li>
    <select onchange="document.location.href='/module/'+this.value" class="form-control tool-bar-form">
        <option>Jump to version</option>
    <option value="COOK/Device-SerialPort-1.003001/SerialPort.pm">1.003001 (COOK on 2007-07-21)</option>

    <option value="COOK/Device-SerialPort-1.003/SerialPort.pm">1.003 (COOK on 2007-07-20)</option>

    <option value="COOK/Device-SerialPort-1.002001/SerialPort.pm">1.002001 (COOK on 2007-06-16)</option>

    <option value="COOK/Device-SerialPort-1.002/SerialPort.pm">1.002 (COOK on 2004-11-09)</option>

    <option value="COOK/Device-SerialPort-1.000002/SerialPort.pm">1.000002 (COOK on 2004-05-11)</option>

    <option value="COOK/Device-SerialPort-1.000001/SerialPort.pm">1.000001 (COOK on 2004-03-29)</option>

    <option value="COOK/Device-SerialPort-1/SerialPort.pm">1 (COOK on 2004-02-23)</option>

    <option value="COOK/Device-SerialPort-0.22/SerialPort.pm">0.22 (COOK on 2003-06-18)</option>

    <option value="COOK/Device-SerialPort-0.21/SerialPort.pm">0.21 (COOK on 2003-06-12)</option>

    <option value="COOK/Device-SerialPort-0.20/SerialPort.pm">0.20 (COOK on 2003-06-12)</option>

    <option value="COOK/Device-SerialPort-0.12/SerialPort.pm">0.12 (COOK on 2001-11-04)</option>

    <option value="COOK/Device-SerialPort-0.11/SerialPort.pm">0.11 (COOK on 2001-07-18)</option>

    <option value="COOK/Device-SerialPort-0.10/SerialPort.pm">0.10 (COOK on 2001-02-13)</option>

    <option value="COOK/Device-SerialPort-0.09/SerialPort.pm">0.09 (COOK on 2001-01-27)</option>

<optgroup label="BackPAN"></optgroup>

    <option value="BBIRTH/Device-SerialPort-0.070/SerialPort.pm">0.070 (BBIRTH on 1999-09-08)
    </option>

    <option value="BBIRTH/Device-SerialPort-0.06/SerialPort.pm">0.06 (BBIRTH on 1999-08-14)
    </option>

    <option value="BBIRTH/Device-SerialPort-0.05/SerialPort.pm">0.05 (BBIRTH on 1999-08-02)
    </option>

    <option value="BBIRTH/Device-SerialPort-0.04/SerialPort.pm">0.04 (BBIRTH on 1999-07-22)
    </option>


    </select>
</li>
<li>
    <select name="release" onchange="document.location.href='/diff/file/?target=COOK/Device-SerialPort-1.04/SerialPort.pm&amp;source=' + encodeURIComponent(this.value)" class="form-control tool-bar-form">
        <option>Diff with version</option>
    <option value="COOK/Device-SerialPort-1.003001/SerialPort.pm">1.003001 (COOK on 2007-07-21)</option>

    <option value="COOK/Device-SerialPort-1.003/SerialPort.pm">1.003 (COOK on 2007-07-20)</option>

    <option value="COOK/Device-SerialPort-1.002001/SerialPort.pm">1.002001 (COOK on 2007-06-16)</option>

    <option value="COOK/Device-SerialPort-1.002/SerialPort.pm">1.002 (COOK on 2004-11-09)</option>

    <option value="COOK/Device-SerialPort-1.000002/SerialPort.pm">1.000002 (COOK on 2004-05-11)</option>

    <option value="COOK/Device-SerialPort-1.000001/SerialPort.pm">1.000001 (COOK on 2004-03-29)</option>

    <option value="COOK/Device-SerialPort-1/SerialPort.pm">1 (COOK on 2004-02-23)</option>

    <option value="COOK/Device-SerialPort-0.22/SerialPort.pm">0.22 (COOK on 2003-06-18)</option>

    <option value="COOK/Device-SerialPort-0.21/SerialPort.pm">0.21 (COOK on 2003-06-12)</option>

    <option value="COOK/Device-SerialPort-0.20/SerialPort.pm">0.20 (COOK on 2003-06-12)</option>

    <option value="COOK/Device-SerialPort-0.12/SerialPort.pm">0.12 (COOK on 2001-11-04)</option>

    <option value="COOK/Device-SerialPort-0.11/SerialPort.pm">0.11 (COOK on 2001-07-18)</option>

    <option value="COOK/Device-SerialPort-0.10/SerialPort.pm">0.10 (COOK on 2001-02-13)</option>

    <option value="COOK/Device-SerialPort-0.09/SerialPort.pm">0.09 (COOK on 2001-01-27)</option>

<optgroup label="BackPAN"></optgroup>

    <option value="BBIRTH/Device-SerialPort-0.070/SerialPort.pm">0.070 (BBIRTH on 1999-09-08)
    </option>

    <option value="BBIRTH/Device-SerialPort-0.06/SerialPort.pm">0.06 (BBIRTH on 1999-08-14)
    </option>

    <option value="BBIRTH/Device-SerialPort-0.05/SerialPort.pm">0.05 (BBIRTH on 1999-08-02)
    </option>

    <option value="BBIRTH/Device-SerialPort-0.04/SerialPort.pm">0.04 (BBIRTH on 1999-07-22)
    </option>


    </select>
</li>

<li class="nav-header">Permalinks</li>
<li>
    <a href="/pod/release/COOK/Device-SerialPort-1.04/SerialPort.pm">This version</a>
</li>
<li>
    <a itemprop="url" href="/pod/Device::SerialPort">Latest version</a>
</li>

  </ul>

  <button id="right-panel-toggle" class="btn-link" onclick="togglePanel('right'); return false;"><span class="panel-hidden">Show</span><span class="panel-visible">Hide</span> Right Panel</button>
  <div id="right-panel" class="pull-right">
  <div class="box-right">
  <!-- For plussers -->

<div class="plussers hidden-phone">
<div><b>++ed by:</b></div>




<!-- Display counts of plussers-->
<p>


2 non-PAUSE users.

</p>
</div>


<div class="author-pic">
<a href="/author/COOK">
  <img src="https://www.gravatar.com/avatar/c3a43f7746dba80b1f5a79c79262ef39?s=130&amp;d=identicon" alt="Author image">
</a>
<strong>
  <a rel="author" href="/author/COOK">COOK</a>
</strong>
<span title="">Kees Cook</span>
</div>

  

  </div>
  <ul class="nav-list box-right hidden-phone dependencies">
    <li class="nav-header">Dependencies</li>
    <li><i class="ttip" title="dynamic_config enabled">unknown</i></li>
    <li><hr /></li>
    <li>
        <a href="http://deps.cpantesters.org/?module=Device::SerialPort">
        <i class="fa fa-retweet fa-fw black"></i>CPAN Testers List</a>
    </li>
    <li>        <a href="/requires/module/Device::SerialPort">        <i class="fa fa-share fa-fw black"></i>Reverse dependencies</a>
    </li>
    <li>
        <a href="https://cpandeps.grinnz.com/?dist=Device-SerialPort">
        <i class="fa fa-asterisk fa-fw black"></i>Dependency graph</a>
    </li>
</ul>

  </div>
  <a name="___pod"></a>
  <div class="pod content anchors">

  
  <ul id="index">
  <li><a href="#NAME">NAME</a></li>
  <li><a href="#SYNOPSIS">SYNOPSIS</a>
    <ul>
      <li><a href="#Constructors">Constructors</a></li>
      <li><a href="#Configuration-Utility-Methods">Configuration Utility Methods</a></li>
      <li><a href="#Configuration-Parameter-Methods">Configuration Parameter Methods</a></li>
      <li><a href="#Operating-Methods">Operating Methods</a></li>
      <li><a href="#Methods-used-with-Tied-FileHandles">Methods used with Tied FileHandles</a></li>
      <li><a href="#Destructors">Destructors</a></li>
      <li><a href="#Methods-for-I/O-Processing">Methods for I/O Processing</a></li>
    </ul>
  </li>
  <li><a href="#DESCRIPTION">DESCRIPTION</a>
    <ul>
      <li><a href="#Initialization">Initialization</a></li>
      <li><a href="#Configuration-Utility-Methods1">Configuration Utility Methods</a></li>
      <li><a href="#Configuration-and-Capability-Methods">Configuration and Capability Methods</a></li>
      <li><a href="#Operating-Methods1">Operating Methods</a></li>
      <li><a href="#Stty-Shortcuts">Stty Shortcuts</a></li>
      <li><a href="#Lookfor-and-I/O-Processing">Lookfor and I/O Processing</a></li>
      <li><a href="#Exports">Exports</a></li>
    </ul>
  </li>
  <li><a href="#PINOUT">PINOUT</a></li>
  <li><a href="#NOTES">NOTES</a></li>
  <li><a href="#EXAMPLE">EXAMPLE</a></li>
  <li><a href="#PORTING">PORTING</a></li>
  <li><a href="#KNOWN-LIMITATIONS">KNOWN LIMITATIONS</a></li>
  <li><a href="#BUGS">BUGS</a></li>
  <li><a href="#Win32::SerialPort-&amp;-Win32API::CommPort">Win32::SerialPort &amp; Win32API::CommPort</a>
    <ul>
      <li><a href="#Win32::SerialPort-Functions-Not-Currently-Supported">Win32::SerialPort Functions Not Currently Supported</a></li>
      <li><a href="#Functions-Handled-in-a-POSIX-system-by-%22stty%22">Functions Handled in a POSIX system by &quot;stty&quot;</a></li>
      <li><a href="#Win32::SerialPort-Functions-Not-Ported-to-POSIX">Win32::SerialPort Functions Not Ported to POSIX</a></li>
      <li><a href="#Win32API::CommPort-Functions-Not-Ported-to-POSIX">Win32API::CommPort Functions Not Ported to POSIX</a></li>
      <li><a href="#%22raw%22-Win32-API-Calls-and-Constants">&quot;raw&quot; Win32 API Calls and Constants</a></li>
      <li><a href="#Compatibility">Compatibility</a></li>
    </ul>
  </li>
  <li><a href="#AUTHORS">AUTHORS</a></li>
  <li><a href="#SEE-ALSO">SEE ALSO</a></li>
  <li><a href="#COPYRIGHT">COPYRIGHT</a></li>
</ul>

<h1 id="NAME">NAME</h1>

<p>Device::SerialPort - Linux/POSIX emulation of Win32::SerialPort functions.</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<pre><code>  use Device::SerialPort qw( :PARAM :STAT 0.07 );</code></pre>

<h2 id="Constructors">Constructors</h2>

<pre><code>  # $lockfile is optional
  $PortObj = new Device::SerialPort ($PortName, $quiet, $lockfile)
       || die &quot;Can&#39;t open $PortName: $!\n&quot;;

  $PortObj = start Device::SerialPort ($Configuration_File_Name)
       || die &quot;Can&#39;t start $Configuration_File_Name: $!\n&quot;;

  $PortObj = tie (*FH, &#39;Device::SerialPort&#39;, $Configuration_File_Name)
       || die &quot;Can&#39;t tie using $Configuration_File_Name: $!\n&quot;;</code></pre>

<h2 id="Configuration-Utility-Methods"><a id="Configuration"></a>Configuration Utility Methods</h2>

<pre><code>  $PortObj-&gt;alias(&quot;MODEM1&quot;);

  $PortObj-&gt;save($Configuration_File_Name)
       || warn &quot;Can&#39;t save $Configuration_File_Name: $!\n&quot;;

  # currently optional after new, POSIX version expected to succeed
  $PortObj-&gt;write_settings;

  # rereads file to either return open port to a known state
  # or switch to a different configuration on the same port
  $PortObj-&gt;restart($Configuration_File_Name)
       || warn &quot;Can&#39;t reread $Configuration_File_Name: $!\n&quot;;

  # &quot;app. variables&quot; saved in $Configuration_File, not used internally
  $PortObj-&gt;devicetype(&#39;none&#39;);     # CM11, CM17, &#39;weeder&#39;, &#39;modem&#39;
  $PortObj-&gt;hostname(&#39;localhost&#39;);  # for socket-based implementations
  $PortObj-&gt;hostaddr(0);            # false unless specified
  $PortObj-&gt;datatype(&#39;raw&#39;);        # in case an application needs_to_know
  $PortObj-&gt;cfg_param_1(&#39;none&#39;);    # null string &#39;&#39; hard to save/restore
  $PortObj-&gt;cfg_param_2(&#39;none&#39;);    # 3 spares should be enough for now
  $PortObj-&gt;cfg_param_3(&#39;none&#39;);    # one may end up as a log file path

  # test suite use only
  @necessary_param = Device::SerialPort-&gt;set_test_mode_active(1);

  # exported by :PARAM
  nocarp || carp &quot;Something fishy&quot;;
  $a = SHORTsize;                       # 0xffff
  $a = LONGsize;                        # 0xffffffff
  $answer = yes_true(&quot;choice&quot;);         # 1 or 0
  OS_Error unless ($API_Call_OK);       # prints error</code></pre>

<h2 id="Configuration-Parameter-Methods"><a id="Configuration1"></a>Configuration Parameter Methods</h2>

<pre><code>  # most methods can be called two ways:
  $PortObj-&gt;handshake(&quot;xoff&quot;);           # set parameter
  $flowcontrol = $PortObj-&gt;handshake;    # current value (scalar)

  # The only &quot;list context&quot; method calls from Win32::SerialPort
  # currently supported are those for baudrate, parity, databits,
  # stopbits, and handshake (which only accept specific input values).
  @handshake_opts = $PortObj-&gt;handshake; # permitted choices (list)

  # similar
  $PortObj-&gt;baudrate(9600);
  $PortObj-&gt;parity(&quot;odd&quot;);
  $PortObj-&gt;databits(8);
  $PortObj-&gt;stopbits(1);        # POSIX does not support 1.5 stopbits

  # these are essentially dummies in POSIX implementation
  # the calls exist to support compatibility
  $PortObj-&gt;buffers(4096, 4096);        # returns (4096, 4096)
  @max_values = $PortObj-&gt;buffer_max;   # returns (4096, 4096)
  $PortObj-&gt;reset_error;                # returns 0

  # true/false parameters (return scalar context only)
  # parameters exist, but message processing not yet fully implemented
  $PortObj-&gt;user_msg(ON);       # built-in instead of warn/die above
  $PortObj-&gt;error_msg(ON);      # translate error bitmasks and carp

  $PortObj-&gt;parity_enable(F);   # faults during input
  $PortObj-&gt;debug(0);

  # true/false capabilities (read only)
  # most are just constants in the POSIX case
  $PortObj-&gt;can_baud;                   # 1
  $PortObj-&gt;can_databits;               # 1
  $PortObj-&gt;can_stopbits;               # 1
  $PortObj-&gt;can_dtrdsr;                 # 1
  $PortObj-&gt;can_handshake;              # 1
  $PortObj-&gt;can_parity_check;           # 1
  $PortObj-&gt;can_parity_config;          # 1
  $PortObj-&gt;can_parity_enable;          # 1
  $PortObj-&gt;can_rlsd;                   # 0 currently
  $PortObj-&gt;can_16bitmode;              # 0 Win32-specific
  $PortObj-&gt;is_rs232;                   # 1
  $PortObj-&gt;is_modem;                   # 0 Win32-specific
  $PortObj-&gt;can_rtscts;                 # 1
  $PortObj-&gt;can_xonxoff;                # 1
  $PortObj-&gt;can_xon_char;               # 1 use stty
  $PortObj-&gt;can_spec_char;              # 0 use stty
  $PortObj-&gt;can_interval_timeout;       # 0 currently
  $PortObj-&gt;can_total_timeout;          # 1 currently
  $PortObj-&gt;can_ioctl;                  # automatically detected
  $PortObj-&gt;can_status;                 # automatically detected
  $PortObj-&gt;can_write_done;             # automatically detected
  $PortObj-&gt;can_modemlines;     # automatically detected
  $PortObj-&gt;can_wait_modemlines;# automatically detected
  $PortObj-&gt;can_intr_count;             # automatically detected
  $PortObj-&gt;can_arbitrary_baud; # automatically detected</code></pre>

<h2 id="Operating-Methods"><a id="Operating"></a>Operating Methods</h2>

<pre><code>  ($count_in, $string_in) = $PortObj-&gt;read($InBytes);
  warn &quot;read unsuccessful\n&quot; unless ($count_in == $InBytes);

  $count_out = $PortObj-&gt;write($output_string);
  warn &quot;write failed\n&quot;         unless ($count_out);
  warn &quot;write incomplete\n&quot;     if ( $count_out != length($output_string) );

  if ($string_in = $PortObj-&gt;input) { PortObj-&gt;write($string_in); }
     # simple echo with no control character processing

  if ($PortObj-&gt;can_wait_modemlines) {
    $rc = $PortObj-&gt;wait_modemlines( MS_RLSD_ON );
    if (!$rc) { print &quot;carrier detect changed\n&quot;; }
  }

  if ($PortObj-&gt;can_modemlines) {
    $ModemStatus = $PortObj-&gt;modemlines;
    if ($ModemStatus &amp; $PortObj-&gt;MS_RLSD_ON) { print &quot;carrier detected\n&quot;; }
  }

  if ($PortObj-&gt;can_intr_count) {
    $count = $PortObj-&gt;intr_count();
    print &quot;got $count interrupts\n&quot;;
  }

  if ($PortObj-&gt;can_arbitrary_baud) {
    print &quot;this port can set arbitrary baud rates\n&quot;;
  }

  ($BlockingFlags, $InBytes, $OutBytes, $ErrorFlags) = $PortObj-&gt;status;
      # same format for compatibility. Only $InBytes and $OutBytes are
      # currently returned (on linux). Others are 0.
      # Check return value of &quot;can_status&quot; to see if this call is valid.

  ($done, $count_out) = $PortObj-&gt;write_done(0);
     # POSIX defaults to background write. Currently $count_out always 0.
     # $done set when hardware finished transmitting and shared line can
     # be released for other use. Ioctl may not work on all OSs.
     # Check return value of &quot;can_write_done&quot; to see if this call is valid.

  $PortObj-&gt;write_drain;  # POSIX alternative to Win32 write_done(1)
                          # set when software is finished transmitting
  $PortObj-&gt;purge_all;
  $PortObj-&gt;purge_rx;
  $PortObj-&gt;purge_tx;

      # controlling outputs from the port
  $PortObj-&gt;dtr_active(T);              # sends outputs direct to hardware
  $PortObj-&gt;rts_active(Yes);            # return status of ioctl call
                                        # return undef on failure

  $PortObj-&gt;pulse_break_on($milliseconds); # off version is implausible
  $PortObj-&gt;pulse_rts_on($milliseconds);
  $PortObj-&gt;pulse_rts_off($milliseconds);
  $PortObj-&gt;pulse_dtr_on($milliseconds);
  $PortObj-&gt;pulse_dtr_off($milliseconds);
      # sets_bit, delays, resets_bit, delays
      # returns undef if unsuccessful or ioctls not implemented

  $PortObj-&gt;read_const_time(100);       # const time for read (milliseconds)
  $PortObj-&gt;read_char_time(5);          # avg time between read char

  $milliseconds = $PortObj-&gt;get_tick_count;</code></pre>

<h2 id="Methods-used-with-Tied-FileHandles"><a id="Methods"></a>Methods used with Tied FileHandles</h2>

<pre><code>  $PortObj = tie (*FH, &#39;Device::SerialPort&#39;, $Configuration_File_Name)
       || die &quot;Can&#39;t tie: $!\n&quot;;             ## TIEHANDLE ##

  print FH &quot;text&quot;;                           ## PRINT     ##
  $char = getc FH;                           ## GETC      ##
  syswrite FH, $out, length($out), 0;        ## WRITE     ##
  $line = &lt;FH&gt;;                              ## READLINE  ##
  @lines = &lt;FH&gt;;                             ## READLINE  ##
  printf FH &quot;received: %s&quot;, $line;           ## PRINTF    ##
  read (FH, $in, 5, 0) or die &quot;$!&quot;;          ## READ      ##
  sysread (FH, $in, 5, 0) or die &quot;$!&quot;;       ## READ      ##
  close FH || warn &quot;close failed&quot;;           ## CLOSE     ##
  undef $PortObj;
  untie *FH;                                 ## DESTROY   ##

  $PortObj-&gt;linesize(10);                    # with READLINE
  $PortObj-&gt;lastline(&quot;_GOT_ME_&quot;);            # with READLINE, list only

      ## with PRINT and PRINTF, return previous value of separator
  $old_ors = $PortObj-&gt;output_record_separator(&quot;RECORD&quot;);
  $old_ofs = $PortObj-&gt;output_field_separator(&quot;COMMA&quot;);</code></pre>

<h2 id="Destructors">Destructors</h2>

<pre><code>  $PortObj-&gt;close || warn &quot;close failed&quot;;
      # release port to OS - needed to reopen
      # close will not usually DESTROY the object
      # also called as: close FH || warn &quot;close failed&quot;;

  undef $PortObj;
      # preferred unless reopen expected since it triggers DESTROY
      # calls $PortObj-&gt;close but does not confirm success
      # MUST precede untie - do all three IN THIS SEQUENCE before re-tie.

  untie *FH;</code></pre>

<h2 id="Methods-for-I/O-Processing"><a id="Methods1"></a><a id="Methods-for-I-O-Processing"></a>Methods for I/O Processing</h2>

<pre><code>  $PortObj-&gt;are_match(&quot;text&quot;, &quot;\n&quot;);    # possible end strings
  $PortObj-&gt;lookclear;                  # empty buffers
  $PortObj-&gt;write(&quot;Feed Me:&quot;);          # initial prompt
  $PortObj-&gt;is_prompt(&quot;More Food:&quot;);    # not implemented

  my $gotit = &quot;&quot;;
  until (&quot;&quot; ne $gotit) {
      $gotit = $PortObj-&gt;lookfor;       # poll until data ready
      die &quot;Aborted without match\n&quot; unless (defined $gotit);
      sleep 1;                          # polling sample time
  }

  printf &quot;gotit = %s\n&quot;, $gotit;                # input BEFORE the match
  my ($match, $after, $pattern, $instead) = $PortObj-&gt;lastlook;
      # input that MATCHED, input AFTER the match, PATTERN that matched
      # input received INSTEAD when timeout without match
  printf &quot;lastlook-match = %s  -after = %s  -pattern = %s\n&quot;,
                           $match,      $after,        $pattern;

  $gotit = $PortObj-&gt;lookfor($count);   # block until $count chars received

  $PortObj-&gt;are_match(&quot;-re&quot;, &quot;pattern&quot;, &quot;text&quot;);
      # possible match strings: &quot;pattern&quot; is a regular expression,
      #                         &quot;text&quot; is a literal string</code></pre>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>This module provides an object-based user interface essentially identical to the one provided by the Win32::SerialPort module.</p>

<h2 id="Initialization">Initialization</h2>

<p>The primary constructor is <b>new</b> with either a <i>PortName</i>, or a <i>Configuretion File</i> specified. With a <i>PortName</i>, this will open the port and create the object. The port is not yet ready for read/write access. First, the desired <i>parameter settings</i> must be established. Since these are tuning constants for an underlying hardware driver in the Operating System, they are all checked for validity by the methods that set them. The <b>write_settings</b> method updates the port (and will return True under POSIX). Ports are opened for binary transfers. A separate <code>binmode</code> is not needed.</p>

<pre><code>  $PortObj = new Device::SerialPort ($PortName, $quiet, $lockfile)
       || die &quot;Can&#39;t open $PortName: $!\n&quot;;</code></pre>

<p>The <code>$quiet</code> parameter is ignored and is only there for compatibility with Win32::SerialPort. The <code>$lockfile</code> parameter is optional. It will attempt to create a file (containing just the current process id) at the location specified. This file will be automatically deleted when the <code>$PortObj</code> is no longer used (by DESTROY). You would usually request <code>$lockfile</code> with <code>$quiet</code> true to disable messages while attempting to obtain exclusive ownership of the port via the lock. Lockfiles are experimental in Version 0.07. They are intended for use with other applications. No attempt is made to resolve port aliases (/dev/modem == /dev/ttySx) or to deal with login processes such as getty and uugetty.</p>

<p>Using a <i>Configuration File</i> with <b>new</b> or by using second constructor, <b>start</b>, scripts can be simplified if they need a constant setup. It executes all the steps from <b>new</b> to <b>write_settings</b> based on a previously saved configuration. This constructor will return <code>undef</code> on a bad configuration file or failure of a validity check. The returned object is ready for access. This is new and experimental for Version 0.055.</p>

<pre><code>  $PortObj2 = start Device::SerialPort ($Configuration_File_Name)
       || die;</code></pre>

<p>The third constructor, <b>tie</b>, will combine the <b>start</b> with Perl&#39;s support for tied FileHandles (see <i>perltie</i>). Device::SerialPort will implement the complete set of methods: TIEHANDLE, PRINT, PRINTF, WRITE, READ, GETC, READLINE, CLOSE, and DESTROY. Tied FileHandle support is new with Version 0.04 and the READ and READLINE methods were added in Version 0.06. In &quot;scalar context&quot;, READLINE sets <b>stty_icanon</b> to do character processing and calls <b>lookfor</b>. It restores <b>stty_icanon</b> after the read. In &quot;list context&quot;, READLINE does Canonical (line) reads if <b>stty_icanon</b> is set or calls <b>streamline</b> if it is not. (<b>stty_icanon</b> is not altered). The <b>streamline</b> choice allows duplicating the operation of Win32::SerialPort for cross-platform scripts.</p>

<p>The implementation attempts to mimic STDIN/STDOUT behaviour as closely as possible: calls block until done and data strings that exceed internal buffers are divided transparently into multiple calls. In Version 0.06, the output separators <code>$,</code> and <code>$\</code> are also applied to PRINT if set. The <b>output_record_separator</b> and <b>output_field_separator</b> methods can set <i>Port-FileHandle-Specific</i> versions of <code>$,</code> and <code>$\</code> if desired. Since PRINTF is treated internally as a single record PRINT, <code>$\</code> will be applied. Output separators are not applied to WRITE (called as <code>syswrite FH, $scalar, $length, [$offset]</code>). The input_record_separator <code>$/</code> is not explicitly supported - but an identical function can be obtained with a suitable <b>are_match</b> setting.</p>

<pre><code>  $PortObj2 = tie (*FH, &#39;Device::SerialPort&#39;, $Configuration_File_Name)
       || die;</code></pre>

<p>The tied FileHandle methods may be combined with the Device::SerialPort methods for <b>read, input</b>, and <b>write</b> as well as other methods. The typical restrictions against mixing <b>print</b> with <b>syswrite</b> do not apply. Since both <b>(tied) read</b> and <b>sysread</b> call the same <code>$ob-&gt;READ</code> method, and since a separate <code>$ob-&gt;read</code> method has existed for some time in Device::SerialPort, you should always use <b>sysread</b> with the tied interface (when it is implemented).</p>

<ul>

<p>Certain parameters <i>SHOULD</i> be set before executing <b>write_settings</b>. Others will attempt to deduce defaults from the hardware or from other parameters. The <i>Required</i> parameters are:</p>

<p>baudrate</p>

<p>Any legal value.</p>

<p>parity</p>

<p>One of the following: &quot;none&quot;, &quot;odd&quot;, &quot;even&quot;.</p>

<p>By default, incoming parity is not checked. This mimics the behavior of most terminal programs (like &quot;minicom&quot;). If you need parity checking enabled, please use the &quot;stty_inpck&quot; and &quot;stty_istrip&quot; functions.</p>

<p>databits</p>

<p>An integer from 5 to 8.</p>

<p>stopbits</p>

<p>Legal values are 1 and 2.</p>

<p>handshake</p>

<p>One of the following: &quot;none&quot;, &quot;rts&quot;, &quot;xoff&quot;.</p>

</ul>

<p>Some individual parameters (eg. baudrate) can be changed after the initialization is completed. These will be validated and will update the <i>serial driver</i> as required. The <b>save</b> method will write the current parameters to a file that <b>start, tie,</b> and <b>restart</b> can use to reestablish a functional setup.</p>

<pre><code>  $PortObj = new Win32::SerialPort ($PortName, $quiet)
       || die &quot;Can&#39;t open $PortName: $^E\n&quot;;    # $quiet is optional

  $PortObj-&gt;user_msg(ON);
  $PortObj-&gt;databits(8);
  $PortObj-&gt;baudrate(9600);
  $PortObj-&gt;parity(&quot;none&quot;);
  $PortObj-&gt;stopbits(1);
  $PortObj-&gt;handshake(&quot;rts&quot;);

  $PortObj-&gt;write_settings || undef $PortObj;

  $PortObj-&gt;save($Configuration_File_Name);
  $PortObj-&gt;baudrate(300);
  $PortObj-&gt;restart($Configuration_File_Name);  # back to 9600 baud

  $PortObj-&gt;close || die &quot;failed to close&quot;;
  undef $PortObj;                               # frees memory back to perl</code></pre>

<h2 id="Configuration-Utility-Methods1"><a id="Configuration2"></a>Configuration Utility Methods</h2>

<p>Use <b>alias</b> to convert the name used by &quot;built-in&quot; messages.</p>

<pre><code>  $PortObj-&gt;alias(&quot;MODEM1&quot;);</code></pre>

<p>Starting in Version 0.07, a number of <i>Application Variables</i> are saved in <b>$Configuration_File</b>. These parameters are not used internally. But methods allow setting and reading them. The intent is to facilitate the use of separate <i>configuration scripts</i> to create the files. Then an application can use <b>start</b> as the Constructor and not bother with command line processing or managing its own small configuration file. The default values and number of parameters is subject to change.</p>

<pre><code>  $PortObj-&gt;devicetype(&#39;none&#39;); 
  $PortObj-&gt;hostname(&#39;localhost&#39;);  # for socket-based implementations
  $PortObj-&gt;hostaddr(0);            # a &quot;false&quot; value
  $PortObj-&gt;datatype(&#39;raw&#39;);        # &#39;record&#39; is another possibility
  $PortObj-&gt;cfg_param_1(&#39;none&#39;);
  $PortObj-&gt;cfg_param_2(&#39;none&#39;);    # 3 spares should be enough for now
  $PortObj-&gt;cfg_param_3(&#39;none&#39;);</code></pre>

<h2 id="Configuration-and-Capability-Methods"><a id="Configuration3"></a>Configuration and Capability Methods</h2>

<p>The Win32 Serial Comm API provides extensive information concerning the capabilities and options available for a specific port (and instance). This module will return suitable responses to facilitate porting code from that environment.</p>

<p>The <b>get_tick_count</b> method is a clone of the <i>Win32::GetTickCount()</i> function. It matches a corresponding method in <i>Win32::CommPort</i>. It returns time in milliseconds - but can be used in cross-platform scripts.</p>

<ul>

<p>Binary selections will accept as <i>true</i> any of the following: <code>(&quot;YES&quot;, &quot;Y&quot;, &quot;ON&quot;, &quot;TRUE&quot;, &quot;T&quot;, &quot;1&quot;, 1)</code> (upper/lower/mixed case) Anything else is <i>false</i>.</p>

<p>There are a large number of possible configuration and option parameters. To facilitate checking option validity in scripts, most configuration methods can be used in two different ways:</p>

<p>method called with an argument</p>

<p>The parameter is set to the argument, if valid. An invalid argument returns <i>false</i> (undef) and the parameter is unchanged. The function will also <i>carp</i> if <b>$user_msg</b> is <i>true</i>. The port will be updated immediately if allowed (an automatic <b>write_settings</b> is called).</p>

<p>method called with no argument in scalar context</p>

<p>The current value is returned. If the value is not initialized either directly or by default, return &quot;undef&quot; which will parse to <i>false</i>. For binary selections (true/false), return the current value. All current values from &quot;multivalue&quot; selections will parse to <i>true</i>.</p>

<p>method called with no argument in list context</p>

<p>Methods which only accept a limited number of specific input values return a list consisting of all acceptable choices. The null list <code>(undef)</code> will be returned for failed calls in list context (e.g. for an invalid or unexpected argument). Only the baudrate, parity, databits, stopbits, and handshake methods currently support this feature.</p>

</ul>

<h2 id="Operating-Methods1"><a id="Operating1"></a>Operating Methods</h2>

<p>Version 0.04 adds <b>pulse</b> methods for the <i>RTS, BREAK, and DTR</i> bits. The <b>pulse</b> methods assume the bit is in the opposite state when the method is called. They set the requested state, delay the specified number of milliseconds, set the opposite state, and again delay the specified time. These methods are designed to support devices, such as the X10 &quot;FireCracker&quot; control and some modems, which require pulses on these lines to signal specific events or data. Timing for the <i>active</i> part of <b>pulse_break_on</b> is handled by <i>POSIX::tcsendbreak(0)</i>, which sends a 250-500 millisecond BREAK pulse. It is <i>NOT</i> guaranteed to block until done.</p>

<pre><code>  $PortObj-&gt;pulse_break_on($milliseconds);
  $PortObj-&gt;pulse_rts_on($milliseconds);
  $PortObj-&gt;pulse_rts_off($milliseconds);
  $PortObj-&gt;pulse_dtr_on($milliseconds);
  $PortObj-&gt;pulse_dtr_off($milliseconds);</code></pre>

<p>In Version 0.05, these calls and the <b>rts_active</b> and <b>dtr_active</b> calls verify the parameters and any required <i>ioctl constants</i>, and return <code>undef</code> unless the call succeeds. You can use the <b>can_ioctl</b> method to see if the required constants are available. On Version 0.04, the module would not load unless <i>asm/termios.ph</i> was found at startup.</p>

<h2 id="Stty-Shortcuts"><a id="Stty"></a>Stty Shortcuts</h2>

<p>Version 0.06 adds primitive methods to modify port parameters that would otherwise require a <code>system(&quot;stty...&quot;);</code> command. These act much like the identically-named methods in Win32::SerialPort. However, they are initialized from &quot;current stty settings&quot; when the port is opened rather than from defaults. And like <i>stty settings</i>, they are passed to the serial driver and apply to all operations rather than only to I/O processed via the <b>lookfor</b> method or the <i>tied FileHandle</i> methods. Each returns the current setting for the parameter. There are no &quot;global&quot; or &quot;combination&quot; parameters - you still need <code>system(&quot;stty...&quot;)</code> for that.</p>

<p>The methods which handle CHAR parameters set and return values as <code>ord(CHAR)</code>. This corresponds to the settings in the <i>POSIX termios cc_field array</i>. You are unlikely to actually want to modify most of these. They reflect the special characters which can be set by <i>stty</i>.</p>

<pre><code>  $PortObj-&gt;is_xon_char($num_char);     # VSTART (stty start=.)
  $PortObj-&gt;is_xoff_char($num_char);    # VSTOP
  $PortObj-&gt;is_stty_intr($num_char);    # VINTR
  $PortObj-&gt;is_stty_quit($num_char);    # VQUIT
  $PortObj-&gt;is_stty_eof($num_char);     # VEOF
  $PortObj-&gt;is_stty_eol($num_char);     # VEOL
  $PortObj-&gt;is_stty_erase($num_char);   # VERASE
  $PortObj-&gt;is_stty_kill($num_char);    # VKILL
  $PortObj-&gt;is_stty_susp($num_char);    # VSUSP</code></pre>

<p>Binary settings supported by POSIX will return 0 or 1. Several parameters settable by <i>stty</i> do not yet have shortcut methods. Contact me if you need one that is not supported. These are the common choices. Try <code>man stty</code> if you are not sure what they do.</p>

<pre><code>  $PortObj-&gt;stty_echo;
  $PortObj-&gt;stty_echoe;
  $PortObj-&gt;stty_echok;
  $PortObj-&gt;stty_echonl;
  $PortObj-&gt;stty_ignbrk;
  $PortObj-&gt;stty_istrip;
  $PortObj-&gt;stty_inpck;
  $PortObj-&gt;stty_parmrk;
  $PortObj-&gt;stty_ignpar;
  $PortObj-&gt;stty_icrnl;
  $PortObj-&gt;stty_igncr;
  $PortObj-&gt;stty_inlcr;
  $PortObj-&gt;stty_opost;
  $PortObj-&gt;stty_isig;
  $PortObj-&gt;stty_icanon;</code></pre>

<p>The following methods require successfully loading <i>ioctl constants</i>. They will return <code>undef</code> if the needed constants are not found. But the method calls may still be used without syntax errors or warnings even in that case.</p>

<pre><code>  $PortObj-&gt;stty_ocrlf;
  $PortObj-&gt;stty_onlcr;
  $PortObj-&gt;stty_echoke;
  $PortObj-&gt;stty_echoctl;</code></pre>

<h2 id="Lookfor-and-I/O-Processing"><a id="Lookfor"></a><a id="Lookfor-and-I-O-Processing"></a>Lookfor and I/O Processing</h2>

<p>Some communications programs have a different need - to collect (or discard) input until a specific pattern is detected. For lines, the pattern is a line-termination. But there are also requirements to search for other strings in the input such as &quot;username:&quot; and &quot;password:&quot;. The <b>lookfor</b> method provides a consistant mechanism for solving this problem. It searches input character-by-character looking for a match to any of the elements of an array set using the <b>are_match</b> method. It returns the entire input up to the match pattern if a match is found. If no match is found, it returns &quot;&quot; unless an input error or abort is detected (which returns undef).</p>

<p>Unlike Win32::SerialPort, <b>lookfor</b> does not handle backspace, echo, and other character processing. It expects the serial driver to handle those and to be controlled via <i>stty</i>. For interacting with humans, you will probably want <code>stty_icanon(1)</code> during <b>lookfor</b> to obtain familiar command-line response. The actual match and the characters after it (if any) may also be viewed using the <b>lastlook</b> method. It also adopts the convention from Expect.pm that match strings are literal text (tested using <b>index</b>) unless preceeded in the <b>are_match</b> list by a <b>&quot;-re&quot;,</b> entry. The default <b>are_match</b> list is <code>(&quot;\n&quot;)</code>, which matches complete lines.</p>

<pre><code>   my ($match, $after, $pattern, $instead) = $PortObj-&gt;lastlook;
     # input that MATCHED, input AFTER the match, PATTERN that matched
     # input received INSTEAD when timeout without match (&quot;&quot; if match)

   $PortObj-&gt;are_match(&quot;text1&quot;, &quot;-re&quot;, &quot;pattern&quot;, &quot;text2&quot;);
     # possible match strings: &quot;pattern&quot; is a regular expression,
     #                         &quot;text1&quot; and &quot;text2&quot; are literal strings</code></pre>

<p>Everything in <b>lookfor</b> is still experimental. Please let me know if you use it (or can&#39;t use it), so I can confirm bug fixes don&#39;t break your code. For literal strings, <code>$match</code> and <code>$pattern</code> should be identical. The <code>$instead</code> value returns the internal buffer tested by the match logic. A successful match or a <b>lookclear</b> resets it to &quot;&quot; - so it is only useful for error handling such as timeout processing or reporting unexpected responses.</p>

<p>The <b>lookfor</b> method is designed to be sampled periodically (polled). Any characters after the match pattern are saved for a subsequent <b>lookfor</b>. Internally, <b>lookfor</b> is implemented using the nonblocking <b>input</b> method when called with no parameter. If called with a count, <b>lookfor</b> calls <code>$PortObj-&gt;read(count)</code> which blocks until the <b>read</b> is <i>Complete</i> or a <i>Timeout</i> occurs. The blocking alternative should not be used unless a fault time has been defined using <b>read_interval, read_const_time, and read_char_time</b>. It exists mostly to support the <i>tied FileHandle</i> functions <b>sysread, getc,</b> and <b>&lt;FH&gt;</b>. When <b>stty_icanon</b> is active, even the non-blocking calls will not return data until the line is complete.</p>

<p>The internal buffers used by <b>lookfor</b> may be purged by the <b>lookclear</b> method (which also clears the last match). For testing, <b>lookclear</b> can accept a string which is &quot;looped back&quot; to the next <b>input</b>. This feature is enabled only when <code>set_test_mode_active(1)</code>. Normally, <b>lookclear</b> will return <code>undef</code> if given parameters. It still purges the buffers and last_match in that case (but nothing is &quot;looped back&quot;). You will want <b>stty_echo(0)</b> when exercising loopback.</p>

<p>The <b>matchclear</b> method is designed to handle the &quot;special case&quot; where the match string is the first character(s) received by <b>lookfor</b>. In this case, <code>$lookfor_return == &quot;&quot;</code>, <b>lookfor</b> does not provide a clear indication that a match was found. The <b>matchclear</b> returns the same <code>$match</code> that would be returned by <b>lastlook</b> and resets it to &quot;&quot; without resetting any of the other buffers. Since the <b>lookfor</b> already searched <i>through</i> the match, <b>matchclear</b> is used to both detect and step-over &quot;blank&quot; lines.</p>

<p>The character-by-character processing used by <b>lookfor</b> is fine for interactive activities and tasks which expect short responses. But it has too much &quot;overhead&quot; to handle fast data streams.There is also a <b>streamline</b> method which is a fast, line-oriented alternative with just pattern searching. Since <b>streamline</b> uses the same internal buffers, the <b>lookclear, lastlook, are_match, and matchclear</b> methods act the same in both cases. In fact, calls to <b>streamline</b> and <b>lookfor</b> can be interleaved if desired (e.g. an interactive task that starts an upload and returns to interactive activity when it is complete).</p>

<p>There are two additional methods for supporting &quot;list context&quot; input: <b>lastline</b> sets an &quot;end_of_file&quot; <i>Regular Expression</i>, and <b>linesize</b> permits changing the &quot;packet size&quot; in the blocking read operation to allow tuning performance to data characteristics. These two only apply during <b>READLINE</b>. The default for <b>linesize</b> is 1. There is no default for the <b>lastline</b> method.</p>

<p>The <i>Regular Expressions</i> set by <b>are_match</b> and <b>lastline</b> will be pre-compiled using the <i>qr//</i> construct on Perl 5.005 and higher. This doubled <b>lookfor</b> and <b>streamline</b> speed in my tests with <i>Regular Expressions</i> - but actual improvements depend on both patterns and input data.</p>

<p>The functionality of <b>lookfor</b> includes a limited subset of the capabilities found in Austin Schutz&#39;s <i>Expect.pm</i> for Unix (and Tcl&#39;s expect which it resembles). The <code>$before, $match, $pattern, and $after</code> return values are available if someone needs to create an &quot;expect&quot; subroutine for porting a script. When using multiple patterns, there is one important functional difference: <i>Expect.pm</i> looks at each pattern in turn and returns the first match found; <b>lookfor</b> and <b>streamline</b> test all patterns and return the one found <i>earliest</i> in the input if more than one matches.</p>

<h2 id="Exports">Exports</h2>

<p>Nothing is exported by default. The following tags can be used to have large sets of symbols exported:</p>

<dl>

<dt id=":PARAM"><a id="PARAM"></a>:PARAM</dt>
<dd>

<p>Utility subroutines and constants for parameter setting and test:</p>

<pre><code>        LONGsize        SHORTsize       nocarp          yes_true
        OS_Error</code></pre>

</dd>
<dt id=":STAT"><a id="STAT"></a>:STAT</dt>
<dd>

<p>The Constants named BM_* and CE_* are omitted. But the modem status (MS_*) Constants are defined for possible use with <b>modemlines</b> and <b>wait_modemlines</b>. They are assigned to corresponding functions, but the bit position will be different from that on Win32.</p>

<p>Which incoming bits are active:</p>

<pre><code>        MS_CTS_ON    - Clear to send
    MS_DSR_ON    - Data set ready
    MS_RING_ON   - Ring indicator  
    MS_RLSD_ON   - Carrier detected
    MS_RTS_ON    - Request to send (might not exist on Win32)
    MS_DTR_ON    - Data terminal ready (might not exist on Win32)</code></pre>

<p>If you want to write more POSIX-looking code, you can use the constants seen there, instead of the Win32 versions:</p>

<pre><code>    TIOCM_CTS, TIOCM_DSR, TIOCM_RI, TIOCM_CD, TIOCM_RTS, and TIOCM_DTR</code></pre>

<p>Offsets into the array returned by <b>status:</b></p>

<pre><code>        ST_BLOCK        ST_INPUT        ST_OUTPUT       ST_ERROR</code></pre>

</dd>
<dt id=":ALL"><a id="ALL"></a>:ALL</dt>
<dd>

<p>All of the above. Except for the <i>test suite</i>, there is not really a good reason to do this.</p>

</dd>
</dl>

<h1 id="PINOUT">PINOUT</h1>

<p>Here is a handy pinout map, showing each line and signal on a standard DB9 connector:</p>

<dl>

<dt id="1-DCD"><a id="1"></a><a id="DCD"></a>1 DCD</dt>
<dd>

<p>Data Carrier Detect</p>

</dd>
<dt id="2-RD"><a id="2"></a><a id="RD"></a>2 RD</dt>
<dd>

<p>Receive Data</p>

</dd>
<dt id="3-TD"><a id="3"></a><a id="TD"></a>3 TD</dt>
<dd>

<p>Transmit Data</p>

</dd>
<dt id="4-DTR"><a id="4"></a><a id="DTR"></a>4 DTR</dt>
<dd>

<p>Data Terminal Ready</p>

</dd>
<dt id="5-SG"><a id="5"></a><a id="SG"></a>5 SG</dt>
<dd>

<p>Signal Ground</p>

</dd>
<dt id="6-DSR"><a id="6"></a><a id="DSR"></a>6 DSR</dt>
<dd>

<p>Data Set Ready</p>

</dd>
<dt id="7-RTS"><a id="7"></a><a id="RTS"></a>7 RTS</dt>
<dd>

<p>Request to Send</p>

</dd>
<dt id="8-CTS"><a id="8"></a><a id="CTS"></a>8 CTS</dt>
<dd>

<p>Clear to Send</p>

</dd>
<dt id="9-RI"><a id="9"></a><a id="RI"></a>9 RI</dt>
<dd>

<p>Ring Indicator</p>

</dd>
</dl>

<h1 id="NOTES">NOTES</h1>

<p>The object returned by <b>new</b> is NOT a <i>Filehandle</i>. You will be disappointed if you try to use it as one.</p>

<p>e.g. the following is WRONG!!</p>

<pre><code> print $PortObj &quot;some text&quot;;</code></pre>

<p>This module uses <i>POSIX termios</i> extensively. Raw API calls are <b>very</b> unforgiving. You will certainly want to start perl with the <b>-w</b> switch. If you can, <b>use strict</b> as well. Try to ferret out all the syntax and usage problems BEFORE issuing the API calls (many of which modify tuning constants in hardware device drivers....not where you want to look for bugs).</p>

<p>With all the options, this module needs a good tutorial. It doesn&#39;t have one yet.</p>

<h1 id="EXAMPLE">EXAMPLE</h1>

<p>It is recommended to always use &quot;read(255)&quot; due to some unexpected behavior with the termios under some operating systems (Linux and Solaris at least). To deal with this, a routine is usually needed to read from the serial port until you have what you want. This is a quick example of how to do that:</p>

<pre><code> my $port=Device::SerialPort-&gt;new(&quot;/dev/ttyS0&quot;);

 my $STALL_DEFAULT=10; # how many seconds to wait for new input
 
 my $timeout=$STALL_DEFAULT;
 
 $port-&gt;read_char_time(0);     # don&#39;t wait for each character
 $port-&gt;read_const_time(1000); # 1 second per unfulfilled &quot;read&quot; call
 
 my $chars=0;
 my $buffer=&quot;&quot;;
 while ($timeout&gt;0) {
        my ($count,$saw)=$port-&gt;read(255); # will read _up to_ 255 chars
        if ($count &gt; 0) {
                $chars+=$count;
                $buffer.=$saw;
 
                # Check here to see if what we want is in the $buffer
                # say &quot;last&quot; if we find it
        }
        else {
                $timeout--;
        }
 }

 if ($timeout==0) {
        die &quot;Waited $STALL_DEFAULT seconds and never saw what I wanted\n&quot;;
 }</code></pre>

<h1 id="PORTING">PORTING</h1>

<p>For a serial port to work under Unix, you need the ability to do several types of operations. With POSIX, these operations are implemented with a set of &quot;tc*&quot; functions. However, not all Unix systems follow this correctly. In those cases, the functions change, but the variables used as parameters generally turn out to be the same.</p>

<dl>

<dt id="Get/Set-RTS"><a id="Get"></a><a id="Get-Set-RTS"></a>Get/Set RTS</dt>
<dd>

<p>This is only available through the bit-set(TIOCMBIS)/bit-clear(TIOCMBIC) ioctl function using the RTS value(TIOCM_RTS).</p>

<pre><code> ioctl($handle,$on ? $TIOCMBIS : $TIOCMBIC, $TIOCM_RTS);</code></pre>

</dd>
<dt id="Get/Set-DTR"><a id="Get1"></a><a id="Get-Set-DTR"></a>Get/Set DTR</dt>
<dd>

<p>This is available through the bit-set(TIOCMBIS)/bit-clear(TIOCMBIC) ioctl function using the DTR value(TIOCM_DTR)</p>

<pre><code> ioctl($handle,$on ? $TIOCMBIS : $TIOCMBIC, $TIOCM_DTR);</code></pre>

<p>or available through the DTRSET/DTRCLEAR ioctl functions, if they exist.</p>

<pre><code> ioctl($handle,$on ? $TIOCSDTR : $TIOCCDTR, 0);</code></pre>

</dd>
<dt id="Get-modem-lines"><a id="Get2"></a>Get modem lines</dt>
<dd>

<p>To read Clear To Send (CTS), Data Set Ready (DSR), Ring Indicator (RING), and Carrier Detect (CD/RLSD), the TIOCMGET ioctl function must be used.</p>

<pre><code> ioctl($handle, $TIOCMGET, $status);</code></pre>

<p>To decode the individual modem lines, some bits have multiple possible constants:</p>

<dl>

<dt id="Clear-To-Send-(CTS)"><a id="Clear"></a><a id="Clear-To-Send--CTS"></a>Clear To Send (CTS)</dt>
<dd>

<p>TIOCM_CTS</p>

</dd>
<dt id="Data-Set-Ready-(DSR)"><a id="Data"></a><a id="Data-Set-Ready--DSR"></a>Data Set Ready (DSR)</dt>
<dd>

<p>TIOCM_DSR</p>

</dd>
<dt id="Ring-Indicator-(RING)"><a id="Ring"></a><a id="Ring-Indicator--RING"></a>Ring Indicator (RING)</dt>
<dd>

<p>TIOCM_RNG TIOCM_RI</p>

</dd>
<dt id="Carrier-Detect-(CD/RLSD)"><a id="Carrier"></a><a id="Carrier-Detect--CD-RLSD"></a>Carrier Detect (CD/RLSD)</dt>
<dd>

<p>TIOCM_CAR TIOCM_CD</p>

</dd>
</dl>

</dd>
<dt id="Get-Buffer-Status"><a id="Get3"></a>Get Buffer Status</dt>
<dd>

<p>To get information about the state of the serial port input and output buffers, the TIOCINQ and TIOCOUTQ ioctl functions must be used. I&#39;m not totally sure what is returned by these functions across all Unix systems. Under Linux, it is the integer number of characters in the buffer.</p>

<pre><code> ioctl($handle,$in ? $TIOCINQ : $TIOCOUTQ, $count);
 $count = unpack(&#39;i&#39;,$count);</code></pre>

</dd>
<dt id="Get-Line-Status"><a id="Get4"></a>Get Line Status</dt>
<dd>

<p>To get information about the state of the serial transmission line (to see if a write has made its way totally out of the serial port buffer), the TIOCSERGETLSR ioctl function must be used. Additionally, the &quot;Get Buffer Status&quot; methods must be functioning, as well as having the first bit of the result set (Linux is TIOCSER_TEMT, others unknown, but we&#39;ve been using TIOCM_LE even though that should be returned from the TIOCMGET ioctl).</p>

<pre><code> ioctl($handle,$TIOCSERGETLSR, $status);
 $done = (unpack(&#39;i&#39;, $status) &amp; $TIOCSER_TEMT);</code></pre>

</dd>
<dt id="Set-Flow-Control"><a id="Set"></a>Set Flow Control</dt>
<dd>

<p>Some Unix systems require special TCGETX/TCSETX ioctls functions and the CTSXON/RTSXOFF constants to turn on and off CTS/RTS &quot;hard&quot; flow control instead of just using the normal POSIX tcsetattr calls.</p>

<pre><code> ioctl($handle, $TCGETX, $flags);
 @bytes = unpack(&#39;SSSS&#39;,$flags);
 $bytes[0] = $on ? ($CTSXON | $RTSXOFF) : 0;
 $flags = pack(&#39;SSSS&#39;,@bytes);
 ioctl($handle, $TCSETX, $flags);</code></pre>

</dd>
</dl>

<h1 id="KNOWN-LIMITATIONS"><a id="KNOWN"></a>KNOWN LIMITATIONS</h1>

<p>The current version of the module has been tested with Perl 5.003 and above. It was initially ported from Win32 and was designed to be used without requiring a compiler or using XS. Since everything is (sometimes convoluted but still pure) Perl, you can fix flaws and change limits if required. But please file a bug report if you do.</p>

<p>The <b>read</b> method, and tied methods which call it, currently can use a fixed timeout which approximates behavior of the <i>Win32::SerialPort</i> <b>read_const_time</b> and <b>read_char_time</b> methods. It is used internally by <i>select</i>. If the timeout is set to zero, the <b>read</b> call will return immediately. A <b>read</b> larger than 255 bytes will be split internally into 255-byte POSIX calls due to limitations of <i>select</i> and <i>VMIN</i>. The timeout is reset for each 255-byte segment. Hence, for large <b>reads</b>, use a <b>read_const_time</b> suitable for a 255-byte read. All of this is expeimental in Version 0.055.</p>

<pre><code>  $PortObj-&gt;read_const_time(500);       # 500 milliseconds = 0.5 seconds
  $PortObj-&gt;read_char_time(5);          # avg time between read char</code></pre>

<p>The timing model defines the total time allowed to complete the operation. A fixed overhead time is added to the product of bytes and per_byte_time.</p>

<p>Read_Total = <b>read_const_time</b> + (<b>read_char_time</b> * bytes_to_read)</p>

<p>Write timeouts and <b>read_interval</b> timeouts are not currently supported.</p>

<p>On some machines, reads larger than 4,096 bytes may be truncated at 4,096, regardless of the read size or read timing settings used. In this case, try turning on or increasing the inter-character delay on your serial device. Also try setting the read size to</p>

<pre><code>  $PortObj-&gt;read(1) or $PortObj-&gt;read(255)</code></pre>

<p>and performing multiple reads until the transfer is completed.</p>

<h1 id="BUGS">BUGS</h1>

<p>See the limitations about lockfiles. Experiment if you like.</p>

<p>With all the <i>currently unimplemented features</i>, we don&#39;t need any more. But there probably are some.</p>

<p>Please send comments and bug reports to kees@outflux.net.</p>

<h1 id="Win32::SerialPort-&amp;-Win32API::CommPort"><a id="Win32"></a><a id="Win32::SerialPort---Win32API::CommPort"></a>Win32::SerialPort &amp; Win32API::CommPort</h1>

<h2 id="Win32::SerialPort-Functions-Not-Currently-Supported"><a id="Win321"></a>Win32::SerialPort Functions Not Currently Supported</h2>

<pre><code>  $LatchErrorFlags = $PortObj-&gt;reset_error;

  $PortObj-&gt;read_interval(100);         # max time between read char
  $PortObj-&gt;write_char_time(5);
  $PortObj-&gt;write_const_time(100);</code></pre>

<h2 id="Functions-Handled-in-a-POSIX-system-by-&quot;stty&quot;"><a id="Functions"></a><a id="Functions-Handled-in-a-POSIX-system-by--stty"></a>Functions Handled in a POSIX system by &quot;stty&quot;</h2>

<pre><code>        xon_limit       xoff_limit      xon_char        xoff_char
        eof_char        event_char      error_char      stty_intr
        stty_quit       stty_eof        stty_eol        stty_erase
        stty_kill       stty_clear      is_stty_clear   stty_bsdel      
        stty_echoke     stty_echoctl    stty_ocrnl      stty_onlcr      </code></pre>

<h2 id="Win32::SerialPort-Functions-Not-Ported-to-POSIX"><a id="Win322"></a>Win32::SerialPort Functions Not Ported to POSIX</h2>

<pre><code>        transmit_char</code></pre>

<h2 id="Win32API::CommPort-Functions-Not-Ported-to-POSIX"><a id="Win32API"></a>Win32API::CommPort Functions Not Ported to POSIX</h2>

<pre><code>        init_done       fetch_DCB       update_DCB      initialize
        are_buffers     are_baudrate    are_handshake   are_parity
        are_databits    are_stopbits    is_handshake    xmit_imm_char
        is_baudrate     is_parity       is_databits     is_write_char_time
        debug_comm      is_xon_limit    is_xoff_limit   is_read_const_time
        suspend_tx      is_eof_char     is_event_char   is_read_char_time
        is_read_buf     is_write_buf    is_buffers      is_read_interval
        is_error_char   resume_tx       is_stopbits     is_write_const_time
        is_binary       is_status       write_bg        is_parity_enable
        is_modemlines   read_bg         read_done       break_active
        xoff_active     is_read_buf     is_write_buf    xon_active</code></pre>

<h2 id="&quot;raw&quot;-Win32-API-Calls-and-Constants"><a id="raw--Win32-API-Calls-and-Constants"></a>&quot;raw&quot; Win32 API Calls and Constants</h2>

<p>A large number of Win32-specific elements have been omitted. Most of these are only available in Win32::SerialPort and Win32API::CommPort as optional Exports. The list includes the following:</p>

<dl>

<dt id=":RAW"><a id="RAW"></a>:RAW</dt>
<dd>

<p>The API Wrapper Methods and Constants used only to support them including PURGE_*, SET*, CLR*, EV_*, and ERROR_IO*</p>

</dd>
<dt id=":COMMPROP"><a id="COMMPROP"></a>:COMMPROP</dt>
<dd>

<p>The Constants used for Feature and Properties Detection including BAUD_*, PST_*, PCF_*, SP_*, DATABITS_*, STOPBITS_*, PARITY_*, and COMMPROP_INITIALIZED</p>

</dd>
<dt id=":DCB"><a id="DCB"></a>:DCB</dt>
<dd>

<p>The constants for the <i>Win32 Device Control Block</i> including CBR_*, DTR_*, RTS_*, *PARITY, *STOPBIT*, and FM_*</p>

</dd>
</dl>

<h2 id="Compatibility">Compatibility</h2>

<p>This code implements the functions required to support the MisterHouse Home Automation software by Bruce Winter. It does not attempt to support functions from Win32::SerialPort such as <b>stty_emulation</b> that already have POSIX implementations or to replicate <i>Win32 idosyncracies</i>. However, the supported functions are intended to clone the equivalent functions in Win32::SerialPort and Win32API::CommPort. Any discrepancies or omissions should be considered bugs and reported to the maintainer.</p>

<h1 id="AUTHORS">AUTHORS</h1>

<pre><code> Based on Win32::SerialPort.pm, Version 0.8, by Bill Birthisel
 Ported to linux/POSIX by Joe Doss for MisterHouse
 Ported to Solaris/POSIX by Kees Cook for Sendpage
 Ported to BSD/POSIX by Kees Cook
 Ported to Perl XS by Kees Cook

 Currently maintained by:
 Kees Cook, kees@outflux.net, http://outflux.net/</code></pre>

<h1 id="SEE-ALSO"><a id="SEE"></a>SEE ALSO</h1>

<p>Win32API::CommPort</p>

<p>Win32::SerialPort</p>

<p>perltoot - Tom Christiansen&#39;s Object-Oriented Tutorial</p>

<h1 id="COPYRIGHT">COPYRIGHT</h1>

<pre><code> Copyright (C) 1999, Bill Birthisel. All rights reserved.
 Copyright (C) 2000-2007, Kees Cook.  All rights reserved.</code></pre>

<p>This module is free software; you can redistribute it and/or modify it under the same terms as Perl itself.</p>

<div class="pod-errors"><p>2 POD Errors</p><div class="pod-errors-detail"><p>The following errors were encountered while parsing the POD:</p><dl><dt>Around line 2647:</dt><dd><p>You can&#39;t have =items (as at line 2653) unless the first thing after the =over is an =item</p></dd><dt>Around line 2737:</dt><dd><p>You can&#39;t have =items (as at line 2747) unless the first thing after the =over is an =item</p></dd></dl></div></div>
  
        <div id="install-instructions-dialog" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Module Install Instructions</h4>
            </div>
            <div class="modal-body">
                <p>To install Device::SerialPort, copy and paste the appropriate command in to your terminal.</p>
                <p><a href="/pod/distribution/App-cpanminus/bin/cpanm">cpanm</a></p>
                <pre>
                    cpanm Device::SerialPort
                </pre>
                <p><a href="/pod/CPAN">CPAN shell</a></p>
                <pre>
                    perl -MCPAN -e shell
                    install Device::SerialPort
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
