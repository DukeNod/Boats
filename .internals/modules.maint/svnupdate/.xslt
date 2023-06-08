<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/maint.xslt"/>



<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Обновление версии сайта через SVN</xsl:text>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">
	<xsl:choose>
	<xsl:when test="/*/retval!=0">
		Ощибка выполнения. Попробуйте обонвить вручную.<br/>
		Код ошибки: <xsl:value-of select="/*/retval"/>
	</xsl:when>
	<xsl:otherwise>
		Процесс завершен.<br/><br/>
		Ответ SVN:<br/><br/>
		<xsl:for-each select="/*/file_list/out">
			<xsl:value-of select="."/><br/>
		</xsl:for-each>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>



</xsl:stylesheet>
