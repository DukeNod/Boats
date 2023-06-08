<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="form[@for=/*/module/essence]/errors/*">
	<xsl:choose>
	<xsl:when test="name() = 'password1_required'"> Поле "Пароль" обязательно для заполнения.</xsl:when>
	<xsl:when test="name() = 'password2_required'"> Поле "Подтверждение пароля" обязательно для заполнения.</xsl:when>
	<xsl:when test="name() = 'password_not_equal'"> Пароль на совпадает с подтверждением.</xsl:when>
	<xsl:when test="name() = 'pond_required'"> Необходимо указать пруд источник.</xsl:when>
	<xsl:when test="@type = 'duplicate'">Такое значение поля "<xsl:value-of select="/*/module/fields/*[name = current()/@field]/title"/>" уже существует.</xsl:when>
	<xsl:when test="@type = 'required'">Поле "<xsl:value-of select="/*/module/fields/*[name = current()/@field]/title"/>" обязательно для заполнения.</xsl:when>
	<xsl:when test="@type = 'bad'"> Не верный формат поля "<xsl:value-of select="/*/module/fields/*[name = current()/@field]/title"/>".</xsl:when>
	<xsl:when test="name() = 'rest_points_too_low'"> Превышено количество баллов</xsl:when>
	<xsl:otherwise><xsl:value-of select="name()"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="form[@for='articles']/errors/currency_bad     ">Необходимо указать торговую марку товара.</xsl:template>

</xsl:stylesheet>
