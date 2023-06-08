<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="SelectList" mode="quick_form">
	<xsl:param name="class" select="'input_text'"/>
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
        	       	<select class="{$class}" name="{name}" id="{name}">
        	       		<xsl:if test="$empty!=''">
        	       			<option value=""><xsl:value-of select="$empty"/></option>
        	       		</xsl:if>
        	       		<xsl:variable name="value" select="value" />
        	       		<xsl:for-each select="$enums/*">
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

<xsl:template match="SelectList" mode="quick_form_sublist">
	<xsl:param name="class" select="'input_text'"/>
	<xsl:param name="enums" select=".."/>
	<xsl:param name="empty" select="''"/>
	        <span class="text"><xsl:apply-templates select="name" mode="forms"/></span> 
       	       	<select class="{$class}" name="{name}" id="{name}">
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
          <br/>
</xsl:template>

<xsl:template match="Select" mode="quick_form">
	<xsl:param name="class" select="'input_text'"/>
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
        	       	<select class="{$class}" name="{name}" id="{name}">
        	       		<xsl:if test="$empty!=''">
        	       			<option value=""><xsl:value-of select="$empty"/></option>
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

<xsl:template match="Radio" mode="quick_form">
	<xsl:param name="class" select="'input_text'"/>

	        <xsl:variable name="radio_list">
		        <xsl:apply-templates select="name" mode="radio_list"/>
	        </xsl:variable>
		<xsl:call-template name="quick_form_radio_element">
			<xsl:with-param name="options" select="$radio_list"/>
			<xsl:with-param name="value" select="value"/>
			<xsl:with-param name="class" select="$class"/>
		</xsl:call-template>
</xsl:template>

<xsl:template match="CheckBox" mode="quick_form">
	<xsl:param name="class" select="'input_text'"/>

        <span class="text"><xsl:apply-templates select="name" mode="forms"/></span> 
	<input type="checkbox"  name="{name}" id="{name}" value="1" class="{$class}">
		<xsl:if test="value=1"><xsl:attribute name="checked"/></xsl:if>
	</input>
</xsl:template>

<xsl:template match="TextField" mode="quick_form">
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
        </span> 
	<input type="text" name="{name}" value="{value}" class="{$class}"/>
	<xsl:if test="comment != ''">
		<span class="hint"><xsl:value-of select="comment" disable-output-escaping="yes"/></span>
	</xsl:if>
          <br/>

</xsl:template>

<xsl:template match="TextFieldPrefix" mode="quick_form_request">

	<div class="form-group row">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
		<div class="col-xs-6 col-md-sm-6 col-md-6 col-lg-6 form-control-prefix">
			<xsl:value-of select="prefix"/>
			<input type="text" id="{element_id}" name="{name}" class="input-prefix" onFocus="$(this).parent().addClass('active')" onBlur="$(this).parent().removeClass('active')" placeholder="{placeholder}" value="{value}">
				<xsl:if test="regexp">
					<xsl:attribute name="data-inputmask-regex">
						<xsl:value-of select="regexp" disable-output-escaping="yes"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="required = 1">
					<xsl:attribute name="required">required</xsl:attribute>
				</xsl:if>
			</input>
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
		</div>
	</div>

</xsl:template>

<xsl:template match="Password" mode="quick_form">
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
        </span> 
	<input type="password" name="{name}" class="{$class}"/>
</xsl:template>

<xsl:template match="TextField" mode="quick_form_password">
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
        </span> 
	<input type="password" name="{name}" class="{$class}"/>
</xsl:template>

<xsl:template match="TextField" mode="quick_form_email">
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
			<input type="text" name="{name}" value="{$value}" class="{$class}">
			 <xsl:attribute name="onfocus">if(this.value=="login@domain.ru") {this.value=""; this.style.color="#000"}</xsl:attribute>
			 <xsl:attribute name="onblur">if(this.value==""){this.value="login@domain.ru"; this.style.color="#92978a"}</xsl:attribute>
			</input>
		</td>
	</tr>
</xsl:template>

<xsl:template match="Email" mode="quick_form">
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
        </span> 
	<input type="text" name="{name}" value="{value}" class="{$class}"/>
	<xsl:if test="comment != ''">
		<span class="hint"><xsl:value-of select="comment" disable-output-escaping="yes"/></span>
	</xsl:if>
          <br/>

