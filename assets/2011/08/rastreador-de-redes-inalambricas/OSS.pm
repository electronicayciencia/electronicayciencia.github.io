<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5">
        <title>Audio::OSS - pure-perl interface to OSS (open sound system) audio devices - metacpan.org</title>
        <link rel="alternate" type="application/rss+xml" title="Recent CPAN Uploads of Audio-OSS - MetaCPAN" href="/feed/distribution/Audio-OSS" />
        <link href="/_assets/09a20e39bc03ec6c8fbc017562af3184c4c5b48e.css" rel="stylesheet" type="text/css">
        <link rel="search" href="/static/opensearch.xml" type="application/opensearchdescription+xml" title="MetaCPAN">
        <link rel="canonical" href="https://metacpan.org/pod/Audio::OSS" />
        <meta name="description" content="pure-perl interface to OSS (open sound system) audio devices" />
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
<meta name="twitter:url"         content="https://metacpan.org/pod/release/DJHD/Audio-OSS-0.0501/OSS.pm" />
<meta name="twitter:title"       content="Audio::OSS" />
<meta name="twitter:description" content="pure-perl interface to OSS (open sound system) audio devices" />
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
    <a itemprop="url"  data-keyboard-shortcut="g a" rel="author" href="/author/DJHD" title="" class="author-name"><span itemprop="name" >David Huggins-Daines</span></a>
  </span>
  <span>&nbsp;/&nbsp;</span>
  <div class="release status-latest maturity-released">
    <span class="dropdown"><b class="caret"></b></span>
    <select class="" onchange="document.location.href=this.value">

  <option selected value="/module/DJHD/Audio-OSS-0.0501/OSS.pm">
    0.0501
      (DJHD on 2001-04-16)
      
  </option>

  <option  value="/module/DJHD/Audio-OSS-0.05/OSS.pm">
    0.05
      (DJHD on 2001-04-05)
      
  </option>
</select>
    
    <a data-keyboard-shortcut="g d" class="release-name" href="/release/DJHD/Audio-OSS-0.0501">Audio-OSS-0.0501</a>
    
    
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
<div id="Audio-OSS-fav" class="logged_in">
<form action="/account/favorite/add" style="display: inline" onsubmit="return favDistribution(this)">
    <input type="hidden" name="remove" value="0">
    <input type="hidden" name="release" value="Audio-OSS-0.0501">
    <input type="hidden" name="author" value="DJHD">
    <input type="hidden" name="distribution" value="Audio-OSS">
    <button type="submit" class="favorite"><span></span> ++</button>
</form>
</div>
<div class="logged_out">
<a href="" onclick="alert('Please sign in to add favorites'); return false" class="favorite">
<span></span> ++</a>
</div>

  &nbsp;/&nbsp;<span itemprop="name" >Audio::OSS</span>
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
    <li class="nav-header">      <time class="relatize" itemprop="dateModified" datetime="2001-04-16">16 Apr 2001 18:15:13 UTC</time>
    </li>
    
    <li>
      Distribution: Audio-OSS</span>
    </li>
    
    <li>
      Module version: <span itemprop="softwareVersion">0.0501</span>
    </li>
    
        <li>
      <a data-keyboard-shortcut="g s" href="/source/DJHD/Audio-OSS-0.0501/OSS.pm"><i class="fa fa-fw fa-file-code-o black"></i>Source</a>
      (<a href="/source/DJHD/Audio-OSS-0.0501/OSS.pm?raw=1">raw</a>)
    </li>
    
    <li>
      <a data-keyboard-shortcut="g b" href="/source/DJHD/Audio-OSS-0.0501/"><i class="fa fa-fw fa-folder-open black"></i>Browse</a>
      (<a href="/source/DJHD/Audio-OSS-0.0501/?raw=1">raw</a>)
    </li>
    <li>
    <a data-keyboard-shortcut="g c" href="/changes/release/DJHD/Audio-OSS-0.0501"><i class="fa fa-fw fa-cogs black"></i>Changes</a>
