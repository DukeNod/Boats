<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<!--

Шаблоны для форматирования дат и времени в различных форматах.

Шаблоны не должны бы (хотя и могут) включать спец-символы (например, неразрывный пробел), но никогда (sic!)
не выводят никакие теги или entity (потому что не факт что будут использованы в html, могут и в xml/rss/text).
Если эти символы и введены как entities, то всё равно они распарсятся при чтении XSLT файла, и выведутся как символы.
Хотя с помощью параметров space, colon, comma, dot можно менять то, как выглядят различные знаки препинания в выводе.

Специальных шаблонов для только дат (без времени) не сделано, так как все нынешние шаблоны показывают
ту информацию, которая им была передана в аргументах, и если там часы, минуты или секунды не переданы,
то они и не будут показаны. Аналогично нет специальных шаблонов только для времени (просто не указывайте дату).

-->

<!--
Дата и время в формате RFC822 (Wed, 02 Oct 2002 15:00:00 +0200).
-->
<xsl:template name="datetime_rfc822">
	<xsl:param name="year"/>
	<xsl:param name="month"/>
	<xsl:param name="day"/>
	<xsl:param name="hour"/>
	<xsl:param name="minute"/>
	<xsl:param name="second"/>
	<xsl:param name="zone"/>
	<xsl:param name="space" select="' '"/>
	<xsl:param name="colon" select="':'"/>
	<xsl:param name="comma" select="','"/>
	<xsl:param name="dot"   select="'.'"/>
	<xsl:param name="month_abbr"><xsl:call-template name="datetime_rfc822_month_abbr"><xsl:with-param name="month" select="$month"/></xsl:call-template></xsl:param>

	<!-- День недели опускаем, его нелегко определить средствами XSLT, а нужды в нём немного. -->

		<xsl:value-of select="format-number($day, '00')"/>
		<xsl:value-of select="$space"/>
		<xsl:value-of select="$month_abbr"/>
		<xsl:value-of select="$space"/>
		<xsl:value-of select="format-number($year, '00')"/>

	<xsl:if test="(string($hour)!='') and (string($minute)!='')">
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$space"/>
	</xsl:if>

	<xsl:if test="(string($hour)!='') and (string($minute)!='')">
		<xsl:value-of select="format-number($hour, '00')"/>
		<xsl:value-of select="$colon"/>
		<xsl:value-of select="format-number($minute, '00')"/>
		<xsl:if test="(string($second)!='')">
			<xsl:value-of select="$colon"/>
			<xsl:value-of select="format-number($second, '00')"/>
		</xsl:if>
	</xsl:if>

	<xsl:if test="(string($zone)!='')">
		<xsl:value-of select="$space"/>
		<xsl:value-of select="$zone"/>
	</xsl:if>

</xsl:template>

<!--
Дата и время в естественно-языковом виде на русском языке (1 января 2007; 32 мая 01:02).
Минимально требуются параметры day & month либо hour & minute.
Параметр separator - это строка, отделяющая дату от времени (например, запятая). Если пуст - то выведется пробел.
Значение month_natural можно перекрыть аргументом, если потребуется.
-->
<xsl:template name="datetime_natural_ru">
	<xsl:param name="year"/>
	<xsl:param name="month"/>
	<xsl:param name="day"/>
	<xsl:param name="hour"/>
	<xsl:param name="minute"/>
	<xsl:param name="second"/>
	<xsl:param name="space" select="' '"/>
	<xsl:param name="colon" select="':'"/>
	<xsl:param name="comma" select="','"/>
	<xsl:param name="dot"   select="'.'"/>
	<xsl:param name="month_natural"><xsl:call-template name="datetime_natural_month_ru_r"><xsl:with-param name="month" select="$month"/></xsl:call-template></xsl:param>

	<xsl:if test="(string($day)!='') and (string($month)!='')">
		<xsl:value-of select="format-number($day, '0')"/>
		<xsl:value-of select="$space"/>
		<xsl:value-of select="$month_natural"/>
		<xsl:if test="(string($year)!='')">
			<xsl:value-of select="$space"/>
			<xsl:value-of select="format-number($year, '00')"/>
		</xsl:if>
	</xsl:if>

	<xsl:if test="(string($day)!='') and (string($month)!='')">
	<xsl:if test="(string($hour)!='') and (string($minute)!='')">
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$space"/>
	</xsl:if>
	</xsl:if>

	<xsl:if test="(string($hour)!='') and (string($minute)!='')">
		<xsl:value-of select="format-number($hour, '00')"/>
		<xsl:value-of select="$colon"/>
		<xsl:value-of select="format-number($minute, '00')"/>
		<xsl:if test="(string($second)!='')">
			<xsl:value-of select="$colon"/>
			<xsl:value-of select="format-number($second, '00')"/>
		</xsl:if>
	</xsl:if>

