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
<xsl:include href="./_common_/picts.xslt" />
<xsl:include href="./_common_/paras.xslt" />
<xsl:include href="./_common_/dates.xslt" />
<xsl:include href="./_common_/admin_quick_form.xslt" />
<xsl:include href="./_common_/admin_quick_list.xslt" />
<xsl:include href="./_common_/calendars.xslt"/>

<!-- Кодировка AJAX-откликов должна быть UTF-8, потому что JS воспринимает только UTF-8 текст (почему-то, несмотря на headers). -->
<!--todo: Попробовать в AJAX-отклике выводить в cp1251, и отправлять header() с content-type & charset. -->
<xsl:output
	method="html" 
	indent="yes"
/>
	<!-- encoding="utf-8" -->

<!--xsl:template priority="-10" match="/" mode="overrideable_content"     ></xsl:template-->

<xsl:template priority="-10" match="/" mode="overrideable_content">
	<!--
	Обрбатываем только один из узлов, причём порядок перехвата важен (особенно для exception),
	Для этого используем choose вместо apply-templates select="...|...|...|".
	При этом из перехвата исключаются вспомогательные узлы типа system, enums, и пр.
	-->
	<xsl:choose>
	<xsl:when test="/*/main"><xsl:apply-templates select="/*/main[1]"/></xsl:when>
	<xsl:when test="/*/list"><xsl:apply-templates select="/*/list[1]"/></xsl:when>
	<xsl:when test="/*/item"><xsl:apply-templates select="/*/item[1]"/></xsl:when>
	<xsl:when test="/*/done"><xsl:apply-templates select="/*/done[1]"/></xsl:when>
	<xsl:when test="/*/form"><xsl:apply-templates select="/*/form[1]"/></xsl:when>
	<xsl:otherwise><!--???--></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
КОРНЕВОЙ УЗЕЛ.
Задаём оформление корневого узла (он единственный по стандарту XML, так что об имени и не заботимся).
В это оформление записываем весь JSON-код, который мы желаем получить в итоге,
включая "вызовы" переопределяемых частей (overrideables). Остальные части, которые не меняются
от страницы к странице, оформляем вызовами именнованных шаблонов (просто для лучшей читабельности кода).
-->
<xsl:template match="/">
	<xsl:choose>
	<xsl:when test="/*/exception">
		<xsl:text>{</xsl:text>
			<xsl:text>"_is_exception_": true, </xsl:text>
			<!--
			todo: заюзать <xsl:apply-templates mode="json"/>,
			todo:только учесть что имя узла error не совпадает с отсутствующим JSONовским.
			todo: <xsl:apply-templates select="/*/error[1]/*" mode="json"/>
			-->
			<xsl:for-each select="/*/exception[1]/*">
				<xsl:text>"</xsl:text>
				<xsl:value-of select="name()"/>
				<xsl:text>": </xsl:text>
	                
				<xsl:text>"</xsl:text>
				<xsl:value-of select="php:function('addslashes', string(.))"/>
				<xsl:text>"</xsl:text>
	                
				<xsl:if test="position()!=last()">
				<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:for-each>
		<xsl:text>}</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select="/" mode="overrideable_content"/>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>



<!--
DOM-JSON конвертерирующий шаблон.
Превращает нужный узел в JSON-структуру. За имена полей берёт имена узлов, а значения делает
либо объектами (если есть дочерние узлы), либо текстом (если нет дочерних узлов).
-->
<xsl:template match="node()" mode="json">
	<xsl:text>"</xsl:text>
		<xsl:value-of select="name()"/>
	<xsl:text>": </xsl:text>

	<xsl:choose>
	<xsl:when test="*">
		<xsl:text>{</xsl:text>
			<xsl:apply-templates select="*" mode="json"/>
		<xsl:text>}</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>"</xsl:text>
			<xsl:value-of select="php:function('addslashes', string(.))"/>
		<xsl:text>"</xsl:text>
	</xsl:otherwise>
	</xsl:choose>

	<xsl:if test="position()!=last()">, </xsl:if>
</xsl:template>


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


<xsl:template match="/*/done" priority="-1">
		<script type="text/javascript">
		        refresh_list();
		</script>
</xsl:template>

</xsl:stylesheet>