</li>

<li>
    <a class="nopopup" href="/contributing-to/DJHD/Audio-OSS-0.0501"><i class="fa fa-fw fa-plus-circle black"></i>How to Contribute</a>
</li>

<li>
    <a rel="noopener nofollow" data-keyboard-shortcut="g i" href="https://rt.cpan.org/Public/Dist/Display.html?Name=Audio-OSS"><i class="fa fa-fw fa-info-circle black"></i>Issues</a>
    (1)
</li>
<li>
    
    <a rel="noopener nofollow" href="http://matrix.cpantesters.org/?dist=Audio-OSS+0.0501" title="Matrix"><i class="fa fa-fw fa-check-circle black"></i>Testers</a>
    <span title="(pass / fail / na)">(<a rel="noopener nofollow" href="https://www.cpantesters.org/distro/A/Audio-OSS.html?oncpan=1&amp;distmat=1&amp;version=0.0501&amp;grade=2" style="color: #090">382</a> / <a rel="noopener nofollow" href="https://www.cpantesters.org/distro/A/Audio-OSS.html?oncpan=1&amp;distmat=1&amp;version=0.0501&amp;grade=3" style="color: #900">25</a> / <a rel="noopener nofollow" href="https://www.cpantesters.org/distro/A/Audio-OSS.html?oncpan=1&amp;distmat=1&amp;version=0.0501&amp;grade=4">0</a>)</span>
</li>
<li>
    <a rel="noopener nofollow" href="http://cpants.cpanauthors.org/release/DJHD/Audio-OSS-0.0501"><i class="fa fa-fw fa-line-chart black"></i>Kwalitee</a>
</li>

  <li>
    <i class="fa fa-fw fa-pie-chart black"></i><a rel="noopener nofollow" href="http://cpancover.com/latest/Audio-OSS-0.0501/index.html">37.13% Coverage </a>
  </li>



<li><i class="fa fa-fw fa-gavel black"></i>License: unknown</li>





    <li class="nav-header">Activity</li>
    <li><div class="activity-graph">
  <img src="/activity?res=month&amp;distribution=Audio-OSS" width="170" height="22" />
  <div align="right"><small class="comment">24 month</small></div>
</div>
</li>
    <li class="nav-header">Tools</li>
<li>
    <a itemprop="downloadUrl" href="https://cpan.metacpan.org/authors/id/D/DJ/DJHD/Audio-OSS-0.0501.tar.gz">
    <i class="fa fa-download fa-fw black"></i>Download (<span itemprop="fileSize" >8.62Kb</span>)</a>
    
    <span class="invisible" itemprop="offers" itemscope itemtype="http://schema.org/Offer">
      <span itemprop="price">0</span>
    </span>
    
</li>
<li>
    <a href="https://explorer.metacpan.org/?url=/module/DJHD/Audio-OSS-0.0501/OSS.pm">
    <i class="fa fa-list-alt fa-fw black"></i>MetaCPAN Explorer
    </a>
</li>
<li>
  <a href="/permission/distribution/Audio-OSS">
    <i class="fa fa-key fa-fw black"></i>Permissions
  </a>
</li>
<li>
    <a href="/feed/distribution/Audio-OSS">
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
        <input type="hidden" name="q" value="dist:Audio-OSS">
        <input type="search" name="q" placeholder="Search distribution" style="width: 153px" class="form-control tool-bar-form">
        <input type="submit" style="display: none">
    </form>
</li>
<li>
    <form action="https://grep.metacpan.org/search">
        <input type="hidden" name="qd" value="Audio-OSS">
        <input type="hidden" name="source" value="metacpan">
         <input type="search" name="q" placeholder="grep distribution" style="width: 153px" class="form-control tool-bar-form">
         <input type="submit" style="display: none">
     </form>