</xsl:template>

<!--
Дата и время в строго-числовом (бестекстовом) русском формате (01.01.2007 01:02:03).
Минимально требуются параметры day & month либо hour & minute.
Параметр separator - это строка, отделяющая дату от времени (например, запятая). Если пуст - то выведется пробел.
-->
<xsl:template name="datetime_numeric_ru">
	<xsl:param name="raw"/>
	<xsl:param name="year"/>
	<xsl:param name="month"/>
	<xsl:param name="day"/>
	<xsl:param name="hour"/>
	<xsl:param name="minute"/>
	<xsl:param name="second"/>
	<xsl:param name="space" select="' '"/>
	<xsl:param name="colon" select="':'"/>
	<xsl:param name="comma" select="''"/>
	<xsl:param name="dot"   select="'.'"/>
	<xsl:param name="short"   select="0"/>


	<xsl:if test="((string($day)='') or (string($month)='')) and ((string($hour)='') or (string($minute)=''))">
		<xsl:copy-of select="$raw"/>
	</xsl:if>

	<xsl:if test="(string($day)!='') and (string($month)!='')">
		<xsl:value-of select="format-number($day, '00')"/>
		<xsl:value-of select="$dot"/>
		<xsl:value-of select="format-number($month, '00')"/>
		<xsl:if test="(string($year)!='')">
			<xsl:value-of select="$dot"/>
			<xsl:choose>
			<xsl:when test="$short=1">
			<xsl:value-of select="format-number(substring($year,3,2), '00')"/>
			</xsl:when>
			<xsl:otherwise>
			<xsl:value-of select="format-number($year, '00')"/>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:if>

	<xsl:if test="(string($day)!='') and (string($month)!='')">
	<xsl:if test="(string($hour)!='') and (string($minute)!='')">
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$space"/>
	</xsl:if>
	</xsl:if>

	<xsl:if test="(string($hour)!='') and (string($minute)!='')">
		<xsl:value-of select="format-number($hour, '00')"/>
		<xsl:value-of select="$colon"/>
		<xsl:value-of select="format-number($minute, '00'  )"/>
		<xsl:if test="(string($second)!='')">
			<xsl:value-of select="$colon"/>
			<xsl:value-of select="format-number($second, '00')"/>
		</xsl:if>
	</xsl:if>

</xsl:template>

