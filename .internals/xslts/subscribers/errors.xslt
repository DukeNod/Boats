<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template mode="subscriber" match="form/errors/*" priority="-1"><xsl:apply-templates select="."/></xsl:template>

<xsl:template mode="subscriber" match="form/errors/email_duplicate    "><div class="error">Запись с таким e-mail уже существует.</div></xsl:template>
<xsl:template mode="subscriber" match="form/errors/email_required     "><div class="error">Необходимо указать e-mail.</div></xsl:template>
<xsl:template mode="subscriber" match="form/errors/email_bad          "><div class="error">Неверный формат e-mail.</div></xsl:template>
<xsl:template mode="subscriber" match="form/errors/code_required      "><div class="error">Необходимо задать код активации.</div></xsl:template>
<xsl:template mode="subscriber" match="form/errors/is_active_required "><div class="error">Необходимо задать статус подписки.</div></xsl:template>
<xsl:template mode="subscriber" match="form/errors/is_active_bad      "><div class="error">Неприемлимое значение статуса подписки.</div></xsl:template>
<xsl:template mode="subscriber" match="form/errors/is_tester_required "><div class="error">Необходимо задать статус тестера.</div></xsl:template>
<xsl:template mode="subscriber" match="form/errors/is_tester_bad      "><div class="error">Неприемлимое значение статуса тестера.</div></xsl:template>



</xsl:stylesheet>