</li>
<li>
    <select onchange="document.location.href='/module/'+this.value" class="form-control tool-bar-form">
        <option>Jump to version</option>
    <option value="DJHD/Audio-OSS-0.05/OSS.pm">0.05 (DJHD on 2001-04-05)</option>

    </select>
</li>
<li>
    <select name="release" onchange="document.location.href='/diff/file/?target=DJHD/Audio-OSS-0.0501/OSS.pm&amp;source=' + encodeURIComponent(this.value)" class="form-control tool-bar-form">
        <option>Diff with version</option>
    <option value="DJHD/Audio-OSS-0.05/OSS.pm">0.05 (DJHD on 2001-04-05)</option>

    </select>
</li>

<li class="nav-header">Permalinks</li>
<li>
    <a href="/pod/release/DJHD/Audio-OSS-0.0501/OSS.pm">This version</a>
</li>
<li>
    <a itemprop="url" href="/pod/Audio::OSS">Latest version</a>
</li>

  </ul>

  <button id="right-panel-toggle" class="btn-link" onclick="togglePanel('right'); return false;"><span class="panel-hidden">Show</span><span class="panel-visible">Hide</span> Right Panel</button>
  <div id="right-panel" class="pull-right">
  <div class="box-right">
  <!-- For plussers -->


<div class="author-pic">
<a href="/author/DJHD">
  <img src="https://www.gravatar.com/avatar/f0ad6fade377f84ea776f7c4c0fbf88b?s=130&amp;d=identicon" alt="Author image">
</a>
<strong>
  <a rel="author" href="/author/DJHD">DJHD</a>
</strong>
<span title="">David Huggins-Daines</span>
</div>

  

  </div>
  <ul class="nav-list box-right hidden-phone dependencies">
    <li class="nav-header">Dependencies</li>
    <li><i class="ttip" title="dynamic_config enabled">unknown</i></li>
    <li><hr /></li>
    <li>
        <a href="http://deps.cpantesters.org/?module=Audio::OSS">
        <i class="fa fa-retweet fa-fw black"></i>CPAN Testers List</a>
    </li>
    <li>        <a href="/requires/module/Audio::OSS">        <i class="fa fa-share fa-fw black"></i>Reverse dependencies</a>
    </li>
    <li>
        <a href="https://cpandeps.grinnz.com/?dist=Audio-OSS&dist_version=0.0501">
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
  <li><a href="#EXPORTS">EXPORTS</a></li>
  <li><a href="#BUGS">BUGS</a></li>
  <li><a href="#AUTHOR">AUTHOR</a></li>
  <li><a href="#SEE-ALSO">SEE ALSO</a></li>
</ul>

<h1 id="NAME">NAME</h1>

<p>Audio::OSS - pure-perl interface to OSS (open sound system) audio devices</p>

<h1 id="SYNOPSIS">SYNOPSIS</h1>

<pre><code>  use Audio::OSS qw(:funcs :formats :mixer);

  my $dsp = IO::Handle-&gt;new(&quot;&lt;/dev/dsp&quot;) or die &quot;open failed: $!&quot;;
  dsp_reset($dsp) or die &quot;reset failed: $!&quot;;

  my $mask = get_supported_formats($dsp);
  if ($mask &amp; AFMT_S16_LE) {
    set_fmt($dsp, AFMT_S16_LE) or die set format failed: $!&quot;;
  }
  my $current_format = set_fmt($dsp, AFMT_QUERY);

  my $sps_actual = set_sps($dsp, 16000);

  set_fragment($dsp, $fragshift, $nfrags);
  my ($frags_avail, $frags_total, $fragsize, $bytes_avail)
      = get_outbuf_info($dsp);
  my ($bytes, $blocks, $dma_ptr) = get_outbuf_ptr($dsp);

  my $mixer = IO::Handle-&gt;new(&quot;&lt;/dev/mixer&quot;) or die &quot;open failed: $!&quot;;
  my $miclevel = mixer_read($mixer, SOUND_MIXER_MIC);</code></pre>

