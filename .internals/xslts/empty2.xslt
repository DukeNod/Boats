<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:include href="_all_.xslt" />
<xsl:include href="./_common_/safes.xslt" />
<xsl:include href="./_common_/media.xslt" />
<xsl:include href="./_common_/meta.xslt" />
<xsl:include href="./_common_/picts.xslt" />
<xsl:include href="./_common_/paras.xslt" />
<xsl:include href="./_common_/dates.xslt" />
<xsl:include href="./_common_/calendars.xslt"/>

<!--
ВНИМАНИЕ:
Тег <meta content-type> (с mime-type и charset) перекрывается автоматически, хотя в документации это нигде явно не описано.
Indent принудительно отключен, потому что XSLT-процессор почему-то его включает (хотя default=no), и это портит вёрстку.
-->
<xsl:output
	method="html" 
	indent="yes"
/>

<!--
ШАБЛОН ДЛЯ СИСТЕМНОЙ ОШИБКИ.
Определяем вёрстку по умолчанию для сообщений о системной ошибке программной части (исключения).
В рамках определённых модулей и ситуация, некоторые исключения могут быть отловлены по более
конкретизированным условиям (по id или type), и для них вёрстка определена иначе. Но в любом случае
необходим вот такой вот механизм "отката" на дефолтную обощённую вёрстку.
-->
<xsl:template priority="-99" match="/*/exception">
	<div class="layoutException">
		<xsl:if test="string(id  )!=''"><p class="layoutExceptionId"  >Код <xsl:value-of select="id  "/></p></xsl:if>
		<xsl:if test="string(type)!=''"><p class="layoutExceptionType">Тип <xsl:value-of select="type"/></p></xsl:if>
		<xsl:if test="string(text)!=''"><p class="layoutExceptionText"><xsl:value-of select="text"/></p></xsl:if>
	</div>
</xsl:template>



<!--
КОРНЕВОЙ УЗЕЛ.
Задаём оформление корневого узла (без режима), и на него навешиваем вывод оформления страницы.
В это оформление записываем только самый базовый HTML-код, определяющий технический формат результата (пролог и корневой тег).
Вещи, касающиеся контента или дизайна, помещаем в переопределяемых шаблонах для тегов head & body.
-->
<xsl:template match="/">
	<xsl:apply-templates select="/" mode="overrideable_content"/>
</xsl:template>


<xsl:decimal-format name="cost" decimal-separator="," grouping-separator="&nbsp;" NaN=""/>
<xsl:decimal-format name="size" decimal-separator="," grouping-separator="&nbsp;" NaN=""/>


<xsl:template match="inline">
<xsl:param name="title_inline" select="''"/>
	<xsl:choose>
		<xsl:when test="linked_paras/*">
			<xsl:apply-templates select="linked_paras/linked_para" mode="linked_para">
				<xsl:with-param name="alt" select="$title_inline"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
				<xsl:value-of select="content" disable-output-escaping="yes"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
