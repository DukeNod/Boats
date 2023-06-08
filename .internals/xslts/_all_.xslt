<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl" exclude-result-prefixes="php">



<!--
Version: 1.0

Определяем дефолтную обработку корневого узла чтобы вывести пустой текст.
Если понадобится переопределить корневой узел на новое оформление и содержание
(а такая нужда возникает на любой странице или в любом разделе (admin/maint/public)),
то это нужно делать с приоритетом строго больше -1000 (например, дефолтным 0).
Так сделано чтобы если не задано явного оформления, то чтобы не выводилось
ничего из DOM (актуально, например, для вызова overrideables, если в вызовах есть
ошибки/опечатки в имени режима; иначе оно выведет весь корневой узел текстом).
-->
<xsl:template priority="-1000" match="/"></xsl:template>



<!--
Три "волшебных" шаблона, которые копируют необработанные элементы не просто текстом
(как оно есть по умолчанию), а со всей структурой узлов. На самом деле пользы от этого
ноль, разве что отловить необработанные узлы и определить откуда вылазят левые тексты.
-->
<xsl:template match="*" priority="-1000">
	<xsl:copy>
		<xsl:apply-templates select="@*" />
		<xsl:apply-templates/>
	</xsl:copy>
</xsl:template>
<xsl:template match="text()" priority="-1000">
	<xsl:value-of select="." disable-output-escaping="yes"/>
</xsl:template>
<xsl:template match="@*|node()" priority="-1000">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>


<xsl:variable name="LANG">
        <!--xsl:value-of select="/*/language"/-->
	<xsl:choose>
	<xsl:when test="/*/language='ru'"></xsl:when>
	<xsl:otherwise><xsl:value-of select="/*/language"/></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="LANGROOT">
	<xsl:value-of select="/*/system/info/pub_root"/>
	<!-- !!! ToDo: Вернуть language на место-->
	<!--xsl:choose>
	<xsl:when test="/*/language='ru'"></xsl:when>
	<xsl:otherwise><xsl:value-of select="/*/language"/>/</xsl:otherwise>
	</xsl:choose-->
</xsl:variable>

<!--
Специальные макросы для вставки определённых фрагментов текста или символов.
На случай когда нужно явно показать что вставляется, а не ставить сами конструкции.
Перевод строки, простой пробел, неразрывный пробел (как unicode-символ)
и неразрывный пробел в виде HTML-сущности (чтобы XSLT-процессинг не превращал сущность в unicode-символ).
-->
<xsl:template name="_newline">
<xsl:text>
</xsl:text>
</xsl:template>



<!--
Дефолтные типовые шаблоны для оформления ошибок.
todo: comment it
-->
<xsl:template priority="-99" match="form/errors/*"><xsl:value-of select="name()"/></xsl:template>
<xsl:template priority="-99" match="errors/*" mode="div"><div class="error"><xsl:apply-templates select="."/></div></xsl:template>
<xsl:template priority="-99" match="parse_errors/*" mode="div"><div class="error"><xsl:apply-templates select="."/></div></xsl:template>
<xsl:template priority="-99" match="parse_warnings/*" mode="div"><div class="warning"><xsl:apply-templates select="."/></div></xsl:template>

<xsl:template match="form/errors/gp_id_required      ">Не указан идентификатор проверочного кода.</xsl:template>
<xsl:template match="form/errors/gp_required         ">Необходимо ввести проверочный код.</xsl:template>
<xsl:template match="form/errors/gp_wrong            ">Проверочный код введён неверно.</xsl:template>

