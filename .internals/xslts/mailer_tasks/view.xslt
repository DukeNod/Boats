<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="view_for_mailer_task">
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

			<tr class="formRowView">
				<th class="formCellHead"><nobr>Статус</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:choose>
					<xsl:when test="$form/data/send_ts='' and $form/data/stop_ts=''">
						<xsl:text>В процессе создания (не запущена).</xsl:text>
					</xsl:when>
					<xsl:when test="$form/data/stop_ts=''">
						<xsl:text>В процессе рассылки (запущена).</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Рассылка закончена (либо остановлена).</xsl:text>
					</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>

		<xsl:if test="$form/data/send_ts!=''">
			<tr class="formRowView">
				<th class="formCellHead"><nobr>Разослано</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="$form/data/progress_done" disable-output-escaping="no"/>
					<xsl:text> из </xsl:text>
					<xsl:value-of select="$form/data/progress_total" disable-output-escaping="no"/>
				</td>
			</tr>
		</xsl:if>

			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowView">
				<th class="formCellHead"><nobr>Заголовок</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="$form/data/subject" disable-output-escaping="no"/>
				</td>
			</tr>
			<tr class="formRowView">
				<th class="formCellHead"><nobr>Сообщение</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="$form/data/message" disable-output-escaping="yes"/>
				</td>
			</tr>

			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowView">
				<th class="formCellHead"><nobr>Режим рассылки</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:choose>
					<xsl:when test="number($form/data/is_test)&gt;0">Тестовая рассылка (только ограниченному кругу лиц).</xsl:when>
					<xsl:otherwise>Всеобщая рассылка (всем активным подписчикам).</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>

			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowView">
				<th class="formCellHead"><nobr>Группы подписчиков</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
				        <xsl:for-each select="$form/data/groups_list/group[id!=0]">
						<xsl:value-of select="name" />
						<br/>
				        </xsl:for-each>
					<xsl:if test="$form/data/groups_list/group[id = 0]/id">Прочие</xsl:if>
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
