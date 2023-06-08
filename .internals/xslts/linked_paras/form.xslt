<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="form_for_linked_para">
	<xsl:param name="form"   select="/.."/>
	<xsl:param name="back"   select="/*/system/back_raw"/>
	<xsl:param name="action" select="/*/system/curr_raw"/>
	<xsl:param name="button"     select="/.."/>
	<xsl:param name="button_w"   select="/.."/>
	<xsl:param name="button_h"   select="/.."/>
	<xsl:param name="button_img" select="/.."/>
	<xsl:param name="button_alt" select="/.."/>
	<xsl:param name="prefix"     select="'_'"/>
	<xsl:param name="uplink_type"/>
	<xsl:param name="uplink_id"/>
<p>
<h3>Язык: <xsl:value-of select="/*/languages/lang[code=/*/language]/name"/></h3>
</p>
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
				<th class="formCellHead"><label for="{$prefix}clear"><nobr>Обтекание параграфа</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<select class="controlSelect" name="clear" id="{$prefix}clear">
						<option value="none">
							<xsl:if test="string($form/data/clear)='none'"><xsl:attribute name="selected"/></xsl:if>
							Разрешить полностью
						</option>
						<option value="both">
							<xsl:if test="string($form/data/clear)='both'"><xsl:attribute name="selected"/></xsl:if>
							Сбросить с обеих сторон
						</option>
						<option value="left">
							<xsl:if test="string($form/data/clear)='left'"><xsl:attribute name="selected"/></xsl:if>
							Сбросить слева, разрешить справа
						</option>
						<option value="right">
							<xsl:if test="string($form/data/clear)='right'"><xsl:attribute name="selected"/></xsl:if>
							Сбросить справа, резрешить слева
						</option>
					</select>
				</td>
			</tr>
			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}align"><nobr>Выравнивание текста</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<select class="controlSelect" name="align" id="{$prefix}align">
						<option value="left">
							<xsl:if test="string($form/data/align)='left'"><xsl:attribute name="selected"/></xsl:if>
							Влево
						</option>
						<option value="right">
							<xsl:if test="string($form/data/align)='right'"><xsl:attribute name="selected"/></xsl:if>
							Вправо
						</option>
						<option value="center">
							<xsl:if test="string($form/data/align)='center'"><xsl:attribute name="selected"/></xsl:if>
							По центру
						</option>
						<option value="justify">
							<xsl:if test="string($form/data/align)='justify'"><xsl:attribute name="selected"/></xsl:if>
							По ширине
						</option>
					</select>
				</td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}name"><nobr>Заголовок</nobr></label></th>
				<td class="formCellFlag"></td>
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
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}text"><nobr>Текст</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls"><nobr>
					<table class="flatTable"><tr class="flatRow" id="{$prefix}text_anchor">
						<td class="flatCell">
							<textarea class="controlString" name="text" rows="15" id="{$prefix}text">
								<xsl:value-of select="$form/data/text"/>
								<xsl:value-of select="''"/>
							</textarea>
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, 'text')"/></xsl:call-template>
						</td>
					</tr></table>
				</nobr></td>
			</tr>
<!--!!!todo: это я пытался сделать выбор вырванивания и обтекания картинками как у тулбаре
			<tr class="formRow">
				<th class="formCellOptional formCellHead">
					<nobr>Поток текста</nobr>
				</th>
				<td class="formCellOptional formCellControls">
					<input type="radio" name="align" value="left"    id="new_linked_para_align_left"   ><xsl:if test="string($form/data/align)='left'   "><xsl:attribute name="checked"/></xsl:if></input><label for="new_linked_para_align_left"   ><img src="{/*/system/info/adm_root}img/text/align_left.gif"    alt="Влево"     width="32" height="16"/></label><xsl:text>&nbsp;&nbsp;</xsl:text>
					<input type="radio" name="align" value="right"   id="new_linked_para_align_right"  ><xsl:if test="string($form/data/align)='right'  "><xsl:attribute name="checked"/></xsl:if></input><label for="new_linked_para_align_right"  ><img src="{/*/system/info/adm_root}img/text/align_right.gif"   alt="Вправо"    width="32" height="16"/></label><xsl:text>&nbsp;&nbsp;</xsl:text>
					<input type="radio" name="align" value="center"  id="new_linked_para_align_center" ><xsl:if test="string($form/data/align)='center' "><xsl:attribute name="checked"/></xsl:if></input><label for="new_linked_para_align_center" ><img src="{/*/system/info/adm_root}img/text/align_center.gif"  alt="По центру" width="32" height="16"/></label><xsl:text>&nbsp;&nbsp;</xsl:text>
					<input type="radio" name="align" value="justify" id="new_linked_para_align_justify"><xsl:if test="string($form/data/align)='justify'"><xsl:attribute name="checked"/></xsl:if></input><label for="new_linked_para_align_justify"><img src="{/*/system/info/adm_root}img/text/align_justify.gif" alt="По ширине" width="32" height="16"/></label>
				</td>
			</tr>
