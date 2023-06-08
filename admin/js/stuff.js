function smart_image_popup (url, w, h)
{
	var id = "ottoclub_image_"+(Math.floor(Math.random()*1000000));
	var w = (parseInt(w)+40);
	var h = (parseInt(h)+40);

	var w = window.open(url, id, "width="+w+",height="+h+",resizable,status,location,scrollbars,menubar");
	if (!w) return true;

	w.focus();
	return false;
}

function popup_window (url, w, h)
{
	var id = "_new_"+(Math.floor(Math.random()*1000000));
//	var w = (parseInt(w)+40);
//	var h = (parseInt(h)+40);

	var w = window.open(url, id, "width="+w+",height="+h+",resizable,status,location,scrollbars,menubar");
	if (!w) return true;

	w.focus();
	return false;
}


function get_text_of_control (control)
{
	var result;
	var id = typeof control == 'string' ? control : (control.id ? control.id : (control.id = 'auto_id_' + Math.floor(Math.rand()*1000000)));
	var ob = typeof control == 'object' ? control : (document.getElementById(control));
	var e;
	if (tinyMCE && (e = tinyMCE.get(id)) && !e.isHidden()) result = e.getContent(); else
	if (ob && typeof ob.value != 'undefined') result = ob.value;
	if (typeof result == 'string' && $.hiddentextDecode) result = $.hiddentextDecode(result);
	return result;
}

function set_text_of_control (control, text)
{
	var id = typeof control == 'string' ? control : (control.id ? control.id : (control.id = 'auto_id_' + Math.floor(Math.rand()*1000000)));
	var ob = typeof control == 'object' ? control : (document.getElementById(control));
	var e;
	if (tinyMCE && (e = tinyMCE.get(id)) && !e.isHidden()) e.setContent(text); else
	if (ob && typeof ob.value != 'undefined') ob.value = text;
}

/*
if ($.browser.msie)
$(function()
{
	$('option:disabled')
		.css('color', 'graytext')
	.parent()
		.bind('focus', function()
		{
			$.data(this, 'si', this.selectedIndex);
		})
		.bind('change', function()
		{
			if (this.options[this.selectedIndex].disabled)
			{
				this.selectedIndex = $.data(this, 'si');
				return false;
			} else
			{
				$.data(this, 'si', this.selectedIndex);
			}
		})
	;
});
*/

function updateStateOfMassDelete ()
{
	if ($('.inlineCheckbox._delete:checked').length)
	{
		$('.inlineButton._delete').css({ visibility: 'visible' });
	} else
	{
		$('.inlineButton._delete').css({ visibility: 'hidden' });
	}
}

