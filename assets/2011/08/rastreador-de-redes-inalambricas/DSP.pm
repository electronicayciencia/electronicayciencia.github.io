<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5">
        <title>Audio::DSP - Perl interface to *NIX digital audio device. - metacpan.org</title>
        <link rel="alternate" type="application/rss+xml" title="Recent CPAN Uploads of Audio-DSP - MetaCPAN" href="/feed/distribution/Audio-DSP" />
        <link href="/_assets/09a20e39bc03ec6c8fbc017562af3184c4c5b48e.css" rel="stylesheet" type="text/css">
        <link rel="search" href="/static/opensearch.xml" type="application/opensearchdescription+xml" title="MetaCPAN">
        <link rel="canonical" href="https://metacpan.org/pod/Audio::DSP" />
        <meta name="description" content="Perl interface to *NIX digital audio device." />
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
<meta name="twitter:url"         content="https://metacpan.org/pod/release/SETHJ/Audio-DSP-0.02/DSP.pm" />
<meta name="twitter:title"       content="Audio::DSP" />
<meta name="twitter:description" content="Perl interface to *NIX digital audio device." />
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
    <a itemprop="url"  data-keyboard-shortcut="g a" rel="author" href="/author/SETHJ" title="" class="author-name"><span itemprop="name" >Seth David Johnson</span></a>
  </span>
  <span>&nbsp;/&nbsp;</span>
  <div class="release status-latest maturity-released">
    <span class="dropdown"><b class="caret"></b></span>
    <select class="" onchange="document.location.href=this.value">

  <option selected value="/module/SETHJ/Audio-DSP-0.02/DSP.pm">
    0.02
      (SETHJ on 2000-09-11)
      
  </option>

  <option  value="/module/SETHJ/Audio-DSP-0.01/DSP.pm">
    0.01
      (SETHJ on 1999-10-18)
      
  </option>
</select>
    
    <a data-keyboard-shortcut="g d" class="release-name" href="/release/SETHJ/Audio-DSP-0.02">Audio-DSP-0.02</a>
    
    
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
<div id="Audio-DSP-fav" class="logged_in">
<form action="/account/favorite/add" style="display: inline" onsubmit="return favDistribution(this)">
    <input type="hidden" name="remove" value="0">
    <input type="hidden" name="release" value="Audio-DSP-0.02">
    <input type="hidden" name="author" value="SETHJ">
    <input type="hidden" name="distribution" value="Audio-DSP">
    <button type="submit" class="favorite"><span></span> ++</button>
</form>
</div>
<div class="logged_out">
<a href="" onclick="alert('Please sign in to add favorites'); return false" class="favorite">
<span></span> ++</a>
</div>

  &nbsp;/&nbsp;<span itemprop="name" >Audio::DSP</span>
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
    <li class="nav-header">      <time class="relatize" itemprop="dateModified" datetime="2000-09-11">11 Sep 2000 05:53:42 UTC</time>
    </li>
    
    <li>
      Distribution: Audio-DSP</span>
    </li>
    
    <li>
      Module version: <span itemprop="softwareVersion">0.02</span>
    </li>
    
        <li>
      <a data-keyboard-shortcut="g s" href="/source/SETHJ/Audio-DSP-0.02/DSP.pm"><i class="fa fa-fw fa-file-code-o black"></i>Source</a>
      (<a href="/source/SETHJ/Audio-DSP-0.02/DSP.pm?raw=1">raw</a>)
    </li>
    
    <li>
      <a data-keyboard-shortcut="g b" href="/source/SETHJ/Audio-DSP-0.02/"><i class="fa fa-fw fa-folder-open black"></i>Browse</a>
      (<a href="/source/SETHJ/Audio-DSP-0.02/?raw=1">raw</a>)
    </li>
    <li>
    <a data-keyboard-shortcut="g c" href="/changes/release/SETHJ/Audio-DSP-0.02"><i class="fa fa-fw fa-cogs black"></i>Changes</a>
</li>

<li>
    <a class="nopopup" href="/contributing-to/SETHJ/Audio-DSP-0.02"><i class="fa fa-fw fa-plus-circle black"></i>How to Contribute</a>
