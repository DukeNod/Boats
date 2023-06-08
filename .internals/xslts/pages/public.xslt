<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/public.xslt"/>

<xsl:template priority="-1" match="/" mode="overrideable_icon"></xsl:template>

<xsl:template priority="-1" match="/" mode="overrideable_title">
	<xsl:choose>
<xsl:when test="/*/page_content/parents/parent/mr='interesting'">
	Это интересно: <xsl:value-of select="/*/page_content/name" disable-output-escaping="yes"/>
</xsl:when>
<xsl:otherwise>
	<xsl:value-of select="$inline_title" disable-output-escaping="yes"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template priority="-1" match="/" mode="overrideable_keywords">
<xsl:choose>
<xsl:when test="/*/page_content/parents/parent/mr='interesting'">
	<xsl:value-of select="/*/page_content/name" disable-output-escaping="yes"/> 
	<xsl:for-each select="/*/page_content/linked_paras/linked_para">
		<xsl:text> </xsl:text><xsl:value-of select="name" disable-output-escaping="yes"/>
	</xsl:for-each>
</xsl:when>
<xsl:otherwise>
	<xsl:value-of select="$inline_title" disable-output-escaping="yes"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template priority="-1" match="/" mode="overrideable_description">
<xsl:choose>
<xsl:when test="/*/page_content/parents/parent/mr='interesting'">
	На сайте Рыболовного Клуба "Ба!Рыбина!" вы найдёте всё о <xsl:value-of select="/*/page_content/name" disable-output-escaping="yes"/>
	<xsl:if test="/*/page_content/linked_paras/linked_para/name!=''">
	, а также информацию о 
	<xsl:for-each select="/*/page_content/linked_paras/linked_para">
		<xsl:if test="name!=''">
		<xsl:text> </xsl:text><xsl:value-of select="name" disable-output-escaping="yes"/>
		<xsl:if test="position()!=last()">
		<xsl:text>,</xsl:text>
		</xsl:if>
		</xsl:if>
	</xsl:for-each>
	</xsl:if>
</xsl:when>
<xsl:otherwise>
	<xsl:value-of select="$inline_title" disable-output-escaping="yes"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="/" mode="overrideable_headers">
		<link href="{/*/system/info/pub_root}css/gallery.css" type="text/css" rel="stylesheet"/>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/gallery.js"></script>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/mootools-core.js"></script>
</xsl:template>


<xsl:template priority="-1" match="/" mode="overrideable_measurer">

	<xsl:for-each select="/*/page_path/parent[position()!=last()]">
		<xsl:variable name="cur_mr"><xsl:apply-templates select="preceding-sibling::* | ." mode="make_mr"/></xsl:variable>
		<a href="{$LANGROOT}{$cur_mr}"><xsl:value-of select="name" disable-output-escaping="yes"/></a>
		<xsl:call-template name="measurer_divider"/>
	</xsl:for-each>
	<a class="act"><xsl:value-of select="$inline_title" disable-output-escaping="yes"/></a>
		
</xsl:template>

<xsl:template match="/" mode="overrideable_content">