-->

			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}float"><nobr>Положение изображения</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<select class="controlSelect" name="float" id="{$prefix}float">
						<option value="above_center"><xsl:if test="string($form/data/float)='above_center'"><xsl:attribute name="selected"/></xsl:if>По центру над текстом</option>
						<option value="above_left"  ><xsl:if test="string($form/data/float)='above_left'  "><xsl:attribute name="selected"/></xsl:if>Слева над текстом</option>
						<option value="above_right" ><xsl:if test="string($form/data/float)='above_right' "><xsl:attribute name="selected"/></xsl:if>Справа над текстом</option>
						<option value="below_center"><xsl:if test="string($form/data/float)='below_center'"><xsl:attribute name="selected"/></xsl:if>По центру под текстом</option>
						<option value="below_left"  ><xsl:if test="string($form/data/float)='below_left'  "><xsl:attribute name="selected"/></xsl:if>Слева под текстом</option>
						<option value="below_right" ><xsl:if test="string($form/data/float)='below_right' "><xsl:attribute name="selected"/></xsl:if>Справа под текстом</option>
						<option value="float_left"  ><xsl:if test="string($form/data/float)='float_left'  "><xsl:attribute name="selected"/></xsl:if>Слева, текст обтекает справа</option>
						<option value="float_right" ><xsl:if test="string($form/data/float)='float_right' "><xsl:attribute name="selected"/></xsl:if>Справа, текст обтекает слева</option>
						<option value="table_left"  ><xsl:if test="string($form/data/float)='table_left'  "><xsl:attribute name="selected"/></xsl:if>Слева, текст колонкой справа</option>
						<option value="table_right" ><xsl:if test="string($form/data/float)='table_right' "><xsl:attribute name="selected"/></xsl:if>Справа, текст колонкой слева</option>
					</select>
				</td>
			</tr>

			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}alt"><nobr>Комментарий</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}alt_anchor">
						<td class="flatCell">
							<input class="controlString" type="text" name="alt" value="{$form/data/alt}" id="{$prefix}alt" />
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, 'alt')"/></xsl:call-template>
						</td>
					</tr></table>
				</td>
			</tr>

			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}url"><nobr>URL с картинки</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<input class="controlString" type="text" name="url" value="{$form/data/url}" id="{$prefix}url" />
				</td>
			</tr>

			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}small"><nobr>Маленькая картинка</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<input class="controlAttach" type="file"   name="small" id="{$prefix}small"/>
					<xsl:if test="($form/config/small_limit_w != '') or ($form/config/small_limit_h != '')">
					(<xsl:value-of select="$form/config/small_limit_w" />x<xsl:value-of select="$form/config/small_limit_h" /> px)
					</xsl:if>
					<input class="controlHidden" type="hidden" name="small_temp" value="{$form/data/small_temp}"/>
				</td>
			</tr>
		<xsl:if test="$form/errors/small_exists or $form/errors/large_exists">
			<tr class="formRowRecovery">
				<th class="formCellHead"><label for="{$prefix}small_name"><nobr>Имя файла м.картинки</nobr></label></th>
				<td class="formCellFlag">&gt;</td>
				<td class="formCellControls">
					<input class="controlString" type="text" name="small_name" value="{$form/data/small_name}" id="{$prefix}small_name"/>
				</td>
			</tr>
		</xsl:if>

			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}large"><nobr>Большая картинка</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<input class="controlAttach" type="file"   name="large" id="{$prefix}large"/>
					<xsl:if test="($form/config/large_limit_w != '') or ($form/config/large_limit_h != '')">
					(<xsl:value-of select="$form/config/large_limit_w" />x<xsl:value-of select="$form/config/large_limit_h" /> px)
					</xsl:if>
					<xsl:if test="$form/config/resize = 1">
					<br/>(Если загрузить только большое изображиение, остальные сформируются автоматический)
					</xsl:if>
					<input class="controlHidden" type="hidden" name="large_temp" value="{$form/data/large_temp}"/>
				</td>
			</tr>
		<xsl:if test="$form/errors/small_exists or $form/errors/large_exists">
			<tr class="formRowRecovery">
				<th class="formCellHead"><label for="{$prefix}large_name"><nobr>Имя файла б.картинки</nobr></label></th>
				<td class="formCellFlag">&gt;</td>
				<td class="formCellControls">
					<input class="controlString" type="text" name="large_name" value="{$form/data/large_name}" id="{$prefix}large_name"/>
				</td>
			</tr>
		</xsl:if>

			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}position"><nobr>Позиция</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
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
						<xsl:for-each select="/*/enums[@for='linked_paras']/siblings/*[id!=$form/id or not($form)]">
							<option value="&gt;{id}">
								<xsl:if test="$form/data/position=concat('&gt;', id)"><xsl:attribute name="selected"/></xsl:if>
								<xsl:text>После №</xsl:text>
								<xsl:value-of select="position"/>
								<xsl:text>: "</xsl:text>
								<xsl:value-of select="name"/>
								<xsl:text>"</xsl:text>
							</option>
						</xsl:for-each>
					</select>
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

		<xsl:if test="($form/data/small_temp!='') or ($form/data/small_file!='')">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRowView">
				<th class="formCellHead">
					<nobr>Маленькая картинка</nobr>
					<br/>
					<input type="checkbox" name="small_delete" value="1" id="{$prefix}small_delete">
						<xsl:if test="number($form/data/small_delete)&gt;0"><xsl:attribute name="checked"/></xsl:if>
					</input>
					<label for="{$prefix}small_delete">Удалить</label>
				</th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<xsl:call-template name="media">
						<xsl:with-param name="src">
							<xsl:choose>
							<xsl:when test="$form/data/small_temp!=''"><xsl:value-of select="concat(/*/system/info/adm_to_tmp_for_linked, $form/data/small_temp)"/></xsl:when>
							<xsl:when test="$form/data/small_file!=''"><xsl:value-of select="concat(/*/system/info/adm_to_dir_for_linked, 'paras/small/', $form/data/uplink_type, '/', $form/data/uplink_id, '/', $form/data/small_file)"/></xsl:when>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>

		<xsl:if test="($form/data/large_temp!='') or ($form/data/large_file!='')">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRowView">
				<th class="formCellHead">
					<nobr>Большая картинка</nobr>
					<br/>
					<input type="checkbox" name="large_delete" value="1" id="{$prefix}large_delete">
						<xsl:if test="number($form/data/large_delete)&gt;0"><xsl:attribute name="checked"/></xsl:if>
					</input>
					<label for="{$prefix}large_delete">Удалить</label>
				</th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<xsl:call-template name="media">
						<xsl:with-param name="src">
							<xsl:choose>
							<xsl:when test="$form/data/large_temp!=''"><xsl:value-of select="concat(/*/system/info/adm_to_tmp_for_linked, $form/data/large_temp)"/></xsl:when>
							<xsl:when test="$form/data/large_file!=''"><xsl:value-of select="concat(/*/system/info/adm_to_dir_for_linked, 'paras/large/', $form/data/uplink_type, '/', $form/data/uplink_id, '/', $form/data/large_file)"/></xsl:when>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>

		</table>

		<!--
		Если форма выводится по конкретным данным, то выводим аплинк оттуда.
		Если форма (добавления) выводится в списке, то берём аплинк как там для списка указано.
		-->
		<xsl:choose>
		<xsl:when test="$form">
			<input type="hidden" name="uplink_type" value="{$form/data/uplink_type}" />
			<input type="hidden" name="uplink_id"   value="{$form/data/uplink_id}"   />
		</xsl:when>
		<xsl:when test="$uplink_type and $uplink_id">
			<input type="hidden" name="uplink_type" value="{$uplink_type}" />
			<input type="hidden" name="uplink_id"   value="{$uplink_id}"   />
		</xsl:when>
		</xsl:choose>
		<input type="hidden" name="back" value="{$back}"/>
	</form>
</xsl:template>



</xsl:stylesheet>
