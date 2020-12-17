<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5">
        <title>Linux::Input - Linux input event interface - metacpan.org</title>
        <link rel="alternate" type="application/rss+xml" title="Recent CPAN Uploads of Linux-Input - MetaCPAN" href="/feed/distribution/Linux-Input" />
        <link href="/_assets/09a20e39bc03ec6c8fbc017562af3184c4c5b48e.css" rel="stylesheet" type="text/css">
        <link rel="search" href="/static/opensearch.xml" type="application/opensearchdescription+xml" title="MetaCPAN">
        <link rel="canonical" href="https://metacpan.org/pod/Linux::Input" />
        <meta name="description" content="Linux input event interface" />
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
<meta name="twitter:url"         content="https://metacpan.org/pod/release/BEPPU/Linux-Input-1.03/lib/Linux/Input.pm" />
<meta name="twitter:title"       content="Linux::Input" />
<meta name="twitter:description" content="Linux input event interface" />
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
    <a itemprop="url"  data-keyboard-shortcut="g a" rel="author" href="/author/BEPPU" title="" class="author-name"><span itemprop="name" >John Beppu</span></a>
  </span>
  <span>&nbsp;/&nbsp;</span>
  <div class="release status-latest maturity-released">
    <span class="dropdown"><b class="caret"></b></span>
    <select class="" onchange="document.location.href=this.value">

  <option selected value="/module/BEPPU/Linux-Input-1.03/lib/Linux/Input.pm">
    1.03
      (BEPPU on 2007-07-27)
      
  </option>

  <option  value="/module/BEPPU/Linux-Input-1.02/lib/Linux/Input.pm">
    1.02
      (BEPPU on 2006-09-13)
      
  </option>

  <option  value="/module/BEPPU/Linux-Input-1.01/lib/Linux/Input.pm">
    1.01
      (BEPPU on 2004-10-14)
      
  </option>

  <option  value="/module/BEPPU/Linux-Input-1.00/lib/Linux/Input.pm">
    1.00
      (BEPPU on 2004-10-10)
      
  </option>
</select>
    
    <a data-keyboard-shortcut="g d" class="release-name" href="/release/BEPPU/Linux-Input-1.03">Linux-Input-1.03</a>
    
    
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
      <title>River stage zero &#10;No dependents</title>

      <!-- 5 bars, 4x15px, 1px apart, colored #e4e2e2 or #7ea3f2 -->
      <rect x="0"  y="0" width="4" height="15" fill="#e4e2e2" />
      <rect x="5"  y="0" width="4" height="15" fill="#e4e2e2" />
      <rect x="10" y="0" width="4" height="15" fill="#e4e2e2" />
      <rect x="15" y="0" width="4" height="15" fill="#e4e2e2" />
      <rect x="20" y="0" width="4" height="15" fill="#e4e2e2" />
    </g>
  </svg>


</span>
<div id="Linux-Input-fav" class="logged_in">
<form action="/account/favorite/add" style="display: inline" onsubmit="return favDistribution(this)">
    <input type="hidden" name="remove" value="0">
    <input type="hidden" name="release" value="Linux-Input-1.03">
    <input type="hidden" name="author" value="BEPPU">
    <input type="hidden" name="distribution" value="Linux-Input">
    <button type="submit" class="favorite"><span></span> ++</button>