<xsl:if test="(/*/page_content/mr = 'about') or (/*/page_content/mr = 'holiday-cottage') or (/*/page_content/mr = 'summer-and-winter-warm-gazebo') or (/*/page_content/mr = 'bath')">
	
    <ul class="ul_3d">
    <li>
	<xsl:choose>
		<xsl:when test="/*/page_content/mr = 'about'">
			<h2>3D-тур по водоёмам клуба "Ба!Рыбина!"</h2>
			<a href="#" id="first" class="link_video{position()} link_3d">
			<img src="{/*/system/info/pub_root}3d/covers/about.png" width="600" height="300" alt="3D-тур по водоёмам клуба Ба!Рыбина!" title="3D-тур по водоёмам клуба Ба!Рыбина!"/>
        	</a>
		</xsl:when>
		<xsl:when test="/*/page_content/mr = 'holiday-cottage'">
			<h2>3D-тур в одном из домиков на берегу водоёма</h2>
			<a href="#" id="first" class="link_video{position()} link_3d">
			<img src="{/*/system/info/pub_root}3d/covers/domik.png" width="600" height="300" alt="3D-тур в одном из домиков на берегу водоёма" title="3D-тур в одном из домиков на берегу водоёма"/>
        	</a>
			
			<h2>3D-тур по территории комплекса домиков в аренду</h2>
			<a href="#" id="other" class="link_video{position()} link_3d">
			<img src="{/*/system/info/pub_root}3d/covers/domiki.png" width="600" height="300" alt="3D-тур по территории комплекса домиков в аренду" title="3D-тур по территории комплекса домиков в аренду"/>
        	</a>
		</xsl:when>
		<xsl:when test="/*/page_content/mr = 'summer-and-winter-warm-gazebo'">
			<h2>3D-тур по утепленной беседке на берегу водоёма</h2>
			<a href="#" id="first" class="link_video{position()} link_3d">
			<img src="{/*/system/info/pub_root}3d/covers/besedka.png" width="600" height="300" alt="3D-тур по утепленной беседке на берегу водоёма" title="3D-тур по утепленной беседке на берегу водоёма"/>
        	</a>
		</xsl:when>
		<xsl:when test="/*/page_content/mr = 'bath'">
			<h2>3D-тур по территории комплекса отдыха рядом с баней</h2>
			<a href="#" id="first" class="link_video{position()} link_3d">
			<img src="{/*/system/info/pub_root}3d/covers/presauna.png" width="600" height="300" alt="3D-тур по территории комплекса отдыха рядом с баней" title="3D-тур по территории комплекса отдыха рядом с баней"/>
        	</a>
			
			<h2>3D-тур внутри бани</h2>
			<a href="#" id="other" class="link_video{position()} link_3d">
			<img src="{/*/system/info/pub_root}3d/covers/sauna.png" width="600" height="300" alt="3D-тур внутри бани" title="3D-тур внутри бани"/>
        	</a>
		</xsl:when>
	</xsl:choose>
	
			

    <div class="popup_block video_popup" id="basic-modal-content-video"> 
      <div class="popup_cont_3d"> 
        <div class="title_3d"><!--JSка сама разберется что сюда выводить :)--></div>
           <div class="video">  
			<div class="popup_3d"> 

		<div id="flashContent">
			<p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a></p>
		</div>
    </div>
      </div></div>
    </div>
        </li>
      </ul>
</xsl:if>

	<xsl:apply-templates select="/*/page_content/linked_paras"/>
   <xsl:if test="/*/page_content/linked_gallery/*">
    <div class="gallery_block"> 
      <ul>
	<xsl:for-each select="/*/page_content/linked_gallery/linked_pict">
        <li class="flickr_badge_image" id="flickr_badge_image{position()}">
		<xsl:apply-templates select="." mode="linked_pict">
			<xsl:with-param name="def" select="/*/page_content/name"/>
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

   <xsl:if test="/*/page_content/gallery/*">
    <div class="gallery_block"> 
      <xsl:for-each select="/*/page_content/gallery/gallery">
      <h2><xsl:value-of select="name" disable-output-escaping="yes"/></h2>
      <ul>
	<xsl:for-each select="linked_picts/linked_pict">
        <li class="flickr_badge_image" id="flickr_badge_image{position()}">
		<xsl:apply-templates select="." mode="linked_pict">
			<xsl:with-param name="def" select="/*/page_content/name"/>
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

	<xsl:variable name="cur_mr"><xsl:apply-templates select="/*/page_path/parent" mode="make_mr"/></xsl:variable>

	<xsl:for-each select="/*/page_content/subpages/page[public = 1]">
		<a href="{$LANGROOT}{$cur_mr}{mr}/"><h2><xsl:value-of select="name" disable-output-escaping="yes"/></h2></a>
		<xsl:apply-templates select="linked_picts/linked_pict" mode="linked_pict">
			<xsl:with-param name="def" select="name"/>
			<xsl:with-param name="class" select="'pic pic_left'"/>
			<xsl:with-param name="href">
				<xsl:if test="linked_paras/*">
					<xsl:value-of select="concat($LANGROOT, $cur_mr, mr, '/')" />
				</xsl:if>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:value-of select="short" disable-output-escaping="yes"/>

	<div class="clearfix"></div>
	<br/>
	</xsl:for-each>
</xsl:template>


<xsl:template match="parent" mode="make_mr"><xsl:value-of select="mr"/>/</xsl:template>

</xsl:stylesheet>