</xsl:template>

<xsl:template match="TextArray" mode="quick_form">
	<xsl:for-each select="value/*">
		<input type="hidden" name="{../../name}[{id}]" value="{value}"/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="DateField" mode="quick_form">
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
	</span> 

	<input type="text" id="{name}" name="{name}" class="{$class}">
		<xsl:attribute name="value">
			<xsl:call-template name="datetime_numeric_ru">
				<xsl:with-param name="year"  select="value_parsed/year"/>
				<xsl:with-param name="month" select="value_parsed/month"/>
				<xsl:with-param name="day"   select="value_parsed/day"/>
			</xsl:call-template>
			<xsl:if test="not(value_parsed)"><xsl:value-of select="value"/></xsl:if>
		</xsl:attribute>
	</input>
	<xsl:text>&nbsp;&nbsp;</xsl:text>
	<xsl:call-template name="calendar_dateonly">
		<xsl:with-param name="id" select="name"/>
		<xsl:with-param name="class" select="'m-valign-middle'"/>
	</xsl:call-template>
          <br/>
</xsl:template>

<xsl:template match="DateTimeField" mode="quick_form">
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
	</span> 

	<input type="text" id="{name}" name="{name}" class="{$class}">
		<xsl:attribute name="value">
			<xsl:call-template name="datetime_numeric_ru">
				<xsl:with-param name="year"  select="value_parsed/year"/>
				<xsl:with-param name="month" select="value_parsed/month"/>
				<xsl:with-param name="day"   select="value_parsed/day"/>
				<xsl:with-param name="hour"   select="value_parsed/hour"/>
				<xsl:with-param name="minute" select="value_parsed/minute"/>
				<xsl:with-param name="second" select="value_parsed/second"/>
			</xsl:call-template>
			<xsl:if test="not(value_parsed)"><xsl:value-of select="value"/></xsl:if>
		</xsl:attribute>
	</input>
	<xsl:text>&nbsp;&nbsp;</xsl:text>
	<xsl:call-template name="calendar_datetime">
		<xsl:with-param name="id" select="name"/>
		<xsl:with-param name="class" select="'m-valign-middle'"/>
	</xsl:call-template>
          <br/>
</xsl:template>

<xsl:template match="TimeField" mode="quick_form">
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
	</span> 
	<xsl:text> с </xsl:text>
	<input type="text" name="{name}[from]" value="{value/from}" class="{$class}"/>
	<xsl:text> до </xsl:text>
	<input type="text" name="{name}[to]" value="{value/to}" class="{$class}"/>
</div>
          <br/>
</xsl:template>

<xsl:template match="TextArea" mode="quick_form">
        <span class="text"><xsl:apply-templates select="name" mode="forms"/></span> 
	<textarea  cols="10" rows="10" name="{name}">
		<xsl:value-of select="value" disable-output-escaping="yes"/>
	</textarea>
          <br/>
</xsl:template>

<xsl:template match="TextArea" mode="quick_form_address">
        <span class="text"><xsl:apply-templates select="name" mode="forms"/></span> 
        <xsl:variable name="value">
        	<xsl:choose>
        	<xsl:when test="value!=''"><xsl:value-of select="value"/></xsl:when>
        	<xsl:otherwise>Индекс, Страна, Край/Область, название улицы, дом, квартира</xsl:otherwise>
        	</xsl:choose>
        </xsl:variable>
	<textarea  cols="10" rows="10" name="{name}">
		<xsl:attribute name="onfocus">if(this.value=="Индекс, Страна, Край/Область, название улицы, дом, квартира") {this.value=""}</xsl:attribute>
		<xsl:attribute name="onblur">if(this.value==""){this.value="Индекс, Страна, Край/Область, название улицы, дом, квартира"}</xsl:attribute>
		<xsl:value-of select="$value" disable-output-escaping="yes"/>
	</textarea>
</xsl:template>

<xsl:template match="Gp" mode="quick_form">
          <div class="capcha_block"> * — поля со звездочкой обязательны для заполнения<br/>
            Вычислите выражение на рисунке<br/>
            <input type="hidden" name="gp_id" value="{gp_id}"/>
            <img src="{/*/system/info/pub_root}gp/{gp_id}" width="{gp_w}" height="{gp_h}" alt="{/*/inlines/inline[label='text:gp']/content}" title="{/*/inlines/inline[label='text:gp']/content}"/>
            <input type="text" class="input_text capcha" name="gp_answer"/>
          </div>
