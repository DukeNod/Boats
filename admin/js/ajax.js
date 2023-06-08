//
// (c) 2007 http://www.howard-studio.ru/
// Sergei Vasilyev, nolar@howard-studio.ru
//

var ajax_pool = [];

function ajax (params)
{
	var xmlhttp = null;
	try { xmlhttp = new ActiveXObject('Msxml2.XMLHTTP'   ); } catch (exception1) {
	try { xmlhttp = new ActiveXObject('Microsoft.XMLHTTP'); } catch (exception2) {
	try { xmlhttp = new XMLHttpRequest();                   } catch (exception3) {
	}}}
	if (!xmlhttp) return false;

	if (typeof(params.object) == 'object')
		params.rawtext = JSON.stringify(params.object);
	if (typeof(params.rawtext) == 'undefined')
		params.rawtext = '';

	if (typeof(params.method) != 'string')
		params.method = 'POST';
	else	params.method = params.method.toUpperCase();

	if (typeof(params.url) == 'undefined')
		params.url = '';

	var index = ajax_pool.length;
	ajax_pool[index] = {};
	ajax_pool[index].params  = params;
	ajax_pool[index].xmlhttp = xmlhttp;
	ajax_pool[index].timer   = params.interval ? setInterval('ajax_timer('+index+');', params.interval) : -1;
	ajax_pool[index].count   = 0;

	xmlhttp.open(params.method, params.url, true);
	xmlhttp.onreadystatechange = function() {
		if (params.on_state) params.on_state(params, xmlhttp.readyState);
		if (xmlhttp.readyState == 4)
		{
			if (ajax_pool[index].timer >= 0) clearInterval(ajax_pool[index].timer);
			switch (xmlhttp.status)
			{
				case 200:// ok
				case 304:// not modified
					var response_text = xmlhttp.responseText;

					var pos = response_text.indexOf('<!--CONTENT-ENDS-HERE-->');
					var debug_text    = pos >= 0 ? response_text.substr(   pos) : ''           ;
					var response_text = pos >= 0 ? response_text.substr(0, pos) : response_text;

					if (params.on_debug)
					params.on_debug(params, debug_text, response_text);

					var response_parsed = false;
					if (params.parse_response)
//					try { var response_object = JSON.parse(response_text); response_parsed = true; }
					try { var response_object = eval('('+response_text+')'); response_parsed = true; }
					catch (e) {}

					if (response_parsed && (typeof(response_object) == 'object') && response_object._is_exception_)
                                        {
						if (params.on_exception)
						params.on_exception(params, response_object.text, response_object.id, response_object.type);
                                        } else
                                        if (response_parsed)
                                        {
						if (params.on_success)
						params.on_success(params, response_object);
                                        } else
                                        {
						if (params.on_rawtext)
						params.on_rawtext(params, response_text);
					}
					break;
				default:
					{
						if (params.on_httperror)
						params.on_httperror(params, xmlhttp.statusText, xmlhttp.status);
					}
					break;
			}
			delete xmlhttp;
		}
	};

	if (params.on_start) params.on_start(params, 0, 0);

	xmlhttp.setRequestHeader('Content-type', 'text/plain');
	xmlhttp.setRequestHeader('Content-length', params.rawtext.length);
	xmlhttp.setRequestHeader('Connection', 'close');
	xmlhttp.send(params.rawtext);

	return true;
}

function ajax_timer (index)
{
	var count  = ++(ajax_pool[index].count );
	var params =   (ajax_pool[index].params);
	if (params.timeout && ((count * params.interval) >= params.timeout))
	{
		clearInterval(ajax_pool[index].timer);
		if (params.on_timeout) params.on_timeout(params, count * params.interval, count);
		ajax_pool[index].xmlhttp.onreadystatechange = function(){};
		ajax_pool[index].xmlhttp.abort();
		delete ajax_pool[index].xmlhttp;
		delete ajax_pool[index];
	} else
	{
		if (params.on_timer) params.on_timer(params, count * params.interval, count);
	}
}

function ajax_debug (params, debug_text, response_text)
{
	alert(response_text);
	alert(debug_text);
}

function ajax_elemental_set (params, text)
{
	if (!params.elemental_id) return;
	var elemental = document.getElementById(params.elemental_id);
	if (!elemental) return;
	elemental.innerHTML = '' + text;
	elemental.style.display = (elemental.innerHTML == '') ? 'none' : '';
}

function ajax_elemental_add (params, text)
{
	if (!params.elemental_id) return;
	var elemental = document.getElementById(params.elemental_id);
	if (!elemental) return;
	elemental.innerHTML = '' + elemental.innerHTML + text;
	elemental.style.display = (elemental.innerHTML == '') ? 'none' : '';
}

function ajax_elemental_on_success   (params, response_object) { ajax_elemental_set(params, ''); }
function ajax_elemental_on_rawtext   (params, response_text  ) { ajax_elemental_set(params, ''); }
function ajax_elemental_on_exception (params, text, id, type ) { ajax_elemental_set(params, 'Ошибка: '+text); }
function ajax_elemental_on_httperror (params, text, code     ) { ajax_elemental_set(params, 'Ошибка: HTTP '+code+' '+text); }
function ajax_elemental_on_timeout   (params, time, count    ) { ajax_elemental_set(params, 'Ошибка: Истекло время ожидания ('+(time/1000)+'сек).'); }
function ajax_elemental_on_start     (params, time, count    ) { ajax_elemental_set(params, 'Обращение к серверу.'); }
function ajax_elemental_on_state     (params, state          ) { ajax_elemental_set(params, ajax_state_text(state)); }
function ajax_elemental_on_timer     (params, time, count    ) { ajax_elemental_add(params, '.'); }

function ajax_state_text (state)
{
	switch (state)
	{
		case 0: return 'Инициализация';
		case 1: return 'Ждите...';
		case 2: return 'Запрос отправлен';
		case 3: return 'Получение данных';
		case 4: return 'Операция выполнена';
		default: return 'Статус \'' + state + '\'';
	}
}