</li>

<li>
    <a rel="noopener nofollow" data-keyboard-shortcut="g i" href="https://rt.cpan.org/Public/Dist/Display.html?Name=Audio-DSP"><i class="fa fa-fw fa-info-circle black"></i>Issues</a>
    (2)
</li>
<li>
    
    <a rel="noopener nofollow" href="http://matrix.cpantesters.org/?dist=Audio-DSP+0.02" title="Matrix"><i class="fa fa-fw fa-check-circle black"></i>Testers</a>
    <span title="(pass / fail / na)">(<a rel="noopener nofollow" href="https://www.cpantesters.org/distro/A/Audio-DSP.html?oncpan=1&amp;distmat=1&amp;version=0.02&amp;grade=2" style="color: #090">82</a> / <a rel="noopener nofollow" href="https://www.cpantesters.org/distro/A/Audio-DSP.html?oncpan=1&amp;distmat=1&amp;version=0.02&amp;grade=3" style="color: #900">365</a> / <a rel="noopener nofollow" href="https://www.cpantesters.org/distro/A/Audio-DSP.html?oncpan=1&amp;distmat=1&amp;version=0.02&amp;grade=4">0</a>)</span>
</li>
<li>
    <a rel="noopener nofollow" href="http://cpants.cpanauthors.org/release/SETHJ/Audio-DSP-0.02"><i class="fa fa-fw fa-line-chart black"></i>Kwalitee</a>
</li>

  <li>
    <i class="fa fa-fw fa-pie-chart black"></i><a rel="noopener nofollow" href="http://cpancover.com/latest/Audio-DSP-0.02/index.html">42.11% Coverage </a>
  </li>



<li><i class="fa fa-fw fa-gavel black"></i>License: unknown</li>





    <li class="nav-header">Activity</li>
    <li><div class="activity-graph">
  <img src="/activity?res=month&amp;distribution=Audio-DSP" width="170" height="22" />
  <div align="right"><small class="comment">24 month</small></div>
</div>
</li>
    <li class="nav-header">Tools</li>
<li>
    <a itemprop="downloadUrl" href="https://cpan.metacpan.org/authors/id/S/SE/SETHJ/Audio-DSP-0.02.tar.gz">
    <i class="fa fa-download fa-fw black"></i>Download (<span itemprop="fileSize" >27.78Kb</span>)</a>
    
    <span class="invisible" itemprop="offers" itemscope itemtype="http://schema.org/Offer">
      <span itemprop="price">0</span>
    </span>
    
</li>
<li>
    <a href="https://explorer.metacpan.org/?url=/module/SETHJ/Audio-DSP-0.02/DSP.pm">
    <i class="fa fa-list-alt fa-fw black"></i>MetaCPAN Explorer
    </a>
</li>
<li>
  <a href="/permission/distribution/Audio-DSP">
    <i class="fa fa-key fa-fw black"></i>Permissions
  </a>
</li>
<li>
    <a href="/feed/distribution/Audio-DSP">
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
        <input type="hidden" name="q" value="dist:Audio-DSP">
        <input type="search" name="q" placeholder="Search distribution" style="width: 153px" class="form-control tool-bar-form">
        <input type="submit" style="display: none">
    </form>
</li>
<li>
    <form action="https://grep.metacpan.org/search">
        <input type="hidden" name="qd" value="Audio-DSP">
        <input type="hidden" name="source" value="metacpan">
         <input type="search" name="q" placeholder="grep distribution" style="width: 153px" class="form-control tool-bar-form">
         <input type="submit" style="display: none">
     </form>
</li>
<li>
    <select onchange="document.location.href='/module/'+this.value" class="form-control tool-bar-form">
        <option>Jump to version</option>
    <option value="SETHJ/Audio-DSP-0.01/DSP.pm">0.01 (SETHJ on 1999-10-18)</option>

    </select>
</li>
<li>
    <select name="release" onchange="document.location.href='/diff/file/?target=SETHJ/Audio-DSP-0.02/DSP.pm&amp;source=' + encodeURIComponent(this.value)" class="form-control tool-bar-form">
        <option>Diff with version</option>
    <option value="SETHJ/Audio-DSP-0.01/DSP.pm">0.01 (SETHJ on 1999-10-18)</option>

    </select>