</xsl:template>

<xsl:template match="UploadFile" mode="quick_form">
	<xsl:param name="class" select="''"/>
		<div class="file-input-box">
			<input id="fileName" class="file-input-text" readonly="readonly"  value="{file_name}"/>
			<input class="file-input" name="{name}" size="1" type="file" accept="image/jpeg, image/png, image/bmp" onchange="document.getElementById('fileName').value=this.value;" />
			<input type="hidden" name="{name}_temp" value="{temp}"/>
		</div><span class="text"><xsl:apply-templates select="name" mode="forms"/><xsl:if test="required=1"> *</xsl:if></span> 
	        <span class="hint_file"><xsl:value-of select="comment" disable-output-escaping="yes"/></span>

		<!--xsl:if test="attach_name!=''">
		<br/>Сейчас прикреплён файл <nobr><xsl:value-of select="attach_name"/></nobr>
		</xsl:if-->
</xsl:template>

<xsl:template name="quick_form_options">
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
		<xsl:call-template name="quick_form_options">
			<xsl:with-param name="options" select="substring-after($options,',')"/>
			<xsl:with-param name="value" select="$value"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template name="quick_form_radio_element">
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
		<xsl:call-template name="quick_form_options">
			<xsl:with-param name="options" select="substring-after($options,',')"/>
			<xsl:with-param name="value" select="$value"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>


<xsl:template match="TextField" mode="quick_form_order">
	<xsl:param name="class" select="'input_text'"/>
	<xsl:param name="pos"/>

        <div class="order_block"> <span class="text_order">
        	<xsl:choose>
        	<xsl:when test="title != ''">
        		<xsl:value-of select="title" disable-output-escaping="yes"/>
        	</xsl:when>
        	<xsl:otherwise>
	        	<xsl:apply-templates select="name" mode="forms"/>
        	</xsl:otherwise>
        	</xsl:choose>
        </span> 
          <input type="text" name="order[{$pos}][{name}]" value="{value}" class="{$class}"/>
	  <xsl:if test="comment != ''">
          <span class="icon_block"><span class="icon"><span class="hint_text">
	          <xsl:value-of select="comment" disable-output-escaping="yes"/>
          </span></span></span>
	  </xsl:if>
        </div>

</xsl:template>

<xsl:template match="SelectList" mode="quick_form_order">
	<xsl:param name="class" select="'input_text'"/>
	<xsl:param name="enums" select="null"/>
	<xsl:param name="empty" select="''"/>
	<xsl:param name="pos"/>

        <div class="order_block"> <span class="text_order">
	        	<xsl:choose>
        		<xsl:when test="title != ''">
        			<xsl:value-of select="title" disable-output-escaping="yes"/>
	        	</xsl:when>
        		<xsl:otherwise>
	        		<xsl:apply-templates select="name" mode="forms"/>
	        	</xsl:otherwise>
        		</xsl:choose>
          </span> 
        	       	<select name="order[{$pos}][{name}]" id="{name}">
        	       		<xsl:if test="$empty!=''">
        	       			<option value=""><xsl:value-of select="$empty"/></option>
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

	  <xsl:if test="comment != ''">
          <span class="icon_block"><span class="icon"><span class="hint_text">
	          <xsl:value-of select="comment" disable-output-escaping="yes"/>
          </span></span></span>
	  </xsl:if>

        </div>

</xsl:template>

<xsl:template match="Select" mode="quick_form_order">
	<xsl:param name="class" select="'input_text'"/>
	<xsl:param name="enums" select="null"/>
	<xsl:param name="empty" select="''"/>
	<xsl:param name="pos"/>

        <div class="order_block"> <span class="text_order">
	        	<xsl:choose>
        		<xsl:when test="title != ''">
        			<xsl:value-of select="title" disable-output-escaping="yes"/>
	        	</xsl:when>
        		<xsl:otherwise>
	        		<xsl:apply-templates select="name" mode="forms"/>
	        	</xsl:otherwise>
        		</xsl:choose>
	        </span> 
        	       	<select name="order[{$pos}][{name}]" id="{name}">
        	       		<xsl:if test="$empty!=''">
        	       			<option value=""><xsl:value-of select="$empty"/></option>
        	       		</xsl:if>
        	       		<xsl:variable name="value" select="value" />
        	       		<xsl:for-each select="values/value">
        	       			<option value="{.}">
        	       			<xsl:if test=". = $value">
	        	       			<xsl:attribute name="selected"/>
        	       			</xsl:if>
        	       			<xsl:value-of select="." disable-output-escaping="yes"/>
        	       			</option>
        	       		</xsl:for-each>
	        	</select>

	  <xsl:if test="comment != ''">
          <span class="icon_block"><span class="icon"><span class="hint_text">
	          <xsl:value-of select="comment" disable-output-escaping="yes"/>
          </span></span></span>
	  </xsl:if>

        </div>