<xsl:template name="repeat-string">
  <xsl:param name="str"/><!-- The string to repeat -->
  <xsl:param name="cnt"/><!-- The number of times to repeat the string -->
  <xsl:param name="pfx"/><!-- The prefix to add to the string -->
  <xsl:choose>
    <xsl:when test="$cnt = 0">
      <xsl:value-of select="$pfx"/>
    </xsl:when>
    <xsl:when test="$cnt mod 2 = 1">
      <xsl:call-template name="repeat-string">
	  <xsl:with-param name="str" select="concat($str,$str)"/>
	  <xsl:with-param name="cnt" select="($cnt - 1) div 2"/>
	  <xsl:with-param name="pfx" select="concat($pfx,$str)"/>
	</xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
	<xsl:call-template name="repeat-string">
	  <xsl:with-param name="str" select="concat($str,$str)"/>
	  <xsl:with-param name="cnt" select="$cnt div 2"/>
	  <xsl:with-param name="pfx" select="$pfx"/>
	</xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="parent" mode="make_mr">
	<xsl:apply-templates select="." mode="check_mr"/>
        <xsl:text>/</xsl:text>
</xsl:template>

<xsl:template match="*" mode="check_mr">
        <xsl:choose>
        <xsl:when test="mr = ''"><xsl:value-of select="id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="mr"/></xsl:otherwise>
        </xsl:choose>
</xsl:template>

<xsl:template name="nl2br">
	<xsl:param name="string"/>
	<xsl:value-of select="normalize-space(substring-before($string,'&#10;'))"/>
	<xsl:choose>
		<xsl:when test="contains($string,'&#10;')">
			<br />
			<xsl:call-template name="nl2br">
				<xsl:with-param name="string" select="substring-after($string,'&#10;')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$string"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:decimal-format name="pricef"
	NaN=""
	decimal-separator=","
	grouping-separator=" "
/>

<xsl:template match="*" mode="show_prices">
	<xsl:for-each select="./*[. != 0]">
	<xsl:if test=". &gt; 0 or . &lt; 0">
		<xsl:apply-templates select="." mode="show_price"><xsl:with-param name="currency" select="name()"/></xsl:apply-templates>
		<xsl:if test="position() != last()">, </xsl:if>
	</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template match="*" mode="show_price">
	<xsl:param name="currency" />

	<!--xsl:if test=". &gt; 0 or . &lt; 0"-->
	<nowrap>
	<xsl:choose>
		<xsl:when test=". = 0 or .=''">0</xsl:when>
		<xsl:when test="$currency = 'usd'">$<xsl:value-of select="format-number(., '# ###', 'pricef')" disable-output-escaping="yes"/></xsl:when>
		<xsl:when test="$currency = 'euro'">€<xsl:value-of select="format-number(., '# ###', 'pricef')" disable-output-escaping="yes"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="format-number(., '# ###', 'pricef')" disable-output-escaping="yes"/> р.</xsl:otherwise>
	</xsl:choose>
	</nowrap>
	<!--/xsl:if-->
</xsl:template>

<xsl:template match="*" mode="correct_citizenship">
	<xsl:choose>
	<xsl:when test=". = ''">
		Лицо без гражданства
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="current()" disable-output-escaping="yes" />
	</xsl:otherwise>	
	</xsl:choose>
</xsl:template>

<xsl:template match="*" mode="campaign_place_type">
	<xsl:choose>
		<xsl:when test=". = 'free'">свободное</xsl:when>
		<xsl:when test=". = 'runsperhour'">фиксированная частота</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="." disable-output-escaping="yes" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*" mode="campaign_weekdays">
	<xsl:choose>
		<xsl:when test=". = '1,1,1,1,1,1,1,'">все</xsl:when>
		<xsl:when test=". = '1,1,1,1,1,0,0,'">рабочие</xsl:when>
		<xsl:when test=". = '0,0,0,0,0,1,1,'">выходные</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="." disable-output-escaping="yes" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*" mode="campaign_group_policy">
	<xsl:choose>
		<xsl:when test=". = 'rotate'"><span title="Если одновременно активно несколько расписаний, выходы распределяются между ними">ротация</span></xsl:when>
		<xsl:when test=". = 'independent'"><span title="Расписания ведут себя как совершенно независимые кампании">независимая</span></xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="." disable-output-escaping="yes" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="platforms_colored">
    <xsl:param name="input"/>
    <xsl:param name="size"/>
    <xsl:if test="string-length($input) &gt; 0">
    	<xsl:variable name="v" select="substring-before($input, ',')"/>
      	<xsl:call-template name="one_platform_colored">
        	<xsl:with-param name="input" select="$v"/>
        	<xsl:with-param name="size" select="$size"/>
      	</xsl:call-template>
      	<xsl:call-template name="platforms_colored">
        	<xsl:with-param name="input" select="substring-after($input, ',')"/>
        	<xsl:with-param name="size" select="$size"/>
      	</xsl:call-template>
    </xsl:if> 
