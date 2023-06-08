<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="view_for_news">
	<xsl:param name="form"   select="/.."/>
	<xsl:param name="back"   select="/*/system/back_raw"/>
	<xsl:param name="action" select="/*/system/curr_raw"/>
	<xsl:param name="button"     select="/.."/>
	<xsl:param name="button_w"   select="/.."/>
	<xsl:param name="button_h"   select="/.."/>
	<xsl:param name="button_img" select="/.."/>
	<xsl:param name="button_alt" select="/.."/>
	<xsl:param name="prefix"     select="'_'"/>

	<form class="form" enctype="multipart/form-data" method="post" action="{$action}">
		<table class="formTable">
			<col width="1"/><col width="1"/><col width="*"/>
	
		<xsl:if test="$form/errors/*">
			<tr class="formRowErrors">
				<th class="formCellHead"></th>
				<td class="formCellFlag"></td>
				<td class="formCellErrors">
					<xsl:apply-templates select="$form/errors/*" mode="div"/>
				</td>
			</tr>
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
		</xsl:if>

			<tr class="formRowView">
				<th class="formCellHead"><nobr>Дата</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:call-template name="datetime_numeric_ru">
						<xsl:with-param name="raw"   select="$form/data/ts" />
						<xsl:with-param name="year"  select="$form/data/ts_parsed/year" />
						<xsl:with-param name="month" select="$form/data/ts_parsed/month"/>
						<xsl:with-param name="day"   select="$form/data/ts_parsed/day"  />
					</xsl:call-template>
				</td>
			</tr>
			<tr class="formRowView">
				<th class="formCellHead"><nobr>Название</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="$form/data/title" disable-output-escaping="yes"/>
				</td>
			</tr>
			<tr class="formRowView">
				<th class="formCellHead"><nobr>Аннотация</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="$form/data/short" disable-output-escaping="yes"/>
				</td>
			</tr>

		<xsl:if test="$button or $button_alt!='' or $button_img!=''">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRowCommands">
				<th class="formCellHead"></th>
				<td class="formCellFlag"></td>
				<td class="formCellCommands">
					<table class="flatTable"><tr class="flatRow">
						<td class="flatCell">
							<button class="inlineButton" type="submit">
								<xsl:copy-of select="$button"/>
								<xsl:if test="not($button)">
									<xsl:attribute name="style">width: <xsl:value-of select="$button_w"/>px; height: <xsl:value-of select="$button_h"/>px;</xsl:attribute>
									<img src="{/*/system/info/adm_root}img/buttons/submit_{$button_img}.gif" width="{$button_w}" height="{$button_h}" alt="{$button_alt}"/>
								</xsl:if>
							</button>
						</td>
					</tr></table>
				</td>
			</tr>
		</xsl:if>

		</table>
		<input type="hidden" name="back" value="{$back}"/>
	</form>
</xsl:template>



</xsl:stylesheet>
