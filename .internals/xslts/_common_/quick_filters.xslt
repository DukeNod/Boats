<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="SelectList" mode="quick_filters">
	<xsl:param name="class" select="'input_text form-control'"/>
	<xsl:param name="enums" select="null"/>
	<xsl:param name="empty" select="''"/>
	        <span class="text">
	        	<xsl:choose>
        		<xsl:when test="title != ''">
        			<xsl:value-of select="title" disable-output-escaping="yes"/>
	        	</xsl:when>
        		<xsl:otherwise>
	        		<xsl:apply-templates select="name" mode="forms"/>
	        	</xsl:otherwise>
        		</xsl:choose>
	        </span> 
        	       	<select class="{$class}" name="filter_{name}" id="{name}">
        	       		<xsl:if test="empty!=''">
        	       			<option value=""><xsl:value-of select="empty"/></option>
        	       		</xsl:if>
        	       		<xsl:variable name="value" select="value" />
        	       		<xsl:for-each select="enums/*">
        	       			<option value="{id}">
        	       			<xsl:if test="id=$value">
	        	       			<xsl:attribute name="selected"/>
        	       			</xsl:if>
        	       			<xsl:value-of select="name" disable-output-escaping="yes"/>
        	       			</option>
        	       		</xsl:for-each>
	        	</select>
          <br/>
</xsl:template>

<xsl:template match="SelectList" mode="quick_filters_sublist">
	<xsl:param name="class" select="'input_text'"/>
	<xsl:param name="enums" select=".."/>
	<xsl:param name="empty" select="''"/>
	        <span class="text"><xsl:apply-templates select="name" mode="forms"/></span> 
       	       	<select class="{$class}" name="filter_{name}" id="{name}">
       	       		<xsl:if test="$empty!=''">
       	       			<option value=""><xsl:value-of select="$empty"/></option>
       	       		</xsl:if>
       	       		<xsl:variable name="value" select="value" />
       	       		<xsl:for-each select="$enums/category">
	       	       		<optgroup label="{name}">
	       	       		<xsl:for-each select="items/item">
       		       			<option value="{id}">
       	       				<xsl:if test="id=$value">
        	       				<xsl:attribute name="selected"/>
       	       				</xsl:if>
	       	       			<xsl:value-of select="name" disable-output-escaping="yes"/>
       		       			</option>
	       	       		</xsl:for-each>
	       	       		</optgroup>
       	       		</xsl:for-each>
        	</select>
</xsl:template>

<xsl:template match="Select" mode="quick_filters">
	<xsl:param name="class" select="'input_text form-control'"/>
	<xsl:param name="enums" select="null"/>
	<xsl:param name="empty" select="''"/>
	        <span class="text">
	        	<xsl:choose>
        		<xsl:when test="title != ''">
        			<xsl:value-of select="title" disable-output-escaping="yes"/>
	        	</xsl:when>
        		<xsl:otherwise>
	        		<xsl:apply-templates select="name" mode="forms"/>
	        	</xsl:otherwise>
        		</xsl:choose>
	        </span> 
			<select class="{$class}" name="filter_{name}" id="{name}">
				<xsl:if test="submit='1'">
					<xsl:attribute name="onchange">
						this.form.submit()
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="style!=''">
					<xsl:attribute name="style">
						<xsl:value-of select="style" disable-output-escaping="yes"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="empty!=''">
        	    	<option value=""><xsl:value-of select="empty"/></option>
				</xsl:if>
				<xsl:variable name="value" select="value" />
				<xsl:for-each select="values_list/value">
					<option value="{id}">
						<xsl:if test="id = $value">
							<xsl:attribute name="selected"/>
						</xsl:if>
						<xsl:value-of select="value" disable-output-escaping="yes"/>
					</option>
				</xsl:for-each>
			</select>
</xsl:template>

