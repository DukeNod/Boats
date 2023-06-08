function show_modal_edit_xml (xml){
	
	document.body.innerHTML +=  ''
    + '<div style="display: none;">'
        + '<div class="box-modal" id="exampleModal">'
			+ '<div class="box-modal_close arcticmodal-close">закрыть</div>'
			+ '<div style="height:700px;"><pre id="editor"></pre></div>'
        + '</div>'
    + '</div>';	
	
	$.ajax({
        url: xml,
        dataType: "text",
        async: true,
        success: function(msg){
            var editor = ace.edit("editor");
            editor.setTheme("ace/theme/chrome");  
            editor.session.setMode("ace/mode/xml");
			editor.renderer.setShowPrintMargin(false);
            editor.setValue(msg);
        }
    });
	
    $('#exampleModal').arcticmodal();
}