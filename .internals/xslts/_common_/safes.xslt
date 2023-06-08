<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="safe_concat">
	<xsl:param name="content"/>
	<xsl:param name="default"/>
	<xsl:param name="prolog"/>
	<xsl:param name="epilog"/>
	<xsl:param name="concat"/>
	<xsl:param name="cut"/>
	<xsl:param name="put"/>

	<xsl:variable name="safe_prolog">
		<xsl:call-template name="safe_string">
			<xsl:with-param name="string" select="$prolog"/>
			<xsl:with-param name="cut" select="$cut"/>
			<xsl:with-param name="put" select="$put"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="safe_epilog">
		<xsl:call-template name="safe_string">
			<xsl:with-param name="string" select="$epilog"/>
			<xsl:with-param name="cut" select="$cut"/>
			<xsl:with-param name="put" select="$put"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="safe_content">
		<xsl:call-template name="safe_string">
			<xsl:with-param name="string" select="$content"/>
			<xsl:with-param name="cut" select="$cut"/>
			<xsl:with-param name="put" select="$put"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="safe_default">
		<xsl:call-template name="safe_string">
			<xsl:with-param name="string" select="$default"/>
			<xsl:with-param name="cut" select="$cut"/>
			<xsl:with-param name="put" select="$put"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="safe_intern">
		<xsl:if test="string($safe_content)!=''"><xsl:value-of select="$safe_content"/></xsl:if>
		<xsl:if test="string($safe_content) =''"><xsl:value-of select="$safe_default"/></xsl:if>
	</xsl:variable>
	<xsl:variable name="safe_string">
		<xsl:value-of select="$safe_prolog"/><xsl:if test="string($safe_prolog)!='' and concat('', $safe_epilog, $safe_intern)!=''"><xsl:value-of select="$concat"/></xsl:if>
		<xsl:value-of select="$safe_intern"/><xsl:if test="string($safe_intern)!='' and concat('', $safe_epilog              )!=''"><xsl:value-of select="$concat"/></xsl:if>
		<xsl:value-of select="$safe_epilog"/>
	</xsl:variable>

	<xsl:call-template name="safe_string">
		<xsl:with-param name="string" select="$safe_string"/>
		<xsl:with-param name="cut" select="$cut"/>
		<xsl:with-param name="put" select="$put"/>
	</xsl:call-template>	
</xsl:template>



<xsl:template name="safe_string">
	<xsl:param name="string"/>
	<xsl:param name="cut"/>
	<xsl:param name="put"/>
	<xsl:value-of select="php:function('preg_replace', '/(^\s+|\s+$)/sux', '', php:function('preg_replace', '/\s+/sux', ' ', translate(php:function('strip_tags', php:function('html_entity_decode', string($string), 0, 'utf-8')), string($cut), string($put))))" disable-output-escaping="yes"/>
</xsl:template>


<xsl:template name="safe_split">
	<xsl:param name="split_str" />
	<xsl:param name="no_last" select="''" />
	<xsl:choose>
	<xsl:when test="contains($split_str,' ')">
		<xsl:value-of select="concat(substring-before($split_str,' '),' ')" />
		<xsl:call-template name="safe_split">
			<xsl:with-param name="split_str" select="substring-after($split_str,' ')" />
			<xsl:with-param name="no_last" select="'1'" />
		</xsl:call-template>		
	</xsl:when>
	<xsl:otherwise>
		<xsl:if test="$no_last = ''"> <!-- Если пришли сюда с пустым no_last - пробелов нет, можно выводить  -->
			<xsl:value-of select="$split_str" />
		</xsl:if>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="safe_cut">
	<xsl:param name="in_string" />

	<xsl:choose>
		<xsl:when test="string-length($in_string) &gt; 259">
			<xsl:variable name="final_string">
				<xsl:call-template name="safe_split">
					<xsl:with-param name="split_str" select="substring($in_string,1,259)" /> <!-- safe_string отработал, нормализация строки не нужна -->
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="normalize-space($final_string)" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$in_string" />
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>

</xsl:stylesheet>
