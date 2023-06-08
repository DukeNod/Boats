//
// (a) 2008, nolar@howard-studio.ru, nolar@numeri.net
// (c) 2008, Design Studio HOWARD, http://www.howard-studio.ru/
//
// Module for working with selections and/or caret position inside of input fields.
// Модуль для работы с выделениями и/или текстовым курсором в полях ввода.
//
//
// ВНИМАНИЕ!
// Если элемент не в фокусе, то сохранение тихо не происходит.
// То есть эта штука работает ТОЛЬКО когда элемент в фокусе.
// Фокус ставьте сами где надо; адекватно расставив хандлеры на фокусы.
//
(function ($)
{
	// Расширяем прототип jQuery функциями этого модуля.
	$.fn.extend({

		// Возвращает текущее выделение элемента (если в фокусе), или undefined (если не в фокусе).
		selectionGet: function ()
		{// 'this' is a jQuery of inputs
			var result;
			this.each(function()
			{// 'this' is a single input

				// Автоопределение каким механизмом пользоваться.
				if (typeof document.selection != 'undefined')//IE&Opera
				{
					// ВНИМАНИЕ! Менять только трижды подумав.
					// Очень точно выверенный алгоритм на предмет cross-browser'ности:
					// * IE выезжает вовне <textarea>, не упираясь в границы, когда moveStart()/moveEnd(), но нормально с <input>.
					// * IE не принимает <input> для moveToElementText(), а только <textarea> (ошибка на наверный аргумент).
					// * IE считает что любое выделение !inRange() когда по this.createTextRange(), но нормально когда по moveToElementText().
					// * Opera не умеет проверять inRange() вообще; а то можно было бы юзать для циклов.

					// Получаем textrange выделения и работаем только если элемент в фокусе.
					var sel_range = document.selection.createRange();
					if (sel_range.parentElement() != this) return;

					// Позиции выделения определяем по тому, сколько раз граница (начало или конец)
					// может сдвинуться влево до того как упрётся в начало элемента.
					var end = 0; var start = 0;
					var old_range, tmp_range;

					tmp_range = sel_range.duplicate();
					for (var step = 10000; step; step = Math.floor(step / 10))
					{
						while (tmp_range.parentElement() == this)
						{
							end += step; 
							old_range = tmp_range.duplicate();
							if (Math.abs(tmp_range.moveEnd('character', -step)) < step) break;
						}
						end -= step;
						tmp_range = old_range;
					}

					tmp_range = sel_range.duplicate();
					for (var step = 10000; step; step = Math.floor(step / 10))
					{
						while (tmp_range.parentElement() == this)
						{
							start += step; 
							old_range = tmp_range.duplicate();
							if (Math.abs(tmp_range.moveStart('character', -step)) < step) break;
						}
						start -= step;
						tmp_range = old_range;
					}

//???--					var end   = -1; var tmp_range = sel_range.duplicate(); while (tmp_range.parentElement() == this) { end  ++; if (tmp_range.moveEnd  ('character', -1) == 0) break; }
//???--					var start = -1; var tmp_range = sel_range.duplicate(); while (tmp_range.parentElement() == this) { start++; if (tmp_range.moveStart('character', -1) == 0) break; }

					// Фиксим поведение Oper'ы, которая считает \r как обычный символ.
					if ($.browser.opera)
					{
						var sel_nl_count = sel_range.text.split(/\r/).length - 1;
						var tmp_nl_count = tmp_range.text.split(/\r/).length - 1;
						start -= tmp_nl_count - sel_nl_count;
						end   -= tmp_nl_count;
					}
				} else
				if (typeof this.selectionStart != 'undefined')//FF&Opera
				{
					// С FF всё проще. Он это уже и так умеет.
					var start = this.selectionStart;
					var end   = this.selectionEnd  ;
				} else
				{
					return;//non-false, non-true!
				}

				result = { start: start, end: end };
				return false;//break;
			});
			return result;
		},

		// Устанавливает текущее выделение элемента.
		selectionSet: function (start, end)
		{// 'this' is a jQuery of inputs
			if (typeof start == 'object') { end = start.end; start = start.start; }
			return this.each(function()
			{// 'this' is a single input

				// Автоопределение каким механизмом пользоваться.
				if (typeof this.createTextRange != 'undefined')//IE&Opera
				{
					// Создаём textrange в поле.
					var range = this.createTextRange();

					// Фиксим поведение Oper'ы, которая считает \r как обычный символ.
					if ($.browser.opera)
					{
						var non_nl_value = range.text.replace(/\r/g, '');
						var tmp_nl_count = non_nl_value.substr(0    , end-0    ).split(/\n/).length - 1;
						var sel_nl_count = non_nl_value.substr(start, end-start).split(/\n/).length - 1;
						start += tmp_nl_count - sel_nl_count;
						end   += tmp_nl_count;
					}

					// Позиционируем textrange в поле, и активируем (выбираем) его.
					range.collapse(true);
					range.moveEnd  ('character', end  );
					range.moveStart('character', start);
					range.select();
				} else
				if (typeof this.setSelectionRange != 'undefined')//FF&Opera
				{
					// С FF всё проще. Он это уже и так умеет.
					this.setSelectionRange(start, end);
				} else
				{
					// do nothing here
				}
			});
		},

		//...
		selectionFetch: function (name)
		{// 'this' is a jQuery of inputs
			var result;
			this.each(function()
			{// 'this' is a single input

				// Тихо отсеиваем случаи когда по указанному имени выделение не сохранено.
				if (typeof this.jq_selection       == 'undefined') return;
				if (typeof this.jq_selection[name] == 'undefined') return;

				// Возвращаем первое найденное сохранённое выделение из множества.
				result = this.jq_selection[name];
				return false;//break;
			});
			return result;
		},

		// Сохраняет текущее или указанное выделение по имени, если может его определить.
		selectionSave: function (name)
		{// 'this' is a jQuery of inputs
			return this.each(function()
			{// 'this' is a single input

				// Гарантируем наличие хранилища выделений.
				if (typeof this.jq_selection == 'undefined') this.jq_selection = {};

				// Сохраняем текущее выделение в объект, если оно определяемо.
				var selection = $(this).selectionGet();
				if (selection) this.jq_selection[name] = selection;

				if (selection)
				if ($.debug) $.debug('jquery.selection SAVED '+this.jq_selection[name].start+':'+this.jq_selection[name].end+' TO '+name);//!!!
			});
		},

		// Восстанавливаем выделение по имени, если такое сохранено.
		selectionLoad: function (name)
		{// 'this' is a jQuery of inputs
			return this.each(function()
			{// 'this' is a single input

				// Тихо отсеиваем случаи когда по указанному имени выделение не сохранено.
				if (typeof this.jq_selection       == 'undefined') return;
				if (typeof this.jq_selection[name] == 'undefined') return;

				// Производим выделение.
				$(this).selectionSet(this.jq_selection[name]);

				if ($.debug) $.debug('jquery.selection LOADED '+this.jq_selection[name].start+':'+this.jq_selection[name].end+' FROM '+name);//!!!
			});
		},

		// Стираем сохранённое выделение по имени, если оно сохранено.
		selectionClear: function (name)
		{// 'this' is a jQuery of inputs
			return this.each(function()
			{// 'this' is a single input

				// Тихо отсеиваем случаи когда очищать и удалять нечего.
				if (typeof this.jq_selection       == 'undefined') return;
				if (typeof this.jq_selection[name] == 'undefined') return;

				// Удаляем выделение.
				this.jq_selection[name] = undefined;

				if ($.debug) $.debug('jquery.selection CLEARED '+name);//!!!
			});
		},

		// Сдвигает сохранённое выделение на определённое количество символов в сторону.
		selectionMove: function (name, count)
		{// 'this' is a jQuery of inputs
			return this.each(function()
			{// 'this' is a single input

				// Тихо отсеиваем случаи когда по указанному имени выделение не сохранено.
				if (typeof this.jq_selection       == 'undefined') return;
				if (typeof this.jq_selection[name] == 'undefined') return;

				// Производим сдвиг выделения куда попрошено (может быть и отрицательным числом).
				this.jq_selection[name].start += count;
				this.jq_selection[name].end   += count;

				if ($.debug) $.debug('jquery.selection '+name+' MOVED BY '+count);//!!!
			});
		},
		selectionMoveStart: function (name, count)
		{// 'this' is a jQuery of inputs
			return this.each(function()
			{// 'this' is a single input

				// Тихо отсеиваем случаи когда по указанному имени выделение не сохранено.
				if (typeof this.jq_selection       == 'undefined') return;
				if (typeof this.jq_selection[name] == 'undefined') return;

				// Производим сдвиг выделения куда попрошено (может быть и отрицательным числом).
				this.jq_selection[name].start += count;
			});
		},
		selectionMoveEnd: function (name, count)
		{// 'this' is a jQuery of inputs
			return this.each(function()
			{// 'this' is a single input

				// Тихо отсеиваем случаи когда по указанному имени выделение не сохранено.
				if (typeof this.jq_selection       == 'undefined') return;
				if (typeof this.jq_selection[name] == 'undefined') return;

				// Производим сдвиг выделения куда попрошено (может быть и отрицательным числом).
				this.jq_selection[name].end += count;
			});
		},
		selectionCollapse: function (name, way)
		{// 'this' is a jQuery of inputs
			if (typeof way  == 'undefined') { way = true; }
			return this.each(function()
			{// 'this' is a single input

				// Тихо отсеиваем случаи когда по указанному имени выделение не сохранено.
				if (typeof this.jq_selection       == 'undefined') return;
				if (typeof this.jq_selection[name] == 'undefined') return;

				// Производим коллапс в указанную сторону.
				if (way)
					this.jq_selection[name].end = this.jq_selection[name].start;
				else
					this.jq_selection[name].start = this.jq_selection[name].end;
			});
		},

		// Включение и выключение режима автосохранения выделения при его изменении.
		selectionAutoSaveEnable: function (name)
		{// 'this' is a jQuery of inputs
			return this.selectionSave(name).each(function()
			{// 'this' is a single input
				if (typeof this.jq_selection_autosavenames == 'object')
				{
					// Добавляем новое имя в существующий список имён выделений.
					this.jq_selection_autosavenames.push(name);
				} else
				{
					// Задаём список имёен выделения для сохранения.
					this.jq_selection_autosavenames = [name];

					// Навешиваем обработчик, причём навешиваем только один раз и навсегда.
					$(this).bind('click keyup select', function()
					{// 'this' is a single input
						var input = this;
						var names = this.jq_selection_autosavenames ? this.jq_selection_autosavenames : [];
						$.each(names, function(key, val)
						{
							$(input).selectionSave(val);
							if ($.debug) $.debug('jquery.selection AUTOSAVED FOR '+val);//!!!
						});
					});
				}
			});
		},
		selectionAutoSaveDisable: function (name)
		{// 'this' is a jQuery of inputs
			return this.selectionClear(name).each(function()
			{// 'this' is a single input
				if (typeof this.jq_selection_autosavenames == 'object')
				{
					// Удаляем указанное имя из списка.
					// (Из-за отсутствия indexof() ничего лучше не придумалось чем заново строить массив).
					var new_names = [];
					$.each(this.jq_selection_autosavenames, function(key, val)
					{
						if (val != name) new_names.push(val);
					});
					this.jq_selection_autosavenames = new_names;

					// Снимаем обработчики событий если больше имён для сохранения нет.
					if (!this.jq_selection_autosavenames.length)
					{
						// FOR NOW, do not unbind!
						// $(this).unbind('click keyup select', THAT_NAMED_ROUTINE);
						// this.jq_selection_autosavenames = undefined;
					}
				}
			});
		},

		//
		selectionText: function (name, text)
		{
			if (typeof text == 'undefined')
			{// get-mode (non-chained)
				var result = '';
				this.each(function()
				{
					// Тихо отсеиваем случаи когда по указанному имени выделение не сохранено.
					if (typeof this.jq_selection       == 'undefined') return;
					if (typeof this.jq_selection[name] == 'undefined') return;

					// Получаем текст выделения.
					var start = this.jq_selection[name].start;
					var end   = this.jq_selection[name].end  ;
					result += $(this).val().substr(start, end - start);
				});
				return result;
			} else
			{// set-mode (chained)
				return this.each(function()
				{// 'this' is a single input
	        
					// Тихо отсеиваем случаи когда по указанному имени выделение не сохранено.
					//!!! здесь надо просто добавиьт в конец!!! (если нет выделения) и если режим forced
					if (typeof this.jq_selection       == 'undefined') return;
					if (typeof this.jq_selection[name] == 'undefined') return;

					// Замещаем текст выделения или помещаем текст в курсор.
					var range = this.createTextRange ? this.createTextRange() : undefined;
					var start = this.jq_selection[name].start;
					var end   = this.jq_selection[name].end  ;
					var value = $(this).val();
					var old_text = value.substr(start, end - start);
					var new_text = typeof text == 'function' ? text.apply(this, [old_text]) : text;
	                                this.value = value.substr(0, start) + new_text + value.substr(end);
	                                this.jq_selection[name].end = start + new_text.length;

					if ($.debug) $.debug('jquery.selection SETTEXT '+start+':'+end+' IN '+name);//!!!
				});
			}
		}

	});

})(jQuery);
