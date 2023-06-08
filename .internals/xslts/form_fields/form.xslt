<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="form_for_field">
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
				<th class="formCellHead"><label for="{$prefix}code"><nobr>Символьный код</nobr></label></th>
				<td class="formCellFlag">*</td>
				<td class="formCellControls">
					<input class="controlString" type="text" name="code" value="{$form/data/code}" id="{$prefix}code" />
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
				<th class="formCellHead"><nobr><label for="{$prefix}required">Обязательное</label></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls"><nobr>
					<input class="controlCheckbox" type="checkbox" name="required" value="1" id="{$prefix}required">
						<xsl:if test="number($form/data/required)&gt;0"><xsl:attribute name="checked"/></xsl:if>
					</input>
					
				</nobr></td>
			</tr>
			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}comment"><nobr>Комментарий</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}comment_anchor">
						<td class="flatCell">
							<textarea class="controlString" name="comment" id="{$prefix}comment" rows="5">
								<xsl:value-of select="$form/data/comment"/>
							</textarea>
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, 'comment')"/></xsl:call-template>
						</td>
					</tr></table>
				</td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}type"><nobr>Тип</nobr></label></th>
				<td class="formCellFlag">*</td>
				<td class="formCellControl">
					<select class="controlSelect" name="type" id="{$prefix}type">
						<option value="TextField">
							<xsl:if test="$form/data/type='TextField'"><xsl:attribute name="selected"/></xsl:if>
							<xsl:text>Текстовое поле</xsl:text>
						</option>
						<option value="TextArea">
							<xsl:if test="$form/data/type='TextArea'"><xsl:attribute name="selected"/></xsl:if>
							<xsl:text>Текстовая область</xsl:text>
						</option>
						<option value="Select">
							<xsl:if test="$form/data/type='Select'"><xsl:attribute name="selected"/></xsl:if>
							<xsl:text>Список значений</xsl:text>
						</option>
						<option value="SelectList">
							<xsl:if test="$form/data/type='SelectList'"><xsl:attribute name="selected"/></xsl:if>
							<xsl:text>Список из базы данных</xsl:text>
						</option>
						<option value="Email">
							<xsl:if test="$form/data/type='Email'"><xsl:attribute name="selected"/></xsl:if>
							<xsl:text>E-mail</xsl:text>
						</option>
						<option value="DateField">
							<xsl:if test="$form/data/type='DateField'"><xsl:attribute name="selected"/></xsl:if>
							<xsl:text>Дата</xsl:text>
						</option>
						<option value="TimeField">
							<xsl:if test="$form/data/type='TimeField'"><xsl:attribute name="selected"/></xsl:if>
							<xsl:text>Время (спецтип)</xsl:text>
						</option>
						<option value="UploadFile">
							<xsl:if test="$form/data/type='UploadFile'"><xsl:attribute name="selected"/></xsl:if>
							<xsl:text>Файл</xsl:text>
						</option>
						<option value="Gp">
							<xsl:if test="$form/data/type='Gp'"><xsl:attribute name="selected"/></xsl:if>
							<xsl:text>Капча</xsl:text>
						</option>
					</select>
				</td>
			</tr>

			<tr class="formRowOptional variable" id="value_tr">
				<xsl:if test="$form/data/type!='Select'">
					<xsl:attribute name="style">display: none</xsl:attribute>
				</xsl:if>

				<th class="formCellHead"><label for="{$prefix}values"><nobr>Значения</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="fromCellControls">
					<table class="flat">
					<xsl:if test="$form/data/values/*">
					<xsl:for-each select="$form/data/values/value">
						<tr class="flat">
							<td class="flat insertLine">
								<input class="controlString" type="text" name="values[]" value="{.}" />
							</td>
							<td class="flat insertLine" style="padding-left: 5px;">
								<button class="inlineButton {$prefix}items_remove" type="submit" value="1" style="width: 20px; height: 20px;">
									<img src="{/*/system/info/adm_root}img/buttons/delete2.gif" width="20" height="20" alt="исключить"/>
								</button>
							</td>
						</tr>
					</xsl:for-each>
					</xsl:if>
						<tr class="flat">
							<td class="flat insertLine">
								<a href='#' id="{$prefix}insert_additional">Добавить</a>
							</td>
							<td class="flat insertLine" style="padding-left: 5px;">
							</td>
						</tr>
					</table>
				</td>
			</tr>

					<script type="text/javascript">
						$(function(){ var prefix = '<xsl:value-of select="$prefix"/>';
						<![CDATA[
							ajax_add_field(prefix, 'insert_additional', 'values');

							ajax_del_items(prefix, 'items_remove');

							$('#'+prefix+'type').change(function() {
								$('.variable').hide();

								if (this.value == 'Select')
								{
									$('#value_tr').show();

								}else if (this.value == 'SelectList')
								{
									$('#list_tr').show();
								}
							});
						});
					]]></script>

			<tr class="formRowOptional variable" id="list_tr">
				<xsl:if test="$form/data/type!='SelectList'">
					<xsl:attribute name="style">display: none</xsl:attribute>
				</xsl:if>

				<th class="formCellHead"><label for="{$prefix}table"><nobr>Таблица</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="fromCellControls">
					<select class="controlSelect" name="table" id="{$prefix}table">
						<option value="production">
							<xsl:if test="$form/data/table='production'"><xsl:attribute name="selected"/></xsl:if>
							<xsl:text>Продукция</xsl:text>
						</option>
						<option value="services">
							<xsl:if test="$form/data/table='services'"><xsl:attribute name="selected"/></xsl:if>
							<xsl:text>Услуги</xsl:text>
						</option>
						<option value="equipments">
							<xsl:if test="$form/data/table='equipments'"><xsl:attribute name="selected"/></xsl:if>
							<xsl:text>Оборудование</xsl:text>
						</option>
					</select>
				</td>
			</tr>

			<input type="hidden" name="back" value="{$form/data/form}"/>

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
