<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<!--

Шаблоны для форматирования различных частей файлов (размеров, иконок и т.п.).

-->

<!--
Пиктограмма файла. Точнее, только её имя на основе расширения файла.
-->
<xsl:template name="file_icon">
	<xsl:param name="dir" select="'/img/icons/'"/>
	<xsl:param name="ext" select="'.gif'"/>
	<xsl:param name="file"/>
	<xsl:param name="class"/>

	<xsl:variable name="ext2" select="translate(substring($file, string-length($file)-2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
	<xsl:variable name="ext3" select="translate(substring($file, string-length($file)-3), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
	<xsl:variable name="ext4" select="translate(substring($file, string-length($file)-4), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>

	<xsl:choose>
	<xsl:when test="$ext3='.pdf'">
		<img src="{$dir}pdf{$ext}" width="20" height="20" alt="PDF" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.swf'">
		<img src="{$dir}flash{$ext}" width="20" height="20" alt="Flash" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.htm' or $ext4='.html' or $ext3='.xml'">
		<img src="{$dir}msie{$ext}" width="20" height="20" alt="Страница" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.txt' or $ext3='.log'">
		<img src="{$dir}text{$ext}" width="20" height="20" alt="Текст" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.rtf' or $ext3='.doc' or $ext4='.docx'">
		<img src="{$dir}msword{$ext}" width="20" height="20" alt="MS Word" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.xls' or $ext4='.xlsx'">
		<img src="{$dir}msexcel{$ext}" width="20" height="20" alt="MS Excel" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.ppt' ">
		<img src="{$dir}mspowerpoint{$ext}" width="20" height="20" alt="MS PowerPoint" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.gif' or $ext3='.jpg' or $ext4='.jpeg' or $ext3='.png' or $ext3='.bmp' or $ext3='.tif' or $ext4='.tiff'">
		<img src="{$dir}picture{$ext}" width="20" height="20" alt="Изображение" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.avi' or $ext3='.mpg' or $ext4='.mpeg' or $ext3='.m4v' or  $ext3='.flv'">
		<img src="{$dir}movie{$ext}" width="20" height="20" alt="Фильм" class="{$class}"/>
	</xsl:when>
	<xsl:otherwise>
		<img src="{$dir}unknown{$ext}" width="20" height="20" alt="" class="{$class}"/>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="file_icon_public">
	<xsl:param name="dir" select="'/img/icons/'"/>
	<xsl:param name="ext" select="'.gif'"/>
	<xsl:param name="file"/>
	<xsl:param name="class"/>

	<xsl:variable name="ext2" select="translate(substring($file, string-length($file)-2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
	<xsl:variable name="ext3" select="translate(substring($file, string-length($file)-3), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
	<xsl:variable name="ext4" select="translate(substring($file, string-length($file)-4), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>

	<xsl:choose>
	<xsl:when test="$ext3='.pdf'">
		<img src="{$dir}pdf.png" width="38" height="43" alt="PDF" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.swf'">
		<img src="{$dir}flash{$ext}" width="20" height="20" alt="Flash" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.htm' or $ext4='.html' or $ext3='.xml'">
		<img src="{$dir}msie{$ext}" width="20" height="20" alt="Страница" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.txt' or $ext3='.log'">
		<img src="{$dir}text{$ext}" width="20" height="20" alt="Текст" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.rtf' or $ext3='.doc' or $ext4='.docx'">
		<img src="{$dir}msword.png" width="38" height="43" alt="MS Word" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.xls' or $ext4='.xlsx'">
		<img src="{$dir}msexcel{$ext}" width="20" height="20" alt="MS Excel" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.ppt' ">
		<img src="{$dir}mspowerpoint{$ext}" width="20" height="20" alt="MS PowerPoint" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.jpg' or $ext4='.jpeg'">
		<img src="{$dir}jpg.png" width="38" height="43" alt="Изображение" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.gif' or $ext3='.jpg' or $ext4='.jpeg' or $ext3='.png' or $ext3='.bmp' or $ext3='.tif' or $ext4='.tiff'">
		<img src="{$dir}picture{$ext}" width="20" height="20" alt="Изображение" class="{$class}"/>
	</xsl:when>
	<xsl:when test="$ext3='.avi' or $ext3='.mpg' or $ext4='.mpeg' or $ext3='.m4v' or  $ext3='.flv'">
		<img src="{$dir}movie{$ext}" width="20" height="20" alt="Фильм" class="{$class}"/>
	</xsl:when>
	<xsl:otherwise>
		<img src="{$dir}unknown{$ext}" width="20" height="20" alt="" class="{$class}"/>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!--
