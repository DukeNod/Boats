$( "#legal_street" ).on( "autocompletesearch", function( event, ui ) {
	var city = $('#legal_city').data("item").guid;
	$(this).autocomplete( "option", "source", PUB_ROOT+"search/street.php?city=" + city );
} );


$( "#legal_street" ).on( "autocompleteselect", function( event, ui ) {
	$(this).val( ui.item.value );
	$(this).data( 'item', ui.item );
	
	$('#address_guid').val(ui.item.guid);

	return false;
} );