</xsl:template>


<xsl:template match="GroupField" mode="quick_form_request">
	<xsl:apply-templates select="title" mode="quick_form_header"/>
	<div class="{class}" id="{element_id}">
		<xsl:apply-templates select="fields/*" mode="quick_form_request"/>
	</div>
</xsl:template>

<xsl:template match="GroupTableField" mode="quick_form_request">
	<xsl:apply-templates select="title" mode="quick_form_header"/>

	<xsl:for-each select="fields/*[position() &lt; 7 and ((position()-1) mod 2)=0]">
	<xsl:variable name="pos" select="position()" />
	<div class="form-group row">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
		<xsl:for-each select=". | following-sibling::*[position()&lt;2]">
			<!--xsl:apply-templates select="fields/*" mode="quick_form_request"/-->
			 <div class="col-xs-3 col-sm-4 col-md-4 col-lg-3">
				<input type="text" id="{element_id}" name="{name}" placeholder="{placeholder}" value="{value}" class="form-control">
				<xsl:if test="regexp">
					<xsl:attribute name="data-inputmask-regex">
						<xsl:value-of select="regexp" disable-output-escaping="yes"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="required = 1">
					<xsl:attribute name="required">required</xsl:attribute>
				</xsl:if>
				</input>
			</div>
			<div class="col-xs-1 col-sm-1 col-md-1 col-lg-1">
				<xsl:if test="position() = 1 and ($pos = 1 or $pos = 2)">
					<label id="{element_id}_label" class="checkbox-inline"><input type="checkbox" id="{element_id}_checkbox" name="checkbox_{name}"/>Отсутствует</label>
				</xsl:if>
			</div>
		</xsl:for-each>
	</div>
	</xsl:for-each>
	<xsl:for-each select="fields/*[position() &gt;= 7]">
		<xsl:apply-templates select="." mode="quick_form_request"/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="TextField" mode="quick_form_request">

	<div class="form-group row">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
		<div class="col-xs-6 col-md-sm-6 col-md-6 col-lg-6">
			<input type="text" id="{element_id}" name="{name}" placeholder="{placeholder}" value="{value}" class="form-control {cssClass}">
				<xsl:if test="regexp">
					<xsl:attribute name="data-inputmask-regex">
						<xsl:value-of select="regexp" disable-output-escaping="yes"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="required = 1">
					<xsl:attribute name="required">required</xsl:attribute>
				</xsl:if>
				<xsl:if test="disabled = 1">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:if>
			</input>
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
		</div>
	</div>

</xsl:template>

<xsl:template match="TextFieldPassword" mode="quick_form_request">

	<div class="form-group row">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
		<div class="col-xs-6 col-md-sm-6 col-md-6 col-lg-6">
			<div class="input-group">
				<input type="text" id="{element_id}" name="{name}" placeholder="{placeholder}" value="{value}" class="form-control">
					<xsl:if test="regexp">
						<xsl:attribute name="data-inputmask-regex">
							<xsl:value-of select="regexp" disable-output-escaping="yes"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="required = 1">
						<xsl:attribute name="required">required</xsl:attribute>
					</xsl:if>
				</input>
				<span class="input-group-btn">
					<button class="btn btn-default" type="button" id="{element_id}_btn"><span class="glyphicon glyphicon-retweet"></span></button>
				</span>
			</div><!-- /input-group -->
			<script type="text/javascript">
				$(function(){
				var min_cnt = <xsl:value-of select="min_count"/>
				var field_name = '<xsl:value-of select="element_id"/>';
				var field_name_btn = '<xsl:value-of select="element_id"/>_btn';
				<![CDATA[
					function str_rand() {
						var result       = '';
						var words        = '0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
						var max_position = words.length - 1;
						var _istrue = null;
						
						do {
							result       = '';
							_istrue = null;
							for( i = 0; i < min_cnt; ++i ) {
								position = Math.floor ( Math.random() * max_position );
								result = result + words.substring(position, position + 1);
							}
							_istrue = result.match( /(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]/g );
							
						} while (_istrue == null);
						return result;
					}
					
					$('#'+field_name_btn).click(function () {
						$('#'+field_name).val(str_rand());
					});
				});
			]]></script>
		</div>
	</div>

