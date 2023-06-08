<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/admin.xslt"/>



<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Доступ запрещён</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="'Доступ запрещён'"/></xsl:call-template>
</xsl:template>


<xsl:template match="/" mode="overrideable_menu">
</xsl:template>


<xsl:template match="/*/main">
		<div class="http404">
			<p>
				Вас тут не ждали.
			</p>
			<p>
				Если точнее, этот раздел сайта закрыт от Вас,
				поэтому используйте меню доступных разделов
				чтобы продолжить работу там, где Вам разрешено работать.
				А ещё Вы можете вернуться на <a href="{/*/system/info/adm_root}">главную страницу</a>.
			</p>
		</div>
</xsl:template>



</xsl:stylesheet>
