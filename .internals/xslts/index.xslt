<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<!--
ТЕЛО (BODY) СТРАНИЦЫ.
Задаём тег body страниц, которые не содержат переопределений этого тега (как правило переопределяет только главная страница).
Помещаем сюда всё фиксированное и переопределяемое наполнение и оформление таких страниц.
-->

<xsl:template name="index_body">
<!-- Main block -->
<div class="paralax_x">
  <div class="">
<div class="start_main parallax-layer"> 
  <div  class="logo_start"><a href="#" class="link_general" onclick="welcome(); return false;"><img src="{/*/system/info/pub_root}images/logo.png"   title="{/*/page_content/name}" alt="{/*/page_content/name}"/></a> 
  </div>
  <div class="navigate_block_start"> 
    <ul>
      <xsl:for-each select="/*/main-menu/*">
      <li class="block-{position()}">
		<xsl:apply-templates select="linked_picts/linked_pict[1]" mode="linked_pict">
			<xsl:with-param name="dir" select="concat(/*/system/info/pub_root, 'linked/picts/230/230/')"/>
			<xsl:with-param name="def" select="name"/>
			<xsl:with-param name="aclass" select="'link_photo'"/>
			<xsl:with-param name="small_w" select="230"/>
			<xsl:with-param name="small_h" select="230"/>
			<xsl:with-param name="href" select="concat($LANGROOT, mr, '/')"/>
		</xsl:apply-templates>
      	<div class="name"><a href="{$LANGROOT}{mr}/"  alt="{name}" title="{name}"><xsl:value-of select="name" disable-output-escaping="yes"/></a></div> </li>
      </xsl:for-each>
      <!--
      <li class="block-2"><a href="{$LANGROOT}fishing/" class="link_photo"  alt="Рыбалка" title="Рыбалка"><img src="{/*/system/info/pub_root}images/1.jpg" alt="Рыбалка" title="Рыбалка"/></a><div class="name"><a href="{$LANGROOT}fishing/"   alt="Рыбалка" title="Рыбалка">Рыбалка</a></div></li>
      <li class="block-3"><a href="{$LANGROOT}gallery/" class="link_photo"  alt="Фото и видео" title="Фото и видео"><img src="{/*/system/info/pub_root}images/1.jpg" alt="Фото и видео" title="Фото и видео"/></a><div class="name"><a href="{$LANGROOT}gallery/"   alt="Фото и видео" title="Фото и видео">Фото         и видео</a></div> </li>
      <li class="block-4"><a href="{$LANGROOT}services/" class="link_photo" alt="Услуги и цены" title="Услуги и цены"><img src="{/*/system/info/pub_root}images/1.jpg" alt="Услуги и цены" title="Услуги и цены"/></a><div class="name"><a href="{$LANGROOT}services/"  alt="Услуги и цены" title="Услуги и цены">Услуги       и цены</a></div> </li>
      -->
    </ul>
  </div>
  <div class="tel_block_start">   <div class="cont"> 
    <div class="tel">+7 (495) 589-89-79</div><p><span class="icon"></span>
    <a href="#"  class="link_call">Перезвоните мне</a></p><p><span class="icon icon-2"></span>
      <a href="{$LANGROOT}location/">Схема проезда</a></p><p><span class="icon icon-3"></span>
    <a href="{$LANGROOT}contacts/">Наши контакты</a></p>
  </div>  </div>
  <div class="auth_block_start"> 
    <div class="cont"> 
      <span id="auth_block_start_text">
      <xsl:choose>
      <xsl:when test="/*/identity/consumer">
        <span class="text"><a href="{$LANGROOT}registration/"><!-- class="link_reg" -->Личный кабинет</a></span><span class="icon"></span><span class="text">  <span class="name_user"><xsl:value-of select="/*/identity/consumer/first_name"/></span><a href="{$LANGROOT}logout/" class="link_out">Выйти</a> </span>
      </xsl:when>
      <xsl:otherwise>
        <span class="text"><a href="#" class="link_auth">Вход 
        для клиентов</a></span><span class="icon"></span><span class="text">или 
        <a href="#" class="link_reg">регистрация</a> </span>
      </xsl:otherwise>
      </xsl:choose>
        </span>  
      <div class="search_block"> 
          <form action="{$LANGROOT}search/" method="get">
	      <input type="text" name="text" class="input_text" value="Поиск по сайту">
		<xsl:attribute name="onfocus">if (this.value=='Поиск по сайту') {this.value='';}</xsl:attribute>
		<xsl:attribute name="onblur">if (this.value==''){this.value='Поиск по сайту'}</xsl:attribute>
	      </input>
            <input type="submit" class="sub" value=""/>
          </form>
      </div>
    </div>
  </div>
  <div class="services_block_start"> 
    <ul>
    	<xsl:for-each select="/*/menu-services/subpages/page">
      <li class="block-{position()}"><xsl:value-of select="position()"/>.<a href="{$LANGROOT}services/{mr}/">
      	<xsl:value-of select="name" disable-output-escaping="yes"/>
      </a></li>
      </xsl:for-each>
    </ul>
  </div>
  <div class="navigate_site_start"> <div class="text"><div class="name">Барыбинские Ведомости</div>
  	<div class="date">
  		<xsl:call-template name="datetime_natural_wday_ru">
			<xsl:with-param name="wday" select="/*/system/now/wday"/>
        	</xsl:call-template>
        	<xsl:text>, </xsl:text>
        	<xsl:call-template name="datetime_natural_ru">
			<xsl:with-param name="year" select="/*/system/now/year"/>
			<xsl:with-param name="month" select="/*/system/now/mon"/>
			<xsl:with-param name="day" select="/*/system/now/mday"/>
        	</xsl:call-template>
        	<xsl:text> г.</xsl:text>
	</div></div>
    <ul>
      <li class="block-1"><a href="{$LANGROOT}news/" class="link_news">Новости</a></li>
      <li class="block-2"><a target="_blank" href="http://www.rusfishing.ru/forum/showthread.php?t=15311">Форум</a></li>
      <li class="block-3"><a href="{$LANGROOT}interesting/">Это интересно</a></li>
    </ul>
  </div>

