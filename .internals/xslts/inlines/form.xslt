<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="form_for_inline">
	<xsl:param name="form"       select="/.."/>
	<xsl:param name="back"       select="/*/system/back_raw"/>
	<xsl:param name="action"     select="/*/system/curr_raw"/>
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
				<th class="formCellHead"><label for="{$prefix}label"><nobr>Метка</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<nobr><xsl:value-of select="$form/data/label" disable-output-escaping="yes"/></nobr>
				</td>
			</tr>
			<tr class="formRowView">
				<th class="formCellHead"><label for="{$prefix}comment"><nobr>Примечание</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="$form/data/comment" disable-output-escaping="yes"/>
				</td>
			</tr>

		<xsl:if test="$form/data/mode='content'">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}content"><nobr>"Сырой" контент</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}content_anchor">
						<td class="flatCell">
							<textarea class="controlString" name="content" rows="25" id="{$prefix}content" style="width: 50em;">
								<xsl:value-of select="$form/data/content"/>
								<xsl:value-of select="''"/>
							</textarea>
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, 'content')"/></xsl:call-template>
						</td>
					</tr></table>
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
		</xsl:if>

		</table>
		<input type="hidden" name="back" value="{$back}"/>
	</form>
</xsl:template>

<xsl:template name="form_for_inline_full">
	<xsl:param name="form"       select="/.."/>
	<xsl:param name="back"       select="/*/system/back_raw"/>
	<xsl:param name="action"     select="/*/system/curr_raw"/>
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

			<tr class="formRowOptional">
				<th class="formCellHead"><nobr>Группа</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl">
					<select class="controlSelect" name="group" id="{$prefix}group">
						<option>
						        <xsl:if test="$form/data/group = 'text'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
							<xsl:text>text</xsl:text>
						</option>
						<option>
						        <xsl:if test="$form/data/group = 'meta'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
							<xsl:text>meta</xsl:text>
						</option>
						<option>
						        <xsl:if test="$form/data/group = 'html'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
							<xsl:text>html</xsl:text>
						</option>
						<option>
						        <xsl:if test="$form/data/group = 'words'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
							<xsl:text>words</xsl:text>
						</option>
					</select>
				</td>
			</tr>
			<tr class="formRowOptional">
				<th class="formCellHead"><nobr>Тип</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl">
					<select class="controlSelect" name="mode" id="{$prefix}mode">
						<option>
						        <xsl:if test="$form/data/mode = 'content'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
							<xsl:text>content</xsl:text>
						</option>
						<option>
						        <xsl:if test="$form/data/group = 'linked'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
							<xsl:text>linked</xsl:text>
						</option>
					</select>
				</td>
			</tr>
			<tr class="formRowView">
				<th class="formCellHead"><label for="{$prefix}label"><nobr>Метка</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<input class="controlString" type="text" name="label" value="{$form/data/label}" id="{$prefix}label" />
				</td>
			</tr>
			<tr class="formRowView">
				<th class="formCellHead"><label for="{$prefix}comment"><nobr>Примечание</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<textarea class="controlString" name="comment" rows="15" id="{$prefix}comment" style="width: 50em;">
						<xsl:value-of select="$form/data/comment"/>
					</textarea>
				</td>
			</tr>

		<xsl:if test="$form/data/mode='content'">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}content"><nobr>"Сырой" контент</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}content_anchor">
						<td class="flatCell">
							<textarea class="controlString" name="content" rows="25" id="{$prefix}content" style="width: 50em;">
								<xsl:value-of select="$form/data/content"/>
								<xsl:value-of select="''"/>
							</textarea>
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, 'content')"/></xsl:call-template>
						</td>
					</tr></table>
				</td>
			</tr>
		</xsl:if>

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
