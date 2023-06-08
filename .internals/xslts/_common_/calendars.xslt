<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template name="calendar_dateonly">
	<xsl:param name="id"/>
	<xsl:param name="name"/>
	<xsl:param name="class"/>
	<xsl:param name="value"/>
	<xsl:param name="mindate"/>
	<xsl:param name="maxdate"/>
	<xsl:param name="format"/>
	<xsl:param name="required" select="0"/>
	<xsl:param name="submit" select="0"/>
	
		<div class='col-sm-3 date-picker-div'>
			<div><!-- class="form-group" -->
				<div class='input-group date {$class}' id='{$id}'>
					<input type='text' name="{$name}" class="form-control date-input" value="{$value}">
						<xsl:if test="$required = 1">
							<xsl:attribute name="required">required</xsl:attribute>
						</xsl:if>
					</input>
					<span class="input-group-addon">
						<span class="glyphicon glyphicon-calendar"></span>
					</span>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			$(function () {
				var dp_options = {
					format: 'DD.MM.YYYY',
					locale: 'ru'
				};
				<xsl:if test="string($format)">
					dp_options.format = '<xsl:value-of select="$format"/>';
					<xsl:if test="string($format) = 'MM.YYYY'">
						dp_options.viewMode = 'months';
					</xsl:if>
				</xsl:if>
				<xsl:if test="string($maxdate)">
					dp_options.maxDate = '<xsl:value-of select="$maxdate"/>';
				</xsl:if>
				<xsl:if test="string($mindate)">
					dp_options.minDate = '<xsl:value-of select="$mindate"/>';
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$submit='1'">
						$('#<xsl:value-of select="$id"/>').datetimepicker(dp_options).on('dp.change',function(){ $('form').submit(); });
					</xsl:when>
					<xsl:otherwise>
						$('#<xsl:value-of select="$id"/>').datetimepicker(dp_options);
					</xsl:otherwise>
				</xsl:choose>
			});
		</script>
</xsl:template>

<xsl:template name="calendar_datetime">
	<xsl:param name="id"/>
	<xsl:param name="class"/>
	<xsl:param name="name"/>
	<xsl:param name="value"/>
	<xsl:param name="required" select="0"/>
	
		<div class='col-sm-3 date-picker-div'>
			<div><!-- class="form-group" -->
				<div class='input-group date' id='{$id}'>
					<input type='text' name="{$name}" class="form-control date-input" value="{$value}">
						<xsl:if test="$required = 1">
							<xsl:attribute name="required">required</xsl:attribute>
						</xsl:if>
					</input>
					<span class="input-group-addon">
						<span class="glyphicon glyphicon-calendar"></span>
					</span>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			$(function () {
				var d = new Date();
				var month = d.getMonth();
				var day = d.getDate();
				var year = d.getFullYear();

				$('#<xsl:value-of select="$id"/>').datetimepicker({
					locale: 'ru'
				//,	viewDate: new Date(year, month, day, 08, 00)
				,	 useCurrent: 'day'
				});
			});
		</script>
</xsl:template>

</xsl:stylesheet>
