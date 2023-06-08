<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<!-- Список названий полей формы, для ее автоматической генерации. -->

<xsl:template match="name[.='email']"		mode="forms">E-mail</xsl:template>
<xsl:template match="name[.='password']"	mode="forms">Пароль</xsl:template>
<xsl:template match="name[.='newpassword1']"	mode="forms">Новый пароль</xsl:template>
<xsl:template match="name[.='newpassword2']"	mode="forms">Повторите новый пароль</xsl:template>

</xsl:stylesheet>
