<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">


<!--
Мега-макрос, который реагирует на все шаблоны подписки-отписки, благо они взаимоисключащие.
Оформление сделано как можно более нейтральным, но можно и переопределять.
-->
<xsl:template name="subscription">
	<xsl:choose>



	<xsl:when test="/*/done[@for='subscribe-request']">
		<p>
			Теперь необходимо подтвердить подписку.
		</p>
		<p>
			На Ваш e-mail выслано письмо с инструкциями.
		</p>
	</xsl:when>

	<xsl:when test="/*/done[@for='subscribe-confirm']">
		<p>
			Подписка подтверждена.
			Спасибо, что стали нашим подписчиком!
		</p>
		<p>
			На Ваш e-mail выслано письмо с подтверждением подписки.
		</p>
	</xsl:when>

	<xsl:when test="/*/form[@for='subscribe-request' and errors/is_active_already]">
		<p>
			Этот e-mail уже есть в списке рассылки.
		</p>
	</xsl:when>

	<xsl:when test="/*/form[@for='subscribe-confirm' and errors/is_active_already]">
		<p>
			Ваша подписка и так уже подтверждена.
		</p>
	</xsl:when>

	<xsl:when       test="/*/form[@for='subscribe-request']">
	<xsl:for-each select="/*/form[@for='subscribe-request']">
		<form class="s_mail" method="get" action="{/*/system/info/pub_root}subscribe">
		<div class="b-deg-pad">
			<table class="b-send-form no-print">
				<tr>
					<td class="name" colspan="2">
					<div class="errors" style="padding: 0 0 1ex 0; ">
						<xsl:apply-templates select="errors/*" mode="div"/>
					</div>
					</td>
				</tr>
				<tr>
					<td class="name">E-mail* </td>
					<td class="value"><input class="medium input" value="{data/email}" name="email"  type="text" />&nbsp;<button class="button_1" >Подписаться</button></td>
				</tr>
				<tr>
					<td colspan="3" class="name">
						&nbsp;
					</td>
				</tr>
			</table>
		</div>
					<!--xsl:text>E-mail*&nbsp;</xsl:text>
					<input type="text" name="email" value="{data/email}" class="in"/>
					<button class="btn" >Подписаться</button-->
		</form>
	</xsl:for-each>
	</xsl:when>

	<xsl:when       test="/*/form[@for='subscribe-confirm']">
	<xsl:for-each select="/*/form[@for='subscribe-confirm']">
		<form class="s_mail" method="get" action="{/*/system/info/pub_root}subscribe">
			<div class="errors" style="padding: 0 0 1ex 0; ">
				<xsl:apply-templates select="errors/*" mode="div"/>
			</div>
			<table class="flat"><tr class="flat">
				<td class="d-label" style="border:0px solid white;">
					E-mail*
				</td>
				<td style="border:0px solid white;">
					<input type="text" name="email" value="{data/email}" class="in"/>
				</td>
				<td class="d-label" style="border:0px solid white;">
					Код*
				</td>
				<td style="border:0px solid white;">
					<input type="text" name="code" value="{data/code}" class="in"/>
				</td>
				<td class="d-button">
					<button class="btn" >Подписаться</button>
				</td>
			</tr>
			</table>
		</form>
	</xsl:for-each>
	</xsl:when>


	
	<xsl:when test="/*/done[@for='unsubscribe-request']">
		<p>
			Теперь необходимо подтвердить отписку.
		</p>
		<p>
			На Ваш e-mail выслано письмо с инструкциями.
		</p>
	</xsl:when>

	<xsl:when test="/*/done[@for='unsubscribe-confirm']">
		<p>
			Вы отписаны от рассылки.
			Спасибо, что были нашим подписчиком!
		</p>
		<p>
			На Ваш e-mail выслано письмо с подтверждением отписки.
		</p>
	</xsl:when>

	<xsl:when test="/*/form[@for='unsubscribe-request' and errors/email_wrong]">
		<p>
			Этот e-mail и так не подписан или не активирован.
		</p>
	</xsl:when>

	<xsl:when test="/*/form[@for='unsubscribe-confirm' and errors/email_wrong]">
		<p>
			Этот e-mail и так не подписан или не активирован.
		</p>
	</xsl:when>

	<xsl:when       test="/*/form[@for='unsubscribe-request']">
	<xsl:for-each select="/*/form[@for='unsubscribe-request']">
		<form method="get" class="s_mail" action="{/*/system/info/pub_root}unsubscribe">
		<div class="b-deg-pad">
			<table class="b-send-form no-print">
				<tr>
					<td class="name" colspan="2">
					<div class="errors" style="padding: 0 0 1ex 0; ">
						<xsl:apply-templates select="errors/*" mode="div"/>
					</div>
					</td>
				</tr>
				<tr>
					<td class="name">E-mail* </td>
					<td class="value"><input class="medium input" value="{data/email}" name="email"  type="text" />&nbsp;<button class="button_1" >Отписаться</button></td>
				</tr>
				<tr>
					<td colspan="3" class="name">
						&nbsp;
					</td>
				</tr>
			</table>
		</div>
			<!--div class="errors" style="padding: 0 0 1ex 0; ">
				<xsl:apply-templates select="errors/*" mode="div"/>
			</div>
			<table class="flat"><tr class="flat">
				<td class="d-label" style="border:0px solid white;">
					<xsl:text>E-mail*&nbsp;</xsl:text>
				</td>
				<td style="border:0px solid white;">
					<input type="text" name="email" value="{data/email}" class="in"/>
				</td>
				<td class="d-button" style="border:0px solid white;">
					<button class="btn" >Отписаться</button>
				</td>
			</tr></table-->
		</form>
	</xsl:for-each>
	</xsl:when>

	<xsl:when       test="/*/form[@for='unsubscribe-confirm']">
	<xsl:for-each select="/*/form[@for='unsubscribe-confirm']">
		<form method="get"  class="s_mail" action="{/*/system/info/pub_root}unsubscribe">
			<div class="errors" style="padding: 0 0 1ex 0; ">
				<xsl:apply-templates select="errors/*" mode="div"/>
			</div>
			<table class="flat"><tr class="flat">
				<td class="d-label" style="border:0px solid white;">
					E-mail*
				</td>
				<td style="border:0px solid white;">
					<input type="text" name="email" class="in" value="{data/email}"/>
				</td>
				<td class="d-label" style="border:0px solid white;">
					Код*
				</td>
				<td style="border:0px solid white;">
					<input type="text" name="code" class="in" value="{data/code}"/>
				</td>
				<td class="d-button">
					<button class="btn" >Отписаться</button>
				</td>
			</tr></table>
		</form>
	</xsl:for-each>
	</xsl:when>



	</xsl:choose>
</xsl:template>



</xsl:stylesheet>
