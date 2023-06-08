function isset(f)
{
	return typeof(f) !== 'undefined';
}

function HandlebarsCompile(template)
{
	return Handlebars.compile(template);
}

var ApiClass = function()
{
	this.is_init = false;
	
	this.api_url = "http://mvkserv.appnow.com/gkh/calc/api/";
	
	
	//var token = GetCookie(auth_cookie);
	
	//if(token) this.token = token;
	
	//var id = GetCookie(user_id_cookie);
	
	//if(id) this.user_id = id;
}

ApiClass.prototype.ClearAuth = function()
{
	delCookie(auth_cookie);
	delCookie(user_id_cookie);
	delCookie(anonymous_cookie);
	delCookie(mail_cookie);
	
	delete this.token;
	delete this.user_id;
}

ApiClass.prototype.make_success = function(callback)
{
	return function(data, textStatus, jqXHR)
	{
		callback(false, data, jqXHR);
	}
}

ApiClass.prototype.make_error = function(callback)
{
	return function(jqXHR, textStatus, errorThrown)
	{
		if (jqXHR.status == '200' && jqXHR.responseText =='')
		{
			callback(false, {}, jqXHR);
		}
		else
		{
			callback(true, []);
		}
	}
}

ApiClass.prototype.Get = function(cmd, callback)
{
	this._Get(this.api_url + cmd, callback);
}

ApiClass.prototype._Get = function(url, callback, noauth)
{
	var params = {
		 url: url
		,dataType: 'json'
		,type: 'GET'
		,success: this.make_success(callback)
		,error: this.make_error(callback)
	};
	
	$.ajax(params);
}

ApiClass.prototype.Call = function(cmd, data, callback)
{
	this.Get(cmd, data, callback);
}

ApiClass.prototype.Post = function(cmd, data, callback, noauth)
{
	 this._Post(this.api_url + cmd + '/', data, callback, noauth);
}

ApiClass.prototype._Post = function(url, data, callback, noauth)
{
	var params = {
		 url: url
		//,contentType: 'application/json'
		,dataType: 'json'
		,type: 'POST'
		,data: data //JSON.stringify(data)
		,success: this.make_success(callback)
		,error: this.make_error(callback)
	};
	
	$.ajax(params);
}

ApiClass.prototype.Put = function(cmd, data, callback, noauth)
{
	 this._Put(this.api_url + cmd, data, callback, noauth);
}

ApiClass.prototype._Put = function(url, data, callback, noauth)
{
	var params = {
		 url: url
		,contentType: 'application/json'
		,dataType: 'text'
		,type: 'PUT'
		,data: JSON.stringify(data)
		,success: this.make_success(callback)
		,error: this.make_error(callback)
	};
	
	$.ajax(params);
}

var QuestionApplication = function()
{
	this.Q = Questions;
	
	console.log(JSON.stringify(Questions));
	
	this.currentQ = this.Q;
	
	this.tpl =
	{
		 radio: HandlebarsCompile($('#radio-template').html())
		,input: HandlebarsCompile($('#input-template').html())
		,hint: HandlebarsCompile($('#hint-template').html())
		,text: HandlebarsCompile($('#text-template').html())
		,date: HandlebarsCompile($('#date-template').html())
	};
	
	this.$table = $('#questions-body');
	this.$table.change(function() {$('.error').hide();});
	
	this.$question = $('#gkh-question');
	
	this.$next_button = $('#gkh-next-button');
	this.$prev_button = $('#gkh-prev-button');
	
	this.$result_row = $('#result-row');
	this.$result = this.$result_row.find('#result-block');
	
	this.$next_button.click($.proxy(this.NextStep, this));
	this.$prev_button.click($.proxy(this.PrevStep, this));
	
	this.InitQuestions();
	
	this.ShowQuestion(this.currentQ);
}

QuestionApplication.prototype.InitQuestions = function()
{
	for(var i in this.Q.answers)
		this._questionTree(this.Q.answers[i].next, this.Q);
}

QuestionApplication.prototype._questionTree = function(Q, parent)
{
	if (!Q) return;
	
	Q.parent = parent;
	
	if (Q.type == 'radio')
	{
		if (Q.next)
		{
			this._questionTree(Q.next, Q);
		}
		else
		{
			for(var i in Q.answers)
				this._questionTree(Q.answers[i].next, Q);
		}
	}
		
	if (Q.type == 'input')
		this._questionTree(Q.next, Q);
		
//	if (Q.type == 'text')
}

QuestionApplication.prototype.ShowQuestion = function(Q)
{
	this.$table.empty();
	this.$question.text(Q.question);
	var $answers = this[Q.type + 'Type'](Q);
	
	if (Q.hint) $answers = $answers.add(this.tpl.hint({ hint: Q.hint }));
	
	this.$table.append($answers);
	
	if (isset(Q.method) && isset(this[Q.method+'_bind'])) this[Q.method+'_bind']();
}

