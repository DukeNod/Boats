<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">


<xsl:template priority="-1" match="*" mode="admin_quick_form">
</xsl:template>

<xsl:template match="TextField" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1 and edit = 1">*</xsl:if></td>
				<td class="formCellControls">
				<xsl:choose>
				<xsl:when test="edit = 1">
					<xsl:choose>
					<xsl:when test="typograph = 1">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}{name}_anchor">
						<td class="flatCell">
							<input class="{cssClass}" type="text" name="{name}" value="{value}" id="{$prefix}{name}" />
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, name)"/></xsl:call-template>
						</td>
					</tr></table>
					</xsl:when>
					<xsl:otherwise>
						<input class="{cssClass}" type="text" name="{name}" value="{value}" id="{$prefix}{name}">
							<xsl:if test="disabled = 1">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
							</xsl:if>
						</input>
					</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="field_comment != ''">
						<label class="field_comment" for="{$prefix}{name}"> (<xsl:value-of select="field_comment" disable-output-escaping="yes"/>)</label>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<div><xsl:value-of select="value" disable-output-escaping="yes"/></div> <!-- class="{cssClass}" -->
				</xsl:otherwise>
				</xsl:choose>
					<xsl:if test="autocomplete">
						<script type="text/javascript">
							$(function(){ var prefix = '<xsl:value-of select="$prefix"/>';
							var field_name = '<xsl:value-of select="name"/>';
							var url = '<xsl:value-of select="autocomplete/url"/>';
							<![CDATA[
								$('#'+prefix+field_name).autocomplete({
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
				</td>
			</tr>
</xsl:template>

<xsl:template match="TextField1" mode="admin_quick_form">
		<xsl:if test="/*/module/isInsert != 1">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls">
					<xsl:choose>
					<xsl:when test="typograph = 1">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}{name}_anchor">
						<td class="flatCell">
							<input class="{cssClass}" type="text" name="{name}" value="{value}" id="{$prefix}{name}" />
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, name)"/></xsl:call-template>
						</td>
					</tr></table>
					</xsl:when>
					<xsl:otherwise>
						<input class="{cssClass}" type="text" name="{name}" value="{value}" id="{$prefix}{name}" />
					</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="field_comment != ''">
						<label class="field_comment" for="{$prefix}{name}"> (<xsl:value-of select="field_comment" disable-output-escaping="yes"/>)</label>
					</xsl:if>
				</td>
			</tr>
		</xsl:if>
</xsl:template>

<xsl:template match="AutocompleteField" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1 and edit = 1">*</xsl:if></td>
				<td class="formCellControls">
				<xsl:choose>
				<xsl:when test="edit = 1">
					<input class="{cssClass}" type="text" name="{element_id}" value="{value_txt}" id="{$prefix}{name}" />
					<input type="hidden" id="{element_id}_hidden" name="{name}" value="{value}">
						<xsl:if test="required = 1">
							<xsl:attribute name="required">required</xsl:attribute>
						</xsl:if>
					</input>
					<xsl:if test="field_comment != ''">
						<label class="field_comment" for="{$prefix}{name}"> (<xsl:value-of select="field_comment" disable-output-escaping="yes"/>)</label>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<div><xsl:value-of select="value" disable-output-escaping="yes"/></div> <!-- class="{cssClass}" -->
				</xsl:otherwise>
				</xsl:choose>
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
				</td>
			</tr>
</xsl:template>

<xsl:template match="AutocompleteFieldMvd" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1 and edit = 1">*</xsl:if></td>
				<td class="formCellControls">
				<xsl:choose>
				<xsl:when test="edit = 1">
						<input class="{cssClass}" type="text" name="{element_id}" value="{value_txt}" id="{element_id}" data-url="{autocomplete/url}" />
						<input type="hidden" id="{element_id}_hidden" name="{name}" value="{value}">
							<xsl:if test="required = 1">
								<xsl:attribute name="required">required</xsl:attribute>
							</xsl:if>
						</input>
					<xsl:if test="field_comment != ''">
						<label class="field_comment" for="{$prefix}{name}"> (<xsl:value-of select="field_comment" disable-output-escaping="yes"/>)</label>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<div><xsl:value-of select="value" disable-output-escaping="yes"/></div> <!-- class="{cssClass}" -->
				</xsl:otherwise>
				</xsl:choose>
					<xsl:if test="autocomplete">
						<script type="text/javascript">
							$(function(){
								var field_name = '<xsl:value-of select="element_id"/>';
								<![CDATA[
								$('#'+field_name).autocomplete({
									minLength: 2
									,source: PUB_ROOT + $('#'+field_name).data('url')
									,select: function( event, ui )
									{
										$('#'+field_name+'_hidden').val(ui.item.id);
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
									$('#'+field_name+'_hidden').val(""); 
								});
								
								var field_init = true
								
								$('select[name="roles"]').change(function()
								{
									if ($(this).val() == 'officer,omvd')
									{
										$tr = $('#'+field_name).closest('tr');
										$tr.find('label nobr').text("Дежурная часть");
										
										$('#'+field_name).autocomplete('option', 'source', PUB_ROOT + "search/omvd.php");
										
										if (!field_init)
										{
											$('#'+field_name).val("");
											$('#'+field_name+'_hidden').val("");
										}
										
										$tr.show();
									}
									else if ($(this).val() == 'officer,uvm')
									{
										$tr = $('#'+field_name).closest('tr');
										$tr.find('label nobr').text("УВМ");
										
										$('#'+field_name).autocomplete('option', 'source', PUB_ROOT + "search/uvm.php");
										
										if (!field_init)
										{
											$('#'+field_name).val("");
											$('#'+field_name+'_hidden').val("");
										}
										
										$tr.show();
									}
									else
									{
										$('#'+field_name).closest('tr').hide();
										$('#'+field_name).val("");
										$('#'+field_name+'_hidden').val("");
									}
								});
								
								$('select[name="roles"]').change();
								
								field_init = false;
							});
						]]></script>
					</xsl:if>
				</td>
			</tr>
</xsl:template>

<xsl:template match="Email" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls">
					<input class="controlString" type="text" name="{name}" value="{value}" id="{$prefix}{name}" />
				</td>
			</tr>
</xsl:template>

<xsl:template match="HeaderText" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead" colspan="3"><nobr><strong><xsl:value-of select="title" disable-output-escaping="yes"/></strong></nobr></th>
			</tr>
</xsl:template>

<xsl:template match="TextArea" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls">
					<xsl:choose>
					<xsl:when test="typograph = 1">
					<table class="flatTable"><tr class="flatRow" id="{$prefix}{name}_anchor">
						<td class="flatCell">
							<textarea class="controlString" name="{name}" id="{$prefix}{name}" rows="{rows}">
								<xsl:value-of select="value"/>
							</textarea>
						</td>
						<td class="flatCell">
							<xsl:call-template name="typograph"><xsl:with-param name="id" select="concat($prefix, name)"/></xsl:call-template>
						</td>
					</tr></table>
					</xsl:when>
					<xsl:otherwise>
						<textarea class="controlString" name="{name}" id="{$prefix}{name}" rows="{rows}">
							<xsl:value-of select="value"/>
						</textarea>
					</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
</xsl:template>

<xsl:template match="Password" mode="admin_quick_form">
			<tr class="formRow formRowRequired">
				<th class="formCellHead"><label for="{$prefix}password1"><nobr>Пароль</nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls">
					<input class="controlString" type="password" name="password1" value="" id="{$prefix}password1" />
				</td>
			</tr>
			<tr class="formRow formRowRequired">
				<th class="formCellHead"><label for="{$prefix}password2"><nobr>Подтверждение пароля</nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls">
					<input class="controlString" type="password" name="password2" value="" id="{$prefix}password2" />
				</td>
			</tr>
</xsl:template>

<xsl:template match="PasswordToEmail" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><nobr><label for="{$prefix}{name}"><xsl:value-of select="title" disable-output-escaping="yes"/></label></nobr></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls"><nobr>
					<input class="controlCheckbox" type="checkbox" name="{name}" value="1" id="{$prefix}{name}">
						<xsl:if test="number(value)&gt;0"><xsl:attribute name="checked"/></xsl:if>
					</input>
					<xsl:if test="field_comment != ''">
						<label class="field_comment" for="{$prefix}{name}"> (<xsl:value-of select="field_comment" disable-output-escaping="yes"/>)</label>
					</xsl:if>
				</nobr></td>
			</tr>
</xsl:template>

<xsl:template match="DateField" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls">
				<xsl:choose>
				<xsl:when test="edit = 1">
							<xsl:call-template name="calendar_dateonly">
								<xsl:with-param name="id" select="concat($prefix, name)"/>
								<xsl:with-param name="name" select="name"/>
								<xsl:with-param name="value">
									<xsl:call-template name="datetime_numeric_ru">
										<xsl:with-param name="year"   select="value_parsed/year"/>
										<xsl:with-param name="month"  select="value_parsed/month"/>
										<xsl:with-param name="day"    select="value_parsed/day"/>
									</xsl:call-template>
									<xsl:if test="not(value_parsed)"><xsl:value-of select="value"/></xsl:if>
								</xsl:with-param>
							</xsl:call-template>
					<!--table class="flatTable"><tr class="flatRow">
						<td class="flatCell">
							<input class="controlDateOnly" type="text" name="{name}" id="{$prefix}{name}">
								<xsl:attribute name="value">
									<xsl:call-template name="datetime_numeric_ru">
										<xsl:with-param name="raw"   select="value" />
										<xsl:with-param name="year"  select="value_parsed/year" />
										<xsl:with-param name="month" select="value_parsed/month"/>
										<xsl:with-param name="day"   select="value_parsed/day"  />
									</xsl:call-template>
								</xsl:attribute>
							</input>
						</td>
						<td class="flatCell">
							<xsl:call-template name="calendar_dateonly"><xsl:with-param name="id" select="concat($prefix, name)"/></xsl:call-template>
						</td>
					</tr></table-->
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="datetime_numeric_ru">
						<xsl:with-param name="raw"   select="value" />
						<xsl:with-param name="year"  select="value_parsed/year" />
						<xsl:with-param name="month" select="value_parsed/month"/>
						<xsl:with-param name="day"   select="value_parsed/day"  />
					</xsl:call-template>
				</xsl:otherwise>
				</xsl:choose>
				</td>
			</tr>
</xsl:template>

<xsl:template match="DateTimeField" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls">
				<xsl:choose>
				<xsl:when test="edit = 1">
							<xsl:call-template name="calendar_dateonly">
								<xsl:with-param name="id" select="concat($prefix, name)"/>
								<xsl:with-param name="name" select="name"/>
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
					<!--table class="flatTable"><tr class="flatRow">
						<td class="flatCell">
							<input class="controlDateOnly" type="text" name="{name}" id="{$prefix}{name}">
								<xsl:attribute name="value">
									<xsl:call-template name="datetime_numeric_ru">
										<xsl:with-param name="raw"   select="value" />
										<xsl:with-param name="year"  select="value_parsed/year" />
										<xsl:with-param name="month" select="value_parsed/month"/>
										<xsl:with-param name="day"   select="value_parsed/day"  />
										<xsl:with-param name="hour"   select="value_parsed/hour"/>
										<xsl:with-param name="minute" select="value_parsed/minute"/>
										<xsl:with-param name="second" select="value_parsed/second"/>
									</xsl:call-template>
								</xsl:attribute>
							</input>
						</td>
						<td class="flatCell">
							<xsl:call-template name="calendar_datetime"><xsl:with-param name="id" select="concat($prefix, name)"/></xsl:call-template>
						</td>
					</tr></table-->
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="datetime_numeric_ru">
						<xsl:with-param name="raw"   select="value" />
						<xsl:with-param name="year"  select="value_parsed/year" />
						<xsl:with-param name="month" select="value_parsed/month"/>
						<xsl:with-param name="day"   select="value_parsed/day"  />
						<xsl:with-param name="hour"   select="value_parsed/hour"/>
						<xsl:with-param name="minute" select="value_parsed/minute"/>
						<xsl:with-param name="second" select="value_parsed/second"/>
					</xsl:call-template>
				</xsl:otherwise>
				</xsl:choose>
				</td>
			</tr>
</xsl:template>

<xsl:template match="CheckBoxList" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls">
				        <xsl:variable name="name" select="name" />
					<xsl:for-each select="values_list/*">
					<input type="checkbox" name="{$name}[{name()}]" id="{$name}_{name()}" value="1">
					        <xsl:variable name="tagname" select="name()" />
						<xsl:if test="../../value/*[name() = $tagname] = 1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
					</input>
					<label for="{$name}_{name()}"><xsl:value-of select="." /></label>
					<br/>
					</xsl:for-each>
				</td>
			</tr>
</xsl:template>

<xsl:template match="PositionField" mode="admin_quick_form">
			<tr class="formRow formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRow formRowOptional">
				<th class="formCellHead"><label for="{$prefix}position"><nobr>Позиция</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl">
					<xsl:variable name="position" select="value"/>
					<select class="controlSelect" name="{name}" id="{$prefix}{name}">
						<xsl:if test="value != '' and value != '&gt;' and value != '&lt;'">
							<option value="{value}">
								<xsl:text>Оставить на своём месте</xsl:text>
							</option>
						</xsl:if>
							<option value="&gt;">
								<xsl:if test="value='&gt;'"><xsl:attribute name="selected"/></xsl:if>
								<xsl:text>Поместить в конец</xsl:text>
							</option>
							<option value="&lt;">
								<xsl:if test="value='&lt;'"><xsl:attribute name="selected"/></xsl:if>
								<xsl:text>Поместить в начало</xsl:text>
							</option>
						<xsl:for-each select="/*/enums[@for=$essence]/siblings/*[id!=/*/form/id]"> <!-- ???  or not($form) -->
							<option value="&gt;{id}">
								<xsl:if test="value=concat('&gt;', id)"><xsl:attribute name="selected"/></xsl:if>
								<xsl:text>После "</xsl:text>
								<xsl:value-of select="name"/>
								<xsl:text>"</xsl:text>
							</option>
						</xsl:for-each>
					</select>
				</td>
			</tr>
</xsl:template>

<xsl:template match="SelectList" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1 and edit = 1">*</xsl:if></td>
				<td class="formCellControls">
				<xsl:choose>
				<xsl:when test="edit = 1">
					<select class="controlSelect" name="{name}">
						<option value=""><xsl:value-of select="empty" disable-output-escaping="yes"/></option>
						<xsl:variable name="value" select="value"/>
						<!--xsl:for-each select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*">
							<option value="{id}">
								<xsl:if test="id=$value"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="name" disable-output-escaping="yes"/>
							</option>
						</xsl:for-each-->
						<xsl:for-each select="enums/*">
							<option value="{id}">
								<xsl:if test="id=$value"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="name" disable-output-escaping="yes"/>
							</option>
						</xsl:for-each>
					</select>
					<xsl:if test="field_comment != ''">
						<label class="field_comment" for="{$prefix}{name}"> (<xsl:value-of select="field_comment" disable-output-escaping="yes"/>)</label>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*[id = current()/value]/name" disable-output-escaping="yes"/>
				</xsl:otherwise>
				</xsl:choose>
				</td>
			</tr>
</xsl:template>

<xsl:template match="Select" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1 and edit = 1">*</xsl:if></td>
				<td class="formCellControls">
				<xsl:choose>
				<xsl:when test="edit = 1">
					<select class="controlSelect" name="{name}">
					        <xsl:if test="empty!=''">
							<option value=""><xsl:value-of select="empty" disable-output-escaping="yes"/></option>
						</xsl:if>
						<xsl:variable name="value" select="value"/>
						<xsl:for-each select="values_list/value">
							<option value="{id}">
								<xsl:if test="id=$value"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="value" disable-output-escaping="yes"/>
							</option>
						</xsl:for-each>
					</select>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="values_list/value[id = current()/value]/value" disable-output-escaping="yes"/>
				</xsl:otherwise>
				</xsl:choose>
				</td>
			</tr>
</xsl:template>

<xsl:template match="SelectText" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls">
					<select class="controlSelect" name="{name}">
					        <xsl:if test="empty!=''">
							<option value=""><xsl:value-of select="empty" disable-output-escaping="yes"/></option>
						</xsl:if>
						<xsl:variable name="value" select="value"/>
						<xsl:for-each select="values_list/value">
							<option>
								<xsl:if test=".=$value"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="." disable-output-escaping="yes"/>
							</option>
						</xsl:for-each>
					</select>
				</td>
			</tr>
</xsl:template>

<xsl:template match="PriceField" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls">
					<input class="controlString" type="text" name="{name}" value="{value}" id="{$prefix}{name}" />
				</td>
			</tr>
</xsl:template>

<xsl:template match="SqlSelected" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls"><xsl:value-of select="format-number(value, '# ###,##', 'pricef')" /></td>
			</tr>
</xsl:template>

<xsl:template match="PriceComputed" mode="admin_quick_form">
		<xsl:if test="/*/module/isInsert != 1">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControl"><span id="{$prefix}{name}" data-val="{value}"><xsl:if test="value &gt; 0"><xsl:value-of select="format-number(value, '# ###,##', 'pricef')" /> руб.</xsl:if></span></td>
			</tr>
		</xsl:if>
</xsl:template>

<xsl:template match="Computed" mode="admin_quick_form">
		<xsl:if test="/*/module/isInsert != 1">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControl"><xsl:value-of select="value" disable-output-escaping="yes"/></td>
			</tr>
		</xsl:if>
</xsl:template>

<xsl:template match="Hidden" mode="admin_quick_form">
			<input type="hidden" name="{name}" value="{value}" id="{$prefix}{name}" />
</xsl:template>

<xsl:template match="HiddenNoDB" mode="admin_quick_form">
			<input type="hidden" name="{name}" value="{value}" id="{$prefix}{name}" />
</xsl:template>

<xsl:template match="SqlSelectedFish" mode="admin_quick_form">
	<xsl:param name="form" select="/.."/>
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls">
					<xsl:for-each select="$form/data/fish_types/fish_type">
						<xsl:if test="count != 0">
							<xsl:value-of select="name" disable-output-escaping="yes"/>:
							<xsl:value-of select="format-number(count, '# ###,##', 'pricef')" />
							<br/>
						</xsl:if>
					</xsl:for-each>
				</td>
			</tr>
</xsl:template>

<xsl:template match="SqlSelectedPonds" mode="admin_quick_form">
	<xsl:param name="form" select="/.."/>
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls">
					<xsl:for-each select="$form/data/ponds/pond">
						<xsl:if test="count != 0">
							<xsl:value-of select="name" disable-output-escaping="yes"/>:
							<xsl:value-of select="format-number(count, '# ###,##', 'pricef')" />
							<br/>
						</xsl:if>
					</xsl:for-each>
				</td>
			</tr>
</xsl:template>

<xsl:template match="TotalWeight" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls"><xsl:value-of select="format-number(value, '# ###,##', 'pricef')" /></td>
			</tr>
</xsl:template>

<xsl:template match="CheckBox" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><nobr><label for="{$prefix}{name}"><xsl:value-of select="title" disable-output-escaping="yes"/></label></nobr></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls"><nobr>
					<input class="controlCheckbox" type="checkbox" name="{name}" value="1" id="{$prefix}{name}">
						<xsl:if test="number(value)&gt;0"><xsl:attribute name="checked"/></xsl:if>
					</input>
					<xsl:if test="field_comment != ''">
						<label class="field_comment" for="{$prefix}{name}"> (<xsl:value-of select="field_comment" disable-output-escaping="yes"/>)</label>
					</xsl:if>
				</nobr></td>
			</tr>
</xsl:template>

<xsl:template match="CheckBox1" mode="admin_quick_form">
		<xsl:if test="/*/module/isInsert != 1">
			<tr class="formRowRequired">
				<th class="formCellHead"><nobr><label for="{$prefix}{name}"><xsl:value-of select="title" disable-output-escaping="yes"/></label></nobr></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControls"><nobr>
					<input class="controlCheckbox" type="checkbox" name="{name}" value="1" id="{$prefix}{name}">
						<xsl:if test="number(value)&gt;0"><xsl:attribute name="checked"/></xsl:if>
					</input>
					<xsl:if test="field_comment != ''">
						<label class="field_comment" for="{$prefix}{name}"> (<xsl:value-of select="field_comment" disable-output-escaping="yes"/>)</label>
					</xsl:if>
				</nobr></td>
			</tr>

			<tr class="formRowRequired">
				<th class="formCellHead"></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<a target="_blank" href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/kvit/{/*/form/id}">Квитанция</a>
				</td>
			</tr>
		</xsl:if>
</xsl:template>

<xsl:template match="ItemsList" mode="admin_quick_form">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="fromCellControls">
					<table class="flat">
					<xsl:for-each select="value/*">
					<xsl:variable name="names_list" select="concat('names-for-', ../../linked_module)"/>
					<xsl:variable name="sel_item" select="/*/enums[@for=$essence]/*[name() = $names_list]/*[id=current()/id]"/>
						<tr class="flat">
							<td class="flat" style="vertical-align: middle;">
								<input type="hidden" name="{../../name}[{position()}][id]" value="{id}"/>
								<xsl:value-of select="$sel_item/name" disable-output-escaping="yes"/>
							</td>
							<td class="flat" style="padding-left: 5px;">
								<button class="inlineButton {$prefix}items_remove" type="submit" name="items_list[{position()}][remove]" value="1" style="width: 20px; height: 20px;">
									<img src="{/*/system/info/adm_root}img/buttons/delete2.gif" width="20" height="20" alt="исключить"/>
								</button>
							</td>
						</tr>
					</xsl:for-each>
						<tr class="flat">
							<td class="flat">
								<select class="controlSelect" name="{name}[new][id]" id="{$prefix}{name}_new">
									<option value=""><xsl:value-of select="empty" disable-output-escaping="yes"/></option>
									<xsl:for-each select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*">
										<option value="{id}"><xsl:value-of select="name"/></option>

									</xsl:for-each>
								</select>
							</td>
							<td class="flat" style="padding-left: 5px;">
								<noscript>
								<button class="inlineButton {$prefix}items_append" type="submit" name="items_list[new][append]" value="1" style="width: 20px; height: 20px;">
									<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="20" height="20" alt="добавить"/>
								</button>
								</noscript>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<script type="text/javascript">
				$(function(){ var prefix = '<xsl:value-of select="$prefix"/>';
				var field_name = '<xsl:value-of select="name"/>';
				<![CDATA[
					ajax_add_items(prefix, field_name+'_new');
					ajax_del_items(prefix, 'items_remove');
				});
			]]></script>
</xsl:template>

<xsl:template match="TableField" mode="admin_quick_form">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="fromCellControls">
		<!--div class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></div-->

		<table class="listTable TableField">
			<col width="1"/>
			<xsl:for-each select="fields/*[name() != 'Hidden']">
				<col width="*"/>
			</xsl:for-each>
			<col width="1"/>
        
			<tr class="listRowHead nodrop nodrag">
				<th class="listCellHead listCellSplitR">
					<xsl:text>№</xsl:text>
				</th>

			<xsl:for-each select="fields/*[name() != 'Hidden']">
				<th class="listCellHead listCellSplitR">
					<xsl:value-of select="title"/>
				</th>
			</xsl:for-each>

				<th class="listCellHead listCellSplitL listCellSplitR">
				</th>
			</tr>
	<xsl:choose>
	<xsl:when test="value/*">
		<xsl:for-each select="value/*">
			<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
			<tr>
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<td class="listCellData listCellSplitL dragHandle">
				        <xsl:value-of select="position"/>
				</td>
				<xsl:apply-templates select="../../fields/*" mode="admin_quick_form_table">
					<xsl:with-param name="row" select="."/>
					<xsl:with-param name="pos" select="position()"/>
				</xsl:apply-templates>

				<td class="listCellData listCellSplitR">
					<button class="inlineButton _items_remove" type="submit" value="1" style="width: 20px; height: 20px;">
						<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="исключить"/>
					</button>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:when>
	</xsl:choose>
			<tr class="flat">
				<td class="flat insertLine" colspan="5">
					<a href='#' id="{name}_insert_table">Добавить</a>
				</td>
			</tr>
		</table>
			<script type="text/javascript">
				$(function(){ var tab_prefix = '<xsl:value-of select="name"/>_';


$('#'+tab_prefix+'insert_table')
.livequery('click', function(){
	<![CDATA[var row = this; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
	]]>
	var sel = this;

		var num = Math.random();
		var struct = $('\
			<tr id="'+tab_prefix+'parts_row_new'+num+'">\
				<td class="listCellData listCellSplitL dragHandle">\
				</td>\
				<xsl:apply-templates select="fields/*" mode="admin_quick_form_table_js"/>
				<td class="listCellData listCellSplitR">\
					<button class="inlineButton '+tab_prefix+'items_remove" type="submit" value="1" style="width: 20px; height: 20px;">\
						<img src="'+ADM_ROOT+'img/buttons/delete2.gif" width="20" height="20" alt="исключить"/>\
					</button>\
				</td>\
			</tr>'
		);
//			$(row).prev().before(struct);
			$(row).before(struct);
			$(".TableField").tableDnDUpdate();

	return false;
});
					ajax_del_items(tab_prefix, 'items_remove');

					$(".TableField").tableDnD({
						onDragClass: "myDragClass",
						dragHandle: ".dragHandle"
					});
				});
					</script>

				</td>
			</tr>
</xsl:template>

<xsl:template match="TextField" mode="admin_quick_form_table">
	<xsl:param name="row" select="''"/>
	<xsl:param name="pos" select="''"/>
			<td class="listCellData listCellSplitR">
				<xsl:choose>
				<xsl:when test="edit = 1">
					<input class="controlNumber" name="{../../name}[{$pos}][{name}]" value="{$row/*[name() = current()/name]}"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="value" disable-output-escaping="yes"/>
				</xsl:otherwise>
				</xsl:choose>
			</td>
</xsl:template>

<xsl:template match="PriceField" mode="admin_quick_form_table">
	<xsl:param name="row" select="''"/>
	<xsl:param name="pos" select="''"/>
			<td class="listCellData listCellSplitR">
				<xsl:choose>
				<xsl:when test="edit = 1">
					<input class="controlNumber" name="{../../name}[{$pos}][{name}]" value="{$row/*[name() = current()/name]}"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(value, '# ###,##', 'pricef')" disable-output-escaping="yes"/>
				</xsl:otherwise>
				</xsl:choose>
			</td>
</xsl:template>

<xsl:template match="SelectList" mode="admin_quick_form_table">
	<xsl:param name="row" select="''"/>
	<xsl:param name="pos" select="''"/>
			<td class="listCellData listCellSplitR">
				<xsl:choose>
				<xsl:when test="edit = 1">
					<select class="controlSelect" style="vertical-align: top;" name="{../../name}[{$pos}][{name}]">
						<option value=""><xsl:value-of select="empty" disable-output-escaping="yes"/></option>
						<xsl:variable name="value" select="$row/*[name() = current()/name]"/>
						<xsl:for-each select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*">
							<option value="{id}">
								<xsl:if test="id=$value"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="name" disable-output-escaping="yes"/>
							</option>
						</xsl:for-each>
					</select>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*[id = $row/*[name() = current()/name]]/name" disable-output-escaping="yes"/>
				</xsl:otherwise>
				</xsl:choose>
			</td>
</xsl:template>

<xsl:template match="Select" mode="admin_quick_form_table">
	<xsl:param name="row" select="''"/>
	<xsl:param name="pos" select="''"/>
			<td class="listCellData listCellSplitR">
				<xsl:choose>
				<xsl:when test="edit = 1">
					<select class="controlSelect" name="{../../name}[{$pos}][{name}]">
					        <xsl:if test="empty!=''">
							<option value=""><xsl:value-of select="empty" disable-output-escaping="yes"/></option>
						</xsl:if>
						<xsl:variable name="value" select="$row/*[name() = current()/name]"/>
						<xsl:for-each select="values_list/value">
							<option value="{id}">
								<xsl:if test="id=$value"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="value" disable-output-escaping="yes"/>
							</option>
						</xsl:for-each>
					</select>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="value" disable-output-escaping="yes"/>
				</xsl:otherwise>
				</xsl:choose>
			</td>
</xsl:template>

<xsl:template match="Hidden" mode="admin_quick_form_table">
	<xsl:param name="row" select="''"/>
	<xsl:param name="pos" select="''"/>
			<input type="hidden" name="{../../name}[{$pos}][{name}]" value="{$row/*[name() = current()/name]}" id="{$prefix}{name}" />
</xsl:template>

<xsl:template match="TextField" mode="admin_quick_form_table_js">
			<td class="listCellData listCellSplitR">\
					<input class="controlNumber" name="{../../name}['+num+'][{name}]"/>\
			</td>\
</xsl:template>

<xsl:template match="PriceField" mode="admin_quick_form_table_js">
			<td class="listCellData listCellSplitR">\
				<xsl:choose>
				<xsl:when test="edit = 1">
					<input class="controlNumber" name="{../../name}['+num+'][{name}]"/>\
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
				</xsl:choose>
			</td>\
</xsl:template>

<xsl:template match="SelectList" mode="admin_quick_form_table_js">
			<td class="listCellData listCellSplitR">\
					<select class="controlSelect" style="vertical-align: top;" name="{../../name}['+num+'][{name}]">\
						<option value=""><xsl:value-of select="empty" disable-output-escaping="yes"/></option>\
						<xsl:for-each select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*">
							<option value="{id}">\
								<xsl:value-of select="name" disable-output-escaping="yes"/>\
							</option>\
						</xsl:for-each>
					</select>\
			</td>\
</xsl:template>

<xsl:template match="Select" mode="admin_quick_form_table_js">
			<td class="listCellData listCellSplitR">\
					<select class="controlSelect" name="{../../name}['+num+'][{name}]">\
					        <xsl:if test="empty!=''">
							<option value=""><xsl:value-of select="empty" disable-output-escaping="yes"/></option>\
						</xsl:if>
						<xsl:for-each select="values_list/value">
							<option value="{id}">\
								<xsl:value-of select="value" disable-output-escaping="yes"/>\
							</option>\
						</xsl:for-each>
					</select>\
			</td>\
</xsl:template>

<xsl:template match="Hidden" mode="admin_quick_form_table_js">
	<xsl:param name="row" select="''"/>
	<xsl:param name="pos" select="''"/>
			<input type="hidden" name="{../../name}['+num+'][{name}]" value="{value}" />\
</xsl:template>

<xsl:template match="TicketFish" mode="admin_quick_form">
		<xsl:if test="/*/module/isInsert != 1">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="fromCellControls">

		<table class="listTable TableField">
			<col width="1"/><col width="1"/><col width="*"/>
        
			<tr class="listRowHead nodrop nodrag">
				<th class="listCellHead listCellSplitR">
					<xsl:text>№</xsl:text>
				</th>
				<th class="listCellHead listCellSplitR">
					<nobr>Вид рыбы</nobr>
				</th>
				<th class="listCellHead listCellSplitR">
					<nobr>Стоимость</nobr>
				</th>
				<th class="listCellHead listCellSplitR">
					<nobr>Норма вылова</nobr>
				</th>
				<th class="listCellHead listCellSplitR">
					<nobr>Тип нормы</nobr>
				</th>
				<th class="listCellHead listCellSplitR">
					<nobr>Пруд</nobr>
				</th>
				<th class="listCellHead listCellSplitR">
					<nobr>Выловлено</nobr>
				</th>
			</tr>
	<xsl:choose>
	<xsl:when test="value/*">
		<xsl:for-each select="value/*">
			<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
			<tr>
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<td class="listCellData listCellSplitL">
				        <xsl:value-of select="position"/>
				</td>
				<td class="listCellData listCellSplitR">
						<xsl:value-of select="/*/enums/fish_types/fish_type[id = current()/fish_type]/name" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR fishPricesInc" data-val="{price}" data-val2="{weight_price}">
					<!--xsl:if test="weight_price &gt; 0">
						<xsl:value-of select="format-number(weight_price, '# ###,##', 'pricef')" disable-output-escaping="yes"/> руб.
						<xsl:text> / </xsl:text>
					</xsl:if-->
					<xsl:if test="price &gt; 0">
						<xsl:value-of select="format-number(price, '# ###,##', 'pricef')" disable-output-escaping="yes"/> руб.
					</xsl:if>
				</td>
				<td class="listCellData listCellSplitR" data-val="{norm_weight}">
					<xsl:if test="norm_weight &gt; 0">
						<xsl:value-of select="format-number(norm_weight, '# ###,##', 'pricef')" disable-output-escaping="yes"/>
					</xsl:if>
				</td>
				<td class="listCellData listCellSplitR" data-val="{weight_type}">
						<xsl:value-of select="../../fields/Select/values_list/value[id = current()/weight_type]/value" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR">
					<select class="controlSelect pondList" style="vertical-align: top;" name="ponds[{fish_type}]">
						<option value="">Выбрать пруд</option>
						<xsl:variable name="pond" select="pond"/>
						<xsl:for-each select="/*/enums[@for=$essence]/ponds/pond">
							<option value="{id}">
								<xsl:if test="id=$pond"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="name" disable-output-escaping="yes"/>
							</option>
						</xsl:for-each>
					</select>
				</td>
				<td class="listCellData listCellSplitR">
					<input class="controlNumber updateForm" name="fish_weights[{fish_type}]" value="{weight}"/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:when>
	</xsl:choose>
		</table>
				</td>
			</tr>
		</xsl:if>
</xsl:template>

<xsl:template match="TicketFish2" mode="admin_quick_form">
		<xsl:if test="/*/module/isInsert != 1">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="fromCellControls">
		<!--div class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></div-->

		<table class="listTable TableField">
			<col width="1"/><col width="1"/><col width="*"/>
        
			<tr class="listRowHead nodrop nodrag">
				<th class="listCellHead listCellSplitR">
					<xsl:text>№</xsl:text>
				</th>

			<xsl:for-each select="fields/*[name!='additional']">
				<th class="listCellHead listCellSplitR">
				<nobr>
					<xsl:value-of select="title"/>
				</nobr>
				</th>
			</xsl:for-each>

				<th class="listCellHead listCellSplitL listCellSplitR">
				</th>
			</tr>
	<xsl:choose>
	<xsl:when test="value/*">
		<xsl:for-each select="value/*">
			<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
			<tr>
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<td class="listCellData listCellSplitL dragHandle">
				        <xsl:value-of select="position"/>
				</td>
				<td class="listCellData listCellSplitR">
					<select class="controlSelect fish_typeList updateForm" style="vertical-align: top;" name="fish_types2[{position()}][fish_type]">
						<option value="">Выбрать вид рыбы</option>
						<xsl:variable name="fish_type" select="fish_type"/>
						<xsl:for-each select="/*/enums[@for=$essence]/fish_types/fish_type[not(id = /*/form/data/fish_types/fish_type/fish_type)]">
							<option value="{id}" price="{price}">
								<xsl:if test="id=$fish_type"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="name" disable-output-escaping="yes"/>
							</option>
						</xsl:for-each>
					</select>
				</td>
				<td class="listCellData listCellSplitR">
					<xsl:if test="price &gt; 0">
						<xsl:value-of select="format-number(price, '# ###,##', 'pricef')" disable-output-escaping="yes"/> руб.
					</xsl:if>
				</td>
				<td class="listCellData listCellSplitR">
					<select class="controlSelect pondList" style="vertical-align: top;" name="fish_types2[{position()}][pond]">
						<option value="">Выбрать пруд</option>
						<xsl:variable name="pond" select="pond"/>
						<xsl:for-each select="/*/enums[@for=$essence]/ponds/pond">
							<option value="{id}">
								<xsl:if test="id=$pond"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="name" disable-output-escaping="yes"/>
							</option>
						</xsl:for-each>
					</select>
				</td>
				<td class="listCellData listCellSplitR">
					<input class="controlNumber updateForm" name="fish_types2[{position()}][weight]" value="{weight}"/>
				</td>

				<td class="listCellData listCellSplitR">
					<button class="inlineButton {../../name}_items_remove" type="submit" value="1" style="width: 20px; height: 20px;">
						<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="исключить"/>
					</button>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:when>
	</xsl:choose>
			<tr class="flat">
				<td class="flat insertLine" colspan="5">
					<a href='#' id="{name}_insert_table">Добавить</a>
				</td>
			</tr>
		</table>
			<script type="text/javascript">
				$(function(){ var tab_prefix = '<xsl:value-of select="name"/>_';


$('#'+tab_prefix+'insert_table')
.livequery('click', function(){
	<![CDATA[var row = this; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
	]]>
	var sel = this;

		var num = Math.random();
		var struct = $('\
			<tr id="'+tab_prefix+'parts_row_new'+num+'">\
				<td class="listCellData listCellSplitL dragHandle">\
				</td>\
				<td class="listCellData listCellSplitR">\
					<select class="controlSelect fish_typeList updateForm" style="vertical-align: top;" name="fish_types2['+num+'][fish_type]">\
						<option value="">Выбрать вид рыбы</option>\
						<xsl:for-each select="/*/enums[@for=$essence]/fish_types/fish_type[not(id = /*/form/data/fish_types/fish_type/fish_type)]">
						<!--xsl:for-each select="/*/enums[@for=$essence]/fish_types/fish_type"-->
							<option value="{id}" price="{price}">\
								<xsl:value-of select="name" disable-output-escaping="yes"/>\
							</option>\
						</xsl:for-each>
					</select>\
				</td>\
				<td class="listCellData listCellSplitR">\
				</td>\
				<td class="listCellData listCellSplitR">\
					<select class="controlSelect pondList" style="vertical-align: top;" name="fish_types2['+num+'][pond]">\
						<option value="">Выбрать пруд</option>\
						<xsl:for-each select="/*/enums[@for=$essence]/ponds/pond">
							<option value="{id}">\
								<xsl:value-of select="name" disable-output-escaping="yes"/>\
							</option>\
						</xsl:for-each>
					</select>\
				</td>\
				<td class="listCellData listCellSplitR">\
					<input class="controlNumber updateForm" name="fish_types2['+num+'][weight]"/>\
				</td>\
				<td class="listCellData listCellSplitR">\
					<button class="inlineButton '+tab_prefix+'items_remove" type="submit" value="1" style="width: 20px; height: 20px;">\
						<img src="'+ADM_ROOT+'img/buttons/delete2.gif" width="20" height="20" alt="исключить"/>\
					</button>\
				</td>\
			</tr>'
		);
//			$(row).prev().before(struct);
			$(row).before(struct);
			$(".TableField").tableDnDUpdate();

	return false;
});

<![CDATA[
$('.'+tab_prefix+'items_remove')
.livequery('click', function(){
	var row = this; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
	if (row) row.parentNode.removeChild(row);
	calc_total();
	return false;
});
]]>
					$(".TableField").tableDnD({
						onDragClass: "myDragClass",
						dragHandle: ".dragHandle"
					});

					$(".fish_typeList").livequery('change', function() {
					        var price = Number($(this.options[this.selectedIndex]).attr('price'));
						$(this).parent().next().html((price != 0) ? number_format(price, 0, '.', ' ') + ' руб.': '');
					});
				});
					</script>

				</td>
			</tr>
		</xsl:if>
</xsl:template>

<xsl:template match="ServiceField" mode="admin_quick_form">
		<xsl:if test="/*/module/isInsert != 1">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="fromCellControls">

		<table class="listTable TableField">
			<col width="1"/><col width="1"/><col width="*"/>
        
			<tr class="listRowHead nodrop nodrag">
				<th class="listCellHead listCellSplitR">
					<xsl:text>№</xsl:text>
				</th>
			<xsl:for-each select="fields/*">
				<th class="listCellHead listCellSplitR">
				<nobr>
					<xsl:value-of select="title"/>
				</nobr>
				</th>
			</xsl:for-each>
			</tr>
	<xsl:choose>
	<xsl:when test="value/*">
		<xsl:for-each select="value/*">
			<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
			<tr>
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<td class="listCellData listCellSplitL">
				        <xsl:value-of select="position"/>
				</td>
				<td class="listCellData listCellSplitR">
						<xsl:value-of select="/*/enums/services/service[id = current()/service]/name" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR servicePricesInc" data-val="{price}">
					<xsl:if test="price &gt; 0">
						<xsl:value-of select="format-number(price, '# ###,##', 'pricef')" disable-output-escaping="yes"/> руб.
					</xsl:if>
				</td>
				<td class="listCellData listCellSplitR">
						<xsl:value-of select="time" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR" data-val="{service_count}">
						<xsl:value-of select="service_count" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR">
					<input class="controlNumber updateForm" name="service_weights[{service}]" value="{weight}"/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:when>
	</xsl:choose>
		</table>
				</td>
			</tr>
		</xsl:if>
</xsl:template>

<xsl:template match="ServiceField2" mode="admin_quick_form">
		<xsl:if test="/*/module/isInsert != 1">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="fromCellControls">

		<table class="listTable TableField">
			<col width="1"/><col width="1"/><col width="*"/>
        
			<tr class="listRowHead nodrop nodrag">
				<th class="listCellHead listCellSplitR">
					<xsl:text>№</xsl:text>
				</th>

			<xsl:for-each select="fields/*[name!='additional']">
				<th class="listCellHead listCellSplitR">
				<nobr>
					<xsl:value-of select="title"/>
				</nobr>
				</th>
			</xsl:for-each>

				<th class="listCellHead listCellSplitL listCellSplitR">
				</th>
			</tr>
	<xsl:choose>
	<xsl:when test="value/*">
		<xsl:for-each select="value/*">
			<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
			<tr>
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<td class="listCellData listCellSplitL dragHandle">
				        <xsl:value-of select="position"/>
				</td>
				<td class="listCellData listCellSplitR">
					<select class="controlSelect serviceList updateForm" style="vertical-align: top;" name="services2[{position()}][service]">
						<option value="">Выбрать услугу</option>
						<xsl:variable name="service" select="service"/>
						<xsl:for-each select="/*/enums[@for=$essence]/services/service[not(id = /*/form/data/services/service/service)]">
							<option value="{id}" price="{price}" time="{time}">
								<xsl:if test="id=$service"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="name" disable-output-escaping="yes"/>
							</option>
						</xsl:for-each>
					</select>
				</td>
				<td class="listCellData listCellSplitR">
					<xsl:if test="price &gt; 0">
						<xsl:value-of select="format-number(price, '# ###,##', 'pricef')" disable-output-escaping="yes"/> руб.
					</xsl:if>
				</td>
				<td class="listCellData listCellSplitR">
					<xsl:value-of select="time" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR">
					<input class="controlNumber updateForm" name="services2[{position()}][weight]" value="{weight}"/>
				</td>

				<td class="listCellData listCellSplitR">
					<button class="inlineButton {../../name}_items_remove" type="submit" value="1" style="width: 20px; height: 20px;">
						<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="исключить"/>
					</button>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:when>
	</xsl:choose>
			<tr class="flat">
				<td class="flat insertLine" colspan="5">
					<a href='#' id="{name}_insert_table">Добавить</a>
				</td>
			</tr>
		</table>
			<script type="text/javascript">
				$(function(){ var tab_prefix = '<xsl:value-of select="name"/>_';


$('#'+tab_prefix+'insert_table')
.livequery('click', function(){
	<![CDATA[var row = this; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
	]]>
	var sel = this;

		var num = Math.random();
		var struct = $('\
			<tr id="'+tab_prefix+'parts_row_new'+num+'">\
				<td class="listCellData listCellSplitL dragHandle">\
				</td>\
				<td class="listCellData listCellSplitR">\
					<select class="controlSelect serviceList updateForm" style="vertical-align: top;" name="services2['+num+'][service]">\
						<option value="">Выбрать услугу</option>\
						<xsl:for-each select="/*/enums[@for=$essence]/services/service[not(id = /*/form/data/services/service/service)]">
						<!--xsl:for-each select="/*/enums[@for=$essence]/fish_types/fish_type"-->
							<option value="{id}" price="{price}" time="{time}">\
								<xsl:value-of select="name" disable-output-escaping="yes"/>\
							</option>\
						</xsl:for-each>
					</select>\
				</td>\
				<td class="listCellData listCellSplitR">\
				</td>\
				<td class="listCellData listCellSplitR">\
				</td>\
				<td class="listCellData listCellSplitR">\
					<input class="controlNumber updateForm" name="services2['+num+'][weight]"/>\
				</td>\
				<td class="listCellData listCellSplitR">\
					<button class="inlineButton '+tab_prefix+'items_remove" type="submit" value="1" style="width: 20px; height: 20px;">\
						<img src="'+ADM_ROOT+'img/buttons/delete2.gif" width="20" height="20" alt="исключить"/>\
					</button>\
				</td>\
			</tr>'
		);
//			$(row).prev().before(struct);
			$(row).before(struct);
			$(".TableField").tableDnDUpdate();

	return false;
});

<![CDATA[
$('.'+tab_prefix+'items_remove')
.livequery('click', function(){
	var row = this; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
	if (row) row.parentNode.removeChild(row);
	calc_total();
	return false;
});
]]>

					$(".TableField").tableDnD({
						onDragClass: "myDragClass",
						dragHandle: ".dragHandle"
					});

					$(".serviceList").livequery('change', function() {
					        var price = Number($(this.options[this.selectedIndex]).attr('price'));
					        var time = $(this.options[this.selectedIndex]).attr('time')
					        if (price == 0)
					        {
					        	time ='';
					        }
						$(this).parent().next().html((price != 0) ? number_format(price, 0, '.', ' ') + ' руб.': '');
						$(this).parent().next().next().html(time);
					});
				});
					</script>

				</td>
			</tr>
		</xsl:if>
</xsl:template>

<xsl:template match="NormPrice" mode="admin_quick_form">
		<xsl:if test="/*/module/isInsert != 1">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<!--td class="formCellControl"><span id="{$prefix}{name}"><xsl:value-of select="format-number(/*/form/data/tarif_info/norm_price, '# ###,##', 'pricef')" /><xsl:if test="/*/form/data/tarif_info/norm_price > 0"> руб.</xsl:if></span></td-->
				<td class="formCellControl"><span id="{$prefix}{name}" data-val="{value}"><xsl:if test="value &gt; 0"><xsl:value-of select="format-number(value, '# ###,##', 'pricef')" /> руб.</xsl:if></span></td>
			</tr>
		</xsl:if>
</xsl:template>

<xsl:template match="TarifField" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControl">
					<select class="controlSelect" name="{name}" style="vertical-align: middle;">
						<option value=""><xsl:value-of select="empty" disable-output-escaping="yes"/></option>
						<xsl:variable name="value" select="value"/>
						<xsl:variable name="w_field">
							<xsl:choose>
							<xsl:when test="/*/system/now/wday = 0">d7</xsl:when>
							<xsl:otherwise><xsl:value-of select="concat('d', /*/system/now/wday)"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!--xsl:for-each select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*[(weekday = '') or (weekday/*[name() = $w_field])]"-->
						<xsl:for-each select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*">
						<xsl:if test="not(weekday/*) or (weekday/*[name() = $w_field] = 1)">
							<option value="{id}">
								<xsl:if test="id=$value"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="name" disable-output-escaping="yes"/>
							</option>
						</xsl:if>
						</xsl:for-each>
					</select>
					<xsl:if test="/*/module/isInsert != 1">
						<button class="inlineButton" type="submit" style="width: 96px; height: 20px; vertical-align: bottom;">
							<img src="{/*/system/info/adm_root}img/buttons/submit_update.gif" width="92" height="19"/>
						</button>
					</xsl:if>
					<xsl:if test="field_comment != ''">
						<label class="field_comment" for="{$prefix}{name}"> (<xsl:value-of select="field_comment" disable-output-escaping="yes"/>)</label>
					</xsl:if>
				</td>
			</tr>
</xsl:template>

<xsl:template match="TotalPrice" mode="admin_quick_form">
		<xsl:if test="/*/module/isInsert != 1">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<!--td class="formCellControl"><span id="{$prefix}{name}"><xsl:value-of select="format-number(/*/form/data/tarif_info/norm_price, '# ###,##', 'pricef')" /><xsl:if test="/*/form/data/tarif_info/norm_price > 0"> руб.</xsl:if></span></td-->
				<td class="formCellControl"><span id="{$prefix}{name}"><xsl:value-of select="format-number(value, '# ###,##', 'pricef')" /><xsl:if test="value &gt; 0"> руб.</xsl:if></span></td>
			</tr>
		</xsl:if>
</xsl:template>

<xsl:template match="CardField" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><nobr>Найти пользователя</nobr></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControl">

	<!--form id="card_filter_form" class="form filter" method="get" action="{/*/system/info/adm_root}tickets/tickets/ajax/find"-->
		<table class="formTable">
			<tr class="formRowCriteria">
				<th class="formCellHead"><nobr>Номер карты</nobr></th>
				<td class="formCellCtrl"><input type="text" class="controlString" style="width: auto;" name="filter_card" value=""/></td>
			</tr>
			<tr class="formRowCriteria">
				<th class="formCellHead"><nobr>Фамилия</nobr></th>
				<td class="formCellCtrl"><input type="text" class="controlString" style="width: auto;" name="filter_last_name" value=""/></td>
			</tr>
			<tr class="formRowCriteria">
				<th class="formCellHead"><nobr>E-mail</nobr></th>
				<td class="formCellCtrl"><input type="text" class="controlString" style="width: auto;" name="filter_email" value=""/></td>
			</tr>
			<tr class="formRowCommands">
				<td class=""></td>
				<td class="formCellCommands">
					<button class="inlineButton" name="filter" value="1" type="submit" style="width: 147px; height: 20px;">
						<img src="{/*/system/info/adm_root}img/buttons/filter_apply.gif" width="147" height="20" alt="Применить фильтр"/>
					</button>
				</td>
			</tr>
		</table>
	<!--/form-->

				</td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"></th>
				<td class="formCellFlag"></td>
				<td colspan="3" id="search_user_content" class="formCellControls">
				</td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"><nobr>ID пользователя</nobr></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<td class="formCellControl">
					<table class="flatTable"><tr class="flatRow">
						<td class="flatCell">
							<span id="{$prefix}{name}" data-val="{value}"><xsl:value-of select="value" /></span>
							<input type="hidden" name="{name}" value="{value}"/>
						</td>
						<td class="flatCell">
							<button id="card_remove" class="inlineButton" value="1" style="width: 20px; height: 20px;">
								<img src="{/*/system/info/adm_root}img/buttons/delete2.gif" width="20" height="20" alt="очистить"/>
							</button>
						</td>
					</tr></table>
				</td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"><nobr>Номер карты</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellControl"><span id="{$prefix}card"><xsl:value-of select="/*/form/data/user_info/card" /></span></td>
			</tr>
			<script type="text/javascript">
				<![CDATA[
					function card_filter(form)
					{
						var options = { 
						        //target:	'#popup__content',   // target element(s) to be updated with server response 
							url:	ADM_ROOT+'tickets/tickets/ajax/find',        // override for form's 'action' attribute 
							type:	'GET',  // 'get' or 'post', override for form's 'method' attribute 
						        //dataType:  'xml'        // 'xml', 'script', or 'json' (expected server response type) 
					        	//beforeSubmit:  formWait,  // pre-submit callback 
						        //success:       formSuccess  // post-submit callback 
						        // other available options: 
					        	//clearForm: true        // clear all form fields after successful submit 
						        //resetForm: true        // reset the form after successful submit 
		 
						        // $.ajax options can be used here too, for example: 
					        	//timeout:   3000 
	        
						        beforeSubmit: function() {
								var content = $('#search_user_content');
				                		content.html('<img class="ajax-loader" src="'+ADM_ROOT+'img/ajax-loader.gif">');
						        },

						        success: function(response_text) {
								// ajax_elemental_set(params, '');
								var content = $('#search_user_content');
				                		content.html(response_text);
						        }
						}; 

					        $(form).ajaxSubmit(options);
				        	return false;
					}

				$(function(){
				        $("#main_form button[name='filter']").click(function(){

						card_filter(this.form);
						return false;
				        });

       				        $("#card_remove").click(function(){
				        	$('#_last_name').get(0).value = ''; //last_name;
				        	$('#_first_name').get(0).value = ''; //first_name;
				        	$('#_middle_name').get(0).value = ''; //middle_name;
				        	$('#_user').html('');
				        	$('#_card').html('');
				        	var user = $('#_user');
				        	$('input', user.parentNode).val('');
				        	$('#_points').html('');
				        	$('#_points').attr('data-val', '');
				        	$('#_pay_points').val('');
				        	
						return false;
				        });
				});
			        ]]>
					</script>
</xsl:template>

<xsl:template match="DetailsInfo" mode="admin_quick_form">
		<xsl:if test="/*/module/isInsert != 1">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<!--td class="formCellControl"><span id="{$prefix}{name}"><xsl:value-of select="format-number(/*/form/data/tarif_info/norm_price, '# ###,##', 'pricef')" /><xsl:if test="/*/form/data/tarif_info/norm_price > 0"> руб.</xsl:if></span></td-->
				<td class="formCellControl"><span id="{$prefix}{name}" data-val="{value}"><xsl:if test="value &gt; 0"><xsl:value-of select="value" /></xsl:if></span></td>
			</tr>
		</xsl:if>
</xsl:template>

<xsl:template match="PayPrice" mode="admin_quick_form">
		<xsl:if test="/*/module/isInsert != 1">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"><xsl:if test="required=1">*</xsl:if></td>
				<!--td class="formCellControl"><span id="{$prefix}{name}"><xsl:value-of select="format-number(/*/form/data/tarif_info/norm_price, '# ###,##', 'pricef')" /><xsl:if test="/*/form/data/tarif_info/norm_price > 0"> руб.</xsl:if></span></td-->
				<td class="formCellControl"><span id="{$prefix}{name}"><xsl:value-of select="format-number(value, '# ###,##', 'pricef')" /><xsl:if test="value &gt; 0"> руб.</xsl:if></span></td>
			</tr>

			<script type="text/javascript">
				<![CDATA[
				function calc_total()
				{
					var prices = $('.fishPricesInc');
					var summ = 0;
					var summ2 = 0;
					var norm_price = Number($('#_norm_price').attr('data-val'));
					var fish_pay = 0;

					$.each(prices, function(key, val)
					{
						var price = Number($(val).attr('data-val'));
						var weight_price = Number($(val).attr('data-val2'));
						var norm_weight = Number($(val).next().attr('data-val'));
						var weight_type = Number($(val).next().next().attr('data-val'));
						var value = Number($('input', $(val).next().next().next().next()).get(0).value);

						if (norm_weight > 0)
						{
							summ += price * value;
							/*
						        if (weight_price && (weight_type == 1))
						        {
							        if (value > norm_weight)
									summ += weight_price * norm_weight + price * (value - norm_weight);
								else
									summ += weight_price * value;
							}else
								summ += price * value;
							*/
						}

						if ((!norm_price) && (norm_weight > 0))
						{
							if (weight_type == 2)
							{
								var p = price * value - norm_weight;
								if (p > 0)
									fish_pay += p;
							}else
							{
		        					var w = value - norm_weight;
						        	if (w > 0)
									fish_pay += price * w;
								/*
							        if (weight_price)
							        {
			        					var w = value - norm_weight;
							        	if (w > 0)
										fish_pay += price * w + norm_weight * weight_price;
									else
										fish_pay += value * weight_price;
								}else
								{
			        					var w = value - norm_weight;
							        	if (w > 0)
										fish_pay += price * w;
								}
								*/
							}
						}
					});
					
					var prices_add = $('.fish_typeList');
					
					$.each(prices_add, function(key, val)
					{
					        var o = val.options[this.selectedIndex]
						var price = Number($(o).attr('price'));
						var value = Number($('input', $(val).parent().next().next().next()).get(0).value);
						summ2 += price * value;
					});

					summ += summ2;
					fish_pay += summ2;

					if (norm_price > 0)
					{
					        var p = summ - norm_price;
						if (p > 0)
							fish_pay = p;
						else
							fish_pay = 0;
					}

					//$('#_summ').html((summ != 0) ? number_format(summ, 0, '.', ' ') + ' руб.': '');
					$('#_fish_pay').html((fish_pay != 0) ? number_format(fish_pay, 0, '.', ' ') + ' руб.': '');

				
				        // Услуги

				        var summ_service = 0;
					var services = $('.servicePricesInc');

					$.each(services, function(key, val)
					{
						var price = Number($(val).attr('data-val'));
						var service_count = Number($(val).next().next().attr('data-val'));
						var value = Number($('input', $(val).next().next().next()).get(0).value);

					        if (service_count > 0)
					        {
							summ_service += price * value;
						}
					});

					var services_add = $('.serviceList');
					
					$.each(services_add, function(key, val)
					{
					        var o = val.options[this.selectedIndex]
						var price = Number($(o).attr('price'));
						var value = Number($('input', $(val).parent().next().next().next()).get(0).value);

						summ_service += price * value;
					});

					$('#_summ_service').html((summ_service != 0) ? number_format(summ_service, 0, '.', ' ') + ' руб.': '');

					var tarif_price = Number($('#_price').attr('data-val'));

					var total_price = fish_pay + summ_service + tarif_price;
					$('#_total_price').html((total_price != 0) ? number_format(total_price, 0, '.', ' ') + ' руб.': '');
					
					var points = Number($('#_points').attr('data-val'));
					var pay_points = Number($('#_pay_points').val());
					if ((points - pay_points) < 0) alert("Превышено количество баллов");

					var pay_price = total_price - pay_points;
					$('#_pay_price').html((pay_price != 0) ? number_format(pay_price, 0, '.', ' ') + ' руб.': '');
				}

			        ]]>

				$(function(){

					$(".updateForm").livequery('change', function() {
						calc_total();
					});

					$("#_pay_points").livequery('change', function() {
						calc_total();
					});
				});
					</script>
		</xsl:if>
</xsl:template>

<xsl:template match="LastName" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}last_name"><nobr>Фамилия</nobr></label></th>
				<td class="formCellFlag">*</td>
				<td class="formCellControls">
					<input type="text" name="last_name" value="{/*/form/data/last_name}" id="{$prefix}last_name" />
				</td>
			</tr>
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}first_name"><nobr>Имя</nobr></label></th>
				<td class="formCellFlag">*</td>
				<td class="formCellControls">
					<input type="text" name="first_name" value="{/*/form/data/first_name}" id="{$prefix}first_name" />
				</td>
			</tr>
			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}middle_name"><nobr>Отчество</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<input type="text" name="middle_name" value="{/*/form/data/middle_name}" id="{$prefix}middle_name" />
				</td>
			</tr>
</xsl:template>

<xsl:template match="StatusEditField" mode="admin_quick_form">
                        <xsl:if test="/*/form/data/card &gt; 0">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}last_name"><nobr>Статус</nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<xsl:value-of select="/*/form/data/status"/><xsl:if test="/*/form/data/pay_summ &gt; 0"> (<xsl:value-of select="format-number(/*/form/data/pay_summ, '# ###', 'pricef')"/> руб.)</xsl:if>
				</td>
			</tr>
			</xsl:if>
</xsl:template>

<xsl:template match="Answers" mode="admin_quick_form">
		<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

		<xsl:for-each select="value/*">
			<tr class="formRowOptional">
				<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
				<td class="formCellFlag"></td>
				<td class="fromCellControls">
					<xsl:value-of select="value" disable-output-escaping="yes"/>
				</td>
			</tr>
		</xsl:for-each>
		
		<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>
</xsl:template>


<xsl:template match="MakeAuth" mode="admin_quick_form">
			<tr class="formRowRequired">
				<th class="formCellHead"><label for="{$prefix}auth"></label></th>
				<td class="formCellFlag"></td>
				<td class="formCellControls">
					<a href="{/*/system/info/pub_root}?auth={/*/form/data/id}|{/*/form/data/encrypted_password}" target="_blank">Авторизоваться</a>
				</td>
			</tr>
</xsl:template>

</xsl:stylesheet>