</form>
</div>
<div class="logged_out">
<a href="" onclick="alert('Please sign in to add favorites'); return false" class="favorite">
<span></span> ++</a>
</div>

  &nbsp;/&nbsp;<span itemprop="name" >Linux::Input</span>
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
    <li class="nav-header">      <time class="relatize" itemprop="dateModified" datetime="2007-07-27">27 Jul 2007 07:40:59 UTC</time>
    </li>
    
    <li>
      Distribution: Linux-Input</span>
    </li>
    
    <li>
      Module version: <span itemprop="softwareVersion">1.03</span>
    </li>
    
        <li>
      <a data-keyboard-shortcut="g s" href="/source/BEPPU/Linux-Input-1.03/lib/Linux/Input.pm"><i class="fa fa-fw fa-file-code-o black"></i>Source</a>
      (<a href="/source/BEPPU/Linux-Input-1.03/lib/Linux/Input.pm?raw=1">raw</a>)
    </li>
    
    <li>
      <a data-keyboard-shortcut="g b" href="/source/BEPPU/Linux-Input-1.03/lib/Linux"><i class="fa fa-fw fa-folder-open black"></i>Browse</a>
      (<a href="/source/BEPPU/Linux-Input-1.03/lib/Linux?raw=1">raw</a>)
    </li>
    <li>
    <a data-keyboard-shortcut="g c" href="/changes/release/BEPPU/Linux-Input-1.03"><i class="fa fa-fw fa-cogs black"></i>Changes</a>
</li>

<li>
    <a class="nopopup" href="/contributing-to/BEPPU/Linux-Input-1.03"><i class="fa fa-fw fa-plus-circle black"></i>How to Contribute</a>
</li>

<li>
    <a rel="noopener nofollow" data-keyboard-shortcut="g i" href="https://rt.cpan.org/Public/Dist/Display.html?Name=Linux-Input"><i class="fa fa-fw fa-info-circle black"></i>Issues</a>
    (0)
</li>
<li>
    
    <a rel="noopener nofollow" href="http://matrix.cpantesters.org/?dist=Linux-Input+1.03" title="Matrix"><i class="fa fa-fw fa-check-circle black"></i>Testers</a>
    <span title="(pass / fail / na)">(<a rel="noopener nofollow" href="https://www.cpantesters.org/distro/L/Linux-Input.html?oncpan=1&amp;distmat=1&amp;version=1.03&amp;grade=2" style="color: #090">529</a> / <a rel="noopener nofollow" href="https://www.cpantesters.org/distro/L/Linux-Input.html?oncpan=1&amp;distmat=1&amp;version=1.03&amp;grade=3" style="color: #900">0</a> / <a rel="noopener nofollow" href="https://www.cpantesters.org/distro/L/Linux-Input.html?oncpan=1&amp;distmat=1&amp;version=1.03&amp;grade=4">0</a>)</span>
</li>
<li>
    <a rel="noopener nofollow" href="http://cpants.cpanauthors.org/release/BEPPU/Linux-Input-1.03"><i class="fa fa-fw fa-line-chart black"></i>Kwalitee</a>
</li>

  <li>
    <i class="fa fa-fw fa-pie-chart black"></i><a rel="noopener nofollow" href="http://cpancover.com/latest/Linux-Input-1.03/index.html">43.62% Coverage </a>
  </li>



<li><i class="fa fa-fw fa-gavel black"></i>License: perl_5</li>





    <li class="nav-header">Activity</li>
    <li><div class="activity-graph">
  <img src="/activity?res=month&amp;distribution=Linux-Input" width="170" height="22" />
  <div align="right"><small class="comment">24 month</small></div>
</div>
</li>
    <li class="nav-header">Tools</li>
<li>
    <a itemprop="downloadUrl" href="https://cpan.metacpan.org/authors/id/B/BE/BEPPU/Linux-Input-1.03.tar.gz">
    <i class="fa fa-download fa-fw black"></i>Download (<span itemprop="fileSize" >5.95Kb</span>)</a>
    
    <span class="invisible" itemprop="offers" itemscope itemtype="http://schema.org/Offer">
      <span itemprop="price">0</span>
    </span>
    
</li>
<li>
    <a href="https://explorer.metacpan.org/?url=/module/BEPPU/Linux-Input-1.03/lib%2FLinux%2FInput.pm">
    <i class="fa fa-list-alt fa-fw black"></i>MetaCPAN Explorer
    </a>