<xsl:template match="Radio" mode="quick_filters">
	<xsl:param name="class" select="'input_text'"/>

	        <xsl:variable name="radio_list">
		        <xsl:apply-templates select="name" mode="radio_list"/>
	        </xsl:variable>
		<xsl:call-template name="quick_filters_radio_element">
			<xsl:with-param name="options" select="$radio_list"/>
			<xsl:with-param name="value" select="value"/>
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
</xsl:template>

<xsl:template match="CheckBox" mode="quick_filters">
	<xsl:param name="class" select="'input_text'"/>

        <span class="text"><xsl:apply-templates select="name" mode="forms"/><xsl:if test="required=1">*</xsl:if></span> 
	<input type="checkbox"  name="filter_{name}" id="{name}" value="1" class="{$class}">
		<xsl:if test="value=1"><xsl:attribute name="checked"/></xsl:if>
	</input>
</xsl:template>

<xsl:template match="CheckBoxSelector" mode="quick_filters">
	<input type="hidden" name="filter_{name}" id="hidden_{name}" value="0" />
	<input type="checkbox" name="filter_{name}" id="{name}" value="1">
		<xsl:if test="cssclass != ''">
			<xsl:attribute name="class">
				<xsl:value-of select="cssclass" disable-output-escaping="yes"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="value=1">
			<xsl:attribute name="checked"/>
		</xsl:if>
	</input>
	<xsl:if test="title != ''">
		<span>
			<xsl:value-of select="title" disable-output-escaping="yes"/>
		</span>
	</xsl:if>
</xsl:template>

<xsl:template match="TextField" mode="quick_filters">
	<xsl:param name="class" select="'input_text'"/>

        <span class="text" id="filter-{name}-title">
        	<xsl:choose>
        	<xsl:when test="title != ''">
        		<xsl:value-of select="title" disable-output-escaping="yes"/>
        	</xsl:when>
        	<xsl:otherwise>
	        	<xsl:apply-templates select="name" mode="forms"/>
        	</xsl:otherwise>
        	</xsl:choose>
        	<xsl:if test="required=1">*</xsl:if>
        </span> 
	<input type="text" name="filter_{name}" value="{value}" class="{$class} form-control" id="{element_id}"/>
	<xsl:if test="comment != ''">
		<span class="hint"><xsl:value-of select="comment" disable-output-escaping="yes"/></span>
	</xsl:if>
	<xsl:if test="autocomplete">
		<script type="text/javascript">
			$(function(){
			var field_name = '<xsl:value-of select="element_id"/>';
			var url = '<xsl:value-of select="autocomplete/url"/>';
			<![CDATA[
				$('#'+field_name).autocomplete({
					minLength: 2
					,source: PUB_ROOT +url
					,select: function( event, ui )
					{
						$(this).val( ui.item.value );
						$(this).data( 'item', ui.item );
				 
						return false;
					}
				}).data("ui-autocomplete")._renderItem = function(ul, item)
				{
						  return $( "<li>" )
							.append( "<div>" + item.name + "</div>" )
							.appendTo( ul );
				};
			});
		]]></script>
	</xsl:if>

</xsl:template>

<xsl:template match="TextField" mode="quick_filters_email">
	<xsl:param name="class" select="'large input m-comment-font'"/>
	<tr>
		<td class="name">
			<xsl:apply-templates select="name" mode="forms"/><xsl:if test="required=1"> *</xsl:if>
		</td>
		<td class="value">
		        <xsl:variable name="value">
		        	<xsl:choose>
		        	<xsl:when test="value!=''"><xsl:value-of select="value"/></xsl:when>
		        	<xsl:otherwise>login@domain.ru</xsl:otherwise>
		        	</xsl:choose>
		        </xsl:variable>
			<input type="text" name="filter_{name}" value="{$value}" class="{$class}">
			 <xsl:attribute name="onfocus">if(this.value=="login@domain.ru") {this.value=""; this.style.color="#000"}</xsl:attribute>
			 <xsl:attribute name="onblur">if(this.value==""){this.value="login@domain.ru"; this.style.color="#92978a"}</xsl:attribute>
			</input>
		</td>
	</tr>
</xsl:template>

