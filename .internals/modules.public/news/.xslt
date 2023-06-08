<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/public.xslt"/>

<xsl:template match="/" mode="overrideable_title">
<xsl:choose>
<xsl:when test="/*/news">
	<xsl:value-of select="/*/news/title" disable-output-escaping="yes"/> — Новости рыболовного клуба "Ба!Рыбина!"
</xsl:when>
<xsl:otherwise>
	
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:variable name="datanum">
<xsl:call-template name="datetime_natural_ru">
				<xsl:with-param name="raw"   select="/*/news/ts"/>
				<xsl:with-param name="year"  select="/*/news/ts_parsed/year"/>
				<xsl:with-param name="month" select="/*/news/ts_parsed/month"/>
				<xsl:with-param name="day"   select="/*/news/ts_parsed/day"/>
			</xsl:call-template>
</xsl:variable>
<xsl:template match="/" mode="overrideable_keywords">
<xsl:choose>
<xsl:when test="/*/news">
<xsl:value-of select="/*/news/title"/>&nbsp;<xsl:value-of select="$datanum"/>
</xsl:when>
<xsl:otherwise>
	
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
<xsl:choose>
<xsl:when test="/*/news">
В Рыболовном Клубе Ба!Рыбина!: <xsl:value-of select="$datanum"/> — <xsl:value-of select="/*/news/title"/>
</xsl:when>
<xsl:otherwise>
	
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="/" mode="global_top_menu">news</xsl:template> 
<xsl:variable name="right_menu">news</xsl:variable> 

<xsl:template match="/" mode="overrideable_measurer">
<xsl:choose>
<xsl:when test="/*/news">
	<a href="{$LANGROOT}news/">Новости</a>
	<xsl:call-template name="measurer_divider"/>
	<a class="act"><xsl:value-of select="/*/news/title" disable-output-escaping="yes"/></a>
</xsl:when>
<xsl:otherwise>
	<a class="act">Новости</a>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="/" mode="overrideable_headers">
	<link rel="alternate" type="application/rss+xml" href="{/*/system/info/pub_root}news/rss" title="RSS"/>

	<xsl:if test="/*/news">
		<link href="{/*/system/info/pub_root}css/gallery.css" type="text/css" rel="stylesheet"/>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/gallery.js"></script>
	</xsl:if>

</xsl:template>

<xsl:template match="/" mode="overrideable_head">
<xsl:choose>
<xsl:when test="/*/news">
	<xsl:value-of select="/*/news/title" disable-output-escaping="yes"/>
</xsl:when>
<xsl:otherwise>
	Новости
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="/" mode="overrideable_content">
	<xsl:choose>
	<xsl:when test="/*/news">
		<xsl:for-each select="/*/news[title!='']">
		<div class="g-left-indent">
		<p class="m-10px-mrg m-bold-font">
		<strong>
			<xsl:call-template name="datetime_natural_ru">
				<xsl:with-param name="raw"   select="ts"/>
				<xsl:with-param name="year"  select="ts_parsed/year"/>
				<xsl:with-param name="month" select="ts_parsed/month"/>
				<xsl:with-param name="day"   select="ts_parsed/day"/>
			</xsl:call-template> г.
		</strong>
	    </p>
			<xsl:apply-templates select="linked_paras"/>			
		</div>

		
   <xsl:if test="linked_gallery/*">
    <div class="gallery_block"> 
      <ul>
	<xsl:for-each select="linked_gallery/linked_pict">
        <li class="flickr_badge_image" id="flickr_badge_image{position()}">
		<xsl:apply-templates select="." mode="linked_pict">
			<xsl:with-param name="def" select="/*/news/title"/>
			<xsl:with-param name="class" select="'pic'"/>
			<xsl:with-param name="href" select="'#'" />
		</xsl:apply-templates>
        </li>
	</xsl:for-each>
      </ul>
	<!-- preload the images -->
	<div style='display:none'>
		<img src='{/*/system/info/pub_root}images/gallery/loading.gif' alt='' />
	</div>
    </div>
   </xsl:if>

   <xsl:if test="gallery/*">
    <div class="gallery_block"> 
      <xsl:for-each select="gallery/gallery">
      <h2><xsl:value-of select="name" disable-output-escaping="yes"/></h2>
      <ul>
	<xsl:for-each select="linked_picts/linked_pict">
        <li class="flickr_badge_image" id="flickr_badge_image{position()}">
		<xsl:apply-templates select="." mode="linked_pict">
			<xsl:with-param name="def" select="/*/news/title"/>
			<xsl:with-param name="class" select="'pic'"/>
			<xsl:with-param name="href" select="'#'" />
		</xsl:apply-templates>
        </li>
	</xsl:for-each>
      </ul>
      </xsl:for-each>
	<!-- preload the images -->
	<div style='display:none'>
		<img src='{/*/system/info/pub_root}images/gallery/loading.gif' alt='' />
	</div>
    </div>
   </xsl:if>

		</xsl:for-each>

	</xsl:when>
	<xsl:otherwise>

<!--
<a name="subscribe"></a>
<div class="b-subscribe-page">
<form action="{/*/system/info/pub_root}subscribe" method="get">
	E-mail <input type="text" name="email" class="b-alone-input" /><button type="submit" class="submit-button"><div class="b-rounded-button m-no-top-mrg"><i class="l"></i>Подписаться<i class="r"></i></div></button>
</form>
</div>
-->

<div class="clearfix">
	<xsl:apply-templates select="/*/pager">
		<xsl:with-param name="url" select="concat($LANGROOT, 'news/')" />
	</xsl:apply-templates>
</div>
    <div class="clear"></div>
    <br/>

<xsl:for-each select="/*/list/news[title!='']">
	<xsl:choose>
	<xsl:when test="linked_paras/* or linked_gallery/*">
		<a href="{$LANGROOT}news/{id}/" class="name"><h2><xsl:value-of select="title" disable-output-escaping="yes"/></h2></a>
	</xsl:when>
	<xsl:otherwise>
		<span class="name"><h2><xsl:value-of select="title" disable-output-escaping="yes"/></h2></span>
	</xsl:otherwise>
	</xsl:choose>
        <span class="date">
		<xsl:call-template name="datetime_numeric_ru">
			<xsl:with-param name="raw"   select="ts"/>
			<xsl:with-param name="year"  select="ts_parsed/year"/>
			<xsl:with-param name="month" select="ts_parsed/month"/>
			<xsl:with-param name="day"   select="ts_parsed/day"/>
		</xsl:call-template>
        </span> 
	<xsl:apply-templates select="linked_picts/linked_pict" mode="linked_pict">
		<xsl:with-param name="def" select="title"/>
		<xsl:with-param name="aclass" select="'link_photo'"/>
		<xsl:with-param name="href">
			<xsl:if test="linked_paras/* or linked_gallery/*">
				<xsl:value-of select="concat($LANGROOT, 'news/', id, '/')" />
			</xsl:if>
		</xsl:with-param>
	</xsl:apply-templates>
        <div class="text">
		<xsl:value-of select="short" disable-output-escaping="yes"/>
        </div>
    <div class="clear"></div>
    <br/>
</xsl:for-each>

	<xsl:apply-templates select="/*/pager">
		<xsl:with-param name="url" select="concat($LANGROOT, 'news/')" />
	</xsl:apply-templates>

	</xsl:otherwise>
	</xsl:choose>

</xsl:template>



</xsl:stylesheet>
