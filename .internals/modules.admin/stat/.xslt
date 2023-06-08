<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/admin.xslt"/>
<xsl:include href="../../xslts/_common_/lists.xslt" />
<xsl:include href="../../xslts/_common_/admin_quick_filters.xslt" />
<xsl:include href="./conf.xslt"/>


<xsl:template match="/" mode="overrideable_selector">
	<xsl:value-of select="$essence"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:value-of select="$essence_title"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="$essence_title"/></xsl:call-template>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">

		<xsl:call-template name="filters_block">
			<xsl:with-param name="rows">
			        <xsl:apply-templates select="/*/filters/*" mode="admin_quick_filters"/>
			</xsl:with-param>
		</xsl:call-template>
	
	<table class="formTable">
		<col width="1"/><col width="1"/><col width="*"/>
		
		<tr class="formRow formRowOptional">
			<th class="formCellHead"><label><nobr>Всего запросов</nobr></label></th>
			<td class="formCellFlag"></td>
			<td class="formCellControl">
				<xsl:value-of select="/*/stat/all" disable-output-escaping="yes"/>
			</td>
		</tr>
		
		<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
		
		<tr class="formRowRequired">
			<th class="formCellHead" colspan="3"><nobr><strong>Текущие статусы дел</strong></nobr></th>
		</tr>
			
		<xsl:for-each select="/*/stat/states/state">
		<tr class="formRow formRowOptional">
			<th class="formCellHead"><label><nobr><xsl:apply-templates select="state" mode="state_title"/></nobr></label></th>
			<td class="formCellFlag"></td>
			<td class="formCellControl">
				<xsl:value-of select="cnt" disable-output-escaping="yes"/>
			</td>
		</tr>
		</xsl:for-each>

		<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
		
		<tr class="formRowRequired">
			<th class="formCellHead" colspan="3"><nobr><strong>По гостиницам</strong></nobr></th>
		</tr>
			
		<xsl:for-each select="/*/stat/hotels/hotel">
			<tr class="formRowRequired">
				<th class="formCellHead" colspan="3"><nobr style="font-size: 15px"><xsl:value-of select="hotel" disable-output-escaping="yes"/></nobr></th>
			</tr>
			<tr class="formRow formRowOptional">
				<th class="formCellHead"><label><nobr>Всего</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl">
					<xsl:value-of select="cnt" disable-output-escaping="yes"/>
				</td>
			</tr>
			<tr class="formRow formRowOptional">
				<th class="formCellHead"><label><nobr>Создано</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl">
					<xsl:value-of select="created" disable-output-escaping="yes"/>
				</td>
			</tr>
			<tr class="formRow formRowOptional">
				<th class="formCellHead"><label><nobr>Отправлено</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl">
					<xsl:value-of select="sent" disable-output-escaping="yes"/>
				</td>
			</tr>
			<tr class="formRow formRowOptional">
				<th class="formCellHead"><label><nobr>Обработано</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl">
					<xsl:value-of select="processed" disable-output-escaping="yes"/>
				</td>
			</tr>
			<tr class="formRow formRowOptional">
				<th class="formCellHead"><label><nobr>Закрыто</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl">
					<xsl:value-of select="closed" disable-output-escaping="yes"/>
				</td>
			</tr>
			<tr class="formRow formRowOptional">
				<th class="formCellHead"><label><nobr>Подписано</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl">
					<xsl:value-of select="signed" disable-output-escaping="yes"/>
				</td>
			</tr>
			<tr class="formRow formRowOptional">
				<th class="formCellHead"><label><nobr>Успешно</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl">
					<xsl:value-of select="result" disable-output-escaping="yes"/>
				</td>
			</tr>
			<tr class="formRow formRowOptional">
				<th class="formCellHead"><label><nobr>С ошибками</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl">
					<xsl:value-of select="error" disable-output-escaping="yes"/>
				</td>
			</tr>
			<!--xsl:for-each select="state/state">
				<tr class="formRow formRowOptional">
					<th class="formCellHead"><label><nobr><xsl:apply-templates select="state" mode="state_title"/></nobr></label></th>
					<td class="formCellFlag"></td>
					<td class="formCellControl">
						<xsl:value-of select="cnt" disable-output-escaping="yes"/>
					</td>
				</tr>
			</xsl:for-each-->
			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
		</xsl:for-each>
	</table>

</xsl:template>

<xsl:template match="state" mode="state_title">
	
	<xsl:choose>
		<xsl:when test=". = 'sent'">Отправлено</xsl:when>
		<xsl:when test=". = 'processed'">Обработано</xsl:when>
		<xsl:when test=". = 'created'">Создано</xsl:when>
		<xsl:when test=". = 'closed'">Закрыто</xsl:when>
	</xsl:choose>
	
</xsl:template>

</xsl:stylesheet>
