<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<!-- Список названий полей формы, для ее автоматической генерации. -->


<xsl:template match="name[.='name']"		mode="forms">Имя</xsl:template>
<xsl:template match="name[.='name_full']"		mode="forms">Полное имя</xsl:template>
<xsl:template match="name[.='off_name']"		mode="forms">Полное название гостиницы</xsl:template>
<xsl:template match="name[.='official_organ']"		mode="forms">Код подразделения - РФ</xsl:template>
<xsl:template match="name[.='official_organ_foreign']"		mode="forms">Код подразделения - иностранцы</xsl:template>
<xsl:template match="name[.='inn']"		mode="forms">ИНН</xsl:template>
<xsl:template match="name[.='ogrn']"		mode="forms">ОГРН</xsl:template>
<xsl:template match="name[.='active']"		mode="forms">Статус пользоватетеля поставщика</xsl:template>
<xsl:template match="name[.='fms_code']"		mode="forms">Идентификатор пользоватетеля поставщика</xsl:template>
<xsl:template match="name[.='hotel_code']"		mode="forms">Код гостиницы</xsl:template>
<xsl:template match="name[.='ur_adrr']"		mode="forms">Юридический адрес</xsl:template>
<xsl:template match="name[.='legal_country']"		mode="forms">Страна</xsl:template>
<xsl:template match="name[.='legal_city']"		mode="forms">Город</xsl:template>
<xsl:template match="name[.='legal_street']"		mode="forms">Улица</xsl:template>
<xsl:template match="name[.='address_guid']"		mode="forms">Guid</xsl:template>
<xsl:template match="name[.='legal_house']"		mode="forms">Дом</xsl:template>
<xsl:template match="name[.='legal_korpus']"		mode="forms">Корпус</xsl:template>
<xsl:template match="name[.='legal_stroenie']"		mode="forms">Строение</xsl:template>
<xsl:template match="name[.='legal_apt']"		mode="forms">Квартира</xsl:template>
<xsl:template match="name[.='h1']"		mode="forms"> </xsl:template>
<xsl:template match="name[.='address_actual']"		mode="forms">Фактический адрес</xsl:template>
<xsl:template match="name[.='capacity']"		mode="forms">Вместимость</xsl:template>
<xsl:template match="name[.='initial_count']"		mode="forms">Начальная заполненность</xsl:template>
<xsl:template match="name[.='subbutton']"		mode="forms">Сохранить</xsl:template>

</xsl:stylesheet>