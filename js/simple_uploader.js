var SimpleFileUploader = function($node, url_to_load, url_to_progress, success)
{
        if (typeof($node.$container) != 'undefined') return;
        
        this.$node = $node;
        this.$node.addClass('attache-files-block');
        
        
		this.url_to_load = url_to_load;
		this.url_to_progress = url_to_progress;
		this.success = success;

        var button_text = 'Добавить файл';
        /*
        this.$node.append($('<div class="file-list"><ul></ul></div>\
	<div class="progress">\
		<div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 20%">\
			<span class="sr-only">20% Complete</span>\
		</div>\
	</div>\
	<input type="file" class="hidden">\
	<button id="attache-file-button" class="btn btn-info" style="margin-top: 5px; margin-left: 5px; margin-bottom: 5px;"> '+button_text+' </button>\
	<span class="text-error"></span>\
	'));
	*/
	this.files = [];

	this.__Clone();

	
	this.offset = 0;
	this.count = 512 * 1024;
	this.total = 0;

	this.xhr = new XMLHttpRequest();
	this.xhr.addEventListener("load", $.proxy(this.__UploadComplete, this), false);
	this.xhr.addEventListener("error", $.proxy(this.__UploadError, this), false);
	this.xhr.addEventListener("abort", $.proxy(this.__UploadError, this), false);

	/*
	this.$file = this.$node.find('input[type=file]');
	this.$file.get(0).__uploader = this;
	this.$file.change(this.__SelectFile);
	*/

	//this.$upload_button = this.$node.find('#attache-file-button').click($.proxy(this.__Click, this));

	this.$submit_button = this.$node.find('input[name="send_file"]').click($.proxy(this.UploadSubmit, this));
	
	/*
	this.$remove = this.$node.find('.file-remove').click(this.__Remove);
	this.$remove.get(0).__uploader = this;
	this.$remove.hide()
	*/

	this.$progress = this.$node.find('div.progress');
	this.$progress_value = this.$progress.find('div.progress-bar');
	this.$progress.hide();
	
	this.$progress_title = this.$node.find('.progress-bar-title');
	

	this.$container = this.$node.find('.file-list ul');

	this.$error = this.$node.find('span.text-error');
	this.$error.hide();

}

SimpleFileUploader.prototype.__Click = function(e)
{
	this.$file.click();
};

SimpleFileUploader.prototype.__SelectFile = function(e)
{
	if (typeof(this.files) === 'undefined' || this.files.length <= 0)
	{
		// $(this).parents('.fileWithName').find('.delete').click();
		this.files = this.init_files;
		return false;
	}
	
	// this.__uploader.$body.hide();

	this.init_files = this.files;

	/*
	if ($(this).parents('.jq-file').next().length == 0)
		this.__uploader.__Clone();
	*/

	$(this).parents('.fileWithName').find('.delete').css({ display: 'inline-block' });
}

SimpleFileUploader.prototype.__InitUploadSessionError = function(resp)
{
	console.log('__InitUploadSessionError');
	console.log(arguments);
}

SimpleFileUploader.prototype.UploadSubmit = function()
{
	if (!this.$input.get(0).files[0]) return false;

	var filename = this.$input.val();
	var ext = filename.split('.').pop().toLowerCase();

	/*if ((ext != 'zip') && (ext != 'xml'))
	{
		this.$error.text("Можно загружать только файлы *.zip и *.xml").show();
		this.$error.addClass("error");
		this.$error.show();
		return false;
	}*/
	
	this.$progress_value.css('width', '0%');
	this.$progress.show();
	this.$progress_title.text('Загрузка');
	this.$progress_title.show();
	// this.__uploader.$text.show();
	this.$error.hide();
	
	$('body').append("<div class='block_all'></div>");
	
	this.__UploadFile(this.$input.get(0).files[0]);
	
	return false;
}

SimpleFileUploader.prototype.__UploadFile = function(file)
{
	this.file = file;
	this.total = file.size;

	$.ajax({
			 url: this.url_to_load
			,dataType: 'json'
			,type: 'POST'
			,data: { cmd: 'init_upload' }
			,success: $.proxy(this.__InitUploadSessionSuccess, this)
			,error: $.proxy(this.__InitUploadSessionError, this)
		});
}

SimpleFileUploader.prototype.urlencode = function(str)
{
	str = (str + '').toString();
	return encodeURIComponent(str).replace(/!/g, '%21').replace(/'/g, '%27').replace(/\(/g, '%28').
	replace(/\)/g, '%29').replace(/\*/g, '%2A').replace(/%20/g, '+');
}

SimpleFileUploader.prototype.__UploadContinue = function()
{
	var url = this.url_to_load+'?session='+this.session+'&total='+this.total+'&filename='+this.urlencode(this.file.name)+'&filesize='+this.file.size;
	this.xhr.open('put', url);
	this.xhr.send(this.file.slice(this.offset, this.offset + this.count));
}

