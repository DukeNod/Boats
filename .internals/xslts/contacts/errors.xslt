<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template mode="contact" match="form/errors/*" priority="-1"><xsl:apply-templates select="."/></xsl:template>

<xsl:template mode="contact" match="form/errors/name_required       "><div class="error">Необходимо указать имя.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/email_required      "><div class="error">Необходимо указать e-mail.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/email_bad           "><div class="error">Некорректный формат e-mail.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/phone_required      "><div class="error">Необходимо указать телефон.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/post_required      "><div class="error">Необходимо указать должность.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/comments_required   "><div class="error">Необходимо ввести сообщение.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/gp_id_required      "><div class="error">Не указан идентификатор проверочного кода.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/gp_required         "><div class="error">Необходимо ввести проверочный код.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/gp_wrong            "><div class="error">Проверочный код введён неверно.</div></xsl:template>

<xsl:template mode="contact" match="form/errors/attach_required     "><div class="error">Необходимо загрузить файл.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/attach_extension    "><div class="error">Файл не принят из-за неподходящего расширения.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/attach_lost         "><div class="error">Временная копия файла уже не существует. Перезагрузите его.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/attach_nameless     "><div class="error">Невозможно определить имя файла.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/attach_exists       "><div class="error">Файл с таким именем уже существует в каталоге. Задайте другое имя.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/attach_size_bad     "><div class="error">Некорректное значение размера файла.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/attach_size_too_low "><div class="error">Файл слишком маленький, нужен больше.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/attach_size_too_high"><div class="error">Файл слишком большой, нужен меньше.</div></xsl:template>
<xsl:template mode="contact" match="form/errors/fio_required	    "><div class="error">Необходимо указать имя.</div></xsl:template>

<xsl:template mode="contact" match="form/errors/type_required       "><div class="error">Необходимо указать тип оборудования.</div></xsl:template>

</xsl:stylesheet>