</div>

</div>
</div>
<!-- End Main block -->

    <xsl:for-each select="/*/news_latest/news[1]">
    <div class="popup_block news_popup" id="basic-modal-content-news" data-id="{id}"> 
      <div class="popup_cont"> 
        <div class="title_popup">Новости</div>
        <a href="{$LANGROOT}news/{id}/" class="name"><xsl:value-of select="title" disable-output-escaping="yes"/></a> 
        <div class="date">
		<xsl:call-template name="datetime_numeric_ru">
			<xsl:with-param name="raw"   select="ts"/>
			<xsl:with-param name="year"  select="ts_parsed/year"/>
			<xsl:with-param name="month" select="ts_parsed/month"/>
			<xsl:with-param name="day"   select="ts_parsed/day"/>
		</xsl:call-template>
        </div>
        <div  class="photo">
		<xsl:apply-templates select="linked_picts/linked_pict" mode="linked_pict">
			<xsl:with-param name="def" select="title"/>
			<xsl:with-param name="class" select="'pic'"/>
			<xsl:with-param name="href">
				<xsl:if test="linked_paras/* or linked_gallery/*">
					<xsl:value-of select="concat($LANGROOT, 'news/', id, '/')" />
				</xsl:if>
			</xsl:with-param>
		</xsl:apply-templates>
        </div>
        <div class="text">
		<xsl:value-of select="short" disable-output-escaping="yes"/>
        </div>
      </div>
    </div>
    </xsl:for-each>

	 <div class="popup_block general_popup" id="basic-modal-content-general"> 
	 <div class="hider">
	  </div>
      <div class="popup_cont"> 
        <div class="general_popup_title"><h1><xsl:value-of select="/*/page_content/name"/></h1>
		</div>
        <div class="text">
		<xsl:for-each select="/*/page_content/linked_paras/linked_para">
		<div class="tab-pad">
					<h2><xsl:value-of select="name"/></h2>
					<xsl:apply-templates select="." mode="linked_para">
						<xsl:with-param name="name" select="''"/>
					</xsl:apply-templates>
		</div>
		</xsl:for-each>
		</div>
      </div>
	  <div class="hider">
	  </div>
    </div>
	
    <div class="popup_block call_popup" id="basic-modal-content-call"> 
      <div class="popup_cont"> 
      	<!--
        <div class="title_popup2">Перезвоните мне</div>
        <div class="text0"> 
          <p>Пожалуйста, заполните следующую форму, и мы перезвоним в указанное 
            Вами время. </p>
          <p> Все поля обязательны для заполнения.</p>
        </div>
        <form action="#" method="post">
          <fieldset>
          <span class="text">Имя</span> 
          <input type="text" class="input_text" value=""/>
          <br/>
          <span class="text">Телефон</span> 
          <input type="text" class="input_text" value=""/>
          <br/>
          <span class="text">Город</span> 
          <input type="text" class="input_text" value=""/>
          <br/>
          <span class="text">Дата</span> 
          <input type="text" class="input_text" value=""/>
          <div class="time"> <span class="text">Время</span>с 
            <input type="text" class="input_text" value=""/>
            до 
            <input type="text" class="input_text" value=""/>
          </div>
          <input type="submit" class="sub" value="Отправить"/>
          </fieldset>
        </form>
        -->
      </div>
    </div>
    <div class="popup_block auth_popup" id="basic-modal-content-auth"> 
      <div class="popup_cont"> 
      </div>
    </div>
    <div class="popup_block reg_popup" id="basic-modal-content-reg"> 
      <div class="popup_cont"> 
      </div>
    </div>
	
	<div class="popup_block general_popup" id="basic-modal-content-general">
		<div class="popup_cont">
		</div>
	</div>
<!--xsl:call-template name="popup_banner"/-->
</xsl:template>

</xsl:stylesheet>
