<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/maint.xslt"/>



<xsl:template match="/" mode="overrideable_title">
	<xsl:choose>
	<xsl:when test="/*/unknown">Страница не найдена</xsl:when>
	<xsl:when test="/*/main   ">Обслуживание сайта</xsl:when>
	</xsl:choose>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">
	<xsl:choose>
	<xsl:when test="/*/unknown">
		<div class="http404">
			<p>
				Запрошенной страницы не существует.
			</p>
			<p>
				Вероятно, это ошибка в административной части, приведшая к неправильно сформированной ссылке.
			</p>
			<p>
				Пожалуйста, сообщите разработчикам сайта адрес страницы (смотрите в адресной строке браузера),
				с примечанием о том, какие действия выполнялись перед тем, как появилась эта страница.
			</p>
			<p>
				Вы можете вернуться на <a href="{/*/system/info/mnt_root}">главную страницу</a> и продолжить работу.
			</p>
		</div>
	</xsl:when>
	<xsl:when test="/*/main">
		<ul class="menuList">
			<li class="menuLink"><a href="{/*/system/info/mnt_root}mailer"                    >Выполнить очередную порцию рассылок</a></li>
			<li class="menuLine"></li>
			<li class="menuLink"><a href="{/*/system/info/mnt_root}clean/temporary_folders"   >Очистить временные папки от старых файлов</a></li>
			<li class="menuLink"><a href="{/*/system/info/mnt_root}clean/mailer_history"      >Очистить историю рассылок от старых заданий</a></li>
			<li class="menuLink"><a href="{/*/system/info/mnt_root}clean/inactive_subscribers">Очистить неактивированные в течение длительного времени подписки</a></li>
			<li class="menuLine"></li>
			<li class="menuLink"><a href="{/*/system/info/mnt_root}split_files"               >[ОСТОРОЖНО! РАЗОВО!] Разнести мусор по папкам с подгруженными файлами</a></li>
			<li class="menuLink"><a href="{/*/system/info/mnt_root}clean_files"               >[ОСТОРОЖНО! РАЗОВО!] Очистить мусор из папок с подгруженными файлами</a></li>
			<li class="menuLink"><a href="{/*/system/info/mnt_root}reorder"                   >[ОСТОРОЖНО! РАЗОВО!] Переупорядочить всё с position-полем.</a></li>
		</ul>
	</xsl:when>
	</xsl:choose>
</xsl:template>



</xsl:stylesheet>