function setCookie (name, value, exdays, path, domain, secure)
{
	var exdate=new Date();
	exdate.setDate(exdate.getDate() + exdays);

      document.cookie = name + "=" + escape(value) +
        ((exdays != null) ? "; expires="+exdate.toUTCString() : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}

$(function()
{
	$('.inlineCheckbox')
	.css({ display: 'none' })
	.after('<img width="20" height="20" alt="удалить"/>')
	.next()
	.each(function()
	{
		var ele = $(this).prev().get(0);
		var row =
			(ele.className.match(/_row1/) ? '1' :
			(ele.className.match(/_row2/) ? '2' :
			('0')));
		$(this).click(function()
		{
			ele.checked = !ele.checked;
			this.src=ADM_ROOT+'img/buttons/delete'+(row)+'state'+(ele.checked?'1':'0')+'.gif';
			updateStateOfMassDelete();
		});
			this.src=ADM_ROOT+'img/buttons/delete'+(row)+'state'+(ele.checked?'1':'0')+'.gif';
	})
	;
	updateStateOfMassDelete();
});

$(function()
{
//	$.debugTarget('#log');
//	$.debugFilter('^..tached ');
	$.debug('hello');

	$.keyboardCreateTypograph()
	.css({ position: 'absolute', zIndex: '1000', display: 'none' })
	.keyboard()
	.appendTo(document.body)
//	.bind('keyboardHintShow', function (event, data)
//	{
//		window.status = data.hint;
//		$(data.key).css({backgroundColor: '#00ff00'});
//	})
//	.bind('keyboardHintHide', function (event, data)
//	{
//		window.status = 'LEAVED '+data.hint;
//		$(data.key).css({backgroundColor: '#C8DDED'});
//		})
	.bind('keyboardKeyClick', function (event, data)
	{// 'this' is a keyboard key
		$(data.key)
		.css({
			backgroundColor: '#0000ff'
		})
		.animate({
			backgroundColor: '#C8DDED'
		}, {
			duration: 250,
			easing: 'linear',
			queue: false
		})
		;
	})
	.bind('keyboardAttached', function(event, input)
	{
		var anchor = $('#'+input.id+'_anchor').add(input);
		$(this)
		.queue([]).stop()
		.queue(function(){ $(this).css('display', 'block'); $(this).dequeue(); })
		.css({
			left: $(anchor).offset().left + $(anchor).width(),
			top:  $(anchor).offset().top  + 0,
			marginLeft: '3px',
			marginTop: '-3px'
		})
		.css({ opacity: 0.00 }).fadeTo(250, 1.00)
		;
	})
	.bind('keyboardRetached', function(event, input)
	{
		var anchor = $('#'+input.id+'_anchor').add(input);
		$(this)
		.queue([]).stop()
		.queue(function(){ $(this).css('display', 'block'); $(this).dequeue(); })
		.animate({
			opacity: 1.0,
			left: $(anchor).offset().left + $(anchor).width(),
			top:  $(anchor).offset().top  + 0,
			marginLeft: '3px',
			marginTop: '-3px'
		}, {
			duration: 250,
			easing: 'swing',
			queue: false
		})
		;
	})
	.bind('keyboardDetached', function(event, input)
	{
		$(this)
		.queue([]).stop()
		.fadeTo(250, 0.00)
		.queue(function(){ $(this).css('display', 'none'); $(this).dequeue(); })
		;
	})
	;

	if ($('textarea.controlString').length)
	{
		$('.layoutContext')
		.append('<label class="contextLine"><input type="checkbox" id="usetinymce" />&nbsp;Визуальный редактор</label>')
		;
	}

	if ($('.controlString').length)
	{
		$('.layoutContext')
		.append('<label class="contextLine"><input type="checkbox" id="hiddentext" />&nbsp;Показывать спецсимволы</label>')
		.append('<label class="contextLine"><input type="checkbox" id="atypograph" />&nbsp;Автотипографика</label>')
		;

		$('#atypograph')
		.each(function(){ this.checked = $.cookie('auto_typograph') ? true : false; })
		.click(function()
		{
			$.cookie('auto_typograph', this.checked ? 1 : null, { path: '/', expires: 365 });
		})
		.triggerHandler('click');

		$('#hiddentext')
		.each(function(){ this.checked = $.cookie('hiddentext') ? true : false; })
		.click(function()
		{
			$('.controlString').hiddentext(this.checked);
			$.cookie('hiddentext', this.checked ? 1 : null, { path: '/', expires: 365 });
			if (!this.checked)
			{
				$('form').unbind('submit.hiddentext');
			} else
			{
				$('form').bind('submit.hiddentext', function()
				{
					$('.controlString').hiddentext(false);
				});
			}
		})
		.triggerHandler('click');

		$('#usetinymce')
		.each(function(){ this.checked = $.cookie('usetinymce') ? true : false; })
		.click(function()
		{
			$.cookie('usetinymce', this.checked ? 1 : null, { path: '/', expires: 365 });
			if (this.checked)
			{
				$('textarea.controlString')
				.hiddentext(false)
				.each(function(){
					var e = tinymce.EditorManager.get(this.id);
					if (e) e.show();
					else {
						e = new tinymce.Editor(this.id, {
							plugins : "safari,table,advhr,advimage,advlink,inlinepopups,insertdatetime,preview,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras",
							entity_encoding : "raw",
							theme : "advanced",
							theme_advanced_layout_manager: "SimpleLayout",


							// Theme options
							theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,outdent,indent,blockquote,|,undo,redo,|,bullist,numlist,|,formatselect,fontselect,fontsizeselect",
							theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,cite,abbr,acronym,del,ins,attribs,,|,link,unlink,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor", // ,anchor
							theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,advhr,|,print,|,ltr,rtl,|,fullscreen,|,visualchars,nonbreaking",
							theme_advanced_toolbar_location : "top",
							theme_advanced_toolbar_align : "left",
							theme_advanced_statusbar_location : "bottom",
							theme_advanced_resizing : true,
							
							table_styles : "Header 1=header1;Header 2=header2;Header 3=header3",
							table_cell_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Table Cell=tableCel1",
							table_row_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Table Row=tableRow1",
							table_cell_limit : 100,
							table_row_limit : 5,
							table_col_limit : 5,
							force_br_newlines: "true",

							plugin_insertdate_dateFormat : "%d.%m.%Y",
							plugin_insertdate_timeFormat : "%H:%M:%S",

							// Drop lists for link/image/media/template dialogs
							template_external_list_url : "lists/template_list.js",
							external_link_list_url : "lists/link_list.js",
							external_image_list_url : "lists/image_list.js",
							media_external_list_url : "lists/media_list.js",

							// Enable translation mode
							translate_mode : true,
							language : "ru",

							//Mad File Manager
							relative_urls : false,	
							file_browser_callback : MadFileBrowser

							/*
							plugins : "table",
							entity_encoding : "raw",
							theme : "advanced",
							theme_advanced_layout_manager: "SimpleLayout",
							theme_advanced_buttons1: "bold,italic,underline,separator,justifyleft,justifycenter,justifyright,justifyfull,fontselect,fontsizeselect,forecolor,bulllist,numlist,link,unlink,separator,tablecontrols",
							theme_advanced_buttons2: "",
							theme_advanced_buttons3: "",
//							fontselect,fontsizeselect,forecolor,bullist,numlist,link",
//							theme_advanced_buttons2: "tablecontrols",
//							theme_advanced_buttons3: "",
//							theme_advanced_disable : "bullist,numlist,link,styleselect,formatselect,indent,outdent,undo,redo,anchor,help,code,unlink,removeformat,sub,sup,hr,charmap,visualaid,image,cleanup,strikethrough",
							theme_advanced_disable : "bullist,numlist",
							theme_advanced_toolbar_location : "top",
							table_styles : "Header 1=header1;Header 2=header2;Header 3=header3",
							table_cell_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Table Cell=tableCel1",
							table_row_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Table Row=tableRow1",
							table_cell_limit : 100,
							table_row_limit : 5,
							table_col_limit : 5,
							force_br_newlines: "true"
							*/
						});
						tinymce.EditorManager.add(e);
						e.render();
					}
				})
				;

				tmp = $('.layoutContext');
				tmp.removeClass('layoutContext');
				tmp.addClass('layoutContext1');
			} else
			{
				$('textarea.controlString')
				.each(function(){
					var e = tinymce.EditorManager.get(this.id);
					if (e) e.hide();
				})
				.hiddentext($('#hiddentext').get(0).checked)
				;

				tmp = $('.layoutContext1');
				tmp.removeClass('layoutContext1');
				tmp.addClass('layoutContext');
			}
		})
		.triggerHandler('click');
	}

	window.form_change = false;

//	$('#main_form > input, #main_form > select, #main_form > textarea').change(function() {
//		window.form_change = true;
//	});
        var $main_form = $('#main_form')
	$('input, select, textarea', $main_form).change(function() {
		window.form_change = true;
	});

	$(".b-tabs .tab").bind("click", function(){
		var $tabs = $(".b-tabs .tab").removeClass("active");
		var $obj = $(this).addClass("active");
		for (i=0; i<$tabs.length; i++)
		{
			if($($tabs.get(i)).hasClass("active"))
			{
				$($(".b-tabs .tab-pad").addClass("m-hidden").get(i)).removeClass("m-hidden");
				break;
			}
		}

		setCookie('bookmark', $(this).attr('id'), 3, ADM_ROOT);
	});

	if (bookmark != "" && $('#'+bookmark).length > 0)
	{
		var $tabs = $(".b-tabs .tab").removeClass("active");
		var $obj = $('#'+bookmark).addClass("active");
		for (i=0; i<$tabs.length; i++)
		{
			if($($tabs.get(i)).hasClass("active"))
			{
				$($(".b-tabs .tab-pad").addClass("m-hidden").get(i)).removeClass("m-hidden");
				break;
			}
		}
	}

	$(".close_img").click(function()
	{
		$("#popup_window").hide();
		$("#ImageBoxOverlay").hide();

		return false;
	});
	$("#ImageBoxOverlay").click(function()
	{
		$("#popup_window").hide();
		$("#ImageBoxOverlay").hide();

		return false;
	});
});

        // http file manager
	function MadFileBrowser(field_name, url, type, win) {
		// alert(win.toString())
	  tinyMCE.activeEditor.windowManager.open({
	      file : PUB_ROOT+"mfm.php?field=" + field_name + "&url=" + url + "",
	      title : 'File Manager',
	      width : 640,
	      height : 450,
	      resizable : "no",
	      inline : "yes",
	      close_previous : "no"
	  }, {
	      window : win,
	      input : field_name
	  });
	  return false;
	}

	function form_ask()
	{
	        /*
		if (window.form_change)
		{
			if (window.confirm("Поля формы были изменены. \n Сохранить изменения?"))
			{
				document.getElementById('main_form').submit();
				return false;
			}
		}

		return true;
		*/
		if (window.form_change)
		{
			if (window.confirm("Поля формы были изменены. \nНе сохраненные изменения будут потеряны. \nПродолжить?"))
			{
				return true;
			}
			return false;
		}

		return true;
	}

function set_ajax_window_coord()
{
        /*
	var top = $(window).scrollTop() + 50;
	var left = $(window).scrollLeft() + Math.round($(window).width()/2)-400;

	curitem = $('#popup_window').get(0);
        $(curitem).css('top', top+'px');
        $(curitem).css('left', left+'px');
        $(curitem).css('width', '800px');
        */
//        $(curitem).css('height', '600px');

	curitem = $('#popup_window').get(0);

	var top = $(window).scrollTop() + 50;

        $(curitem).css('top', top+'px');
        margin = Math.round(($(window).width() - $(curitem).width())/2);
	$(curitem).css('margin-left', margin);
	$(curitem).css('margin-right', margin);
}

function ajax_window(url)
{
	        $("#ImageBoxOverlay").height($(document).height());
	        $("#ImageBoxOverlay").width($(document).width());
		$("#ImageBoxOverlay").show();

		var content = $('#popup__content');
                content.html('<img class="ajax-loader" src="'+ADM_ROOT+'img/ajax-loader.gif">');
//		content.css('left', '50%');
//		content.css('margin-left', '0');
		set_ajax_window_coord();
		$("#popup_window").show();

		if (url.indexOf('?') != -1) url += '&ajax=1';
		else url += '?ajax=1';

		ajax({
			url		: url,
			method		: 'get',
			parse_response	: false,
			on_rawtext	: function(params, response_text) {
						ajax_elemental_set(params, '');
						catch_ajax_window(params, response_text);
					},
			on_exception	: ajax_elemental_on_exception,
			on_httperror	: ajax_elemental_on_httperror,
			on_timeout	: ajax_elemental_on_timeout,
			on_state	: ajax_elemental_on_state,
			on_start	: ajax_elemental_on_start,
			//on_timer	: ajax_elemental_on_timer,
//			on_debug	: ajax_debug,
			interval	: 500,
			timeout		: 10000
//			elemental_id    : prefix+'filter_status',//for ajax_elemental
			});
}	

function catch_ajax_window(params, response_text)
{
		//$("#ImageBoxOverlay").hide();
		//$("#popup_window").hide();

		var content = $('#popup__content');
		content.html(response_text);
//		content.css('left', '50%');
//		content.css('margin-left', -1*Math.round($('.listTable', content).width()/2));

		set_ajax_window_coord();
		//$("#popup_window").show();
	        $("#ImageBoxOverlay").height($(document).height());
	        $("#ImageBoxOverlay").width($(document).width());
		//$("#ImageBoxOverlay").show();

	$("a", content).click(function()
	{
	        ajax_window(this.href);
		return false;
	});

	$("form", content).submit(function()
	{
		var options = { 
		        //target:	'#popup__content',   // target element(s) to be updated with server response 
			//url:	url,        // override for form's 'action' attribute 
			//type:	'GET',  // 'get' or 'post', override for form's 'method' attribute 
		        //dataType:  'xml'        // 'xml', 'script', or 'json' (expected server response type) 
	        	//beforeSubmit:  formWait,  // pre-submit callback 
		        //success:       formSuccess  // post-submit callback 
		        // other available options: 
	        	//clearForm: true        // clear all form fields after successful submit 
		        //resetForm: true        // reset the form after successful submit 
		 
		        // $.ajax options can be used here too, for example: 
	        	//timeout:   3000 
	        
		        beforeSubmit: function() {
				var content = $('#popup__content');
                		content.html('<img class="ajax-loader" src="'+ADM_ROOT+'img/ajax-loader.gif">');
		        },

		        success: function(response_text) {
				ajax_elemental_set(params, '');
				catch_ajax_window(params, response_text);
		        }
		}; 

	        $(this).ajaxSubmit(options);
		return false;
	});
}

		function toggleHidden(url, id, state, row, field)
		{

			if (id != '')
			ajax({
				url		: ADM_ROOT+url+'?toggle='+id+'&hidden='+state+'&field='+field,
				parse_response	: true,
				on_success	: function(params, response_object) {
					var rowName  = "#hidden_" + field + id;
					var rowState = ((response_object.field == 1)? "of" : "on") + row;
					var rowTitle = (response_object.field == 1)? "Да": "Нет";
					var rowImage  = ADM_ROOT+"img/buttons/turn"+ rowState +".gif";
					$( rowName ).empty();
					$( rowName ).append( '<a href="javascript: void(0);" id="hidden_' + field + id +'" onClick="toggleHidden(\''+url+'\', '+ id +', '+(0+!response_object.field)+', '+ row +', \'' + field + '\')"><img src="'+ rowImage +'" title="'+ rowTitle +'" border="0" /></a>' );
				},
				on_exception	: ajax_elemental_on_exception,
				on_httperror	: ajax_elemental_on_httperror,
				on_timeout	: ajax_elemental_on_timeout,
				on_state	: ajax_elemental_on_state,
				on_start	: ajax_elemental_on_start,
				on_timer	: ajax_elemental_on_timer,
//				on_debug	: ajax_debug,
				interval	: 500,
				timeout		: 10000
//				elemental_id    : prefix+'filter_status',//for ajax_elemental
//				object		: { category: val }
			});
			return false;
		}

function previousTag(node) { 
   var node = node.previousSibling; 
   return (node && node.nodeType!=1) ? previousTag(node) : node; 
} 
// аналог nextSibling 
function nextTag(node) { 
   var node = node.nextSibling; 
   return (node && node.nodeType!=1) ? nextTag(node) : node; 
} 

function parentTag(node, tag_name)
{
   var node = node.parentNode;
   return (node && node.nodeName.toLowerCase() != tag_name) ? parentTag(node, tag_name) : node; 
}

function number_format( number, decimals, dec_point, thousands_sep )  // Format a number with grouped thousands
{
    // +   original by: Jonas Raoni Soares Silva (http://www.jsfromhell.com)
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +     bugfix by: Michael White (http://crestidg.com)

    var i, j, kw, kd, km, minus = "";
 
    // input sanitation & defaults
    if( isNaN(decimals = Math.abs(decimals)) )
    {
        decimals = 2;
    }

    if( dec_point == undefined )
    {

        dec_point = ",";

    }

    if( thousands_sep == undefined )
    {
        thousands_sep = ".";
    }

    if(number < 0)
    {
    	minus = "-";
    	number = number*-1;
    }

    i = parseInt(number = (+number || 0).toFixed(decimals)) + "";

    if( (j = i.length) > 3 ){
        j = j % 3;
    } else{
        j = 0;
    }

    km = (j ? i.substr(0, j) + thousands_sep : "");

    kw = i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thousands_sep);

    //kd = (decimals ? dec_point + Math.abs(number - i).toFixed(decimals).slice(2) : "");

    kd = (decimals ? dec_point + Math.abs(number - i).toFixed(decimals).replace(/-/, 0).slice(2) : "");

    return minus + km + kw + kd;

}
