<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<!--
-->
<xsl:template name="list_of_mailer_tasks">
	<xsl:param name="node" select="/.."/>
	<xsl:param name="hide_links" />
	<xsl:param name="filters"/>
	<xsl:param name="sorters"/>
	<xsl:param name="pager"  />

	<xsl:if test="not($hide_links)">
		<div class="link">
			<div class="linkCommand">
				<a href="{/*/system/info/adm_root}mailer_tasks/insert?back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="17" height="17" alt="добавить" />
					<span>Добавить рассылку</span>
				</a>
			</div>
		</div>
	</xsl:if>

	<xsl:choose>
	<xsl:when test="$node/*">
		<xsl:if test="$pager">
			<xsl:call-template name="pager_block">
				<xsl:with-param name="filters" select="$filters"/>
				<xsl:with-param name="sorters" select="$sorters"/>
				<xsl:with-param name="pager"   select="$pager"  />
			</xsl:call-template>
		</xsl:if>

		<form class="list" method="post" action="{/*/system/info/adm_root}mailer_tasks/multi">
		<table class="listTable">
			<col width="*"/><col width="1"/><col width="1"/><col width="1"/><col width="1"/><col width="1"/>
			<xsl:if test="not($hide_links)">
			<col width="1"/><col width="1"/><col width="1"/><col width="1"/>
			</xsl:if>
        
			<tr class="listRowHead">

				<th class="listCellHead listCellSplitL">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'subject'"/>
						<xsl:with-param name="text">Заголовок</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'progress_total'"/>
						<xsl:with-param name="text">Писем</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'progress'"/>
						<xsl:with-param name="text">Прогресс</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'send_ts'"/>
						<xsl:with-param name="text">Запущено</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'stop_ts'"/>
						<xsl:with-param name="text">Окончено</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead listCellSplitR">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'is_test'"/>
						<xsl:with-param name="text">Тестовая?</xsl:with-param>
					</xsl:call-template>
				</th>

				<xsl:if test="not($hide_links)">
				<th class="listCellHead listCellSplitL listCellSplitR" colspan="4">
				</th>
				</xsl:if>
			</tr>
			<tr class="listRowNull"></tr>
		<xsl:for-each select="$node/*">
			<tr>
				<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>
				<xsl:variable name="defcmd"><xsl:choose><xsl:when test="send_ts='' and stop_ts=''">update</xsl:when><xsl:otherwise>view</xsl:otherwise></xsl:choose></xsl:variable>

       				<td class="listCellData listCellSplitL listCellSplitR">
       					<a href="{/*/system/info/adm_root}mailer_tasks/{$defcmd}/{id}">
						<xsl:value-of select="subject" disable-output-escaping="no"/>
					</a>
				</td>
				<td class="listCellData" style="text-align: center">
					<nobr>
						<xsl:choose>
						<xsl:when test="number(progress_total)&gt;0">
							<xsl:value-of select="progress_done"/>
							<xsl:text>/</xsl:text>
							<xsl:value-of select="progress_total"/>
						</xsl:when>
						<xsl:otherwise><center>&mdash;</center></xsl:otherwise>
						</xsl:choose>
					</nobr>
				</td>
				<td class="listCellData" style="text-align: right">
					<nobr>
						<xsl:choose>
						<xsl:when test="number(progress_total)&gt;0">
							<xsl:value-of select="format-number(progress * 100, '0.0')"/>
							<xsl:text>%</xsl:text>
						</xsl:when>
						<xsl:otherwise><center>&mdash;</center></xsl:otherwise>
						</xsl:choose>
					</nobr>
				</td>
				<td class="listCellData">
					<nobr>
						<xsl:choose>
						<xsl:when test="send_ts!=''">
							<xsl:call-template name="datetime_numeric_ru">
								<xsl:with-param name="year"   select="send_ts_parsed/year"  />
								<xsl:with-param name="month"  select="send_ts_parsed/month" />
								<xsl:with-param name="day"    select="send_ts_parsed/day"   />
								<xsl:with-param name="hour"   select="send_ts_parsed/hour"  />
								<xsl:with-param name="minute" select="send_ts_parsed/minute"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise><center>&mdash;</center></xsl:otherwise>
						</xsl:choose>
					</nobr>
				</td>
				<td class="listCellData">
					<nobr>
						<xsl:choose>
						<xsl:when test="stop_ts!=''">
							<xsl:call-template name="datetime_numeric_ru">
								<xsl:with-param name="year"   select="stop_ts_parsed/year"  />
								<xsl:with-param name="month"  select="stop_ts_parsed/month" />
								<xsl:with-param name="day"    select="stop_ts_parsed/day"   />
								<xsl:with-param name="hour"   select="stop_ts_parsed/hour"  />
								<xsl:with-param name="minute" select="stop_ts_parsed/minute"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise><center>&mdash;</center></xsl:otherwise>
						</xsl:choose>
					</nobr>
				</td>
				<td class="listCellData listCellCommand listCellSplitR">
					<xsl:choose>
					<xsl:when test="$hide_links or send_ts!='' or stop_ts!=''">
						<xsl:choose>
						<xsl:when test="number(is_test)&gt;0">
							<img src="{/*/system/info/adm_root}img/buttons/turnof{$row}.gif" width="20" height="20" alt="включено"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="{/*/system/info/adm_root}img/buttons/turnon{$row}.gif"  width="20" height="20" alt="выключено"/>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
						<xsl:when test="number(is_test)&gt;0">
							<a href="{/*/system/info/adm_root}mailer_tasks/switch/{id}/is_test/0?back={/*/system/curr_url}">
							<img src="{/*/system/info/adm_root}img/buttons/turnof{$row}.gif" width="20" height="20" alt="выключить"/></a>
						</xsl:when>
						<xsl:otherwise>
							<a href="{/*/system/info/adm_root}mailer_tasks/switch/{id}/is_test/1?back={/*/system/curr_url}">
							<img src="{/*/system/info/adm_root}img/buttons/turnon{$row}.gif"  width="20" height="20" alt="включить"/></a>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
					</xsl:choose>
				</td>

			<xsl:if test="not($hide_links)">
				<td class="listCellData listCellCommand listCellSplitL">
					<xsl:choose>
					<xsl:when test="send_ts='' or stop_ts!=''">
						<a href="{/*/system/info/adm_root}mailer_tasks/update/{id}?back={/*/system/curr_url}">
						<img src="{/*/system/info/adm_root}img/buttons/update{$row}.gif" width="20" height="20" alt="изменить" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/none.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="listCellData listCellCommand">
					<xsl:choose>
					<xsl:when test="send_ts='' or stop_ts!=''">
						<a href="{/*/system/info/adm_root}mailer_tasks/delete/{id}?back={/*/system/curr_url}">
						<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="удалить" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/none.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="listCellData listCellCommand">
					<xsl:choose>
					<xsl:when test="send_ts='' or stop_ts!=''">
						<a href="{/*/system/info/adm_root}mailer_tasks/send/{id}?back={/*/system/curr_url}">
						<img src="{/*/system/info/adm_root}img/buttons/send{$row}.gif" width="20" height="20" alt="запустить" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/none.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="listCellData listCellCommand listCellSplitR">
					<xsl:choose>
					<xsl:when test="send_ts!='' and stop_ts=''">
						<a href="{/*/system/info/adm_root}mailer_tasks/stop/{id}?back={/*/system/curr_url}">
						<img src="{/*/system/info/adm_root}img/buttons/stop{$row}.gif" width="20" height="20" alt="остановить" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/none.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			</tr>
		</xsl:for-each>
		</table>
		</form>
	</xsl:when>
	<xsl:otherwise>
		<div class="list listEmpty">Сейчас нет ни одной рассылки.</div>
	</xsl:otherwise>
	</xsl:choose>

</xsl:template>



</xsl:stylesheet>