<xsl:template match="Email" mode="quick_filters">
	<xsl:param name="class" select="'input_text'"/>

        <span class="text">
        	<xsl:choose>
        	<xsl:when test="title != ''">
        		<xsl:value-of select="title" disable-output-escaping="yes"/>
        	</xsl:when>
        	<xsl:otherwise>
	        	<xsl:apply-templates select="name" mode="forms"/>
        	</xsl:otherwise>
        	</xsl:choose>
        	<xsl:if test="required=1">*</xsl:if>
        </span> 
	<input type="text" name="filter_{name}" value="{value}" class="{$class}"/>
	<xsl:if test="comment != ''">
		<span class="hint"><xsl:value-of select="comment" disable-output-escaping="yes"/></span>
	</xsl:if>
          <br/>

</xsl:template>

<xsl:template match="DateField" mode="quick_filters">
	<xsl:param name="class" select="'input_text'"/>

        <span class="text" id="filter-{name}-title">
        	<xsl:choose>
        	<xsl:when test="title != ''">
        		<xsl:value-of select="title" disable-output-escaping="yes"/>
        	</xsl:when>
        	<xsl:otherwise>
	        	<xsl:apply-templates select="name" mode="forms"/>
        	</xsl:otherwise>
        	</xsl:choose>
		</span> 
	
	<xsl:text>&nbsp;&nbsp;</xsl:text>
	<xsl:call-template name="calendar_dateonly">
		<xsl:with-param name="id" select="element_id"/>
		<xsl:with-param name="name" select="concat('filter_', name)"/>
		<xsl:with-param name="class" select="'m-valign-middle'"/>
		<xsl:with-param name="value">
			<xsl:call-template name="datetime_numeric_ru">
				<xsl:with-param name="year"   select="value_parsed/year"/>
				<xsl:with-param name="month"  select="value_parsed/month"/>
				<xsl:with-param name="day"    select="value_parsed/day"/>
			</xsl:call-template>
			<xsl:if test="not(value_parsed)"><xsl:value-of select="value"/></xsl:if>
		</xsl:with-param>
		<xsl:with-param name="mindate" select="mindate"/>
		<xsl:with-param name="maxdate" select="maxdate"/>
		<xsl:with-param name="format" select="format"/>
		<xsl:with-param name="submit" select="submit"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="AutocompleteField" mode="quick_filters">
	<xsl:param name="class" select="'input_text'"/>

        <span class="text" id="filter-{name}-title">
        	<xsl:choose>
        	<xsl:when test="title != ''">
        		<xsl:value-of select="title" disable-output-escaping="yes"/>
        	</xsl:when>
        	<xsl:otherwise>
	        	<xsl:apply-templates select="name" mode="forms"/>
        	</xsl:otherwise>
        	</xsl:choose>
        	<xsl:if test="required=1">*</xsl:if>
        </span> 
	<input type="text" name="filter_{name}_txt" value="{value_txt}" placeholder="{placeholder}" class="{$class}" id="{element_id}"/>
	<input type="hidden" id="{element_id}_hidden" name="filter_{name}" value="{value}"/>
	<xsl:if test="comment != ''">
		<span class="hint"><xsl:value-of select="comment" disable-output-escaping="yes"/></span>
	</xsl:if>
	
	<xsl:if test="autocomplete">
		<script type="text/javascript">
			$(function(){
			var field_name = '<xsl:value-of select="element_id"/>';
			var url = '<xsl:value-of select="autocomplete/url"/>';
			<![CDATA[
				$('#'+field_name).autocomplete({
					minLength: 2
					,source: PUB_ROOT +url
					,select: function( event, ui )
					{
						$('#'+field_name+'_hidden').val(ui.item.id).valid();
						$(this).val( ui.item.value );
						$(this).data( 'item', ui.item );
				 
						return false;
					}
				}).data("ui-autocomplete")._renderItem = function(ul, item)
				{
						  return $( "<li>" )
							.append( "<div>" + item.value + "</div>" )
							.appendTo( ul );
				};
				
				$('#'+field_name).on('input paste', function()
				{
					$('#'+field_name+'_hidden').val("").valid(); 
				}).blur(function()
				{
					if(!$('#'+field_name+'_hidden').val()) $(this).val("");
				});
			});
		]]></script>
	</xsl:if>