</li>
<li>
  <a href="/permission/distribution/Linux-Input">
    <i class="fa fa-key fa-fw black"></i>Permissions
  </a>
</li>
<li>
    <a href="/feed/distribution/Linux-Input">
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
        <input type="hidden" name="q" value="dist:Linux-Input">
        <input type="search" name="q" placeholder="Search distribution" style="width: 153px" class="form-control tool-bar-form">
        <input type="submit" style="display: none">
    </form>
</li>
<li>
    <form action="https://grep.metacpan.org/search">
        <input type="hidden" name="qd" value="Linux-Input">
        <input type="hidden" name="source" value="metacpan">
         <input type="search" name="q" placeholder="grep distribution" style="width: 153px" class="form-control tool-bar-form">
         <input type="submit" style="display: none">
     </form>
</li>
<li>
    <select onchange="document.location.href='/module/'+this.value" class="form-control tool-bar-form">
        <option>Jump to version</option>
    <option value="BEPPU/Linux-Input-1.02/lib/Linux/Input.pm">1.02 (BEPPU on 2006-09-13)</option>

    <option value="BEPPU/Linux-Input-1.01/lib/Linux/Input.pm">1.01 (BEPPU on 2004-10-14)</option>

    <option value="BEPPU/Linux-Input-1.00/lib/Linux/Input.pm">1.00 (BEPPU on 2004-10-10)</option>

    </select>
</li>
<li>
    <select name="release" onchange="document.location.href='/diff/file/?target=BEPPU/Linux-Input-1.03/lib%2FLinux%2FInput.pm&amp;source=' + encodeURIComponent(this.value)" class="form-control tool-bar-form">
        <option>Diff with version</option>
    <option value="BEPPU/Linux-Input-1.02/lib/Linux/Input.pm">1.02 (BEPPU on 2006-09-13)</option>

    <option value="BEPPU/Linux-Input-1.01/lib/Linux/Input.pm">1.01 (BEPPU on 2004-10-14)</option>

    <option value="BEPPU/Linux-Input-1.00/lib/Linux/Input.pm">1.00 (BEPPU on 2004-10-10)</option>

    </select>
</li>

<li class="nav-header">Permalinks</li>
<li>
    <a href="/pod/release/BEPPU/Linux-Input-1.03/lib/Linux/Input.pm">This version</a>
</li>
<li>
    <a itemprop="url" href="/pod/Linux::Input">Latest version</a>
</li>

  </ul>

  <button id="right-panel-toggle" class="btn-link" onclick="togglePanel('right'); return false;"><span class="panel-hidden">Show</span><span class="panel-visible">Hide</span> Right Panel</button>
  <div id="right-panel" class="pull-right">
  <div class="box-right">
  <!-- For plussers -->


<div class="author-pic">
<a href="/author/BEPPU">
  <img src="https://www.gravatar.com/avatar/7ad9238f6593a1839b4c1bd9fdb832c4?s=130&amp;d=identicon" alt="Author image">
</a>
<strong>
  <a rel="author" href="/author/BEPPU">BEPPU</a>
</strong>
<span title="">John Beppu</span>
</div>

  

<div id="contributors">
    <div class="contributors-header">and 1 contributors</div>
    <div align="right">
        <button class="btn-link"
            onclick="$(this).hide(); $('#contributors ul').slideDown(); return false;"
        >show them</button>
    </div>
    <ul class="nav nav-list box-right" style="display: none">
    
        <li class="contributor">
        John Beppu (beppu@cpan.org)
        
        </li>
    
    </ul>
