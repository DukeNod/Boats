<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="TextField" mode="quick_mail">
		<tr>
			<th width="40%">
	        	<xsl:choose>
        		<xsl:when test="title != ''">
        			<xsl:value-of select="title" disable-output-escaping="yes"/>
	        	</xsl:when>
        		<xsl:otherwise>
	        		<xsl:apply-templates select="name" mode="forms"/>
	        	</xsl:otherwise>
        		</xsl:choose>
			</th>

			<td><xsl:value-of select="value"/></td>
		</tr>
</xsl:template>

<xsl:template match="Email" mode="quick_mail">
		<tr>
			<th width="40%">
	        	<xsl:choose>
        		<xsl:when test="title != ''">
        			<xsl:value-of select="title" disable-output-escaping="yes"/>
	        	</xsl:when>
        		<xsl:otherwise>
	        		<xsl:apply-templates select="name" mode="forms"/>
	        	</xsl:otherwise>
        		</xsl:choose>
			</th>

			<td><xsl:value-of select="value"/></td>
		</tr>
</xsl:template>

<xsl:template match="Select" mode="quick_mail">
		<tr>
			<th width="40%">
	        	<xsl:choose>
        		<xsl:when test="title != ''">
        			<xsl:value-of select="title" disable-output-escaping="yes"/>
	        	</xsl:when>
        		<xsl:otherwise>
	        		<xsl:apply-templates select="name" mode="forms"/>
	        	</xsl:otherwise>
        		</xsl:choose>
			</th>

			<td><xsl:value-of select="value"/></td>
		</tr>
</xsl:template>

<xsl:template match="SelectList" mode="quick_mail">
	<xsl:param name="enums"/>
	<xsl:variable name="value" select="value"/>
		<tr>
			<th width="40%">
	        	<xsl:choose>
        		<xsl:when test="title != ''">
        			<xsl:value-of select="title" disable-output-escaping="yes"/>
	        	</xsl:when>
        		<xsl:otherwise>
	        		<xsl:apply-templates select="name" mode="forms"/>
	        	</xsl:otherwise>
        		</xsl:choose>
			</th>

			<td><xsl:value-of select="enums/*[id=$value]/name"/></td>
		</tr>
</xsl:template>

<xsl:template match="DateField" mode="quick_mail">
		<tr>
			<th width="40%">
	        	<xsl:choose>
        		<xsl:when test="title != ''">
        			<xsl:value-of select="title" disable-output-escaping="yes"/>
	        	</xsl:when>
        		<xsl:otherwise>
	        		<xsl:apply-templates select="name" mode="forms"/>
	        	</xsl:otherwise>
        		</xsl:choose>
			</th>

			<td>
				<!--xsl:call-template name="datetime_numeric_ru">
					<xsl:with-param name="year"  select="value_parsed/year"/>
					<xsl:with-param name="month" select="value_parsed/month"/>
					<xsl:with-param name="day"   select="value_parsed/day"/>
				</xsl:call-template-->
				<xsl:if test="value != ''">
					<xsl:value-of select="value"/> г.
				</xsl:if>
			</td>
		</tr>
</xsl:template>

<xsl:template match="TimeField" mode="quick_mail">
		<tr>
			<th width="40%">
	        	<xsl:choose>
        		<xsl:when test="title != ''">
        			<xsl:value-of select="title" disable-output-escaping="yes"/>
	        	</xsl:when>
        		<xsl:otherwise>
	        		<xsl:apply-templates select="name" mode="forms"/>
	        	</xsl:otherwise>
        		</xsl:choose>
			</th>

			<td>
				<!--xsl:call-template name="datetime_numeric_ru">
					<xsl:with-param name="year"  select="value_parsed/year"/>
					<xsl:with-param name="month" select="value_parsed/month"/>
					<xsl:with-param name="day"   select="value_parsed/day"/>
				</xsl:call-template-->
				<xsl:text> с </xsl:text>
					<xsl:value-of select="value/from"/>
				<xsl:text> до </xsl:text>
					<xsl:value-of select="value/to"/>
			</td>
		</tr>
</xsl:template>

<xsl:template match="TextArea" mode="quick_mail">
		<tr>
			<th width="40%">
	        	<xsl:choose>
        		<xsl:when test="title != ''">
        			<xsl:value-of select="title" disable-output-escaping="yes"/>
	        	</xsl:when>
        		<xsl:otherwise>
	        		<xsl:apply-templates select="name" mode="forms"/>
	        	</xsl:otherwise>
        		</xsl:choose>
			</th>

			<td><xsl:value-of select="value"/></td>
		</tr>
</xsl:template>

<xsl:template match="Gp" mode="quick_mail">
</xsl:template>

<xsl:template match="UploadFile" mode="quick_mail">
</xsl:template>

</xsl:stylesheet>