<!--
Вспомогательный шаблон - имя месяца на русском языке в родительном падеже (января, февраля, марта...).
NB: Если нужно будет с большой буквы - то завести другой шаблон, datetime_natural_month_ru_R (регистр имеет значение).
-->
<xsl:template name="datetime_natural_month_ru_r">
	<xsl:param name="month"/>
	<xsl:choose>
	<xsl:when test="number($month)= 1">января</xsl:when>
	<xsl:when test="number($month)= 2">февраля</xsl:when>
	<xsl:when test="number($month)= 3">марта</xsl:when>
	<xsl:when test="number($month)= 4">апреля</xsl:when>
	<xsl:when test="number($month)= 5">мая</xsl:when>
	<xsl:when test="number($month)= 6">июня</xsl:when>
	<xsl:when test="number($month)= 7">июля</xsl:when>
	<xsl:when test="number($month)= 8">августа</xsl:when>
	<xsl:when test="number($month)= 9">сентября</xsl:when>
	<xsl:when test="number($month)=10">октября</xsl:when>
	<xsl:when test="number($month)=11">ноября</xsl:when>
	<xsl:when test="number($month)=12">декабря</xsl:when>
	<xsl:otherwise><xsl:value-of select="$month"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="datetime_natural_month_ru">
	<xsl:param name="month"/>
	<xsl:choose>
	<xsl:when test="number($month)= 1">Январь</xsl:when>
	<xsl:when test="number($month)= 2">Февраль</xsl:when>
	<xsl:when test="number($month)= 3">Март</xsl:when>
	<xsl:when test="number($month)= 4">Апрель</xsl:when>
	<xsl:when test="number($month)= 5">Май</xsl:when>
	<xsl:when test="number($month)= 6">Июнь</xsl:when>
	<xsl:when test="number($month)= 7">Июль</xsl:when>
	<xsl:when test="number($month)= 8">Август</xsl:when>
	<xsl:when test="number($month)= 9">Сентябрь</xsl:when>
	<xsl:when test="number($month)=10">Октябрь</xsl:when>
	<xsl:when test="number($month)=11">Ноябрь</xsl:when>
	<xsl:when test="number($month)=12">Декабрь</xsl:when>
	<xsl:otherwise><xsl:value-of select="$month"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="datetime_natural_month_ru_sh">
	<xsl:param name="month"/>
	<xsl:choose>
	<xsl:when test="number($month)= 1">янв</xsl:when>
	<xsl:when test="number($month)= 2">февр</xsl:when>
	<xsl:when test="number($month)= 3">мар</xsl:when>
	<xsl:when test="number($month)= 4">апр</xsl:when>
	<xsl:when test="number($month)= 5">май</xsl:when>
	<xsl:when test="number($month)= 6">июнь</xsl:when>
	<xsl:when test="number($month)= 7">июль</xsl:when>
	<xsl:when test="number($month)= 8">авг</xsl:when>
	<xsl:when test="number($month)= 9">сент</xsl:when>
	<xsl:when test="number($month)=10">окт</xsl:when>
	<xsl:when test="number($month)=11">ноя</xsl:when>
	<xsl:when test="number($month)=12">дек</xsl:when>
	<xsl:otherwise><xsl:value-of select="$month"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