</div>



  </div>
  <ul class="nav-list box-right hidden-phone dependencies">
    <li class="nav-header">Dependencies</li>
    <li><a href="/pod/Class::Data::Inheritable" title="Class::Data::Inheritable" class="ellipsis">Class::Data::Inheritable</a></li>
    <li><a href="/pod/IO::File" title="IO::File" class="ellipsis">IO::File</a></li>
    <li><a href="/pod/IO::Select" title="IO::Select" class="ellipsis">IO::Select</a></li>
    <li><i class="ttip" title="dynamic_config enabled">and possibly others</i></li>
    <li><hr /></li>
    <li>
        <a href="http://deps.cpantesters.org/?module=Linux::Input">
        <i class="fa fa-retweet fa-fw black"></i>CPAN Testers List</a>
    </li>
    <li>        <a href="/requires/module/Linux::Input">        <i class="fa fa-share fa-fw black"></i>Reverse dependencies</a>
    </li>
    <li>
        <a href="https://cpandeps.grinnz.com/?dist=Linux-Input&dist_version=1.03">
        <i class="fa fa-asterisk fa-fw black"></i>Dependency graph</a>
    </li>
</ul>

  </div>
  <a name="___pod"></a>
  <div class="pod content anchors">

  
  <ul id="index">
  <li><a href="#NAME">NAME</a></li>
  <li><a href="#SYNOPSIS">SYNOPSIS</a></li>
  <li><a href="#DESCRIPTION">DESCRIPTION</a>
    <ul>
      <li><a href="#Class-Methods">Class Methods</a>
        <ul>
          <li><a href="#new">new</a></li>
          <li><a href="#entity_bytes">entity_bytes</a></li>
          <li><a href="#timeout">timeout</a></li>
        </ul>
      </li>
      <li><a href="#Object-Methods">Object Methods</a>
        <ul>
          <li><a href="#fh">fh</a></li>
          <li><a href="#selector">selector</a></li>
          <li><a href="#poll">poll</a></li>
        </ul>
      </li>
    </ul>
  </li>
  <li><a href="#AUTHOR">AUTHOR</a></li>
  <li><a href="#SEE-ALSO">SEE ALSO</a></li>
</ul>

<h1 id="NAME">NAME</h1>

<p>Linux::Input - Linux input event interface</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<p>Example: 1 joystick using event API</p>