</xsl:template>

<xsl:template name="colored_circle">
	<xsl:param name="color" />
	<xsl:param name="size" />
	<xsl:param name="title" />
	<span style="background-color: {$color}; display: inline-block; width: {$size}px; height: {$size}px; border-radius: 50%; margin-right:4px" title="{$title}" />
</xsl:template>

<xsl:template name="colored_square">
	<xsl:param name="color" />
	<xsl:param name="size" />
	<xsl:param name="title" />
	<span style="background-color: {$color}; display: inline-block; width: {$size}px; height: {$size}px; border-radius: 10%; margin-right:4px" title="{$title}" />
</xsl:template>

<xsl:template name="date_name_colored">
	<xsl:param name="text" />
	<xsl:param name="weekday" />

	<xsl:choose>
		<xsl:when test="$weekday='6' or $weekday='7'">
			<span style="color:#990000"><xsl:value-of select="$text" disable-output-escaping="yes"/></span>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$text" disable-output-escaping="yes"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- общее название целевых платформ у разных корневых -->
<xsl:template name="target_platforms_common_name">
	<xsl:param name="root" />

	<xsl:choose>
		<xsl:when test="$root='metroMonitors'">
			Ветки метро
		</xsl:when>
		<xsl:when test="$root='monitorsTram'">
			Маршруты
		</xsl:when>
		<xsl:when test="$root='busMonitors'">
			Маршруты
		</xsl:when>
		<xsl:when test="$root='monitorsStandalone'">
			Мониторы
		</xsl:when>
		<xsl:otherwise>
			Платформы
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*" mode="bool_to_yes_no">
	<xsl:choose>
		<xsl:when test='. = "1"'>ДА</xsl:when>
		<xsl:when test='. = "0"'>НЕТ</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*" mode="bool_to_plus">
	<xsl:choose>
		<xsl:when test='. = "1"'>+</xsl:when>
		<xsl:when test='. = "0"'></xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- Сообщения проверки валидности кампании -->
<xsl:template name="campaign_validity_text">
	<xsl:param name="errors" />
	<xsl:param name="warnings" />
	<xsl:param name="skip" />

	<xsl:choose>
		<!-- не проверяем черновики, отмененные и т.п. -->
		<xsl:when test="not($skip='')">
		</xsl:when>
		<!-- нет ни ошибок, ни предупреждений -->
		<xsl:when test="($errors='') and ($warnings='')">
		</xsl:when>
		<!-- есть ошибки, и, возможно, предупреждения -->
		<xsl:when test="not($errors='')">
			Ошибки:<br />
			<xsl:value-of select="php:functionString('str_replace','|','&lt;br /&gt;',$errors)" disable-output-escaping="yes"/>
			<xsl:if test="not($warnings='')">
				<br />Предупреждения:<br />
				<xsl:value-of select="php:functionString('str_replace','|','&lt;br /&gt;',$warnings)" disable-output-escaping="yes"/>
			</xsl:if>
		</xsl:when>
		<!-- есть предупреждения -->
		<xsl:when test="not($warnings='')">
			Предупреждения:<br />
			<xsl:value-of select="php:functionString('str_replace','|','&lt;br /&gt;',$warnings)" disable-output-escaping="yes"/>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- клик по ячейке инвентаря открывает список кампаний с установками фильтров, соответствующими ячейке, которую кликнули -->
