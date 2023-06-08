<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="form_for_article">
	<xsl:param name="form"   select="/.."/>
	<xsl:param name="back"   select="/*/system/back_raw"/>
	<xsl:param name="action" select="/*/system/curr_raw"/>
	<xsl:param name="button"     select="/.."/>
	<xsl:param name="button_w"   select="/.."/>
	<xsl:param name="button_h"   select="/.."/>
	<xsl:param name="button_img" select="/.."/>
	<xsl:param name="button_alt" select="/.."/>
	<xsl:param name="prefix" select="'_'"/>
	<xsl:param name="desc_list" />

	<form enctype="multipart/form-data" method="post" action="{$action}">
		<table class="formTable">
			<col width="1"/><col width="1"/><col width="*"/>
	
		<xsl:if test="$form/errors/*">
			<tr class="formRow formRowErrors">
				<th class="formCellHead"></th>
				<td class="formCellFlag"></td>
				<td class="formCellErrors">
					<xsl:apply-templates select="$form/errors/*" mode="div"/>
				</td>
			</tr>
			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
		</xsl:if>
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}mr"><nobr>mod_rewrite</nobr></label></th>
				<td class="formCellFlag">*</td>
				<td class="formCellControls">
					<input class="controlString" type="text" name="mr" value="{$form/data/mr}" id="{$prefix}mr" />
				</td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}name"><nobr>Название</nobr></label></th>
				<td class="formCellFlag">*</td>
				<td class="formCellControls">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}name_anchor">
						<td class="flatCell">
							<input class="controlString" type="text" name="name" value="{$form/data/name}" id="{$prefix}name" />
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, 'name')"/></xsl:call-template>
						</td>
					</tr></table>
				</td>
			</tr>
			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}short"><nobr>Краткое описание</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}short_anchor">
						<td class="flatCell">
							<textarea class="controlString" name="short" id="{$prefix}short" rows="10">
								<xsl:value-of select="$form/data/short"/>
							</textarea>
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, 'short')"/></xsl:call-template>
						</td>
					</tr></table>
				</td>
			</tr>
			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			
			<tr class="formRow formRowOptional">
				<th class="formCellHead"><label for="{$prefix}position"><nobr>Позиция</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl">
					<select class="controlSelect" name="position" id="{$prefix}position">
						<xsl:if test="$form/info/position">
							<option value="{$form/info/position}">
								<xsl:text>Оставить на своём месте</xsl:text>
							</option>
						</xsl:if>
							<option value="&gt;">
								<xsl:if test="$form/data/position='&gt;'"><xsl:attribute name="selected"/></xsl:if>
								<xsl:text>Поместить в конец</xsl:text>
							</option>
							<option value="&lt;">
								<xsl:if test="$form/data/position='&lt;'"><xsl:attribute name="selected"/></xsl:if>
								<xsl:text>Поместить в начало</xsl:text>
							</option>
						<xsl:for-each select="/*/enums[@for=$essence]/siblings/*[id!=$form/id or not($form)]">
							<option value="&gt;{id}">
								<xsl:if test="$form/data/position=concat('&gt;', id)"><xsl:attribute name="selected"/></xsl:if>
								<xsl:text>После "</xsl:text>
								<xsl:value-of select="name"/>
								<xsl:text>"</xsl:text>
							</option>
						</xsl:for-each>
					</select>
				</td>
			</tr>

			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}item"><nobr>Товары</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="fromCellControls">
					<table class="flat">
					<xsl:for-each select="$form/data/items_list/item">
					<xsl:variable name="id" select="id"/>
					<xsl:variable name="sel_item" select="/*/enums[@for='articles']/names-for-items/item[id=$id]"/>
						<tr class="flat">
							<td class="flat" style="vertical-align: middle;">
								<input type="hidden" name="items_list[{position()}][id]" value="{id}"/>
								<!--!!!todo: path-like name-->
								<xsl:for-each select="$sel_item/parents/parent">
									<xsl:value-of select="name" disable-output-escaping="yes"/> -&gt;
								</xsl:for-each>
								<xsl:value-of select="$sel_item/category_name" disable-output-escaping="yes"/> -&gt;
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
								<select class="controlSelect" name="item_category" id="{$prefix}category">
									<option value="">Выберите категорию</option>
									<xsl:apply-templates select="/*/enums/item_category_tree//category">
									</xsl:apply-templates>
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
									<option value="">Выберите товар</option>
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

							// Процедура обновления списока товаров.
							$('#'+prefix+'category')
							.livequery('change', function(){
								linked_items_update_select(this, prefix, 'items/ajax');
							});

							// Процедура добавления нового товара в список привязанных товаров.
							$('#'+prefix+'items_new')
							.livequery('change', function(){
								linked_items_add(this, prefix, 'category');
							});

							// Процедура удаления товара из списка привязанных товаров.
							$('.'+prefix+'items_remove')
							.livequery('click', function(){
								linked_items_del(this);
							});
						});
					]]></script>
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
									<xsl:attribute name="style">width: <xsl:value-of select="$button_w+4"/>px; height: <xsl:value-of select="$button_h+4"/>px;</xsl:attribute>
									<img src="{/*/system/info/adm_root}img/buttons/submit_{$button_img}.gif" width="{$button_w}" height="{$button_h}" alt="{$button_alt}"/>
								</xsl:if>
							</button>
						</td>
					</tr></table>
				</td>
			</tr>
		</xsl:if>

			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
		</table>
		<input type="hidden" name="back" value="{$back}"/>
	</form>
</xsl:template>

<xsl:template match="category">
	<xsl:param name="id"   select="/.."/>
	<option value="{id}">
		<xsl:if test="$id=id"><xsl:attribute name="selected"/></xsl:if>
		<xsl:call-template name="repeat-string">
			<xsl:with-param name="str" select="'--'"/>
			<xsl:with-param name="cnt" select="@level"/>
	      		<xsl:with-param name="pfx" select="''"/>
		</xsl:call-template>
		<xsl:text> </xsl:text><xsl:value-of select="name"/>
	</option>
</xsl:template>
</xsl:stylesheet>
