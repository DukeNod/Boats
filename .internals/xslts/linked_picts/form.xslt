<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="form_for_linked_pict">
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
				<th class="formCellHead"><label for="{$prefix}small"><nobr>
					<xsl:choose>
					<xsl:when test="$form/config/count=1">Файл картинки</xsl:when>
					<xsl:otherwise>Маленькая картинка</xsl:otherwise>
					</xsl:choose>
					</nobr></label></th>
				<td class="formCellFlag">*</td>
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
				<th class="formCellHead"><label for="{$prefix}small_name"><nobr>Имя файла картинки</nobr></label></th>
				<td class="formCellFlag">&gt;</td>
				<td class="formCellControls">
					<input class="controlString" type="text" name="small_name" value="{$form/data/small_name}" id="{$prefix}small_name"/>
				</td>
			</tr>
		</xsl:if>

		<xsl:if test="$form/config/count = 3">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}middle"><nobr>Средняя картинка</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<input class="controlAttach" type="file"   name="middle" id="{$prefix}middle"/>
					<xsl:if test="($form/config/middle_limit_w != '') or ($form/config/middle_limit_h != '')">
					(<xsl:value-of select="$form/config/middle_limit_w" />x<xsl:value-of select="$form/config/middle_limit_h" /> px)
					</xsl:if>
					<input class="controlHidden" type="hidden" name="middle_temp" value="{$form/data/middle_temp}"/>
				</td>
			</tr>
		<xsl:if test="$form/errors/middle_exists">
			<tr class="formRowRecovery">
				<th class="formCellHead"><label for="{$prefix}middle_name"><nobr>Имя файла с.картинки</nobr></label></th>
				<td class="formCellFlag">&gt;</td>
				<td class="formCellControls">
					<input class="controlString" type="text" name="middle_name" value="{$form/data/middle_name}" id="{$prefix}middle_name"/>
				</td>
			</tr>
		</xsl:if>
		</xsl:if>

		<xsl:if test="$form/config/count > 1">
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
						<xsl:for-each select="/*/enums[@for='linked_picts']/siblings/*[id!=$form/id or not($form)]">
							<option value="&gt;{id}">
								<xsl:if test="$form/data/position=concat('&gt;', id)"><xsl:attribute name="selected"/></xsl:if>
								<xsl:text>После №</xsl:text>
								<xsl:value-of select="position"/>
								<xsl:text>: "</xsl:text>
								<xsl:value-of select="alt"/>
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
			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRow">
				<th class="formCellHead">
					<nobr>
					<xsl:choose>
					<xsl:when test="$form/config/count=1">Файл картинки</xsl:when>
					<xsl:otherwise>Маленькая картинка</xsl:otherwise>
					</xsl:choose>
					</nobr>
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
							<xsl:when test="$form/data/small_file!=''"><xsl:value-of select="concat(/*/system/info/adm_to_dir_for_linked, 'picts/small/', $form/data/uplink_type, '/', $form/data/uplink_id, '/', $form/data/small_file)"/></xsl:when>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>

		<xsl:if test="$form/config/count = 3">
		<xsl:if test="($form/data/middle_temp!='') or ($form/data/middle_file!='')">
			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRow">
				<th class="formCellHead">
					<nobr>Средняя картинка</nobr>
					<br/>
					<input type="checkbox" name="middle_delete" value="1" id="{$prefix}middle_delete">
						<xsl:if test="number($form/data/middle_delete)&gt;0"><xsl:attribute name="checked"/></xsl:if>
					</input>
					<label for="{$prefix}middle_delete">Удалить</label>
				</th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<xsl:call-template name="media">
						<xsl:with-param name="src">
							<xsl:choose>
							<xsl:when test="$form/data/middle_temp!=''"><xsl:value-of select="concat(/*/system/info/adm_to_tmp_for_linked, $form/data/middle_temp)"/></xsl:when>
							<xsl:when test="$form/data/middle_file!=''"><xsl:value-of select="concat(/*/system/info/adm_to_dir_for_linked, 'picts/middle/', $form/data/uplink_type, '/', $form/data/uplink_id, '/', $form/data/middle_file)"/></xsl:when>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		</xsl:if>

		<xsl:if test="$form/config/count > 1">
		<xsl:if test="($form/data/large_temp!='') or ($form/data/large_file!='')">
			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRow">
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
							<xsl:when test="$form/data/large_file!=''"><xsl:value-of select="concat(/*/system/info/adm_to_dir_for_linked, 'picts/large/', $form/data/uplink_type, '/', $form/data/uplink_id, '/', $form/data/large_file)"/></xsl:when>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
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