SimpleFileUploader.prototype.__UploadComplete = function(e)
{
	this.offset += this.count;
	
	var resp;

	try
	{
		resp = JSON.parse(e.target.response);
	}
	catch (err)
	{
		console.log(e.target.response);
	}

	this.$progress_value.css('width', Math.min((this.offset / this.total) * 100.0, 100.0) + '%');

	if (this.offset >= this.total)
	{
		/*
		var url = resp.url
		url = url.substr(url.lastIndexOf('/')+1);
		var file_id = url.substr(0, url.lastIndexOf('?'));

		var icon = this.FileIcon(this.file.name);

		var $file_row = $('<li><a href="'+resp.url+'" target="_blank">'+icon+' '+this.file.name+'</a> <span class="file-remove glyphicon glyphicon-remove-sign"></span></li>');
		$file_row.find('.file-remove').click($.proxy(this.__Remove, this));
		$file_row.data('file_id', file_id);
		$file_row.data('file_name', this.file.name);
		$file_row.data('file_size', this.file.size);

		this.$progress.hide();
		this.$container.append($file_row);
		this.$file.val('');
		*/
		
		this.$input.val('');
		
//		setTimeout($.proxy(this.ProcessStart,this), 500);
        setTimeout($.proxy(function () {
            $('.block_all').remove();
            $.ajax({
                url: PUB_ROOT+'api/customeradfile/upload_result'
                , dataType: 'json'
                , type: 'GET'
                , data: {session: this.session}
                , success: $.proxy(this.success, this)
            });
        }, this), 500);
        return;
	}
	else
	{
		this.__UploadContinue();
	}
}

SimpleFileUploader.prototype.__UploadError = function(e)
{
	$('.block_all').remove();
	console.log('__UploadError');
	console.log(arguments);
}

SimpleFileUploader.prototype.__InitUploadSessionSuccess = function(resp)
{
	this.session = resp.session;

	if (this.session === 'undefined' || this.session == '')
	{
		console.log('Cannot init upload session!');
		return;
	}

	this.offset = 0;
	this.__UploadContinue();
}

SimpleFileUploader.prototype.__Remove = function(e)
{
        var $row = $(e.currentTarget).parents('li');
        var file_id = $row.data('file_id');
        if(file_id)
	$.ajax({
			 url: '/core/file-upload'
			,dataType: 'json'
			,type: 'POST'
			,data: { cmd: 'delete', file_id: file_id }
		});
        $row.remove();
}

SimpleFileUploader.prototype.FileIcon = function(filename)
{
	var ext = filename.substr(filename.lastIndexOf('.'));

	var icon = ''

	switch(ext)
	{
	case '.pdf':
		icon = 'pdf';
		break;
	case '.swf':
		icon = 'flash';
		break;
	case '.htm':
	case '.html':
	case '.xml':
		icon = 'msie';
		break;
	case '.txt':
	case '.log':
		icon = 'text';
		break;
	case '.rtf':
	case '.doc':
	case '.docx':
		icon = 'msword';
		break;
	case '.xls':
	case '.xlsx':
		icon = 'msexcel';
		break;
	case '.ppt':
		icon = 'mspowerpoint';
		break;
	case '.gif':
	case '.jpg':
	case '.jpeg':
	case '.png':
	case '.bmp':
	case '.tif':
	case '.tiff':
		icon = 'picture';
		break;
	case '.avi':
	case '.mpg':
	case '.mpeg':
	case '.m4v':
	case '.flv':
		icon = 'movie';
		break;
	default:
		icon = 'unknown';
	}

	if (icon)
		return '<img src="http://dev.appnow.com/core/static/images/file_icons/'+icon+'.gif" width="20" height="20" class="file_icon '+((icon == 'picture') ? 'picture' : '')+'"/>';
	else
		return '';
}

SimpleFileUploader.prototype.getFilesList = function()
{
	var data = [];
	this.$container.children().each(function()
	{
		data.push({ url: $('a', this).attr('href'), file_name: $(this).data('file_name'), file_size: $(this).data('file_size') });
	});

	return data;
}

SimpleFileUploader.prototype.Clear = function()
{
	//this.$container.empty();
	this.$node.children().not(':last').remove();
	this.$node.children().first().find('.delete').click();
}

SimpleFileUploader.prototype.__Clone = function()
{
	/*
	var $input = $('<input name="file'+Math.random()+'" data-placeholder="файл не выбран" type="file" class="fileWithName">');
	this.$node.append($input);
	$input.styler({
        fileBrowse: "fileBrowse"
    ,	filePlaceholder: "файл не выбран"
	});
	*/
	this.$input = this.$node.find('input[name="upload_file"]');

	var $file = this.$node;

	this.$input.get(0).__uploader = this;
	
	//$file.find('.jq-file__name').after('<span class="delete"></span>');
	$file.css('display', 'block');

	this.$input.change(this.__SelectFile);

	$file.find('.delete').click(function()
	{
		var $file = $(this).parents('.fileWithName');
		if ($file.siblings().length != 0)
		{
			$file.remove();
		}
		else
		{
	        $file.find('input').val('');
    	    $file.find('.jq-file__name').text(_L('supnofile'));
    	    $file.find('.delete').hide();
		}
    })
}

SimpleFileUploader.prototype.ProcessStart = function()
{
	this.$progress_value.css('width', '0%');
	this.$progress.show();
	this.$progress_title.text('Обработка').show();
	// this.__uploader.$text.show();
	this.$error.hide();
	
	this.__ProcessContinue();
	
	return false;
}

SimpleFileUploader.prototype.__ProcessContinue = function(resp)
{
	if (resp)
	{
		this.$progress_value.css('width', resp.progress + '%');
		
		if (resp.uploader_id)
		{
			setTimeout($.proxy(function()
			{
				$('.block_all').remove();
				$.proxy(this.success, this)(resp);
			},this), 500);
			return;
		}
	}
	
	console.log(resp);
	setTimeout($.proxy(function()
	{
		$.ajax({
			 url: this.url_to_progress
			,dataType: 'json'
			,type: 'POST'
			,data: { session: this.session }
			,success: $.proxy(this.__ProcessContinue, this)
		});
	},this), 500);
}

