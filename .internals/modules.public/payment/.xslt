<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/public.xslt"/>
<xsl:include href="../../xslts/index.xslt"/>
<xsl:include href="../../xslts/req_list.xslt"/>

<xsl:include href="../../xslts/_common_/calendars.xslt" />

<xsl:template match="/" mode="overrideable_title">
	Клиенты и оплата
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
</xsl:template>

<xsl:template match="/" mode="overrideable_headers">
	<style>
		.approve_button { display: inline-block; width: 130px; }
	</style>
	<script type="text/javascript" src="{/*/system/info/pub_root}js/pays.js?3"></script>
</xsl:template>

<xsl:template match="/" mode="global_top_menu">payment</xsl:template> 
<xsl:template match="/" mode="global_left_menu">payment</xsl:template> 

<xsl:template match="/" mode="overrideable_head">
	Клиенты и оплата
</xsl:template>

<xsl:template match="/" mode="overrideable_measurer">
	<xsl:call-template name="measurer_divider"/>
	<span class="active">Клиенты и оплата</span>
</xsl:template>

<xsl:template match="/" mode="overrideable_content">

<xsl:for-each select="/*/payment">
<h2><xsl:value-of select="client" disable-output-escaping="yes"/></h2>
<div class="layout clearfix">
	<a href="{/*/system/info/pub_root}payment/edit/{id}" class="btn btn-default clearfix edit-btns">Редактировать</a>
	<a href="{/*/system/info/pub_root}payment/cancel/{id}/" class="btn btn-default clearfix edit-btns">
		<xsl:choose>
		<xsl:when test="cancel = 1">Восстановить</xsl:when>
		<xsl:otherwise>Отменить</xsl:otherwise>
		</xsl:choose>
	</a>