</xsl:template> 

<xsl:template match="DateTimeField" mode="quick_filters">
	<xsl:param name="class" select="'input_text'"/>

        <span class="text" id="filter-{name}-title">
        	<xsl:choose>
        	<xsl:when test="title != ''">
        		<xsl:value-of select="title" disable-output-escaping="yes"/>
        	</xsl:when>
        	<xsl:otherwise>
	        	<xsl:apply-templates select="name" mode="forms"/>
        	</xsl:otherwise>
        	</xsl:choose>
		</span>

	<xsl:text>&nbsp;&nbsp;</xsl:text>
	<xsl:call-template name="calendar_datetime">
		<xsl:with-param name="id" select="element_id"/>
		<xsl:with-param name="name" select="concat('filter_', name)"/>
		<xsl:with-param name="class" select="'m-valign-middle'"/>
		<xsl:with-param name="value">
			<xsl:call-template name="datetime_numeric_ru">
				<xsl:with-param name="year"   select="value_parsed/year"/>
				<xsl:with-param name="month"  select="value_parsed/month"/>
				<xsl:with-param name="day"    select="value_parsed/day"/>
				<xsl:with-param name="hour"   select="value_parsed/hour"/>
				<xsl:with-param name="minute" select="value_parsed/minute"/>
				<xsl:with-param name="second" select="value_parsed/second"/>
			</xsl:call-template>
			<xsl:if test="not(value_parsed)"><xsl:value-of select="value"/></xsl:if>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="TimeField" mode="quick_filters">
	<xsl:param name="class" select="'input_text'"/>

<div class="time">
        <span class="text">
        	<xsl:choose>
        	<xsl:when test="title != ''">
        		<xsl:value-of select="title" disable-output-escaping="yes"/>
        	</xsl:when>
        	<xsl:otherwise>
	        	<xsl:apply-templates select="name" mode="forms"/>
        	</xsl:otherwise>
        	</xsl:choose>
	        <xsl:if test="required=1">*</xsl:if>
	</span> 
	<xsl:text> с </xsl:text>
	<input type="text" name="{name}[from]" value="{value/from}" class="{$class}"/>
	<xsl:text> до </xsl:text>
	<input type="text" name="{name}[to]" value="{value/to}" class="{$class}"/>
</div>
          <br/>
</xsl:template>

<xsl:template name="quick_filters_options">
	<xsl:param name="options"/>
	<xsl:param name="value"/>

	<xsl:if test="$options!=''">
		<xsl:variable name="op" select="substring-before($options,',')"/>
		<xsl:variable name="option">
			<xsl:choose>
			<xsl:when test="$op!=''">
				<xsl:value-of select="$op"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$options"/>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<option>
			<xsl:if test="$option=$value"><xsl:attribute name="selected"/></xsl:if>
			<xsl:value-of select="$option"/>
		</option>
		<xsl:call-template name="quick_filters_options">
			<xsl:with-param name="options" select="substring-after($options,',')"/>
			<xsl:with-param name="value" select="$value"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template name="quick_filters_radio_element">
	<xsl:param name="options"/>
	<xsl:param name="value"/>

	<xsl:if test="$options!=''">
		<xsl:variable name="op" select="substring-before($options,',')"/>
		<xsl:variable name="option">
			<xsl:choose>
			<xsl:when test="$op!=''">
				<xsl:value-of select="$op"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$options"/>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<input type="radio" value="{$option}">
			<xsl:if test="$option=$value"><xsl:attribute name="checked"/></xsl:if>
		</input>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$option"/>
		<xsl:call-template name="quick_filters_options">
			<xsl:with-param name="options" select="substring-after($options,',')"/>
			<xsl:with-param name="value" select="$value"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>


</xsl:stylesheet>
