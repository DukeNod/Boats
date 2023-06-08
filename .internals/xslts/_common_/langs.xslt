<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="list_of_languages">
	<xsl:param name="link" />

	<xsl:if test="/*/languages/lang and count(/*/languages/lang) &gt; 1">
	<p>
	Выбор языка: 
	<xsl:for-each select="/*/languages/lang">

		<xsl:choose>
		<xsl:when test="code=/*/language">
			<b><xsl:value-of select="name" /></b>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			<!--xsl:when test="contains($link, '?')">
				<a href="{$link}&amp;lang={code}&amp;back={$link}&amp;lang={code}" onClick="return form_ask()"><xsl:value-of select="name" /></a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$link}?lang={code}&amp;back={$link}?lang={code}" onClick="return form_ask()"><xsl:value-of select="name" /></a>
			</xsl:otherwise-->
			<xsl:when test="contains($link, '?')">
				<a href="{$link}&amp;lang={code}&amp;back={$link}&amp;lang={code}" onClick="return form_ask()"><xsl:value-of select="name" /></a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$link}?lang={code}&amp;back={$link}&amp;lang={code}" onClick="return form_ask()"><xsl:value-of select="name" /></a>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="position()!=last()">
			<xsl:text> | </xsl:text>
		</xsl:if>
	</xsl:for-each>
	</p>
	</xsl:if>

</xsl:template>

<xsl:template name="list_of_languages_main">
	<xsl:param name="link" />

	<xsl:if test="/*/languages/lang and count(/*/languages/lang) &gt; 1">
	<p>
	Выбор языка: 
	<xsl:for-each select="/*/languages/lang">

		<xsl:choose>
		<xsl:when test="code=/*/language">
			<b><xsl:value-of select="name" /></b>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="contains($link, '?')">
				<xsl:choose>
				<xsl:when test="contains($link, 'lang')">
					<a href="{php:function('preg_replace', '/lang=\w{2}/sux', concat('lang=', code), string($link))}"><xsl:value-of select="name" /></a>
				</xsl:when>
				<xsl:otherwise>
					<a href="{$link}&amp;lang={code}"><xsl:value-of select="name" /></a>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$link}?lang={code}"><xsl:value-of select="name" /></a>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="position()!=last()">
			<xsl:text> | </xsl:text>
		</xsl:if>
	</xsl:for-each>
	</p>
	</xsl:if>

</xsl:template>

</xsl:stylesheet>