QuestionApplication.prototype.radioType = function(Q)
{
	var $answers = $([]);
	
	for(var i in Q.answers)
		$answers = $answers.add(this.tpl.radio({ id: i, name: "question", text: Q.answers[i].text }));
	
	return $answers;
}

QuestionApplication.prototype.textType = function(Q)
{
	this.$next_button.attr('disabled', 'disabled');

	var $answers = $([]);
	
	$answers = $answers.add(this.tpl.text({ text: Q.text }));
	
	return $answers;
}

QuestionApplication.prototype.inputType = function(Q)
{
	var $answers = $([]);
	
	for(var i in Q.answers)
	{
		if (Q.answers[i].date)
			$answers = $answers.add(this.tpl.date({ id: i, name: "question", text: Q.answers[i].text }));
		else
			$answers = $answers.add(this.tpl.input({ id: i, name: "question", text: Q.answers[i].text }));
	}
	
	return $answers;
}

QuestionApplication.prototype.NextStep = function()
{
	$('.error').hide();
	
	if (isset(this.currentQ.method) && isset(this[this.currentQ.method+'_check']))
		var nextQ = this[this.currentQ.method+'_check']();
	else
		var nextQ = this[this.currentQ.type + 'Check']();
		
	if(nextQ)
	{
		this.$prev_button.removeAttr('disabled');
		this.currentQ = nextQ;
		this.ShowQuestion(this.currentQ);
	}
	
	return false;
}

QuestionApplication.prototype.PrevStep = function()
{
	this.$next_button.removeAttr('disabled');
	this.$result_row.hide();
	$('.error').hide();	
	
	if (this.currentQ.parent)
	{
		this.currentQ = this.currentQ.parent;
		this.ShowQuestion(this.currentQ);
	}

	if (!this.currentQ.parent)
	{
		this.$prev_button.attr('disabled', 'disabled');
	}
	
	return false;
}

QuestionApplication.prototype.radioCheck = function()
{
	var $ans = this.$table.find('input[type="radio"]:checked');
	if ($ans.length == 0)
	{
		$('#radio-error').show();
		return false;
	}
	
	return isset(this.currentQ.next) ? this.currentQ.next : this.currentQ.answers[$ans.data('id')].next;
}

QuestionApplication.prototype.inputCheck = function()
{
	var err = false;	
	this.$table.find('input[type="text"]').each(function()
	{
		if (this.value == '')
		{
			err = true;
		}
	});
	
	if (err)
	{
		$('#input-error').show();
		return false;
	}
	
	if (!this.currentQ.next) return false;

	return this.currentQ.next;
}

QuestionApplication.prototype.formula9_bind = function()
{
	var $rooms = this.$table.find('#question-rooms');
	var $other = this.$table.find('#question-el_others').parent();
	$other.attr('id', 'question-el_others-main');
	$other.empty();
	
	$rooms.on('input', $.proxy(function(e)
	{
		e.preventDefault();
		
		var val = $(e.currentTarget).val();
		$(e.currentTarget).val(val.replace(/[^\d]/g, ''));

		val = Number(val);
		
		if (!val) return;
		
		var inputs = '';
		for(var i = 1; i < val; i++)
		{
			inputs += '<input class="controlNumber" type="text" name="question" id="question-el_others-'+i+'"><br>';
		}
		
		$other.empty();
		
		$other.append(inputs);
		
	}, this));
}

QuestionApplication.prototype.formula9_check = function()
{
	var data = {};
	data.rooms = this.$table.find('#question-rooms').val();
	data.peoples_all = this.$table.find('#question-peoples_all').val();
	data.peoples_room = this.$table.find('#question-peoples_room').val();
	data.el_all = this.$table.find('#question-el_all').val();
	data.el = this.$table.find('#question-el').val();
	data.el_others = [];
	
	this.$table.find('#question-el_others-main input').each(function()
	{
		data.el_others.push($(this).val());
	});
	
	this.$result_row.show();
	
	this.result_timeout = setTimeout($.proxy(function()
	{
		if (this.$result.text() == '...')
			this.$result.text()
		else
			this.$result.text(this.$result.text() + '.');
		
	}, this), 300);
	
	Api.Post(this.currentQ.method, data, $.proxy(function(fail, data, jqXHR)
	{
		clearTimeout(this.result_timeout);
		
		if (fail)
		{
			return;
		}
		
		this.$result.text(data.result + ' рублей (тариф Т=1)');
		
	}, this))

	return false;
}

$(function()
{
	window.Api = new ApiClass();
	window.QuestionApp = new QuestionApplication();
});