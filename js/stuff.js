function IsSet(f)
{
	return typeof(f) !== 'undefined';
}

/*
	function closeMaps(){
		$(".b-contacts-map__big").fadeOut("fast");
	}
*/
	function hide_all(){
		closeMaps();
	}
/*
function popup_form_exec(mr, url)
{

$('.link_'+mr).click(function (e) {

	$.extend($.modal.defaults, {
	closeClass: "modalClose_main-"+mr,
	closeHTML: "<a href='#'></a>"
	});
	
	$('#basic-modal-content-'+mr).modal(		
	{
		opacity:70,
		overlayCss: {backgroundColor:"#000"},
		overlayClose: true,
		onOpen: function (dialog) {
			dialog.overlay.fadeIn('fast', function () {
				dialog.data.hide();
				dialog.container.fadeIn('fast', function () {
					dialog.data.slideDown('fast');	 
				});
			});
		}
	});

	$("#basic-modal-content-"+mr+" .popup_cont").load(url, function(responseText, textStatus, XMLHttpRequest){
		popup_form_fetch(mr);
	});

	return false
});
}
*/

function setCookie(name, value, expires_add){var valueEscaped = escape(value);var expiresDate = new Date();expiresDate.setTime(expiresDate.getTime() + expires_add);var expires = expiresDate.toGMTString();var newCookie = name + "=" + valueEscaped + "; path=/; expires=" + expires;if (valueEscaped.length <= 4000) document.cookie = newCookie + ";";}

function getCookie(name){var prefix = name + "=";var cookieStartIndex = document.cookie.indexOf(prefix);if (cookieStartIndex == -1) return null;var cookieEndIndex = document.cookie.indexOf(";", cookieStartIndex + prefix.length);if (cookieEndIndex == -1) cookieEndIndex = document.cookie.length;return unescape(document.cookie.substring(cookieStartIndex + prefix.length, cookieEndIndex));}

function popup_request_img()
{
    $("#ImageBoxOverlay").height($(document).height());
    $("#ImageBoxOverlay").width($(document).width());

	curitem = $('#popup_banner').get(0);

	var top = $(window).scrollTop() + 50;

    $(curitem).css('top', top+'px');
    margin = Math.round(($(window).width() - 800)/2);
    
	$(curitem).css('margin-left', margin);
	$(curitem).css('margin-right', margin);

	$("#popup_banner .close_img").click(function()
	{
		$("#popup_banner").hide();
		$("#ImageBoxOverlay").hide();

		return false;
	});
	
	$("#ImageBoxOverlay,#request-img-open").click(function()
	{
		$("#popup_banner").hide();
		$("#ImageBoxOverlay").hide();

		return false;
	});
	
	/*$(".request-img").click(function()
	{
		var top = $(window).scrollTop() + 50;
		$(curitem).css('top', top+'px');
		
		$img = $('#request-img-open');
		
		$img.get(0).src = this.src;
		
		$("#ImageBoxOverlay").show();
		$("#popup_banner").show();
		
	    $("#ImageBoxOverlay").height($(document).height());
	});*/
	
	return false
}

function dadata(street, bounds)
{
    var token = "dfb467c6cc442257c2932c5621eb4ac03fb744cc",
        type  = "ADDRESS";

        $('#'+street).suggestions({
            token: token,
            type: type,
            hint: false,
            bounds: bounds,
            onSelect: function(suggestion, changed){
                //suggestion.data.fias_id
                //var street_name = $(street).attr('name');

                $('#'+street).val(suggestion.unrestricted_value);
                $('#'+street+'_fias').val(suggestion.data.fias_id).valid();
            },
            onSelectNothing: function(query) {
                $('#'+street+'_fias').val('').valid();
                //$('#'+street).val('');
            }
        });
}
        
function confirm_delete()
{
	return confirm('Вы уверены?');
}

$(function(){
	
/*
popup_form_exec('call', PUB_ROOT+"forms/call/");

popup_form_exec('reg', PUB_ROOT+"registration/reg/");
popup_form_exec('auth', PUB_ROOT+"login/");

popup_form_exec('voip', PUB_ROOT+"votes/ajax/");
*/

//popup_request_img();

});