</div>
<dl>
	<dt>
		<span class="id_field integer_type label label-info">
			Данные
		</span>
	</dt>
	<dd class="well">
		<table class="hotel-info">
			<xsl:if test="cancel = 1">
			<tr>
				<td colspan="2" class="error" style="font-weight: bold">Отменен</td>
			</tr>
			</xsl:if>
			<tr>
				<td>Номер телефона:</td>
				<td>
					<!--xsl:if test="phone != ''">+7 <xsl:value-of select="concat(substring(phone,1,3), ' ', substring(phone,4,3), ' ', substring(phone,7,2), ' ', substring(phone,9,2))" disable-output-escaping="yes"/></xsl:if-->
					<xsl:if test="phone != ''">+7 <xsl:value-of select="phone" disable-output-escaping="yes"/></xsl:if>
				</td>
			</tr>
			<tr>
				<td>Клиент:</td>
				<td><xsl:value-of select="client" disable-output-escaping="yes"/></td>
			</tr>
			<tr>
				<td>Номер договора:</td>
				<td><xsl:value-of select="contract_number" disable-output-escaping="yes"/></td>
			</tr>
			<tr>
				<td>Дата заключения договора:</td>
				<td><xsl:apply-templates select="contract_date_parsed" mode="show_date_ru"/></td>
			</tr>
			<tr>
				<td>Филиал:</td>
				<td><xsl:value-of select="branch" disable-output-escaping="yes"/></td>
			</tr>
			<tr>
				<td>Регион:</td>
				<td><xsl:value-of select="region" disable-output-escaping="yes"/></td>
			</tr>
			<tr>
				<td>Менеджер:</td>
				<td><xsl:value-of select="manager" disable-output-escaping="yes"/></td>
			</tr>
			<tr>
				<td>Модель катера:</td>
				<td>
					<xsl:for-each select="models/model">
						<xsl:value-of select="name" disable-output-escaping="yes"/><br/>
					</xsl:for-each>
				</td>
			</tr>
			<tr>
				<td>Новый/БУ:</td>
				<td><xsl:value-of select="type" disable-output-escaping="yes"/></td>
			</tr>
			<tr>
				<td>Номер катера:</td>
				<td><xsl:value-of select="boat_number" disable-output-escaping="yes"/></td>
			</tr>
			<tr>
				<td>Наличие / Заказ:</td>
				<td>
					<xsl:choose>
						<xsl:when test='avail = "yes"'>В наличии</xsl:when>
						<xsl:when test='avail = "no"'>Под заказ</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td>Служебка:</td>
				<td>
					<xsl:choose>
						<xsl:when test='slugebka = "sent"'>Отправлена</xsl:when>
						<xsl:when test='slugebka = "not sent"'>Не отправлена</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td>Форма оплаты:</td>
				<td><xsl:value-of select="paytype" disable-output-escaping="yes"/></td>
			</tr>
			<tr>
				<td>Организация:</td>
				<td><xsl:value-of select="organization" disable-output-escaping="yes"/></td>
			</tr>
			<tr>
				<td>Документы отданы клиенту:</td>
				<td>
					<xsl:choose>
						<xsl:when test='docs = "yes"'>Да</xsl:when>
						<xsl:when test='docs = "no"'>Нет</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td>Документы отданы в бухгалтерию:</td>
				<td>
					<xsl:choose>
						<xsl:when test='docs_buh = "yes"'>Да</xsl:when>
						<xsl:when test='docs_buh = "no"'>Нет</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td>Сумма к оплате:</td>
				<td>
					<xsl:apply-templates select="summ" mode="show_price"><xsl:with-param name="currency" select="currency"/></xsl:apply-templates>
				</td>
			</tr>
			<tr>
				<td>Размер скидки:</td>
				<td>
					<xsl:apply-templates select="discount" mode="show_price"><xsl:with-param name="currency" select="currency"/></xsl:apply-templates>
				</td>
			</tr>
			<tr>
				<td>Планируемая дата отгрузки:</td>
				<td><xsl:apply-templates select="shipping_date_parsed" mode="show_date_ru"/></td>
			</tr>
			<tr>
				<td>Статус отгрузки:</td>
				<td>
					<xsl:choose>
						<xsl:when test='shipping_status = "yes"'>Да</xsl:when>
						<xsl:when test='shipping_status = "no"'>Нет</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td>Просрочка отгрузки:</td>
				<td>
					<xsl:choose>
						<xsl:when test='shipping_time = "bad"'>Отгрузка просрочена</xsl:when>
						<xsl:when test='shipping_time = "good"'>Нет просрочки</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td>Долг по клиенту:</td>
				<td>
					<xsl:if test='debt &gt; 0'>
						<xsl:attribute name="class">danger</xsl:attribute>
						<xsl:apply-templates select="debt" mode="show_price"><xsl:with-param name="currency" select="currency"/></xsl:apply-templates>
					</xsl:if>
				</td>
			</tr>
			<tr>
				<td>Сумма просроченных платежей:</td>
				<td>
					<xsl:if test='bad_pays &gt; 0'>
						<xsl:attribute name="class">danger</xsl:attribute>
						<xsl:apply-templates select="bad_pays" mode="show_price"><xsl:with-param name="currency" select="currency"/></xsl:apply-templates>
					</xsl:if>
				</td>
			</tr>
			<tr>
				<td>Проверка полной оплаты и отгрузки катера:</td>
				<td>
					<xsl:choose>
						<xsl:when test='full_status = "finish"'>Катер оплачен и отгружен</xsl:when>
						<xsl:when test='full_status = "work"'>В работе</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td>Трейд ин (сумма зачета):</td>
				<td>
					<xsl:apply-templates select="tradein" mode="show_price"><xsl:with-param name="currency" select="currency"/></xsl:apply-templates>
				</td>
			</tr>
			<tr>
				<td>Трейд ин - предмет зачета:</td>
				<td><xsl:value-of select="tradein_obj" disable-output-escaping="yes"/></td>
			</tr>
			<tr>
				<td>Подарок (что дарили):</td>
				<td><xsl:value-of select="gift" disable-output-escaping="yes"/></td>
			</tr>
			<tr>
				<td>Подарок (сумма подарка):</td>
				<td>
					<xsl:apply-templates select="gift_summ" mode="show_price"><xsl:with-param name="currency" select="currency"/></xsl:apply-templates>
				</td>
			</tr>
			<xsl:if test="/*/identity /consumer/roles/role = 'admin'">
			<tr>
				<td>Считать в план:</td>
				<td>
					<xsl:choose>
						<xsl:when test='active = "1"'>Да</xsl:when>
						<xsl:when test='active = "0"'>Нет</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td>В план на:</td>
				<td><xsl:apply-templates select="plan_date_parsed" mode="show_date_ru"/></td>
			</tr>
			</xsl:if>
		</table>
	</dd>
</dl>

