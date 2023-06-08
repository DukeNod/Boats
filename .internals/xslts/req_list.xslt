<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template priority="-99" match="request" mode="overrideable_list_link">
	<a class="pjax sign_link" href="#">
	  Подписать
	</a>
</xsl:template>

<xsl:template priority="-99" match="request" mode="overrideable_list_checkbox">
	<input type="checkbox" name="bulk_ids[]" id="bulk_ids_" value="{file_id}" />
</xsl:template>

<xsl:template name="req_list">
	<xsl:param name="list"/>
	<xsl:param name="checkboxes" select="1"/>

<div id='list'>

<table class='table table-condensed table-striped'>
<thead>
<tr>
<xsl:if test="$checkboxes = 1">
<th class='shrink'>
<input class='toggle' type='checkbox'/>
</th>
</xsl:if>
<th class='header pjax   integer_type' data-href='/cabinet/request?model_name=request&amp;sort=id' rel='tooltip' title=''>Id</th>
<th class='header pjax   string_type' data-href='/cabinet/request?model_name=request&amp;sort=request_number' rel='tooltip' title=''>Номер дела</th>
<th class='header pjax   string_type' rel='tooltip' title=''>ФИО</th>
<th class='header pjax  resident_entrance_time_field datetime_type' data-href='/cabinet/request?model_name=request&amp;sort=resident_entrance_time' rel='tooltip' title=''>Заселение с</th>
<th class='header pjax  resident_departure_time_field datetime_type' data-href='/cabinet/request?model_name=request&amp;sort=resident_departure_time' rel='tooltip' title=''>Заселение по</th>
<th class='header pjax  created_at_field datetime_type' data-href='/cabinet/request?model_name=request&amp;sort=created_at' rel='tooltip' title=''>Дата создания</th>
<!--th class='header pjax   string_type' data-href='/cabinet/request?model_name=request&amp;sort=state' rel='tooltip' title=''>Статус</th-->
<th class='last shrink'></th>
</tr>
</thead>
<tbody>
<xsl:for-each select="$list/request">
<tr class='request_row' id="request_row_{file_id}" data-file_id="{file_id}">
<xsl:if test="$checkboxes = 1">
<td>
	<xsl:apply-templates select="." mode="overrideable_list_checkbox"/>
</td>
</xsl:if>
<td class=' integer_type'><xsl:value-of select="id" disable-output-escaping="yes"/></td>
<td class=' string_type'><xsl:value-of select="request_number" disable-output-escaping="yes"/></td>
<td class=' string_type'><xsl:value-of select="resident_name" disable-output-escaping="yes"/></td>
<td class='resident_entrance_time_field datetime_type'>
	<xsl:call-template name="datetime_numeric_ru">
		<xsl:with-param name="year"  select="resident_entrance_time_parsed/year" />
		<xsl:with-param name="month" select="resident_entrance_time_parsed/month"/>
		<xsl:with-param name="day"   select="resident_entrance_time_parsed/day"  />
	</xsl:call-template>
</td>
<td class='resident_departure_time_field datetime_type'>
	<xsl:call-template name="datetime_numeric_ru">
		<xsl:with-param name="year"  select="resident_departure_time_parsed/year" />
		<xsl:with-param name="month" select="resident_departure_time_parsed/month"/>
		<xsl:with-param name="day"   select="resident_departure_time_parsed/day"  />
	</xsl:call-template>
</td>
<td class='created_at_field datetime_type'>
	<xsl:call-template name="datetime_numeric_ru">
		<xsl:with-param name="year"  select="created_at_parsed/year" />
		<xsl:with-param name="month" select="created_at_parsed/month"/>
		<xsl:with-param name="day"   select="created_at_parsed/day"  />
		<xsl:with-param name="hour"  select="created_at_parsed/hour" />
		<xsl:with-param name="minute" select="created_at_parsed/minute"/>
		<xsl:with-param name="second"   select="created_at_parsed/second"  />
	</xsl:call-template>
</td>
<!--td class=' string_type'>
	<xsl:apply-templates select="state" mode="request_state"/>
</td-->
<td class='last links'>
	<xsl:apply-templates select="." mode="overrideable_list_link"/>
</td>
</tr>
</xsl:for-each>
</tbody>
</table>

</div>

</xsl:template>

</xsl:stylesheet>