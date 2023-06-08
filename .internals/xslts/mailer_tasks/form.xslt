<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="form_for_mailer_task">
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
					<xsl:apply-templates select="$form/errors/*" mode="mailer_task"/>
				</td>
			</tr>
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
		</xsl:if>

			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}subject"><nobr>Заголовок</nobr></label></th>
				<td class="formCellFlag">*</td>
				<td class="formCellControls">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}subject_anchor">
						<td class="flatCell">
							<input class="controlString" type="text" name="subject" value="{$form/data/subject}" id="{$prefix}subject" />
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, 'subject')"/></xsl:call-template>
						</td>
					</tr></table>
				</td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"><nobr>Сообщение</nobr></th>
				<td class="formCellFlag">*</td>
				<td class="formCellControls"><nobr>
					<table class="flatTable"><tr class="flatRow" id="{$prefix}message_anchor">
						<td class="flatCell">
							<textarea class="controlString" name="message" rows="20" id="{$prefix}message">
								<xsl:value-of select="$form/data/message"/>
								<xsl:value-of select="''"/>
							</textarea>
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, 'message')"/></xsl:call-template>
						</td>
					</tr></table>
				</nobr></td>
			</tr>

			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowOptional">
				<th class="formCellHead"><nobr></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls"><nobr>
					<input class="controlCheckbox" type="checkbox" name="is_test" value="1" id="{$prefix}is_test">
						<xsl:if test="number($form/data/is_test)&gt;0"><xsl:attribute name="checked"/></xsl:if>
					</input>
					<label for="{$prefix}is_test">Тестовая рассылка (только ограниченному кругу подписчиков)</label>
				</nobr></td>
			</tr>
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
			<tr class="formRowRequired">
				<th class="formCellHead"><nobr>Группы</nobr></th>
				<td class="formCellFlag">*</td>
				<td class="fromCellControls">
						<input class="controlCheckbox" type="checkbox" name="groups_list_all" value="1" id="{$prefix}group_all"/>
						<label for="{$prefix}group_all">Все</label>
						<br/>
				        <xsl:for-each select="/*/enum/subscriber_groups/group">
						<input class="controlCheckbox groups" type="checkbox" name="groups_list[][id]" value="{id}" id="{$prefix}group{position()}">
							<xsl:if test="$form/data/groups_list/group[id = current()/id]/id"><xsl:attribute name="checked"/></xsl:if>
						</input>
						<label for="{$prefix}group{position()}"><xsl:value-of select="name" /></label>
						<br/>
				        </xsl:for-each>
						<input class="controlCheckbox groups" type="checkbox" name="groups_list[][id]" value="0" id="{$prefix}group0">
							<xsl:if test="$form/data/groups_list/group[id = 0]/id"><xsl:attribute name="checked"/></xsl:if>
						</input>
						<label for="{$prefix}group0">Прочие</label>
						<br/>
				</td>
			</tr>

			<script type="text/javascript">
				var domain = '<xsl:value-of select="$form/data/domain"/>';
				$(function(){ var prefix = '<xsl:value-of select="$prefix"/>';
				<![CDATA[
					$('#'+prefix+'group_all').change(function(){
						if (this.checked)
						{
							$('.groups').each(function(){ this.checked = true });
						}else
						{
							$('.groups').each(function(){ this.checked = false });
						}
					});

				});

					function link_item()
					{
						ajax_window(ADM_ROOT+'tours/ajax/list?domain='+domain);
						return false;
					}

					]]></script>

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