<h1 id="DESCRIPTION">DESCRIPTION</h1>

<p><code>Audio::OSS</code> is a pure Perl interface to the Open Sound System, as used on Linux, FreeBSD, and other Unix systems.</p>

<p>It provides a procedural interface based around filehandles opened on the audio device (usually <i>/dev/dsp*</i> for PCM audio).</p>

<p>It also defines constants for various <code>ioctl</code> calls and other things based on the OSS system header files, so you don&#39;t have to rely on <code>.ph</code> files that may or may be correct or even present on your system.</p>

<p>Currently, only the PCM audio input and output functions are supported. Mixer support is likely in the future, sequencer support less likely.</p>

<h1 id="EXPORTS">EXPORTS</h1>

<p>The main exports of <code>Audio::OSS</code> are rubber, tea, and tractor parts.</p>

<p>Seriously, though, nothing is exported by default. However, there are three export tags which cover the vast majority of things you might conceivably want, and which exist on most systems. These are:</p>

<dl>

<dt id=":funcs"><a id="funcs"></a><code>:funcs</code></dt>
<dd>

<p>This tag imports the following functions, which perform various operations on the PCM audio device:</p>

<pre><code>  dsp_sync
  dsp_reset
  dsp_get_caps
  set_sps
  set_fmt
  set_stereo
  get_supported_fmts
  set_fragment
  get_outbuf_ptr
  get_inbuf_ptr
  get_outbuf_info
  get_inbuf_info
  mixer_read_devmask
  mixer_read_recmask
  mixer_read_stereodevs
  mixer_read_caps
  mixer_read
  mixer_write</code></pre>

<p>Some functions are exported only if the underlying support for them exists on your operating system, namely:</p>

<pre><code>  get_mixer_info</code></pre>

</dd>
<dt id=":formats"><a id="formats"></a><code>:formats</code></dt>
<dd>

<p>This tag imports the following constants, which correspond to arguments to the <code>set_fmt</code> and bits in the return value from <code>get_supported_fmts</code>:</p>

<pre><code>  AFMT_QUERY
  AFMT_S16_NE
  AFMT_S16_LE
  AFMT_S16_BE
  AFMT_U16_LE
  AFMT_U16_BE
  AFMT_U8
  AFMT_MU_LAW
  AFMT_A_LAW</code></pre>

</dd>
<dt id=":caps"><a id="caps"></a><code>:caps</code></dt>
<dd>

<p>This tag imports the following constants, which correspond to bits in the return value from <code>dsp_get_caps</code>:</p>

<pre><code>  DSP_CAP_REVISION
  DSP_CAP_DUPLEX
  DSP_CAP_REALTIME
  DSP_CAP_BATCH
  DSP_CAP_COPROC
  DSP_CAP_TRIGGER
  DSP_CAP_MMAP
  DSP_CAP_MULTI
  DSP_CAP_BIND</code></pre>

</dd>
<dt id=":mixer"><a id="mixer"></a><code>:mixer</code></dt>
<dd>

<p>This tag imports the following constants, which are used in mixer operations:</p>

<pre><code>  SOUND_MIXER_NRDEVICES
  SOUND_MIXER_VOLUME
  SOUND_MIXER_BASS
  SOUND_MIXER_TREBLE
  SOUND_MIXER_SYNTH
  SOUND_MIXER_PCM
  SOUND_MIXER_SPEAKER
  SOUND_MIXER_LINE
  SOUND_MIXER_MIC
  SOUND_MIXER_CD
  SOUND_MIXER_IMIX
  SOUND_MIXER_ALTPCM
  SOUND_MIXER_RECLEV
  SOUND_MIXER_IGAIN
  SOUND_MIXER_OGAIN
  SOUND_MIXER_LINE1
  SOUND_MIXER_LINE2
  SOUND_MIXER_LINE3
  SOUND_MIXER_DIGITAL1
  SOUND_MIXER_DIGITAL2
  SOUND_MIXER_DIGITAL3
  SOUND_MIXER_PHONEIN
  SOUND_MIXER_PHONEOUT
  SOUND_MIXER_VIDEO
  SOUND_MIXER_RADIO
  SOUND_MIXER_MONITOR
  SOUND_MIXER_NONE
  SOUND_ONOFF_MIN
  SOUND_ONOFF_MAX

  SOUND_MIXER_RECSRC
  SOUND_MIXER_DEVMASK
  SOUND_MIXER_RECMASK
  SOUND_MIXER_CAPS
  SOUND_CAP_EXCL_INPUT
  SOUND_MIXER_STEREODEVS
  SOUND_MIXER_OUTSRC
  SOUND_MIXER_OUTMASK</code></pre>