<xsl:template name="inventory_click">
	<xsl:param name="date" select="''"/>
	<xsl:param name="interval" select="''"/>
	<xsl:param name="platform" select="''"/>
	<xsl:param name="from" select="''"/>
	<xsl:param name="to" select="''"/>
	<xsl:param name="state" select="'withinventory'"/>

	<xsl:text>window.open('</xsl:text>
		<xsl:value-of select="/*/system/info/pub_root" disable-output-escaping="yes" />

		<!-- Корневая платформа -->
		<xsl:text>?filter_Roots=</xsl:text>
		<xsl:value-of select="/*/filters/*[name='RootCode']/value" disable-output-escaping="yes" />

		<!-- Статус кампаний -->
		<xsl:if test="not($state='')">
			<xsl:text>&amp;filter_state=</xsl:text>
			<xsl:value-of select="$state" disable-output-escaping="yes" />
		</xsl:if>

		<!-- Дата, которую включают все кампании -->
		<xsl:if test="not($date='')">
			<xsl:text>&amp;filter_day=</xsl:text>
			<xsl:value-of select="$date" disable-output-escaping="yes" />
		</xsl:if>

		<!-- Временной интервал -->
		<xsl:if test="not($interval='')">
			<xsl:text>&amp;filter_Interval=</xsl:text>
			<xsl:value-of select="$interval" disable-output-escaping="yes" />
		</xsl:if>

		<!-- Целевая платформа, которая присутствует в кампаниях -->
		<xsl:if test="not($platform='')">
			<xsl:text>&amp;filter_PlatformID=</xsl:text>
			<xsl:value-of select="$platform" disable-output-escaping="yes" />
		</xsl:if>

		<!-- Начало периода, который присутствует в кампаниях -->
		<!-- Должно быть меньше или равно даты окончания кампании -->
		<xsl:if test="not($from='')">
			<xsl:text>&amp;filter_ffrom=</xsl:text>
			<xsl:value-of select="$from" disable-output-escaping="yes" />
		</xsl:if>

		<!-- Окончание периода, который присутствует в кампаниях -->
		<!-- Должно быть больше или равно даты старта кампании -->
		<xsl:if test="not($to='')">
			<xsl:text>&amp;filter_sto=</xsl:text>
			<xsl:value-of select="$to" disable-output-escaping="yes" />
		</xsl:if>
	<xsl:text>','_blank')</xsl:text>
</xsl:template>


<xsl:template match="*" mode="auth_extended_policy_desc">
<!--
	Расширенная политика безопасности: 
	применять ко всем без исключения пользователям: <xsl:apply-templates select="force_extended_policy" mode="bool_to_yes_no"/>,
	минимальная длина пароля <xsl:value-of select="min_password_length"/> символов,
	требовать в пароле маленькие латинские буквы: <xsl:apply-templates select="want_lower_latin" mode="bool_to_yes_no"/>,
	требовать большие латинские буквы: <xsl:apply-templates select="want_upper_latin" mode="bool_to_yes_no"/>,
	требовать цифры: <xsl:apply-templates select="want_digit" mode="bool_to_yes_no"/>,
	срок действия временного пароля <xsl:value-of select="temp_password_lifetime_days"/> дней,
	максимальное число попыток ввода неправильного пароля: <xsl:value-of select="max_wrong_password_attempts"/>,
	попыток ввода неправильного пароля перед введением задержки на следующую попытку: <xsl:value-of select="password_attempts_before_delay"/>,
	задержка в минутах: <xsl:value-of select="password_attempts_delay_minutes"/> (варьируется случайным образом на +-50% от этой величины),
	блокированный за ввод неверных паролей пользователь автоматически разблокируется через <xsl:value-of select="user_auto_unlock_minutes"/> минут.
-->
</xsl:template>

</xsl:stylesheet>
