<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8" />
<meta name="author" content="{{ site.meta.author.name }}" />
<meta name="keywords" content="{{ page.tags | join: ',' }}" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>{{ site.name }}{% if page.title %} / {{ page.title }}{% endif %}</title>
<link href="http://{{ site.host }}/feed.xml" rel="alternate" title="{{ site.name }}" type="application/atom+xml" />
<link rel="stylesheet" href="/assets/css/font-awesome.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/site.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/code/github.css" />

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>


{% for style in page.styles %}<link rel="stylesheet" type="text/css" href="{{ style }}" />
{% endfor %}
</head>

<body class="{{ layout.class }}">

<div class="main">
	{{ content }}
</div>

<aside>
	<h2><a href="/">{{ site.name }}</a></h2>
	
	<nav class="block">
		<ul>
		<h3><a href="/pages/archive.html">ARCHIVE</a></h3>
		<h3><a href="/pages/about.html">ABOUT ME</a></h3>
		<h3><a href="/pages/recycle.html">RECYCLE BIN</a></h3>
		<h3><a href="/pages/diary.html">DIARY AHA</a></h3>
		<h3><a href="/pages/papers.html">PAPERS</a></h3>
		</ul>
	</nav>
	
	<form action="/search/" class="block block-search">
		<h3>Search</h3>
		<p><input type="search" name="q" placeholder="Search" /></p>
	</form>
	
	<div class="block block-about">
		<figure>
			<!-- {% if site.meta.author.gravatar %}<img src="{{ site.meta.gravatar}}{{ site.meta.author.gravatar }}?s=48" />{% endif %} -->
			<img src="\avatar.jpg" height="48" width="48" />
			<figcaption><strong>{{ site.meta.author.name }}</strong></figcaption>
		</figure>
		<p>Always think positively,always improve your potential.</p>
	</div>
	
	<div class="block block-license">
		<h3>Copyright</h3>
		<p><a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/2.5/cn/" target="_blank" class="hide-target-icon" title="Copyright declaration of site content"><img alt="知识共享许可协议" src="http://i.creativecommons.org/l/by-nc-nd/2.5/cn/88x31.png" /></a></p>
	</div>	
	<div class="block block-license">
		<h3>Web traffic</h3>
	<a href="http://info.flagcounter.com/za4T"><img src="http://s07.flagcounter.com/count2/za4T/bg_FFFFFF/txt_000000/border_CCCCCC/columns_5/maxflags_15/viewers_0/labels_0/pageviews_0/flags_0/percent_0/" alt="Flag Counter" border="0"></a>
	</div>

	
	<div class="block block-thank">
		<h3>Powered by</h3>
		<p>
			<a href="https://github.com/" target="_blank">GitHub</a>,
			<a href="http://www.google.com/cse/" target="_blank">GSE</a>,
			<a href="http://en.gravatar.com/" target="_blank">Gravatar</a>,
			<a href="https://github.com/mojombo/jekyll" target="_blank">jekyll</a>
		</p>
	</div>
</aside>

<script src="/assets/js/elf-0.5.0.min.js"></script>
<script src="/assets/js/highlight.min.js"></script>
<script src="/assets/js/site.js"></script>
{% for script in page.scripts %}<script src="{{ script }}"></script>
{% endfor %}
<script>
site.URL_GOOGLE_API = '{{site.meta.gapi}}';
site.VAR_SITE_NAME = "{{ site.name | replace:'"','\"' }}";
site.VAR_GOOGLE_CUSTOM_SEARCH_ID = '{{ site.meta.author.gcse }}';
site.TPL_SEARCH_TITLE = '#{0} / 搜索：#{1}';
site.VAR_AUTO_LOAD_ON_SCROLL = {{ site.custom.scrollingLoadCount }};
</script>
                                    

</body>
</html>