</xsl:template>

<xsl:template match="Password" mode="quick_form_request">
	
	<div class="form-group row">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
		<div class="col-xs-6 col-md-sm-6 col-md-6 col-lg-6">
			<input type="password" id="password1" name="password1" placeholder="{placeholder}" value="{value}" class="form-control">
				<xsl:if test="regexp">
					<xsl:attribute name="data-inputmask-regex">
						<xsl:value-of select="regexp" disable-output-escaping="yes"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="required = 1">
					<xsl:attribute name="required">required</xsl:attribute>
				</xsl:if>
			</input>
		</div>
	</div>
	<div class="form-group row">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3">Еще раз пароль</label>
		<div class="col-xs-6 col-md-sm-6 col-md-6 col-lg-6">
			<input type="password" id="password2" name="password2" placeholder="{placeholder}" value="{value}" class="form-control">
				<xsl:if test="regexp">
					<xsl:attribute name="data-inputmask-regex">
						<xsl:value-of select="regexp" disable-output-escaping="yes"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="required = 1">
					<xsl:attribute name="required">required</xsl:attribute>
				</xsl:if>
			</input>
		</div>
	</div>
	
</xsl:template>

<xsl:template match="TextArea" mode="quick_form_request">

	<div class="form-group row">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
		<div class="col-xs-6 col-md-sm-6 col-md-6 col-lg-6">
			<textarea type="text" id="{element_id}" name="{name}" placeholder="{placeholder}" class="form-control">
				<xsl:value-of select="value" disable-output-escaping="yes"/>
			</textarea>
		</div>
	</div>

</xsl:template>

<xsl:template match="AutocompleteField" mode="quick_form_request">

	<div class="form-group row">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
		<div class="col-xs-6 col-md-sm-6 col-md-6 col-lg-6">
			<input type="text" id="{element_id}" name="{element_id}" placeholder="{placeholder}" value="{value_txt}" class="form-control">
				<xsl:if test="required = 1">
					<xsl:attribute name="required">required</xsl:attribute>
				</xsl:if>
			</input>
			<input type="hidden" id="{element_id}_hidden" name="{name}" value="{value}" data-msg="Выберите из подсказок">
				<xsl:if test="required = 1">
					<xsl:attribute name="required">required</xsl:attribute>
				</xsl:if>
			</input>
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
								});
							});
						]]></script>
					</xsl:if>
		</div>
	</div>

</xsl:template> 

<xsl:template match="AutocompleteFieldWthChBox" mode="quick_form_request">

	<div class="form-group row">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
		<div class="col-xs-4 col-md-sm-4 col-md-4 col-lg-4">
			<input type="text" id="{element_id}" name="{element_id}" placeholder="{placeholder}" value="{value_txt}" class="form-control">
				<xsl:if test="required = 1">
					<xsl:attribute name="required">required</xsl:attribute>
				</xsl:if>
			</input>
			<input type="hidden" id="{element_id}_hidden" name="{name}" value="{value}" data-msg="Выберите из подсказок">
				<xsl:if test="required = 1">
					<xsl:attribute name="required">required</xsl:attribute>
				</xsl:if>
			</input>
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
										$('#'+field_name+'_hidden').trigger('change');
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
									$('#'+field_name+'_hidden').trigger('change');
								});
							});
						]]></script>
					</xsl:if>
		</div>
		<div class="col-xs-2 col-md-sm-2 col-md-2 col-lg-2">
			<label id="{element_id}_label" class="checkbox-inline"><input type="checkbox" id="{element_id}_checkbox" name="checkbox_{name}"/><xsl:value-of select="title_chbx" disable-output-escaping="yes"/></label>
		</div>
	</div>

</xsl:template>

