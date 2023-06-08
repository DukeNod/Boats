<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="form_for_news">
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

			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}ts"><nobr>Дата</nobr></label></th>
				<td class="formCellFlag">*</td>
				<td class="formCellControls">
					<table class="flatTable"><tr class="flatRow">
						<td class="flatCell">
							<input class="controlDateOnly" type="text" name="ts" id="{$prefix}ts">
								<xsl:attribute name="value">
									<xsl:call-template name="datetime_numeric_ru">
										<xsl:with-param name="raw"   select="$form/data/ts" />
										<xsl:with-param name="year"  select="$form/data/ts_parsed/year" />
										<xsl:with-param name="month" select="$form/data/ts_parsed/month"/>
										<xsl:with-param name="day"   select="$form/data/ts_parsed/day"  />
									</xsl:call-template>
								</xsl:attribute>
							</input>
						</td>
						<td class="flatCell">
							<xsl:call-template name="calendar_dateonly"><xsl:with-param name="id" select="concat($prefix, 'ts')"/></xsl:call-template>
						</td>
					</tr></table>
				</td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}title"><nobr>Название</nobr></label></th>
				<td class="formCellFlag">*</td>
				<td class="formCellControls">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}title_anchor">
						<td class="flatCell">
							<input class="controlString" type="text" name="title" value="{$form/data/title}" id="{$prefix}title" />
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, 'title')"/></xsl:call-template>
						</td>
					</tr></table>
				</td>
			</tr>

			<input type="hidden" name="group" value="{$form/data/group}"/>
			<input type="hidden" name="domain" value="{$form/data/domain}"/>

			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}short"><nobr>Аннотация</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls"><nobr>
					<table class="flatTable"><tr class="flatRow" id="{$prefix}short_anchor">
						<td class="flatCell">
							<textarea class="controlString" name="short" rows="5" id="{$prefix}short">
								<xsl:value-of select="$form/data/short"/>
							</textarea>
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, 'short')"/></xsl:call-template>
						</td>
					</tr></table>
				</nobr></td>
			</tr>

			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}item"><nobr>Галереи</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="fromCellControls">
					<table class="flat">
					<xsl:for-each select="$form/data/gallery/gallery">
					<xsl:variable name="sel_item" select="/*/enums/names-for-items/gallery[id=current()/id]"/>
						<tr class="flat">
							<td class="flat" style="vertical-align: middle;">
								<input type="hidden" name="items_list[{position()}][id]" value="{id}"/>
								<xsl:value-of select="/*/enums/gallery_groups/gallery_group[id=$sel_item/group]/name" disable-output-escaping="yes"/> -&gt;
								<xsl:value-of select="$sel_item/name" disable-output-escaping="yes"/>
							</td>
							<td class="flat" style="padding-left: 5px;">
								<button class="inlineButton {$prefix}items_remove" type="submit" name="items_list[{position()}][remove]" value="1" style="width: 20px; height: 20px;">
									<img src="{/*/system/info/adm_root}img/buttons/delete2.gif" width="20" height="20" alt="исключить"/>
								</button>
							</td>
						</tr>
					</xsl:for-each>
						<tr class="flat">
							<td class="flat">
								<select class="controlSelect" name="group" id="{$prefix}group">
									<option value="">Выберите группу</option>
									<option value="0">Без группы</option>
									<xsl:for-each select="/*/enums/gallery_groups/gallery_group">
										<option value="{id}">
											<xsl:value-of select="name"/>
										</option>
									</xsl:for-each>
								</select><span id="{$prefix}filter_status"></span>
							</td>
							<td class="flat" style="padding-left: 5px;">
								<noscript>
								<button class="inlineButton {$prefix}items_refresh" type="submit" name="items_refresh" value="1" style="width: 20px; height: 20px;">
									<img src="{/*/system/info/adm_root}img/buttons/refesh0.gif" width="20" height="20" alt="обновить"/>
								</button>
								</noscript>
							</td>
						</tr>
						<tr class="flat">
							<td class="flat">
								<select class="controlSelect" name="items_list[new][id]" id="{$prefix}items_new">
									<option value="">Выберите галерею</option>
								</select>
							</td>
							<td class="flat" style="padding-left: 5px;">
								<noscript>
								<button class="inlineButton {$prefix}items_append" type="submit" name="items_list[new][append]" value="1" style="width: 20px; height: 20px;">
									<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="20" height="20" alt="добавить"/>
								</button>
								</noscript>
							</td>
						</tr>
					</table>
					<script type="text/javascript">
						$(function(){ var prefix = '<xsl:value-of select="$prefix"/>';
						<![CDATA[
							ajax_update_items(prefix, 'group', 'items_new', 'gallery/ajax', 'ajax_elemental', 'group');
							ajax_add_items(prefix, 'items_new', 'group');
							ajax_del_items(prefix, 'items_remove');

						]]>
						});
					</script>
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
