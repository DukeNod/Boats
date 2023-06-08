<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../../xslts/admin.xslt"/>



<xsl:template match="/" mode="overrideable_selector">inlines</xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Установка значения у текстовой вставки</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root, 'inlines')"/><xsl:with-param name="text" select="'Текстовые вставки'"/></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="'Установка значения'"/></xsl:call-template>
</xsl:template>



<xsl:template match="/*/form">
	<p>
		<!--!!!todo: сделать побольше текстового материала, который вообще надо вынести в именованный шаблон.-->
		<!-- В естественном ходе работы эта страница не должна выкидывать form ни в коем случае.-->
		Выполнение невозможно.
	</p>	
</xsl:template>



</xsl:stylesheet>