-->
<xsl:template name="file_size">
	<xsl:param name="size"/>

	<xsl:choose>
	<xsl:when test="number($size)&gt;(1024*1024*1024)"><xsl:value-of select="floor(number($size) div 1024 div 1024 div 1024 * 10) div 10"/>&nbsp;ГБ</xsl:when>
	<xsl:when test="number($size)&gt;(1024*1024     )"><xsl:value-of select="floor(number($size) div 1024 div 1024          * 10) div 10"/>&nbsp;МБ</xsl:when>
	<xsl:when test="number($size)&gt;(1024          )"><xsl:value-of select="floor(number($size) div 1024                   * 1 ) div 1 "/>&nbsp;КБ</xsl:when>
	<xsl:otherwise><xsl:value-of select="number($size)"/>&nbsp;байт</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match='linked_file'>
	<xsl:variable name="ext3" select="translate(substring(attach_file, string-length(attach_file)-3), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
	<xsl:choose>
	<xsl:when test="$ext3 = '.flv'">
	        <xsl:value-of select="name" disable-output-escaping="yes"/>
		<xsl:text> &nbsp;</xsl:text>
		<!--a href="#" onClick="showVideo({id}, this)" class="m-14px-font"><xsl:value-of select="name"/> </a>
		<xsl:text> &nbsp;</xsl:text>
		<a href="#" id="filehref{id}" onClick="return showVideo({id}, this)" class="m-black-font">Смотреть</a-->
		<a href="#" onClick="return showVideo({id}, this)"><xsl:call-template name="file_icon">
			<xsl:with-param name="dir" select="concat(/*/system/info/adm_root, 'img/icons/')"/>
			<xsl:with-param name="file" select="attach_file"/>
			<xsl:with-param name="class" select="'g-icon'"/>
		</xsl:call-template></a>
		<xsl:text>&nbsp;</xsl:text>
		<xsl:call-template name="file_size">
			<xsl:with-param name="size" select="attach_size"/>
		</xsl:call-template>

		<div id="file{id}"> <!--   style="position: absolute; display: none; margin-top: -380; z-index: 100;" -->
		<script type="text/javascript">
			var s<xsl:value-of select="id"/> = new SWFObject("<xsl:value-of select="/*/system/info/pub_root"/>dsn/mediaplayer.swf","mediaplayer","480","360","7");
			s<xsl:value-of select="id"/>.addParam("allowfullscreen","true");
			s<xsl:value-of select="id"/>.addVariable("width","480");
			s<xsl:value-of select="id"/>.addVariable("height","360");
			s<xsl:value-of select="id"/>.addVariable("file","<xsl:value-of select="/*/system/info/adm_to_dir_for_linked"/>files/attach/<xsl:value-of select="uplink_type"/>/<xsl:value-of select="uplink_id"/>/<xsl:value-of select="attach_file"/>");
			s<xsl:value-of select="id"/>.addVariable("autostart","false");
			s<xsl:value-of select="id"/>.addVariable("shownavigation","true");
			// s<xsl:value-of select="id"/>.addVariable("image","video.jpg");
			s<xsl:value-of select="id"/>.addVariable('enablejs','true');
			s<xsl:value-of select="id"/>.write("file<xsl:value-of select="id"/>");
		</script>

			<!--
			<script language="javascript">
				if (AC_FL_RunContent == 0) {
					alert("This page requires AC_RunActiveContent.js.");
				} else {
					AC_FL_RunContent(
						'codebase', 'http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0',
						'width', '570',
						'height', '151',
						'src', '<xsl:value-of select="/*/system/info/pub_root"/>dsn/fplayer',
						'quality', 'high',
						'pluginspage', 'http://www.macromedia.com/go/getflashplayer',
						'align', 'middle',
						'play', 'true',
						'loop', 'true',
						'scale', 'showall',
						'wmode', 'opaque',
						'devicefont', 'false',
						'id', 'fplayer',
						'bgcolor', '#ffffff',
						'name', 'fplayer',
						'menu', 'true',
						'allowFullScreen', 'true',
						'allowScriptAccess','sameDomain',
						'movie', '<xsl:value-of select="/*/system/info/pub_root"/>dsn/fplayer',
						'salign', '',
						'flashvars', 'video_url=<xsl:value-of select="/*/system/info/adm_to_dir_for_linked"/>files/attach/<xsl:value-of select="uplink_type"/>/<xsl:value-of select="uplink_id"/>/<xsl:value-of select="attach_file"/>' 
						); //end AC code
						// &amp;preview_url=/dsn/8.jpg
				}
			</script>
			<noscript>
				<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0" width="570" height="151" id="map_dealers" align="middle">
				<param name="allowScriptAccess" value="sameDomain" />
				<param name="allowFullScreen" value="false" />
				<param name="movie" value="{/*/system/info/pub_root}dsn/fplayer.swf" />
				<param name="flashvars" value="video_url={/*/system/info/adm_to_dir_for_linked}files/attach/{uplink_type}/{uplink_id}/{attach_file}" />
				<param name="quality" value="high" />
				<param name="bgcolor" value="#BEC1CA" />
			    	<img src="{/*/system/info/pub_root}dsn/dummy_illustration.jpg" width="588" height="151" alt=""/>
				<embed src="{/*/system/info/pub_root}dsn/fplayer.swf" quality="high" bgcolor="#ffffff" width="570" height="151" name="map_dealers" align="middle" allowScriptAccess="sameDomain" allowFullScreen="true" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
				</object>
			</noscript>
			-->
		</div>
	</xsl:when>
	<xsl:otherwise>
		<!--
		<a href="{/*/system/info/adm_to_dir_for_linked}files/attach/{uplink_type}/{uplink_id}/{attach_file}" target="_blank" class="m-14px-font"><xsl:value-of select="name"/> </a>
		<xsl:text> &nbsp;</xsl:text>
		<a href="{/*/system/info/adm_to_dir_for_linked}files/attach/{uplink_type}/{uplink_id}/{attach_file}" target="_blank" class="m-black-font">Скачать</a>
		<a href="{/*/system/info/adm_to_dir_for_linked}files/attach/{uplink_type}/{uplink_id}/{attach_file}" target="_blank"><xsl:call-template name="file_icon">
			<xsl:with-param name="dir" select="concat(/*/system/info/adm_root, 'img/icons/')"/>
			<xsl:with-param name="file" select="attach_file"/>
			<xsl:with-param name="class" select="'g-icon'"/>
		</xsl:call-template></a>
		<xsl:text>&nbsp;</xsl:text>
		<xsl:call-template name="file_size">
			<xsl:with-param name="size" select="attach_size"/>
		</xsl:call-template>
		-->
		<a href="{/*/system/info/pub_root}linked/files/attach/{uplink_type}/{uplink_id}/{attach_file}"><xsl:call-template name="file_icon_public">
			<xsl:with-param name="dir" select="concat(/*/system/info/pub_root, 'images/icons/')"/>
			<xsl:with-param name="file" select="attach_file"/>
		</xsl:call-template></a>
		<a href="{/*/system/info/pub_root}linked/files/attach/{uplink_type}/{uplink_id}/{attach_file}"><xsl:value-of select="name"/></a>
		<xsl:text> (</xsl:text>
		<xsl:call-template name="file_size">
			<xsl:with-param name="size" select="attach_size"/>
		</xsl:call-template>
		<xsl:text>)</xsl:text>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match='linked_video'>
	<iframe width="560" height="345" src="http://www.youtube.com/embed/{code}?rel=0" frameborder="0" allowfullscreen="allowfullscreen"></iframe>
</xsl:template>

</xsl:stylesheet>
