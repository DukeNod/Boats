<?xml version='1.0' encoding='cp1251' ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<!--
Шаблон для автоматического вывода media-контента.

Вывод производится тегами и иными структурами в зависимости от типа контента,
который определяется из расширения файла (из параметра src; после последней точки).
Добавление новых типов типов media делается дописыванием условий в существующие where'ы,
либо добавлением новых where'ов с соответствующим наполнением (структурой элементов).

Не путать media-контент как таковой, и прилинкованные картинки (linked_picts) - это разные вещи!
Media-контент может быть у любых сущностей, в любых их полях, либо идти вообще без привязки к БД и полям.
-->
<xsl:template name="media">
	<xsl:param name="src"/>
	<xsl:param name="w"/>
	<xsl:param name="h"/>
	<xsl:param name="id"/>
	<xsl:param name="alt"/>
	<xsl:param name="title"/>
	<xsl:param name="class"/>
	<xsl:param name="style"/>
	<xsl:param name="onClick"/>
	<xsl:param name="onDblClick"/>
	<xsl:param name="onMouseOver"/>
	<xsl:param name="onMouseOut"/>

	<!--
	Для определения способа вывода нам понадобится расширение выводимого контента.
	Причём для сравнения его нужно нормализовать (привести к нижнему регистру, урезать точку и т.п.).
	И учесть что расширения бывают разной длины, а нам всё нужно свести воедино в одно имя.
	Делаем параметром, а не переменной, чтоб можно было принудительно перекрыть если приспичит.
	-->
	<xsl:param name="ext">
		<xsl:choose>
		<xsl:when test="substring($src, string-length($src) - 1, 1) = '.'"><xsl:value-of select="translate(substring($src, string-length($src)+1 - 1), 'ABCDEFHIJKLMNOPQRSTUVWXYZ', 'abcdefhijklmnopqrstuvwxyz')"/></xsl:when>
		<xsl:when test="substring($src, string-length($src) - 2, 1) = '.'"><xsl:value-of select="translate(substring($src, string-length($src)+1 - 2), 'ABCDEFHIJKLMNOPQRSTUVWXYZ', 'abcdefhijklmnopqrstuvwxyz')"/></xsl:when>
		<xsl:when test="substring($src, string-length($src) - 3, 1) = '.'"><xsl:value-of select="translate(substring($src, string-length($src)+1 - 3), 'ABCDEFHIJKLMNOPQRSTUVWXYZ', 'abcdefhijklmnopqrstuvwxyz')"/></xsl:when>
		<xsl:when test="substring($src, string-length($src) - 4, 1) = '.'"><xsl:value-of select="translate(substring($src, string-length($src)+1 - 4), 'ABCDEFHIJKLMNOPQRSTUVWXYZ', 'abcdefhijklmnopqrstuvwxyz')"/></xsl:when>
		</xsl:choose>
	</xsl:param>

	<!-- В завимимости от типа указанного контента используем разную систему вывода. -->
	<xsl:choose>

	<!-- Shockwave Flash определяем по расширению ".swf" (case-insensitive). -->
	<xsl:when test="$ext='swf'">
		<!--
		!!!todo: изюавиться от переменных; расставить правиьлные подполя в AC_FL_()
		!!!todo: определиться насчёт slash-quoting'а в src-полях (где value-of в AC_FL).
		-->
		<xsl:variable name="flash_file_ext" select="substring($src, string-length($src)-3)"/>
		<xsl:variable name="short_src" select="substring-before($src, $flash_file_ext)"/>
		<xsl:variable name="flash_id" select="translate($short_src, '/', '_')"/>
		<script type="text/javascript"><![CDATA[<!--]]>
			if (AC_FL_RunContent == 0) {
				alert("This page requires AC_RunActiveContent.js.");
			} else {
				AC_FL_RunContent(
				'codebase',		'http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0',
				'width',		'<xsl:value-of select="$w"/>',
				'height',		'<xsl:value-of select="$h"/>',
				'src',			'<xsl:value-of select="$short_src"/>',
				'quality',		'high',
				'pluginspage',		'http://www.macromedia.com/go/getflashplayer',
				'align',		'middle',
				'play',			'true',
				'loop',			'true',
				'scale',		'showall',
				'wmode',		'transparent',
				'devicefont',		'false',
				'id',			'<xsl:value-of select="$flash_id"/>',
				'bgcolor',		'#FFFFFF',
				'name',			'<xsl:value-of select="$flash_id"/>',
				'menu',			'true',
				'allowFullScreen',	'false',
				'allowScriptAccess',	'sameDomain',
				'movie',		'<xsl:value-of select="$short_src"/>',
				'salign',		''
				); //end AC code
			}
		<![CDATA[//-->]]></script>
		<noscript>
		<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0" width="{$w}" height="{$h}" id="{$flash_id}" align="middle">
			<param name="allowScriptAccess" value="sameDomain" />
			<param name="allowFullScreen" value="false" />
			<param name="movie" value="{$src}" />
			<param name="quality" value="high" />
			<param name="wmode" value="transparent" />
			<param name="bgcolor" value="#FFFFFF" />
			<embed src="{$src}" quality="high" wmode="transparent" bgcolor="#FFFFFF" width="{$w}" height="{$h}" name="{$flash_id}" align="middle" allowScriptAccess="sameDomain" allowFullScreen="false" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
		</object>
		</noscript>
	</xsl:when>

	<!-- FLV-видео определяем по расширению ".flv" (case-insensitive). -->
	<!--todo later: выбрать плеер и посмотреть как точно оно вставляется.
	<xsl:when test="$ext='flv'">
	</xsl:when>
	-->

	<!-- Прочее видео определяем по расширениям ".avi/mpg/mpeg" (case-insensitive). -->
	<!--todo later: выбрать плеер и посмотреть как точно оно вставляется.
	<xsl:when test="$ext='avi' or $ext='mpg' or $ext='mpeg'">
	</xsl:when>
	-->

	<!-- В остальных случаях, независимо от расширения, полагаем что объект может быть подключен как картинка. -->
	<!-- Причём в alt/title загоняем текст, лишённый сущностей, тегов и прочими способами обезопасенный. -->
	<!-- NB: Раньше тут был вывод через CDATA+doe, потому что иначе в альтах писались &lt/gt/amp, и была дописка $attrs. -->
	<xsl:otherwise>
		<img>
			<xsl:if test="string($src  )!=''"><xsl:attribute name="src"   ><xsl:value-of select="$src  "/></xsl:attribute></xsl:if>
			<xsl:if test="string($w    )!=''"><xsl:attribute name="width" ><xsl:value-of select="$w    "/></xsl:attribute></xsl:if>
			<xsl:if test="string($h    )!=''"><xsl:attribute name="height"><xsl:value-of select="$h    "/></xsl:attribute></xsl:if>
			<xsl:if test="string($id   )!=''"><xsl:attribute name="id"    ><xsl:value-of select="$id   "/></xsl:attribute></xsl:if>
			<xsl:if test="string($id   )!=''"><xsl:attribute name="name"  ><xsl:value-of select="$id   "/></xsl:attribute></xsl:if>
			<xsl:if test="string($class)!=''"><xsl:attribute name="class" ><xsl:value-of select="$class"/></xsl:attribute></xsl:if>
			<xsl:if test="string($style)!=''"><xsl:attribute name="style" ><xsl:value-of select="$style"/></xsl:attribute></xsl:if>

			<xsl:if test="string($alt  )!=''"><xsl:attribute name="alt"   >
				<xsl:call-template name="safe_string">
					<xsl:with-param name="string" select="$alt"/>
					<xsl:with-param name="cut" select="'&#x0D;&#x0A;&#x26;&#x3C;&#x3E;&#x22;'"/>
					<xsl:with-param name="put" select='"&#x20;&#x20;&#x20;&#x20;&#x20;&#x27;"'/>
				</xsl:call-template>
			</xsl:attribute></xsl:if>

			<xsl:if test="string($title)!=''"><xsl:attribute name="title" >
				<xsl:call-template name="safe_string">
					<xsl:with-param name="string" select="$alt"/>
					<xsl:with-param name="cut" select="'&#x0D;&#x0A;&#x26;&#x3C;&#x3E;&#x22;'"/>
					<xsl:with-param name="put" select='"&#x20;&#x20;&#x20;&#x20;&#x20;&#x27;"'/>
				</xsl:call-template>
			</xsl:attribute></xsl:if>

			<xsl:if test="string($onClick    )!=''"><xsl:attribute name="onClick"    ><xsl:value-of select="$onClick    "/></xsl:attribute></xsl:if>
			<xsl:if test="string($onDblClick )!=''"><xsl:attribute name="onDblClick" ><xsl:value-of select="$onDblClick "/></xsl:attribute></xsl:if>
			<xsl:if test="string($onMouseOver)!=''"><xsl:attribute name="onMouseOver"><xsl:value-of select="$onMouseOver"/></xsl:attribute></xsl:if>
			<xsl:if test="string($onMouseOut )!=''"><xsl:attribute name="onMouseOut" ><xsl:value-of select="$onMouseOut "/></xsl:attribute></xsl:if>
		</img>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>



</xsl:stylesheet>
