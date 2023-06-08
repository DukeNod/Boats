<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="form_for_mailer_file">
	<xsl:param name="form"   select="/.."/>
	<xsl:param name="back"   select="/*/system/back_raw"/>
	<xsl:param name="action" select="/*/system/curr_raw"/>
	<xsl:param name="button"     select="/.."/>
	<xsl:param name="button_w"   select="/.."/>
	<xsl:param name="button_h"   select="/.."/>
	<xsl:param name="button_img" select="/.."/>
	<xsl:param name="button_alt" select="/.."/>
	<xsl:param name="prefix"     select="'_'"/>
	<xsl:param name="mailer_task"/>

	<form class="form" enctype="multipart/form-data" method="post" action="{$action}">
		<table class="formTable">
			<col width="1"/><col width="1"/><col width="*"/>

		<xsl:if test="$form/errors/*">
			<tr class="formRowErrors">
				<th class="formCellHead"></th>
				<td class="formCellFlag"></td>
				<td class="formCellErrors">
					<xsl:apply-templates select="$form/errors/*" mode="mailer_file"/>
				</td>
			</tr>
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
		</xsl:if>

			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}attach"><nobr>Файл</nobr></label></th>
				<td class="formCellFlag">*</td>
				<td class="formCellControl">
					<input class="controlAttach" type="file"   name="attach" id="{$prefix}attach"/>
					<input class="controlHidden" type="hidden" name="attach_temp" value="{$form/data/attach_temp}"/>
				</td>
			</tr>
			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}name"><nobr>Имя файла (с расширением)</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl" style="padding-bottom: 0;">
					<input class="controlString" type="text" name="name" value="{$form/data/name}" id="{$prefix}name"/>
				</td>
			</tr>
			<tr class="formRowOptional">
				<th class="formCellHead"></th>
				<td class="formCellFlag"></td>
				<td class="formCellHint">
					<div style="width: 50em;">
						Имя, под&nbsp;которым файл будет прикреплён к&nbsp;письму.
						Нужно <b>с&nbsp;расширением</b>!
						Без&nbsp;мусорных символов, неуместных в&nbsp;имени файла.
						<br/>
						<b>Если не&nbsp;указано</b>&nbsp;&mdash; будет использовано
						имя загруженного файла.
					</div>
				</td>
			</tr>

		<xsl:if test="$form/errors/attach_exists">
			<tr class="formRowRecovery">
				<th class="formCellHead"><label for="{$prefix}attach_name"><nobr>Имя файла</nobr></label></th>
				<td class="formCellFlag">&gt;</td>
				<td class="formCellControl">
					<input class="controlString" type="text" name="attach_name" value="{$form/data/attach_name}" id="{$prefix}attach_name"/>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="($form/data/attach_temp!='') or ($form/data/attach_file!='')">
			<tr class="formRowView">
				<th class="formCellHead"><nobr>Ссылка</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<a target="_blank">
						<xsl:choose>
						<xsl:when test="$form/data/attach_temp!=''"><xsl:attribute name="href"><xsl:value-of select="/*/system/info/adm_to_tmp_for_linked"/><xsl:value-of select="$form/data/attach_temp"/></xsl:attribute></xsl:when>
						<xsl:when test="$form/data/attach_file!=''"><xsl:attribute name="href"><xsl:value-of select="/*/system/info/adm_to_dir_for_linked"/>mailer/<xsl:value-of select="$form/data/attach_file"/></xsl:attribute></xsl:when>
						</xsl:choose>
						<xsl:value-of select="$form/data/attach_name"/>
					</a>
				</td>
			</tr>
		</xsl:if>

			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowOptional">
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
						<xsl:for-each select="/*/enum[@for='mailer_files']/siblings/*[id!=$form/id or not($form)]">
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

		</table>

		<!--
		Если форма выводится по конкретным данным, то выводим аплинк оттуда.
		Если форма (добавления) выводится в списке, то берём аплинк как там для списка указано.
		-->
		<xsl:choose>
		<xsl:when test="$form">
			<input type="hidden" name="mailer_task" value="{$form/data/mailer_task}" />
		</xsl:when>
		<xsl:when test="$mailer_task">
			<input type="hidden" name="mailer_task" value="{$mailer_task}" />
		</xsl:when>
		</xsl:choose>
		<input type="hidden" name="back" value="{$back}"/>
	</form>
</xsl:template>



</xsl:stylesheet>