</li>

<li class="nav-header">Permalinks</li>
<li>
    <a href="/pod/release/SETHJ/Audio-DSP-0.02/DSP.pm">This version</a>
</li>
<li>
    <a itemprop="url" href="/pod/Audio::DSP">Latest version</a>
</li>

  </ul>

  <button id="right-panel-toggle" class="btn-link" onclick="togglePanel('right'); return false;"><span class="panel-hidden">Show</span><span class="panel-visible">Hide</span> Right Panel</button>
  <div id="right-panel" class="pull-right">
  <div class="box-right">
  <!-- For plussers -->


<div class="author-pic">
<a href="/author/SETHJ">
  <img src="https://www.gravatar.com/avatar/adac85ca7ea1cdcabccb95131ab53670?s=130&amp;d=identicon" alt="Author image">
</a>
<strong>
  <a rel="author" href="/author/SETHJ">SETHJ</a>
</strong>
<span title="">Seth David Johnson</span>
</div>

  

  </div>
  <ul class="nav-list box-right hidden-phone dependencies">
    <li class="nav-header">Dependencies</li>
    <li><i class="ttip" title="dynamic_config enabled">unknown</i></li>
    <li><hr /></li>
    <li>
        <a href="http://deps.cpantesters.org/?module=Audio::DSP">
        <i class="fa fa-retweet fa-fw black"></i>CPAN Testers List</a>
    </li>
    <li>        <a href="/requires/module/Audio::DSP">        <i class="fa fa-share fa-fw black"></i>Reverse dependencies</a>
    </li>
    <li>
        <a href="https://cpandeps.grinnz.com/?dist=Audio-DSP&dist_version=0.02">
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
  <li><a href="#CONSTRUCTOR">CONSTRUCTOR</a></li>
  <li><a href="#METHODS">METHODS</a>
    <ul>
      <li><a href="#Opening-and-closing-the-device">Opening and closing the device</a></li>
      <li><a href="#Dealing-with-data-in-memory">Dealing with data in memory</a></li>
      <li><a href="#Reading/writing-data-directly-to/from-the-device">Reading/writing data directly to/from the device</a></li>
      <li><a href="#I/O-Control">I/O Control</a></li>
      <li><a href="#Misc">Misc</a></li>
      <li><a href="#Deprecated-methods">Deprecated methods</a></li>
    </ul>
  </li>
  <li><a href="#CONSTANTS">CONSTANTS</a></li>
  <li><a href="#NOTES">NOTES</a></li>
  <li><a href="#AUTHOR">AUTHOR</a></li>
  <li><a href="#SEE-ALSO">SEE ALSO</a></li>
  <li><a href="#COPYRIGHT">COPYRIGHT</a></li>
</ul>

<h1 id="NAME">NAME</h1>

<p>Audio::DSP - Perl interface to *NIX digital audio device.</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<pre><code>    use Audio::DSP;

    ($buf, $chan, $fmt, $rate) = (4096, 1, 8, 8192);

    $dsp = new Audio::DSP(buffer   =&gt; $buf,
                          channels =&gt; $chan,
                          format   =&gt; $fmt,
                          rate     =&gt; $rate);

    $seconds = 5;
    $length  = ($chan * $fmt * $rate * $seconds) / 8;

    $dsp-&gt;init() || die $dsp-&gt;errstr();

    # Record 5 seconds of sound
    for (my $i = 0; $i &lt; $length; $i += $buf) {
        $dsp-&gt;read() || die $dsp-&gt;errstr();
    }

    # Play it back
    for (;;) {
        $dsp-&gt;write() || last;
    }

    $dsp-&gt;close();</code></pre>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p>Audio::DSP is built around the OSS (Open Sound System) API and allows perl to interface with a digital audio device. It provides, among other things, an <a href="#item_init">initialization</a> method which opens and handles ioctl messaging on the audio device file. Audio::DSP also provides some <a href="#Dealing-with-data-in-memory">rudimentary methods</a> for the storage and manipulation of audio data in memory.</p>