<xsl:template match="DadataField" mode="quick_form_request">

	<div class="form-group row">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
		<div class="col-xs-6 col-md-sm-6 col-md-6 col-lg-6">
			<input type="text" id="{element_id}" placeholder="{placeholder}" value="{value_txt}" class="form-control"/>
			<input id="{element_id}_fias" type="hidden" name="{name}" value="{value}" data-msg="Выберите из подсказок"/>
			<script type="text/javascript">
				$(function(){
					var field_id = '<xsl:value-of select="element_id"/>';
					var bounds = '<xsl:value-of select="bounds"/>';
					dadata(field_id, bounds);
				});
			</script>
		</div>
	</div>

</xsl:template>

<xsl:template match="MultiImgUpload" mode="quick_form_request">
	
	<div class="form-group row multi-img" data-name="{name}">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
		<div class="multi-img-wrapper">
			<div class="img-section">
			<xsl:for-each select="value/*">
				<div class="img-block">
					<img class="img_view" src="data:image/jpeg;base64,{value}" alt="" width="200"/>
					<input type="hidden" name="{../../name}[]" value="{value}"/>
					<img class="img_del" src="{/*/system/info/pub_root}i/buttons/delete1.gif" alt=""/>
				</div>
			</xsl:for-each>
			</div>
			<a  class="img_add" href="#"><img src="{/*/system/info/pub_root}i/buttons/insert0.gif" alt=""/> Добавить</a>
			<input type="file" id="{element_id}" accept="image/jpeg, image/png, image/bmp" name="{name}_hidden" class="img-required" style="display: none"> <!-- data-rule-img_required="true"  -->
			</input>
		</div>
	</div>

</xsl:template>

<xsl:template match="UploadFile" mode="quick_form_request">
	<div class="form-group row">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3">
			<xsl:choose>
				<xsl:when test="title != ''">
					<xsl:value-of select="title" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="name" mode="forms"/>
				</xsl:otherwise>
			</xsl:choose>
		</label>
		<div class="col-xs-6 col-md-sm-6 col-md-6 col-lg-6">
			<input type="hidden" name="MAX_FILE_SIZE" value="1048576" /><!-- <1Mb - Поле MAX_FILE_SIZE должно быть указано до поля загрузки файла -->
			<input id="fileName" class="form-control" readonly="readonly" value="{file_name}" /> <!--class="file-input-text"-->
			<input class="form-control" name="{name}" size="1" type="file" onchange="document.getElementById('fileName').value=this.value;" /> <!--class="file-input"-->
		</div>
		<!--span class="hint_file">
			<xsl:value-of select="comment" disable-output-escaping="yes"/>
		</span-->
	</div>
</xsl:template>

<xsl:template match="DateField" mode="quick_form_request">

	<div class="form-group row {cssClass}">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3">
       		<xsl:value-of select="title" disable-output-escaping="yes"/>
		</label>
		<xsl:text>&nbsp;&nbsp;</xsl:text>
		<xsl:call-template name="calendar_dateonly">
			<xsl:with-param name="id" select="element_id"/>
			<xsl:with-param name="name" select="name"/>
			<xsl:with-param name="required" select="required"/>
			<xsl:with-param name="class" select="'col-xs-6 col-md-sm-6 col-md-6 col-lg-6'"/>
			<xsl:with-param name="value">
				<xsl:call-template name="datetime_numeric_ru">
					<xsl:with-param name="year"   select="value_parsed/year"/>
					<xsl:with-param name="month"  select="value_parsed/month"/>
					<xsl:with-param name="day"    select="value_parsed/day"/>
				</xsl:call-template>
				<xsl:if test="not(value_parsed)"><xsl:value-of select="value"/></xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</div>
    
</xsl:template>

<xsl:template match="SelectList" mode="quick_form_request">

		<div class="form-group row  ">
			<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
				<div class="col-xs-6 col-md-sm-6 col-md-6 col-lg-6" style="width: 586px">
        	       	<select class="form-control" name="{name}" id="{element_id}">
										<xsl:if test="required = 1">
											<xsl:attribute name="required">required</xsl:attribute>
										</xsl:if>
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
                </div>
            </div>
	
</xsl:template>

