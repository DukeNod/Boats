<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="form_for_meta">
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

			<!--tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}name"><nobr>Название страницы</nobr></label></th>
				<td class="formCellFlag">&nbsp;</td>
				<td class="formCellControls">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}name_anchor">
						<td class="flatCell">
							<input class="controlString" type="text" name="name" value="{$form/data/name}" id="{$prefix}name" />
						</td>
						<td class="flatCell">
							&nbsp;
						</td>
					</tr></table>
				</td>
			</tr-->
			
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}url"><nobr>Url с "/" в начале и в конце!!!</nobr></label></th>
				<td class="formCellFlag">*</td>
				<td class="formCellControls">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}url_anchor">
						<td class="flatCell">
							<input class="controlString" type="text" name="url" value="{$form/data/url}" id="{$prefix}url" />
						</td>
						<td class="flatCell">
							&nbsp;
						</td>
					</tr></table>
				</td>
			</tr>
			
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}title"><nobr>Meta-заголовок (title)</nobr></label></th>
				<td class="formCellFlag">&nbsp;</td>
				<td class="formCellControls"><nobr>
					<table class="flatTable"><tr class="flatRow" id="{$prefix}title_anchor">
						<td class="flatCell">
							<textarea class="controlString" name="title" rows="5" id="{$prefix}title">
								<xsl:value-of select="$form/data/title"/>
							</textarea>
						</td>
						<td class="flatCell">
							&nbsp;
						</td>
					</tr></table>
				</nobr></td>
			</tr>
			
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}description"><nobr>Meta-описание (description)</nobr></label></th>
				<td class="formCellFlag">&nbsp;</td>
				<td class="formCellControls"><nobr>
					<table class="flatTable"><tr class="flatRow" id="{$prefix}description_anchor">
						<td class="flatCell">
							<textarea class="controlString" name="description" rows="5" id="{$prefix}description">
								<xsl:value-of select="$form/data/description"/>
							</textarea>
						</td>
						<td class="flatCell">
							&nbsp;
						</td>
					</tr></table>
				</nobr></td>
			</tr>
			
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}keywords"><nobr>Meta-ключевики (keywords)</nobr></label></th>
				<td class="formCellFlag">&nbsp;</td>
				<td class="formCellControls"><nobr>
					<table class="flatTable"><tr class="flatRow" id="{$prefix}description_anchor">
						<td class="flatCell">
							<textarea class="controlString" name="keywords" rows="5" id="{$prefix}keywords">
								<xsl:value-of select="$form/data/keywords"/>
							</textarea>
						</td>
						<td class="flatCell">
							&nbsp;
						</td>
					</tr></table>
				</nobr></td>
			</tr>
			
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}counters"><nobr>Счетчики</nobr></label></th>
				<td class="formCellFlag">&nbsp;</td>
				<td class="formCellControls"><nobr>
					<table class="flatTable"><tr class="flatRow" id="{$prefix}counters_anchor">
						<td class="flatCell">
							<textarea class="controlString" name="counters" rows="5" id="{$prefix}counters">
								<xsl:value-of select="$form/data/counters"/>
							</textarea>
						</td>
						<td class="flatCell">
							&nbsp;
						</td>
					</tr></table>
				</nobr></td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}h1"><nobr>H1</nobr></label></th>
				<td class="formCellFlag">&nbsp;</td>
				<td class="formCellControls"><nobr>
					<textarea class="controlString" name="h1" rows="5" id="{$prefix}h1">
						<xsl:value-of select="$form/data/h1"/>
					</textarea>
				</nobr></td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}footer"><nobr>Подвал</nobr></label></th>
				<td class="formCellFlag">&nbsp;</td>
				<td class="formCellControls"><nobr>
					<textarea class="controlString" name="footer" rows="5" id="{$prefix}footer">
						<xsl:value-of select="$form/data/footer"/>
					</textarea>
				</nobr></td>
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