</xsl:for-each>

<h2>Платежи</h2>

<div class="layout clearfix">
	<a href="{/*/system/info/pub_root}payment/pay_edit/{/*/payment/id}/" class="btn btn-default clearfix edit-btns" style="margin-bottom: 0">Добавить платеж</a>
	<a href="{/*/system/info/pub_root}payment/pay_edit/{/*/payment/id}/?refund=1" class="btn btn-default clearfix edit-btns" style="margin-bottom: 0">Добавить возврат</a>
</div>

		<div id='list' style='width: 880px;'>

			<table class='table table-condensed table-striped'>
			<thead>
				<tr>
					<th class='header pjax'>Дата</th>
					<th class='header pjax'>Тип</th>
					<th class='header pjax'>Сумма</th>
					<th class='header pjax'>Форма оплаты:</th>
					<th class='header pjax'>Статус оплаты</th>
					<th class='header pjax'>Статус просрочки</th>
					<th class='header pjax'>Трейд ин</th>
					<th class='header pjax'>Трейд ин - предмет зачета</th>
					<th class='header pjax'></th>
					<th class='header pjax'></th>
				</tr>
			</thead>
			<tbody>
			<xsl:for-each select="/*/payment/pays/pay">
				<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
				<tr class='request_row' id="request_row_{id}" data-file_id="{id}">
					<td class=' string_type'><xsl:apply-templates select="date_parsed" mode="show_date_ru"/></td>
					<td class=' string_type'>
						<xsl:choose>
						<xsl:when test="summ  &gt; 0">Платеж</xsl:when>
						<xsl:otherwise>Возврат</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class=' string_type'>
						<xsl:apply-templates select="summ" mode="show_price"><xsl:with-param name="currency" select="../../currency"/></xsl:apply-templates>
					</td>
					<td><xsl:value-of select="paytype" disable-output-escaping="yes"/></td>
					<td class=' string_type'>
						<xsl:choose>
							<xsl:when test='status = "yes"'>Да</xsl:when>
							<xsl:when test='status = "no"'>Нет</xsl:when>
						</xsl:choose>
						<xsl:choose>
						<xsl:when test="/*/identity /consumer/roles/role = 'admin'">
							<a href="#" data-id="{id}" data-row="{$row}" data-approved="{approved}" title="" class="approve_button">
							<xsl:choose>
							<xsl:when test="approved = 1">
								<xsl:attribute name="title">Подтверждён</xsl:attribute>
									<img src="{/*/system/info/pub_root}i/buttons/turnof{$row}.gif"/><span>Подтверждён</span>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="title">Подтвердить</xsl:attribute>
									<img src="{/*/system/info/pub_root}i/buttons/turnon{$row}.gif"/><span>Не подтвержден</span>
							</xsl:otherwise>
							</xsl:choose>
							</a>
						</xsl:when>
						<xsl:when test="approved = 1">
							(подтверждён)
						</xsl:when>
						</xsl:choose>
					</td>
					<td class=' string_type'>
						<xsl:choose>
							<xsl:when test='pstate = "yes"'>Платеж оплачен</xsl:when>
							<xsl:when test='pstate = "no"'>Платеж просрочен</xsl:when>
							<xsl:when test='pstate = "wait"'>Ожидание</xsl:when>
						</xsl:choose>
					</td>
					<td class=' string_type'>
						<xsl:choose>
							<xsl:when test='tradein = "yes"'>Да</xsl:when>
							<xsl:when test='tradein = "no"'>Нет</xsl:when>
						</xsl:choose>
					</td>
					<td class=' string_type'>
						<xsl:value-of select='tradein_obj' />
					</td>
					<xsl:if test="approved != 1 or /*/identity /consumer/roles/role = 'admin'">
					<td class=' string_type'><a href="{/*/system/info/pub_root}payment/pay_edit/{../../id}/{id}/"><img src="{/*/system/info/pub_root}i/buttons/update{$row}.gif"/></a></td>
					<td class=' string_type'><a href="{/*/system/info/pub_root}payment/pay_delete/{id}/" onclick='return confirm_delete()'><img src="{/*/system/info/pub_root}i/buttons/delete{$row}.gif"/></a></td>
					</xsl:if>
				</tr>
			</xsl:for-each>
			</tbody>
			</table>

		</div>

</xsl:template>

</xsl:stylesheet>