<xsl:template match="ItemsList" mode="quick_form_request">

		<div class="form-group row  ">
			<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
				<div class="col-xs-6 col-md-sm-6 col-md-6 col-lg-6" style="width: 586px">
					<table class="flat">
					<xsl:for-each select="value/*">
					<xsl:variable name="id" select="id"/>
						<tr class="flat">
							<td class="flat" style="vertical-align: middle;">
								<input type="hidden" name="{../../name}[{position()}][id]" value="{id}"/>
								<xsl:value-of select="../../enums/names_for/*[id=current()/id]/name" disable-output-escaping="yes"/>
							</td>
							<td class="flat" style="padding-left: 5px;">
								<button class="inlineButton items_remove" type="submit" name="items_list[{position()}][remove]" value="1" style="width: 20px; height: 20px;">
									<img src="{/*/system/info/pub_root}i/buttons/delete2.gif" width="20" height="20" alt="исключить"/>
								</button>
							</td>
						</tr>
					</xsl:for-each>
						<tr class="flat">
							<td class="flat" style="padding-top: 5px">
								<select class="form-control" name="{name}[new][id]" id="{name}_new">
									<option value=""><xsl:value-of select="empty" disable-output-escaping="yes"/></option>
									<xsl:for-each select="enums/list/*">
										<option value="{id}"><xsl:value-of select="name"/></option>

									</xsl:for-each>
								</select>
							</td>
							<td class="flat" style="padding-left: 5px;">
								<noscript>
								<button class="inlineButton items_append" type="submit" name="items_list[new][append]" value="1" style="width: 20px; height: 20px;">
									<img src="{/*/system/info/pub_root}i/buttons/insert0.gif" width="20" height="20" alt="добавить"/>
								</button>
								</noscript>
							</td>
						</tr>
					</table>
			<script type="text/javascript">
				$(function(){ var prefix = '';
				var field_name = '<xsl:value-of select="name"/>';
				<![CDATA[
					ajax_add_items(prefix, field_name+'_new');
					ajax_del_items(prefix, 'items_remove');
				});
			]]></script>
                </div>
            </div>
	
</xsl:template>

<xsl:template match="Select" mode="quick_form_request">

		<div class="form-group row  ">
			<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
				<div class="col-xs-6 col-md-sm-6 col-md-6 col-lg-6" style="width: 586px">
        	       	<select class="form-control" name="{name}" id="{element_id}">
										<xsl:if test="required = 1">
											<xsl:attribute name="required">required</xsl:attribute>
										</xsl:if>
        	       		<xsl:if test="empty!=''">
        	       			<option value=""><xsl:value-of select="empty"/></option>
        	       		</xsl:if>
        	       		<xsl:variable name="value" select="value" />
        	       		<xsl:for-each select="values_list/*">
        	       			<option value="{id}">
        	       			<xsl:if test="id=$value">
	        	       			<xsl:attribute name="selected"/>
        	       			</xsl:if>
        	       			<xsl:value-of select="value" disable-output-escaping="yes"/>
        	       			</option>
        	       		</xsl:for-each>
		        	</select>
                </div>
            </div>
	
</xsl:template>

<xsl:template match="CheckBox" mode="quick_form_request">

	<div class="form-group row">
		<label for="" class="col-xs-6 col-md-sm-6 col-md-3 col-lg-3"><xsl:value-of select="title" disable-output-escaping="yes"/></label>
		<div class="col-sm-5 col-md-6 col-lg-6">
			<input type="checkbox" name="{name}" id="{element_id}" value="1">
				<xsl:if test="value=1"><xsl:attribute name="checked"/></xsl:if>
			</input>
		</div>
	</div>
	
</xsl:template>

<xsl:template match="HeaderText" mode="quick_form_request">
	<xsl:apply-templates select="title" mode="quick_form_header"/>
</xsl:template>

<xsl:template match="TextButton" mode="quick_form_request">
	<xsl:param name="class" select="'input_button'"/>

    <div class="form-group row">
        <div class="col-lg-3 col-lg-offset-2">
            <button class="btn btn-info" type="submit"><i class="fa fa-file-excel-o"></i>&nbsp;&nbsp;<xsl:value-of select="title"/></button>
        </div>
    </div>

</xsl:template>

<xsl:template match="title" mode="quick_form_header">
	<xsl:if test=". != ''">
		<h4 style="margin-bottom:30px;font-size:16px;font-weight: bold" class=""><i class="fa fa-file"></i> <xsl:value-of select="." disable-output-escaping="yes"/></h4>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