<xsl:template name="insert_form_for_linked_pict">
	<xsl:param name="form"   select="/.."/>
	<xsl:param name="prefix"     select="'_'"/>
	<xsl:param name="uplink_type"/>
	<xsl:param name="uplink_id"/>
	<xsl:param name="comments" select="''"/>

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
				<th class="formCellHead"></th><td class="formCellFlag"></td>
				<th class="formCellHead"><label for="{$prefix}alt"><nobr>Комментарий</nobr></label></th>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"></th><td class="formCellFlag"></td>
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
				<th class="formCellHead"></th><td class="formCellFlag"></td>
				<th class="formCellHead"><label for="{$prefix}small"><nobr>
					<xsl:choose>
					<xsl:when test="$form/config/count=1">Файл картинки</xsl:when>
					<xsl:otherwise>Маленькая картинка</xsl:otherwise>
					</xsl:choose>
					</nobr></label></th>
				<td class="formCellFlag"></td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"></th><td class="formCellFlag"></td>
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
				<th class="formCellHead"><label for="{$prefix}small_name"><nobr>Имя файла картинки</nobr></label></th>
				<td class="formCellFlag">&gt;</td>
				<td class="formCellControls">
					<input class="controlString" type="text" name="small_name" value="{$form/data/small_name}" id="{$prefix}small_name"/>
				</td>
			</tr>
		</xsl:if>

		<xsl:if test="$form/config/count = 3">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}middle"><nobr>Средняя картинка</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<input class="controlAttach" type="file"   name="middle" id="{$prefix}middle"/>
					<xsl:if test="($form/config/middle_limit_w != '') or ($form/config/middle_limit_h != '')">
					(<xsl:value-of select="$form/config/middle_limit_w" />x<xsl:value-of select="$form/config/middle_limit_h" /> px)
					</xsl:if>
					<input class="controlHidden" type="hidden" name="middle_temp" value="{$form/data/middle_temp}"/>
				</td>
			</tr>
		<xsl:if test="$form/errors/middle_exists">
			<tr class="formRowRecovery">
				<th class="formCellHead"><label for="{$prefix}middle_name"><nobr>Имя файла с.картинки</nobr></label></th>
				<td class="formCellFlag">&gt;</td>
				<td class="formCellControls">
					<input class="controlString" type="text" name="middle_name" value="{$form/data/middle_name}" id="{$prefix}middle_name"/>
				</td>
			</tr>
		</xsl:if>
		</xsl:if>

		<xsl:if test="$form/config/count > 1">
			<tr class="formRowOptional">
				<th class="formCellHead"></th><td class="formCellFlag"></td>
				<th class="formCellHead"><label for="{$prefix}large"><nobr>Большая картинка</nobr></label></th>
				<td class="formCellFlag"></td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"></th><td class="formCellFlag"></td>
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
		</xsl:if>
		<xsl:if test="$comments != ''">
			<tr class="formRowRecovery">
				<th class="formCellHead"></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<xsl:value-of select="$comments" disable-output-escaping="yes"/>
				</td>
			</tr>
		</xsl:if>

			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

		<xsl:if test="($form/data/small_temp!='') or ($form/data/small_file!='')">
			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRow">
				<th class="formCellHead">
					<nobr>
					<xsl:choose>
					<xsl:when test="$form/config/count=1">Файл картинки</xsl:when>
					<xsl:otherwise>Маленькая картинка</xsl:otherwise>
					</xsl:choose>
					</nobr>
					<br/>
					<input type="checkbox" name="small_delete" value="1" id="{$prefix}small_delete">
						<xsl:if test="number($form/data/small_delete)&gt;0"><xsl:attribute name="checked"/></xsl:if>
					</input>
					<label for="{$prefix}small_delete">Удалить</label>
				</th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<xsl:variable name="small_src">
						<xsl:choose>
						<xsl:when test="$form/data/small_temp!=''"><xsl:value-of select="concat(/*/system/info/adm_to_tmp_for_linked, $form/data/small_temp)"/></xsl:when>
						<xsl:when test="$form/data/small_file!=''"><xsl:value-of select="concat(/*/system/info/adm_to_dir_for_linked, 'picts/small/', $form/data/uplink_type, '/', $form/data/uplink_id, '/', $form/data/small_file)"/></xsl:when>
						</xsl:choose>
					</xsl:variable>

				        <xsl:choose>
				        <xsl:when test="$form/data/small_w &gt; 500">
					<a href="{$small_src}" target="_blank">
						<xsl:call-template name="media">
							<xsl:with-param name="src" select="$small_src"/>
							<xsl:with-param name="w" select="500"/>
							<xsl:with-param name="h" select="''"/>
						</xsl:call-template>
					</a>
				        </xsl:when>
				        <xsl:otherwise>
					<xsl:call-template name="media">
						<xsl:with-param name="src" select="$small_src"/>
					</xsl:call-template>
				        </xsl:otherwise>
				        </xsl:choose>

				</td>
			</tr>
		</xsl:if>

		<xsl:if test="$form/config/count = 3">
		<xsl:if test="($form/data/middle_temp!='') or ($form/data/middle_file!='')">
			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRow">
				<th class="formCellHead">
					<nobr>Средняя картинка</nobr>
					<br/>
					<input type="checkbox" name="middle_delete" value="1" id="{$prefix}middle_delete">
						<xsl:if test="number($form/data/middle_delete)&gt;0"><xsl:attribute name="checked"/></xsl:if>
					</input>
					<label for="{$prefix}middle_delete">Удалить</label>
				</th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<xsl:variable name="middle_src">
						<xsl:choose>
						<xsl:when test="$form/data/middle_temp!=''"><xsl:value-of select="concat(/*/system/info/adm_to_tmp_for_linked, $form/data/middle_temp)"/></xsl:when>
						<xsl:when test="$form/data/middle_file!=''"><xsl:value-of select="concat(/*/system/info/adm_to_dir_for_linked, 'picts/middle/', $form/data/uplink_type, '/', $form/data/uplink_id, '/', $form/data/middle_file)"/></xsl:when>
						</xsl:choose>
					</xsl:variable>
				        <xsl:choose>
				        <xsl:when test="$form/data/middle_w &gt; 500">
					<a href="{$middle_src}" target="_blank">
						<xsl:call-template name="media">
							<xsl:with-param name="src" select="$middle_src"/>
							<xsl:with-param name="w" select="500"/>
							<xsl:with-param name="h" select="''"/>
						</xsl:call-template>
					</a>
				        </xsl:when>
				        <xsl:otherwise>
					<xsl:call-template name="media">
						<xsl:with-param name="src" select="$middle_src"/>
					</xsl:call-template>
				        </xsl:otherwise>
				        </xsl:choose>
				</td>
			</tr>
		</xsl:if>
		</xsl:if>

		<xsl:if test="$form/config/count > 1">
		<xsl:if test="($form/data/large_temp!='') or ($form/data/large_file!='')">
			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRow">
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
					<xsl:variable name="large_src">
						<xsl:choose>
						<xsl:when test="$form/data/large_temp!=''"><xsl:value-of select="concat(/*/system/info/adm_to_tmp_for_linked, $form/data/large_temp)"/></xsl:when>
						<xsl:when test="$form/data/large_file!=''"><xsl:value-of select="concat(/*/system/info/adm_to_dir_for_linked, 'picts/large/', $form/data/uplink_type, '/', $form/data/uplink_id, '/', $form/data/large_file)"/></xsl:when>
						</xsl:choose>
					</xsl:variable>
				        <xsl:choose>
				        <xsl:when test="$form/data/large_w &gt; 500">
					<a href="{$large_src}" target="_blank">
						<xsl:call-template name="media">
							<xsl:with-param name="src" select="$large_src"/>
							<xsl:with-param name="w" select="500"/>
							<xsl:with-param name="h" select="''"/>
						</xsl:call-template>
					</a>
				        </xsl:when>
				        <xsl:otherwise>
					<xsl:call-template name="media">
						<xsl:with-param name="src" select="$large_src"/>
					</xsl:call-template>
				        </xsl:otherwise>
				        </xsl:choose>
				</td>
			</tr>
		</xsl:if>
		</xsl:if>

		<!--
		Если форма выводится по конкретным данным, то выводим аплинк оттуда.
		Если форма (добавления) выводится в списке, то берём аплинк как там для списка указано.
		-->
		<xsl:choose>
		<xsl:when test="$form">
			<input type="hidden" name="uplink_type" value="{$form/data/uplink_type}" />
			<!--input type="hidden" name="uplink_id"   value="{$form/data/uplink_id}"   /-->
		</xsl:when>
		<xsl:when test="$uplink_type and $uplink_id">
			<input type="hidden" name="uplink_type" value="{$uplink_type}" />
			<!--input type="hidden" name="uplink_id"   value="{$uplink_id}"   /-->
		</xsl:when>
		</xsl:choose>