</dd>
</dl>

<p>The full list of constants and functions which can be imported from this module follows. Note that not all of these may be available on your system. When you build this module, the <code>Makefile.PL</code> will try to find them all, leaving out any that fail. To some extent, these are documented in the system header files, specifically <i>&lt;sys/soundcard.h&gt;</i> or <i>&lt;linux/soundcard.h&gt;</i>.</p>

<pre><code>  SNDCTL_DSP_RESET
  SNDCTL_DSP_SYNC
  SNDCTL_DSP_SPEED
  SNDCTL_DSP_STEREO
  SNDCTL_DSP_GETBLKSIZE
  SNDCTL_DSP_SAMPLESIZE
  SNDCTL_DSP_CHANNELS
  SNDCTL_DSP_POST
  SNDCTL_DSP_SUBDIVIDE
  SNDCTL_DSP_SETFRAGMENT
  SNDCTL_DSP_GETOSPACE
  SNDCTL_DSP_GETISPACE
  SNDCTL_DSP_NONBLOCK
  SNDCTL_DSP_GETCAPS
  SNDCTL_DSP_GETFMTS
  SNDCTL_DSP_SETFMT
  SNDCTL_DSP_GETTRIGGER
  SNDCTL_DSP_SETTRIGGER
  SNDCTL_DSP_GETIPTR
  SNDCTL_DSP_GETOPTR
  SNDCTL_DSP_MAPINBUF
  SNDCTL_DSP_MAPOUTBUF
  SNDCTL_DSP_SETSYNCRO
  SNDCTL_DSP_SETDUPLEX
  SNDCTL_DSP_GETODELAY

  SNDCTL_DSP_GETCHANNELMASK
  SNDCTL_DSP_BIND_CHANNEL
  SNDCTL_DSP_PROFILE

  SOUND_PCM_READ_RATE
  SOUND_PCM_READ_CHANNELS
  SOUND_PCM_READ_BITS
  SOUND_PCM_READ_FILTER

  SOUND_MIXER_READ_VOLUME
  SOUND_MIXER_READ_BASS
  SOUND_MIXER_READ_TREBLE
  SOUND_MIXER_READ_SYNTH
  SOUND_MIXER_READ_PCM
  SOUND_MIXER_READ_SPEAKER
  SOUND_MIXER_READ_LINE
  SOUND_MIXER_READ_MIC
  SOUND_MIXER_READ_CD
  SOUND_MIXER_READ_IMIX
  SOUND_MIXER_READ_ALTPCM
  SOUND_MIXER_READ_RECLEV
  SOUND_MIXER_READ_IGAIN
  SOUND_MIXER_READ_OGAIN
  SOUND_MIXER_READ_LINE1
  SOUND_MIXER_READ_LINE2
  SOUND_MIXER_READ_LINE3
  SOUND_MIXER_READ_RECSRC
  SOUND_MIXER_READ_DEVMASK
  SOUND_MIXER_READ_RECMASK
  SOUND_MIXER_READ_STEREODEVS
  SOUND_MIXER_READ_CAPS

  SOUND_MIXER_WRITE_VOLUME
  SOUND_MIXER_WRITE_BASS
  SOUND_MIXER_WRITE_TREBLE
  SOUND_MIXER_WRITE_SYNTH
  SOUND_MIXER_WRITE_PCM
  SOUND_MIXER_WRITE_SPEAKER
  SOUND_MIXER_WRITE_LINE
  SOUND_MIXER_WRITE_MIC
  SOUND_MIXER_WRITE_CD
  SOUND_MIXER_WRITE_IMIX
  SOUND_MIXER_WRITE_ALTPCM
  SOUND_MIXER_WRITE_RECLEV
  SOUND_MIXER_WRITE_IGAIN
  SOUND_MIXER_WRITE_OGAIN
  SOUND_MIXER_WRITE_LINE1
  SOUND_MIXER_WRITE_LINE2
  SOUND_MIXER_WRITE_LINE3
  SOUND_MIXER_WRITE_RECSRC
  SOUND_MIXER_WRITE_DEVMASK
  SOUND_MIXER_WRITE_RECMASK

  SOUND_MIXER_INFO
  SOUND_MIXER_AGC
  SOUND_MIXER_3DSE
  SOUND_MIXER_PRIVATE1
  SOUND_MIXER_PRIVATE2
  SOUND_MIXER_PRIVATE3
  SOUND_MIXER_PRIVATE4
  SOUND_MIXER_PRIVATE5
  SOUND_MIXER_GETLEVELS
  SOUND_MIXER_SETLEVELS

  OSS_GETVERSION

  AFMT_QUERY
  AFMT_MU_LAW
  AFMT_A_LAW
  AFMT_IMA_ADPCM
  AFMT_U8
  AFMT_S16_LE
  AFMT_S16_BE
  AFMT_S16_NE
  AFMT_S8
  AFMT_U16_LE
  AFMT_U16_BE
  AFMT_MPEG
  AFMT_AC3

  DSP_CAP_REVISION
  DSP_CAP_DUPLEX
  DSP_CAP_REALTIME
  DSP_CAP_BATCH
  DSP_CAP_COPROC
  DSP_CAP_TRIGGER
  DSP_CAP_MMAP
  DSP_CAP_MULTI
  DSP_CAP_BIND

  PCM_ENABLE_INPUT
  PCM_ENABLE_OUTPUT

  DSP_BIND_QUERY
  DSP_BIND_FRONT
  DSP_BIND_SURR
  DSP_BIND_CENTER_LFE
  DSP_BIND_HANDSET
  DSP_BIND_MIC
  DSP_BIND_MODEM1
  DSP_BIND_MODEM2
  DSP_BIND_I2S
  DSP_BIND_SPDIF

  APF_NORMAL
  APF_NETWORK
  APF_CPUINTENS</code></pre>

<h1 id="BUGS">BUGS</h1>

<p>The <code>Makefile.PL</code> is pretty slow, and could be optimized to check more than one constant at once, or all of them at once, even.</p>

<p>There is no object oriented interface (this is a feature, in my opinion).</p>

<p>The documentation is lacking, but then, that&#39;s also true for OSS itself.</p>

<h1 id="AUTHOR">AUTHOR</h1>

<p>David Huggins-Daines &lt;dhd@cepstral.com&gt;</p>

<h1 id="SEE-ALSO"><a id="SEE"></a>SEE ALSO</h1>

<p>perl(1), <i>/usr/include/sys/soundcard.h</i></p>
  
        <div id="install-instructions-dialog" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Module Install Instructions</h4>
            </div>
            <div class="modal-body">
                <p>To install Audio::OSS, copy and paste the appropriate command in to your terminal.</p>
                <p><a href="/pod/distribution/App-cpanminus/bin/cpanm">cpanm</a></p>
                <pre>
                    cpanm Audio::OSS
                </pre>
                <p><a href="/pod/CPAN">CPAN shell</a></p>
                <pre>
                    perl -MCPAN -e shell
                    install Audio::OSS
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
