<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template mode="mailer_file" match="form/errors/*" priority="-1"><xsl:apply-templates select="."/></xsl:template>

<xsl:template mode="mailer_file" match="form/errors/uplink_absent       "><div class="error">Указанная рассылка не существует.</div></xsl:template>
<xsl:template mode="mailer_file" match="form/errors/name_required       "><div class="error">Необходимо задать имя файла как оно будет в сообщении.</div></xsl:template>

<xsl:template mode="mailer_file" match="form/errors/attach_required     "><div class="error">Необходимо загрузить файл.</div></xsl:template>
<xsl:template mode="mailer_file" match="form/errors/attach_extension    "><div class="error">Файл не принят из-за неподходящего расширения.</div></xsl:template>
<xsl:template mode="mailer_file" match="form/errors/attach_lost         "><div class="error">Временная копия файла уже не существует. Перезагрузите его.</div></xsl:template>
<xsl:template mode="mailer_file" match="form/errors/attach_nameless     "><div class="error">Невозможно определить имя файла.</div></xsl:template>
<xsl:template mode="mailer_file" match="form/errors/attach_exists       "><div class="error">Файл с таким именем уже существует в каталоге. Задайте другое имя.</div></xsl:template>
<xsl:template mode="mailer_file" match="form/errors/attach_size_bad     "><div class="error">Некорректное значение размера файла.</div></xsl:template>
<xsl:template mode="mailer_file" match="form/errors/attach_size_too_low "><div class="error">Файл слишком маленький, нужен больше.</div></xsl:template>
<xsl:template mode="mailer_file" match="form/errors/attach_size_too_high"><div class="error">Файл слишком большой, нужен меньше.</div></xsl:template>



</xsl:stylesheet>