</xsl:template>


<xsl:template name="list_for_linked_pict_import">
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
		<xsl:if test="$form/errors_list/*">
			<tr class="formRowErrors">
				<th class="formCellHead"></th>
				<td class="formCellFlag"></td>
				<td class="formCellErrors">
					<div class="error">Картинки с такими именами уже существуют в каталоге. Задайте другое имя.</div>
				</td>
			</tr>
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
		</xsl:if>


			<xsl:for-each select="$form/list/image">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}alt{position()}"><nobr>Комментарий</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}alt_anchor{position()}">
						<td class="flatCell">
							<input class="controlString" type="text" name="images[{position()}][alt]" value="{alt}" id="{$prefix}alt{position()}" />
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, 'alt', position())"/></xsl:call-template>
						</td>
					</tr></table>
				</td>
			</tr>
			<tr class="formRow">
				<th class="formCellHead">
					<nobr>Файл картинки</nobr>
					<br/>
					<input type="checkbox" name="images[{position()}][delete]" value="1" id="{$prefix}delete{position()}">
						<xsl:if test="number(delete)&gt;0"><xsl:attribute name="checked"/></xsl:if>
					</input>
					<label for="{$prefix}delete{position()}">Удалить</label>
				</th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<a href="{concat(/*/system/info/pub_root, 'uploads/', $form/data/path, '/', real_name)}"
					onclick="return smart_image_popup('{concat(/*/system/info/pub_root, 'uploads/', $form/data/path, '/', real_name)}')"
					>
						<img src="{concat(/*/system/info/pub_root, 'uploaded_img.php?i=uploads/', $form/data/path, '/', real_name)}" />
					</a>
					<input type="hidden" name="images[{position()}][real_name]" value="{real_name}"/>
				</td>
			</tr>
			<xsl:if test="exists">
				<tr class="formRowRecovery">
					<th class="formCellHead"><label for="{$prefix}large_name"><nobr>Имя файла картинки</nobr></label></th>
					<td class="formCellFlag">&gt;</td>
					<td class="formCellControls">
						<input class="controlString" type="text" name="images[{position()}][large_name]" value="{large_name}" id="{$prefix}large_name"/>
					</td>
				</tr>
			</xsl:if>
			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			</xsl:for-each>

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
		<input type="hidden" name="path" value="{$form/data/path}"/>
	</form>
</xsl:template>

</xsl:stylesheet>