<pre><code>  my $js1 = Linux::Input-&gt;new(&#39;/dev/input/event3&#39;);
  while (1) {
    while (my @events = $js1-&gt;poll(0.01)) {
      foreach (@event) {
      }
    }
  }</code></pre>

<p>Example: 2 joysticks using joystick API (different event structure)</p>

<pre><code>  my $js1 = Linux::Input::Joystick-&gt;new(&#39;/dev/input/js0&#39;);
  my $js2 = Linux::Input::Joystick-&gt;new(&#39;/dev/input/js1&#39;);
  my $selector = IO::Select-&gt;new();
  $selector-&gt;add($js1-&gt;fh);
  $selector-&gt;add($js2-&gt;fh);

  while (my $fh = $selector-&gt;can_read) {
    my @event;
    if ($fh == $js1-&gt;fh) {
      @event = $js1-&gt;poll()
    } elsif ($fh == $js2-&gt;fh) {
      @event = $js2-&gt;poll()
    }
    foreach (@event) {
      # work
    }
  }</code></pre>

<p>Example 3: monitor all input devices</p>

<pre><code>  use File::Basename qw(basename);
  my @inputs = map { &quot;/dev/input/&quot; . basename($_) }
    &lt;/sys/class/input/event*&gt;;

  my @dev;
  my $selector = IO::Select-&gt;new();
  foreach (@inputs) {
    my $device = Linux::Input-&gt;new($_);
    $selector-&gt;add($device-&gt;fh);
    push @dev, $device;
  }

  while (my $fh = $selector-&gt;can_read) {
    # work
  }</code></pre>

<p>Example 4: testing for events on the command line</p>

<pre><code>  # information on what event queue belongs to what device
  cat /proc/bus/input/devices

  # verify that events are coming in
  sudo evtest.pl /dev/input/event*</code></pre>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p><a href="/pod/release/BEPPU/Linux-Input-1.03/lib/Linux/Input.pm">Linux::Input</a> provides a pure-perl interface to the Linux kernel&#39;s input event interface. It basically provides a uniform API for getting realtime data from all the different input devices that Linux supports.</p>

<p>For more information, please read: <i>/usr/src/linux/Documentation/input/input.txt</i>.</p>

<h2 id="Class-Methods"><a id="Class"></a>Class Methods</h2>

<h3 id="new">new</h3>

<p>This method takes one filename as a parameter and returns a <a href="/pod/release/BEPPU/Linux-Input-1.03/lib/Linux/Input.pm">Linux::Input</a> object.</p>

<p><b>Example</b>:</p>

<pre><code>  my $js1 = Linux::Input-&gt;new(&#39;/dev/input/event3&#39;);</code></pre>

<h3 id="entity_bytes">entity_bytes</h3>

<p>This method returns the size of the event structure on this system.</p>

<p><b>Example</b>:</p>

<pre><code>  my $struct_size = Linux::Input-&gt;entity_bytes();</code></pre>

<h3 id="timeout">timeout</h3>

<p>This method can be used to read or specify the default timeout value for the select()&#39;ing on filehandles that happens within the module. The default value is 0.01.</p>

<h2 id="Object-Methods"><a id="Object"></a>Object Methods</h2>

<h3 id="fh">fh</h3>

<p>This method returns the filehandle of a <a href="/pod/release/BEPPU/Linux-Input-1.03/lib/Linux/Input.pm">Linux::Input</a> object.</p>

<p><b>Example</b>:</p>

<pre><code>  my $filehandle = $js-&gt;fh();</code></pre>

<h3 id="selector">selector</h3>

<p>This method is used internally to return the <a href="/pod/IO::Select">IO::Select</a> object that&#39;s been assigned to the current <a href="/pod/release/BEPPU/Linux-Input-1.03/lib/Linux/Input.pm">Linux::Input</a> object.</p>

<h3 id="poll">poll</h3>

<p>This method takes a <code>$timeout</code> value as a parameter and returns a list of <code>@events</code> for the current <a href="/pod/release/BEPPU/Linux-Input-1.03/lib/Linux/Input.pm">Linux::Input</a> object. Each event is a hashref with the following key/value pairs.</p>

<dl>

<dt id="tv_sec">tv_sec</dt>
<dd>

</dd>
<dt id="tv_usec">tv_usec</dt>
<dd>

</dd>
<dt id="type">type</dt>
<dd>

</dd>
<dt id="code">code</dt>
<dd>

</dd>
<dt id="value">value</dt>
<dd>

</dd>
</dl>

<p><b>Example</b>:</p>

<pre><code>  my @events = $js-&gt;poll(0.01);</code></pre>

<h1 id="AUTHOR">AUTHOR</h1>

<p>John Beppu (beppu@cpan.org)</p>

<h1 id="SEE-ALSO"><a id="SEE"></a>SEE ALSO</h1>

<p><a href="/pod/release/BEPPU/Linux-Input-1.03/lib/Linux/Input/Joystick.pm">Linux::Input::Joystick</a>, <a href="/pod/Class::Data::Inheritable">Class::Data::Inheritable</a>, <a href="/pod/IO::Select">IO::Select</a>, <a href="/pod/IO::File">IO::File</a></p>
  
        <div id="install-instructions-dialog" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Module Install Instructions</h4>
            </div>
            <div class="modal-body">
                <p>To install Linux::Input, copy and paste the appropriate command in to your terminal.</p>
                <p><a href="/pod/distribution/App-cpanminus/bin/cpanm">cpanm</a></p>
                <pre>
                    cpanm Linux::Input
                </pre>
                <p><a href="/pod/CPAN">CPAN shell</a></p>
                <pre>
                    perl -MCPAN -e shell
                    install Linux::Input
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
