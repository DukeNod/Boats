//
// (a) 2008, nolar@howard-studio.ru, nolar@numeri.net
// (c) 2008, Design Studio HOWARD, http://www.howard-studio.ru/
//
//
//
(function ($)
{
	// Используется как обработчик всех событий, изменяющих значение поля, в режиме видимости скрытого текста.
	var handlerForAnyChange = function (event)
	{
		$(this).timer('jquery.hiddentext', 0, function () { $(this).hiddentextEncode(); });
	};

	// Расширяем основной объект jQuery функциями этого модуля.
	$.extend({
		hiddentextMap:
		{
			'\u00A0': '\u00BA',
			'\u00AD': '\u00AC'
//			' '     : '\u00B7\u200B'//'-'
//			'-- '   : '\u2014 '
		},
		hiddentextEncode: function (s)
		{
			var forward = this.hiddentextMap;
//			var reverse = {}; $.each(forward, function(key, val) { reverse[val] = key; });
			var map = forward;

			var keys = []; $.each(map, function (key, val) { keys.push(key); });
			var regx = '('+keys.join(')|(')+')';

			return s.replace(new RegExp(regx, 'g'), function(s){ return map[s] ? map[s] : s; });
		},
		hiddentextDecode: function (s)
		{
			var forward = this.hiddentextMap;
			var reverse = {}; $.each(forward, function(key, val) { reverse[val] = key; });
			var map = reverse;

			var keys = []; $.each(map, function (key, val) { keys.push(key); });
			var regx = '('+keys.join(')|(')+')';

			return s.replace(new RegExp(regx, 'g'), function(s){ return map[s] ? map[s] : s; });
		}

	});

	// Расширяем прототип jQuery функциями этого модуля.
	$.fn.extend({

		//
		//
		//
		hiddentextEncode: function (force)
		{// 'this' is a jQuery of inputs
			return this.each(function()
			{// 'this' is a single input

				var old_value = this.value;
				var new_value = $.hiddentextEncode(old_value);

				var selection = $(this).selectionFetch('jquery.hiddentext') || $(this).selectionGet('jquery.hiddentext');
				var old1 = !selection ? '' : old_value.substr(0, selection.start);
				var old2 = !selection ? '' : old_value.substr(selection.start, selection.end - selection.start);
				var old3 = !selection ? '' : old_value.substr(selection.end);
				var new1 = !selection ? '' : $.hiddentextEncode(old1);
				var new2 = !selection ? '' : $.hiddentextEncode(old2);
				var new3 = !selection ? '' : $.hiddentextEncode(old3);

				if (force || old_value != new_value)
				{
					$(this)
					.selectionClear('jquery.hiddentext')
					.selectionSave ('jquery.hiddentext')
					.val(new_value)
					.selectionMoveEnd  ('jquery.hiddentext', new1.length - old1.length + new2.length - old2.length)
					.selectionMoveStart('jquery.hiddentext', new1.length - old1.length)
					.selectionLoad ('jquery.hiddentext')
					.selectionClear('jquery.hiddentext')
					;
				}
			});
		},
		hiddentextDecode: function (force)
		{// 'this' is a jQuery of inputs
			return this.each(function()
			{// 'this' is a single input

				var old_value = this.value;
				var new_value = $.hiddentextDecode(old_value);

				var selection = $(this).selectionFetch('jquery.hiddentext') || $(this).selectionGet('jquery.hiddentext');
				var old1 = !selection ? '' : old_value.substr(0, selection.start);
				var old2 = !selection ? '' : old_value.substr(selection.start, selection.end - selection.start);
				var old3 = !selection ? '' : old_value.substr(selection.end);
				var new1 = !selection ? '' : $.hiddentextDecode(old1);
				var new2 = !selection ? '' : $.hiddentextDecode(old2);
				var new3 = !selection ? '' : $.hiddentextDecode(old3);

				if (force || old_value != new_value)
				{
					$(this)
					.selectionClear('jquery.hiddentext')
					.selectionSave ('jquery.hiddentext')
					.val(new_value)
					.selectionMoveEnd  ('jquery.hiddentext', new1.length - old1.length + new2.length - old2.length)
					.selectionMoveStart('jquery.hiddentext', new1.length - old1.length)
					.selectionLoad ('jquery.hiddentext')
					.selectionClear('jquery.hiddentext')
					;
				}
			});
		},

		//
		//
		//
		hiddentextShow: function ()
		{// 'this' is jQuery of inputs
			return this
			.hiddentextEncode()
			.bind('change keypress cut paste delete', handlerForAnyChange)
			;
		},
		hiddentextHide: function ()
		{// 'this' is jQuery of inputs
			return this
			.unbind('change keypress cut paste delete', handlerForAnyChange)
			.timer('jquery.hiddentext')
			.hiddentextDecode()
			;
		},
		hiddentext: function (show)
		{// 'this' is jQuery of inputs
			return show ? this.hiddentextShow() : this.hiddentextHide();
		}
	});

})(jQuery);
