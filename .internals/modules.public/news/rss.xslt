<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/_all_.xslt"/>
<xsl:include href="../../xslts/_common_/dates.xslt"/>



<xsl:output 
	method="xml"
	cdata-section-elements="description title"
/>



<!--
WARNING:
Принуждение к московскому времени, причём без учёта реального часового пояса.
Потому как он не опеделяется ни в поле из базы, ни в //system/now.
А если б и определялся в //system/now, то всё равно надо использовать то,
что хранилось бы в поле (дата публикации), а оно не хранится.
-->

<xsl:template match="/">

	<rss version="2.0">
		<channel>
			<language>ru-ru</language>
			<title>М.П.А. Медицинские партнеры</title>
			<link><xsl:value-of select="/*/system/info/pub_site"/></link>
<!--???			<description></description>-->
<!--???			<pubDate>Tue, 10 Jun 2003 04:00:00 GMT</pubDate>-->
<!--???			<lastBuildDate>Tue, 10 Jun 2003 09:41:01 GMT</lastBuildDate>-->
 			<xsl:for-each select="/*/news/news">
				<item>
					<guid><xsl:value-of select="/*/system/info/pub_site"/>news/<xsl:value-of select="id"/></guid>
					<link><xsl:value-of select="/*/system/info/pub_site"/>news/<xsl:value-of select="id"/></link>

					<xsl:for-each select="linked_picts/linked_pict[1]">
					<enclosure url="{/*/system/info/pub_site}{small_href}"/>
					</xsl:for-each>

					<!--
					Workaround с декодированием entity нужно чтобы пофиксить тот баг, что IE в своём RSS-reader'е показывает entity "как есть", но только в заголовке, а не в тексте.
					А по-хорошему, вообще всё стоит передевать без entity, а в unicode-символах.
					-->
					<title><xsl:value-of select="php:function('html_entity_decode', string(title), 0, 'utf-8')" disable-output-escaping="yes"/></title>
					<description><xsl:value-of select="short" disable-output-escaping="yes"/></description>

					<pubDate>
						<xsl:call-template name="datetime_rfc822">
							<xsl:with-param name="year"   select="ts_parsed/year"/>
							<xsl:with-param name="month"  select="ts_parsed/month"/>
							<xsl:with-param name="day"    select="ts_parsed/day"/>
							<xsl:with-param name="hour"   select="ts_parsed/hour"/>
							<xsl:with-param name="minute" select="ts_parsed/minute"/>
							<xsl:with-param name="second" select="ts_parsed/second"/>
							<xsl:with-param name="zone"   select="'+0300'"/>
						</xsl:call-template>
					</pubDate>
				</item>
			</xsl:for-each>
		</channel>
	</rss>
</xsl:template>



</xsl:stylesheet>