<p>In order to use Audio::DSP, you&#39;ll need to have the necessary OSS drivers/libraries installed. OSS is available for many popular Unices, and a GPLed version (with which this extension was initially developed and tested) is distributed with with the Linux kernel.</p>

<h1 id="CONSTRUCTOR">CONSTRUCTOR</h1>

<dl>

<dt id="new([params])"><a id="new"></a><a id="new-params"></a>new([params])</dt>
<dd>

<p>Returns blessed Audio::DSP object. Parameters:</p>

<dl>

<dt id="device">device</dt>
<dd>

<p>Name of audio device file. Default is &#39;/dev/dsp&#39;.</p>

</dd>
<dt id="buffer">buffer</dt>
<dd>

<p>Length of buffer, in bytes, for reading from/writing to the audio device file. Default is 4096.</p>

</dd>
<dt id="rate">rate</dt>
<dd>

<p>Sampling rate in bytes per second. This parameter affects, among other things, the highest frequency in the sampled signal, which must be less than half the sample rate. Compact discs use a 44100 samples per second sampling rate.</p>

<p>Default sample rate is 8192.</p>

</dd>
<dt id="format">format</dt>
<dd>

<p>Sample format. This parameter affects not only the size and the byte-order of a sample, but also its dynamic range.</p>

<p>Sample format may be directly specified as an integer (e.g. 8 or 16) or as one of the format <a href="#CONSTANTS">constants</a> defined in soundcard.h and exported by Audio::DSP on use. The latter is preffered; an integer value of 16 (for example) corresponds to little endian signed 16 (AFMT_S16_LE), which format may or may not work with your card. So be careful.</p>