Вспомогательный шаблон - трёхбуквенное обозначение месяца на английском языке (Jan, Feb, Mar...).
-->
<xsl:template name="datetime_rfc822_month_abbr">
	<xsl:param name="month"/>
	<xsl:choose>
	<xsl:when test="number($month)= 1">Jan</xsl:when>
	<xsl:when test="number($month)= 2">Feb</xsl:when>
	<xsl:when test="number($month)= 3">Mar</xsl:when>
	<xsl:when test="number($month)= 4">Apr</xsl:when>
	<xsl:when test="number($month)= 5">May</xsl:when>
	<xsl:when test="number($month)= 6">Jun</xsl:when>
	<xsl:when test="number($month)= 7">Jul</xsl:when>
	<xsl:when test="number($month)= 8">Aug</xsl:when>
	<xsl:when test="number($month)= 9">Sep</xsl:when>
	<xsl:when test="number($month)=10">Oct</xsl:when>
	<xsl:when test="number($month)=11">Nov</xsl:when>
	<xsl:when test="number($month)=12">Dec</xsl:when>
	<xsl:otherwise><xsl:value-of select="$month"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="datetime_natural_month_ru_in">
	<xsl:param name="month"/>
	<xsl:choose>
	<xsl:when test="number($month)= 1">январе</xsl:when>
	<xsl:when test="number($month)= 2">феврале</xsl:when>
	<xsl:when test="number($month)= 3">марте</xsl:when>
	<xsl:when test="number($month)= 4">апреле</xsl:when>
	<xsl:when test="number($month)= 5">мае</xsl:when>
	<xsl:when test="number($month)= 6">июне</xsl:when>
	<xsl:when test="number($month)= 7">июле</xsl:when>
	<xsl:when test="number($month)= 8">августе</xsl:when>
	<xsl:when test="number($month)= 9">сентябре</xsl:when>
	<xsl:when test="number($month)=10">октябре</xsl:when>
	<xsl:when test="number($month)=11">ноябре</xsl:when>
	<xsl:when test="number($month)=12">декабре</xsl:when>
	<xsl:otherwise><xsl:value-of select="$month"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="datetime_natural_wday_ru">
	<xsl:param name="wday"/>
	<xsl:choose>
	<xsl:when test="number($wday)= 1">Понедельник</xsl:when>
	<xsl:when test="number($wday)= 2">Вторник</xsl:when>
	<xsl:when test="number($wday)= 3">Среда</xsl:when>
	<xsl:when test="number($wday)= 4">Четверг</xsl:when>
	<xsl:when test="number($wday)= 5">Пятница</xsl:when>
	<xsl:when test="number($wday)= 6">Суббота</xsl:when>
	<xsl:when test="number($wday)= 7">Воскресенье</xsl:when>
	<xsl:otherwise><xsl:value-of select="$wday"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="datetime_natural_wday_ru_short">
	<xsl:param name="wday"/>
	<xsl:choose>
	<xsl:when test="number($wday)= 1">Пн</xsl:when>
	<xsl:when test="number($wday)= 2">Вт</xsl:when>
	<xsl:when test="number($wday)= 3">Ср</xsl:when>
	<xsl:when test="number($wday)= 4">Чт</xsl:when>
	<xsl:when test="number($wday)= 5">Пт</xsl:when>
	<xsl:when test="number($wday)= 6">Сб</xsl:when>
	<xsl:when test="number($wday)= 0">Вс</xsl:when>
	<xsl:otherwise><xsl:value-of select="$wday"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="day_word">
	<xsl:param name="d"/>
	<xsl:choose>
		<xsl:when test="(($d mod 10&gt;0) and ($d mod 10&lt;5) and not($d&gt;=11 and $d&lt;=15))">
			<xsl:choose>
				<xsl:when test="(($d mod 10=1) or ($d&gt;=11 and $d&lt;=15))">
					день
				</xsl:when>
				<xsl:otherwise>
					дня
				</xsl:otherwise>
			</xsl:choose>		
		</xsl:when>
		<xsl:otherwise>
					дней
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="num_sufix">
	<xsl:param name="n"/>
	<xsl:choose>
		<xsl:when test="(not(($n mod 100 &gt; 10) and ($n mod 100 &lt; 20)))">
			<xsl:choose>
				<xsl:when test="(($n=0) or ($n mod 10=2) or ($n mod 10=6) or ($n mod 10=7) or ($n mod 10=8))">
					<xsl:text>-ой</xsl:text>
				</xsl:when>
				<xsl:when test="(($n mod 10=3))">
					<xsl:text>-ий</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>-ый</xsl:text>
				</xsl:otherwise>
			</xsl:choose>		
		</xsl:when>
		<xsl:otherwise>
					<xsl:text>-ый</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="*" mode="show_date_ru">
	<xsl:call-template name="datetime_numeric_ru">
		<xsl:with-param name="year"  select="year" />
		<xsl:with-param name="month" select="month"/>
		<xsl:with-param name="day"   select="day"  />
	</xsl:call-template>
</xsl:template>

<xsl:template match="*" mode="show_datetime_ru">
	<xsl:call-template name="datetime_numeric_ru">
		<xsl:with-param name="year"  select="year" />
		<xsl:with-param name="month" select="month"/>
		<xsl:with-param name="day"   select="day"  />
		<xsl:with-param name="hour"  select="hour" />
		<xsl:with-param name="minute" select="minute"/>
		<xsl:with-param name="second"   select="second"  />
	</xsl:call-template>
</xsl:template>

<xsl:template match="*" mode="show_time_ru">
	<xsl:call-template name="datetime_numeric_ru">
		<xsl:with-param name="hour"  select="hour" />
		<xsl:with-param name="minute" select="minute"/>
		<xsl:with-param name="second"   select="second"  />
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
