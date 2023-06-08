<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">


<xsl:template match="/" mode="overrideable_context">
	<xsl:apply-templates select="/" mode="overrideable_menu"/>
	<form class="contextLine" action="{/*/system/info/adm_root}questions/redirect" method="post" style="line-height: 25px;">
		Перейти к вопросу<br/>
		№ <input class="controlNumber" name="number"/><br/>
		<input type="hidden" name="service" value="{/*/form/data/service}"/><br/>
		<input type="submit" value="Найти"/>
	</form>
</xsl:template>

</xsl:stylesheet>