<p>If the format constant is passed as a string (e.g. &#39;AFMT_U8&#39; rather than AFMT_U8), it will work, but <b>this feature is deprecated</b>. It has been retained for backward-compatibility, but do not assume that it will be present in future versions.</p>

<p>Default sample format is AFMT_U8.</p>

</dd>
<dt id="channels">channels</dt>
<dd>

<p>1 (mono) or 2 (stereo). Default is 1.</p>

</dd>
<dt id="file">file</dt>
<dd>

<p>File from which to read raw sound data to be stored in memory.</p>

<p>No effort is made to interpret the type of file being read. It&#39;s up to you to set the appropriate rate, channel, and format parameters if you wish to write the sound data to your audio device without damaging your hearing.</p>

</dd>
</dl>

</dd>
</dl>

<h1 id="METHODS">METHODS</h1>

<h2 id="Opening-and-closing-the-device"><a id="Opening"></a>Opening and closing the device</h2>

<dl>

<dt id="init([params])"><a id="init"></a><a id="init-params"></a>init([params])</dt>
<dd>

<p>Opens and initializes audio device file. Parameters <a href="#item_device">device</a>, <a href="#item_buffer">buffer</a>, <a href="#item_rate">rate</a>, <a href="#item_format">format</a>, and <a href="#item_channels">channels</a> are shared with the constructor, and will override them. Additional parameters:</p>

<dl>

<dt id="mode">mode</dt>
<dd>

<p>Integer mode in which to open audio device file. Specifying the modes &#39;O_RDWR&#39;, &#39;O_RDONLY&#39;, and &#39;O_WRONLY&#39; as strings will work, but <b>this feature is deprecated</b>. Use the Fcntl.pm constants to obtain the approriate integer mode values instead.</p>

<p>The default value is O_RDWR.</p>

</dd>
</dl>

<p>Example:</p>

<pre><code>    $dsp-&gt;init(mode =&gt; O_RDONLY) || die $dsp-&gt;errstr();</code></pre>

<p>Returns true on success, false on error.</p>

</dd>
<dt id="open([mode])"><a id="open"></a><a id="open-mode"></a>open([mode])</dt>
<dd>

<p>Opens audio device file, does not send any ioctl messages. Default mode is O_RDWR.</p>

<p>Example:</p>

<pre><code>    $dsp-&gt;open(O_RDONLY) || die $dsp-&gt;errstr();</code></pre>

<p>Returns true on success, false on error.</p>

</dd>
<dt id="close()"><a id="close"></a>close()</dt>
<dd>

<p>Closes audio device file. Returns true on success, false on error.</p>

</dd>
</dl>

<h2 id="Dealing-with-data-in-memory"><a id="Dealing"></a>Dealing with data in memory</h2>

<dl>

<dt id="audiofile($filename)"><a id="audiofile"></a><a id="audiofile-filename"></a>audiofile($filename)</dt>
<dd>

<p>Reads data from specified file and stores it in memory. If there is sound data stored already in memory, the file data will be concatenated onto the end of it.</p>

<p>No effort is made to interpret the type of file being read. It&#39;s up to you to set the appropriate rate, channel, and format parameters if you wish to write the sound data to your audio device without damaging your hearing.</p>

<pre><code>    $dsp-&gt;audiofile(&#39;foo.raw&#39;) || die $dsp-&gt;errstr();</code></pre>

<p>Returns true on success, false on error.</p>

</dd>
<dt id="read()"><a id="read"></a>read()</dt>
<dd>

<p>Reads buffer length of data from audio device file and appends it to the audio data stored in memory. Returns true on success, false on error.</p>

</dd>
<dt id="write()"><a id="write"></a>write()</dt>
<dd>

<p>Writes buffer length of sound data currently stored in memory, starting at the current <a href="#item_setmark">play mark</a> offset, to audio device file. <a href="#item_setmark">Play mark</a> is incremented one buffer length. Returns true on success, false on error or if the <a href="#item_setmark">play mark</a> exceeds the length of audio data stored in memory.</p>

</dd>
<dt id="clear()"><a id="clear"></a>clear()</dt>
<dd>

<p>Clears audio data currently stored in memory, sets play mark to zero. No return value.</p>

</dd>
<dt id="data()"><a id="data"></a>data()</dt>
<dd>

<p>Returns sound data stored in memory.</p>

<pre><code>    open RAWFILE, &#39;&gt;foo.raw&#39;;
    print RAWFILE $dsp-&gt;data();
    close RAWFILE;</code></pre>

</dd>
<dt id="datacat($data)"><a id="datacat"></a><a id="datacat-data"></a>datacat($data)</dt>
<dd>

<p>Concatenates argument (a string) to audio data stored in memory. Returns length of audio data currently stored.</p>

</dd>
<dt id="datalen()"><a id="datalen"></a>datalen()</dt>
<dd>

<p>Returns length of audio data currently stored in memory.</p>

</dd>
<dt id="setbuffer([$length])"><a id="setbuffer"></a><a id="setbuffer-length"></a>setbuffer([$length])</dt>
<dd>

<p>Sets read/write buffer if argument is provided.</p>

<p>Returns buffer length currently specified.</p>

</dd>
<dt id="setmark([$mark])"><a id="setmark"></a><a id="setmark-mark"></a>setmark([$mark])</dt>
<dd>

<p>Sets play mark if argument is provided. The play mark indicates how many bites of audio data stored in memory have been written to the audio device file since the mark was last set to zero. This lets the <a href="#item_write">write()</a> method know what to write.</p>

<p>Returns current play mark.</p>

</dd>
</dl>

<h2 id="Reading/writing-data-directly-to/from-the-device"><a id="Reading"></a><a id="Reading-writing-data-directly-to-from-the-device"></a>Reading/writing data directly to/from the device</h2>

<p>These methods are provided mainly for the purposes of anyone wishing to delve into hard-disk recording.</p>

<dl>

<dt id="dread([$length])"><a id="dread"></a><a id="dread-length"></a>dread([$length])</dt>
<dd>

<p>Reads length of data from audio device file and returns it. If length is not supplied, a &quot;buffer length&quot; of data (as specified when the <a href="#item_new">constructor</a>/<a href="#item_init">init()</a> method was called) is read. If there is an error reading from the device file, a false value is returned.</p>

</dd>
<dt id="dwrite($data)"><a id="dwrite"></a><a id="dwrite-data"></a>dwrite($data)</dt>
<dd>

<p>Writes data directly to audio device. Returns true on success, false on error.</p>

</dd>
</dl>

<h2 id="I/O-Control"><a id="I"></a><a id="I-O-Control"></a>I/O Control</h2>

<p>The device must be opened with <a href="#item_init">init()</a> or <a href="#item_open">open()</a> before calling any of the following methods.</p>

<p>It is important to set sampling parameters in the following order: <a href="#item_setfmt">setfmt()</a>, <a href="#item_channels">channels()</a>, <a href="#item_speed">speed()</a>. Setting sampling rate (speed) before number of channels does not work with all devices, according to OSS documentation. The safe alternative is to call <a href="#item_init">init()</a> with the appropriate parameters.</p>

<dl>

<dt id="post()"><a id="post"></a>post()</dt>
<dd>

<p>Sends SNDCTL_DSP_POST ioctl message to audio device file. Returns true on success, false on error.</p>

</dd>
<dt id="reset()"><a id="reset"></a>reset()</dt>
<dd>

<p>Sends SNDCTL_DSP_RESET ioctl message to audio device file. Returns true on success, false on error.</p>

</dd>
<dt id="sync()"><a id="sync"></a>sync()</dt>
<dd>

<p>Sends SNDCTL_DSP_SYNC ioctl message to audio device file. Returns true on success, false on error.</p>

</dd>
<dt id="setfmt($format)"><a id="setfmt"></a><a id="setfmt-format"></a>setfmt($format)</dt>
<dd>

<p>Sends SNDCTL_DSP_SETFMT ioctl message to audio device file, with sample format as argument. Returns sample format to which the device was actually set if successful, false on error. You should check the return value even on success to ensure the requested sample format was in fact set for the device.</p>

<pre><code>    my $format = AFMT_S16_LE; # signed 16-bit, little-endian
    my $rv     = $dsp-&gt;setfmt($format) || die $dsp-&gt;errstr;

    die &quot;Failed to set requested sample format&quot;
        unless ($format == $rv);</code></pre>

</dd>
<dt id="channels($channels)"><a id="channels1"></a><a id="channels-channels"></a>channels($channels)</dt>
<dd>

<p>Sends SNDCTL_DSP_CHANNELS ioctl message to audio device file, with number of channels as argument. Returns number of channels to which the device was actually set if successful, false on error. You should check the return value even on success to ensure the requested number of channels were in fact set for the device.</p>

<pre><code>    my $chan = 2; # stereo
    my $rv   = $dsp-&gt;channels($chan) || die $dsp-&gt;errstr;

    die &quot;Failed to set requested number of channels&quot;
        unless ($chan == $rv);</code></pre>

</dd>
<dt id="speed($rate)"><a id="speed"></a><a id="speed-rate"></a>speed($rate)</dt>
<dd>

<p>Sends SNDCTL_DSP_SPEED ioctl message to audio device file, with sample rate as argument. Returns sample rate to which the device was actually set if successful, false on error. You should check the return value even on success to ensure the requested sample rate was in fact set for the device.</p>

<pre><code>    my $rate = 44100; # CD-quality sample rate
    my $rv   = $dsp-&gt;speed($rate) || die $dsp-&gt;errstr;

    die &quot;Failed to set requested sample rate&quot;
        unless ($rate == $rv);</code></pre>

</dd>
<dt id="setduplex()"><a id="setduplex"></a>setduplex()</dt>
<dd>

<p>Sends SNDCTL_DSP_SETDUPLEX ioctl message to audio device file. Returns true on success, false on error.</p>

</dd>
</dl>

<h2 id="Misc">Misc</h2>

<dl>

<dt id="errstr()"><a id="errstr"></a>errstr()</dt>
<dd>

<p>Returns last recorded error.</p>

</dd>
</dl>

<h2 id="Deprecated-methods"><a id="Deprecated"></a>Deprecated methods</h2>

<p>The following methods exist for transitional compatibility with version 0.01 and may not be available in future versions.</p>

<p>The preferred alternative to the set* methods below is either to:</p>

<dl>

<dt id="1.-close-the-device-and-call-init()-with-the-appropriate-parameters-or:"><a id="1"></a><a id="close-the-device-and-call-init--with-the-appropriate-parameters-or"></a>1. close the device and call <a href="#item_init">init()</a> with the appropriate parameters or:</dt>
<dd>

</dd>
<dt id="2.-call-the-appropriate-I/O-control-methods-after-having-closed/re-opened-the-device,-or-after-having-called-reset()"><a id="2"></a><a id="call-the-appropriate-I-O-control-methods-after-having-closed-re-opened-the-device--or-after-having-called-reset"></a>2. call the appropriate I/O control methods after having closed/re-opened the device, or after having called <a href="#item_reset">reset()</a></dt>
<dd>

</dd>
</dl>

<p>The second should only be performed if you know what you are doing. It is important, for example, to set sampling parameters in the following order: <a href="#item_setfmt">setfmt()</a>, <a href="#item_channels">channels()</a>, <a href="#item_speed">speed()</a>. Setting sampling rate (speed) before number of channels does not work with all devices, according to OSS documentation.</p>

<dl>

<dt id="getformat($format)"><a id="getformat"></a><a id="getformat-format"></a>getformat($format)</dt>
<dd>

<p>Returns true if specified <a href="#item_format">sample format</a> is supported by audio device. A false value may indicate the format is not supported, but it may also mean that the SNDCTL_DSP_GETFMTS ioctl failed (the <a href="#item_init">init()</a> method must be called before this method), etc. Be sure to check the last <a href="#item_errstr">error message</a> in this case.</p>

<p><b>Deprecated</b>. If you wish to check if a given format is supported by the device, instead call <a href="#item_getfmts">getfmts()</a> method, then AND the return value with the format for which you wish to check.</p>

<pre><code>    my $format = AFMT_S16_LE;
    my $mask   = $dsp-&gt;getfmts;

    print &quot;Format is supported!\n&quot;
        if ($format &amp; $mask);</code></pre>

</dd>
<dt id="queryformat()"><a id="queryformat"></a>queryformat()</dt>
<dd>

<p>Returns currently used format of initialized audio device. Unlike the <a href="#item_setformat">setformat()</a> method, queryformat &quot;asks&quot; the audio device directly which format is being used.</p>

<p><b>Deprecated</b>. If you wish to find the format to which the device is currently set, instead call <a href="#item_setfmt">setfmt()</a> with AFMT_QUERY as an argument and check the return value.</p>

<pre><code>    my $format = $dsp-&gt;setfmt(AFMT_QUERY);
    print &quot;Device set to format $format.\n&quot;;</code></pre>

</dd>
<dt id="setchannels([$channels])"><a id="setchannels"></a><a id="setchannels-channels"></a>setchannels([$channels])</dt>
<dd>

<p><b>Deprecated</b>. See introduction to this section for alternative methods.</p>

<p>Sets number of channels if argument is provided. If the audio device file is open, the number of channels will not actually be changed until you call <a href="#item_close">close()</a> and <a href="#item_init">init()</a> again.</p>

<p>Returns number of channels currently specified.</p>

</dd>
<dt id="setdevice([$device_name])"><a id="setdevice"></a><a id="setdevice-device_name"></a>setdevice([$device_name])</dt>
<dd>

<p><b>Deprecated</b>. See introduction to this section for alternative methods.</p>

<p>Sets audio device file if argument is provided. If the device is open, it will not actually be changed until you call <a href="#item_close">close()</a> and <a href="#item_init">init()</a> again.</p>

<p>Returns audio device file name currently specified.</p>

</dd>
<dt id="setformat([$bits])"><a id="setformat"></a><a id="setformat-bits"></a>setformat([$bits])</dt>
<dd>

<p><b>Deprecated</b>. See introduction to this section for alternative methods.</p>

<p>Sets sample format if argument is provided. If the audio device file is open, the sample format will not actually be changed until you call <a href="#item_close">close()</a> and <a href="#item_init">init()</a> again.</p>

<p>Returns sample format currently specified.</p>

</dd>
<dt id="setrate([$rate])"><a id="setrate"></a><a id="setrate-rate"></a>setrate([$rate])</dt>
<dd>

<p><b>Deprecated</b>. See introduction to this section for alternative methods.</p>

<p>Sets sample rate if argument is provided. If the audio device file is open, the sample rate will not actually be changed until you call <a href="#item_close">close()</a> and <a href="#item_init">init()</a> again.</p>

<p>Returns sample rate currently specified.</p>

</dd>
</dl>

<h1 id="CONSTANTS">CONSTANTS</h1>

<p>The following audio-format constants are exported by Audio::DSP on use:</p>

<dl>

<dt id="AFMT_MU_LAW">AFMT_MU_LAW</dt>
<dd>

<p>logarithmic mu-Law</p>

</dd>
<dt id="AFMT_A_LAW">AFMT_A_LAW</dt>
<dd>

<p>logarithmic A-Law</p>

</dd>
<dt id="AFMT_IMA_ADPCM">AFMT_IMA_ADPCM</dt>
<dd>

<p>4:1 compressed (IMA)</p>

</dd>
<dt id="AFMT_U8">AFMT_U8</dt>
<dd>

<p>8 bit unsigned</p>

</dd>
<dt id="AFMT_S16_LE">AFMT_S16_LE</dt>
<dd>

<p>16 bit signed little endian (Intel - used in PC soundcards)</p>

</dd>
<dt id="AFMT_S16_BE">AFMT_S16_BE</dt>
<dd>

<p>16 bit signed big endian (PPC, Sparc, etc)</p>

</dd>
<dt id="AFMT_S8">AFMT_S8</dt>
<dd>

<p>8 bit signed</p>

</dd>
<dt id="AFMT_U16_LE">AFMT_U16_LE</dt>
<dd>

<p>16 bit unsigned little endian</p>

</dd>
<dt id="AFMT_U16_BE">AFMT_U16_BE</dt>
<dd>

<p>16 bit unsigned bit endian</p>

</dd>
<dt id="AFMT_MPEG">AFMT_MPEG</dt>
<dd>

<p>MPEG (not currently supported by OSS)</p>

</dd>
</dl>

<h1 id="NOTES">NOTES</h1>

<p>Audio::DSP does not provide any methods for converting the raw audio data stored in memory into other formats (that&#39;s another project altogether). You can, however, use the <a href="#item_data">data()</a> method to dump the raw audio to a file, then use a program like sox to convert it to your favorite format. If you are interested in writing .wav files, you may want to take a look at Nick Peskett&#39;s Audio::Wav module.</p>

<h1 id="AUTHOR">AUTHOR</h1>

<p>Seth David Johnson, seth@pdamusic.com</p>

<h1 id="SEE-ALSO"><a id="SEE"></a>SEE ALSO</h1>

<p>Open Sound System homepage:</p>

<pre><code>    http://www.opensound.com/</code></pre>

<p>Open Sound System - Audio programming:</p>

<pre><code>    http://www.opensound.com/pguide/audio.html</code></pre>

<p>OSS Programmer&#39;s guide (PDF):</p>

<pre><code>    http://www.opensound.com/pguide/oss.pdf</code></pre>

<p>A GPLed version of OSS distributed with the Linux kernel was used in the development of Audio::DSP. See &quot;The Linux Sound Subsystem&quot;:</p>

<pre><code>    http://www.linux.org.uk/OSS/</code></pre>

<p>To my knowledge, the Advanced Linux Sound Architecture (ALSA) API is supposed to remain compatible with the OSS API on which this extension is built. ALSA homepage:</p>

<pre><code>    http://www.alsa-project.org/</code></pre>

<p>perl(1).</p>

<h1 id="COPYRIGHT">COPYRIGHT</h1>

<p>Copyright (c) 1999-2000 Seth David Johnson. All Rights Reserved. This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.</p>
  
        <div id="install-instructions-dialog" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Module Install Instructions</h4>
            </div>
            <div class="modal-body">
                <p>To install Audio::DSP, copy and paste the appropriate command in to your terminal.</p>
                <p><a href="/pod/distribution/App-cpanminus/bin/cpanm">cpanm</a></p>
                <pre>
                    cpanm Audio::DSP
                </pre>
                <p><a href="/pod/CPAN">CPAN shell</a></p>
                <pre>
                    perl -MCPAN -e shell
                    install Audio::DSP
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
