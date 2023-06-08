$( "#_reg_street" ).on( "autocompletesearch", function( event, ui ) {
	var city = $('#_reg_city').data("item").guid;
	$(this).autocomplete( "option", "source", PUB_ROOT+"search/street.php?city=" + city );
} );


$( "#_reg_street" ).on( "autocompleteselect", function( event, ui ) {
	$(this).val( ui.item.value );
	$(this).data( 'item', ui.item );
	
	$('#_reg_address').val(ui.item.guid);

	return false;
} );

$(function(){
});
						