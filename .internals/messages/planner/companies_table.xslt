<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
        <!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
        <!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
        <!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
        ]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

	<!-- универсальный шаблон для отображения списка кампаний в рассылке -->
    <xsl:template name="companies_table" >
        <xsl:param name="items"/>
        <xsl:param name="no_data_message"/>

		<table style="border: 1px solid black; border-style: collapse; border-collapse: collapse">
			<tr style="border: 1px solid black; padding: 5px">
				<th style="border: 1px solid black; padding: 5px" title="Бренд рекламной кампании">Бренд</th>
				<th style="border: 1px solid black; padding: 5px" title="Идентификатор кампании и ссылка на карточку">Кампания</th>
				<th style="border: 1px solid black; padding: 5px" title="Дата начала расписания">Начало</th>
				<th style="border: 1px solid black; padding: 5px" title="Дата окончания расписания">Окончание</th>
				<th style="border: 1px solid black; padding: 5px" title="Статус конкретного расписания">Статус</th>
				<th style="border: 1px solid black; padding: 5px" title="Имя файла ролика">Ролик</th>
				<th style="border: 1px solid black; padding: 5px" title="Статус загрузки ролика во внешнюю систему">Загружен</th>
				<th style="border: 1px solid black; padding: 5px" title="Сколько показов задано в ЛК">Показов ЛК</th>
				<th style="border: 1px solid black; padding: 5px" title="Общий прогноз для группы, т.е. всех расписаний">Прогноз</th>
				<th style="border: 1px solid black; padding: 5px" title="Общий факт для группы, т.е. всех расписаний">Факт</th>
			</tr>
			<xsl:choose>
				<xsl:when test="$items/item">
					<xsl:for-each select="$items/item">
						<tr style="border: 1px solid black; padding: 5px">
							<td style="border: 1px solid black; padding: 5px">
								<xsl:value-of select="BrandName" disable-output-escaping="yes"/>
							</td>
							<td style="border: 1px solid black; padding: 5px">
								<a href="{/*/system/info/pub_site}campaign/{ExternalID}/" title="{Name}">
									<xsl:value-of select="ExternalID" disable-output-escaping="yes"/>
								</a>
							</td>
							<td style="border: 1px solid black; padding: 5px">
								<xsl:apply-templates select="MinDate_parsed" mode="show_datetime_ru"/>
							</td>
							<td style="border: 1px solid black; padding: 5px">
								<xsl:apply-templates select="MaxDate_parsed" mode="show_datetime_ru"/>
							</td>
							<td style="border: 1px solid black; padding: 5px">
								<xsl:apply-templates select="Kind" mode="campaign_kind_colored"/>
							</td>
							<td style="border: 1px solid black; padding: 5px">
								<xsl:value-of select="filename" disable-output-escaping="yes"/>
							</td>
							<td style="border: 1px solid black; padding: 5px">
								<xsl:value-of select="LoadStatus" disable-output-escaping="yes"/>
							</td>
							<td style="border: 1px solid black; padding: 5px">
								<xsl:value-of select="format-number(GroupTotalCount,'# ###,##','pricef')" disable-output-escaping="yes"/>
							</td>
							<td style="border: 1px solid black; padding: 5px">
								<xsl:call-template name="forecast_count">
									<xsl:with-param name="plancount" select="GroupPlanCount"/>
									<xsl:with-param name="totalcount" select="GroupTotalCount"/>
									<xsl:with-param name="percent" select="GroupOverheadPercent"/>
								</xsl:call-template>
							</td>
							<td style="border: 1px solid black; padding: 5px">
								<xsl:value-of select="format-number(GroupFactCount,'# ###,##','pricef')" disable-output-escaping="yes"/>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<tr style="border: 1px solid black; padding: 5px">
						<td style="border: 1px solid black; padding: 5px" colspan="10">
							<xsl:value-of select="$no_data_message" disable-output-escaping="yes"/>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</table>
    </xsl:template>

</xsl:stylesheet>