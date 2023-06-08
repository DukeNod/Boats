//
// (a) 2008, nolar@howard-studio.ru, nolar@numeri.net
// (c) 2008, Design Studio HOWARD, http://www.howard-studio.ru/
//
// Virtual Keyboard module for jQuery.
//
// Example:
//
//	<html><body>
//	<table class="keyboardBox" id="keyboard">
//		<tr>
//			<td class="keyboardKey" colspan="2" rowspan="2">
//				<div class="keyboardKeyText">&nbsp;</div>
//				<div class="keyboardKeyView">NBSP</div>
//				<div class="keyboardKeyHint">No Break SPace</div>
//			</td>
//			<td class="keyboardKey">
//				<div class="keyboardKeyText">&#x00AD;</div>
//				<div class="keyboardKeyView">&#x00AC;</div>
//				<div class="keyboardKeyHint">Soft Hyphen</div>
//			</td>
//		</tr>
//		<tr>
//			<td class="keyboardKey">
//				<div class="keyboardKeyText">&#x2014;</div>
//				<div class="keyboardKeyView">&#x2014;</div>
//				<div class="keyboardKeyHint">Em Dash</div>
//			</td>
//		</tr>
//		<tr>
//			<td class="keyboardKey">
//				<div class="keyboardKeyText">&laquo;&#xFFFC;&raquo;</div>
//				<div class="keyboardKeyView">&laquo;abc&raquo;</div>
//			</td>
//			<td class="keyboardKey">
//				<div class="keyboardKeyText">&bdquo;&#xFFFC;&ldquo;</div>
//				<div class="keyboardKeyView">&bdquo;abc&ldquo;</div>
//			</td>
//			<td class="keyboardKey">
//				<div class="keyboardKeyText">&ldquo;&#xFFFC;&rdquo;</div>
//				<div class="keyboardKeyView">&ldquo;abc&rdquo;</div>
//			</td>
//		</tr>	
//	</table>
//	<script type="text/javascript">
//	$(function(){
//		$('#keyboard').keyboard();
//		$('input, textarea')
//			.focus(function(){ $('#keyboard').keyboardAttach(this); })
//			.blur (function(){ $('#keyboard').keyboardDetach(    ); })
//			;
//	});
//	</script>
//	</body></html>
//
(function ($)
{
	// Расширяем прототип jQuery функциями этого модуля.
	$.fn.extend({

		//
		// Вставка символа и/или обработка фрагмента в поле ввода.
		//
		// Аргумент - текст, который будет вставлен в поле вводе вместо текущего выделения (если там что-то
		// выделено), либо в позицию курсора (если ничего не выделено). Курсор помещается после вставленного
		// текста.
		//
		// Если аргумент содержит unicode-символ xFFFC (object replacement character), то он замещается
		// текстом выделения в этом поле ввода (если что-то выделено), либо пустой строкой (если ничего не выделено).
		//
		// ВНИМАНИЕ! В любом случае, функция помещает фокус ввода в каждое из полей ввода из соответствующего jQuery,
		// провоцируя вызов всех обработчиков событий blur/focus для всех задействованных полей, в том числе blur того,
		// которое активно в момент вызова функции, даже если оно не находится в соответствующем jQuery.
		// Всё это очень важно, если визуальное поведение клавиатуры привязано к событиям фокусировки полей ввода.
		// В таком случае все blur нужно выполнять с задержкой, с обязательно проверкой что произошло сразу после blur
		// (фокус ушёл к другому полю ввода насовсем, либо фокус ушёл в целях вставки символа в другое поле ввода,
		// либо фокус временно ушёл при нажатии на кнопку клавиатуры, либо ещё чего).
		// Фокус ввода важно перемещать в поле ввода, потому что иначе браузер может вернуть "не то" выделение (range),
		// в том числе и выделение простого текста, вне всех полей ввода (зависи от браузера).
		//
		// Пример 1. Помещаем неразрывный пробел во всех поля ввода на странице.
		//	$('input, textarea').keypaste('\u00A0');
		//
		// Пример 2. Обрамляем круглыми скобками выделение в поле ввода по его идентификатору.
		//	$('#megatext').keypaste('(\uFFFC)');
		//
		keypaste: function (text)
		{ // 'this' is a jQuery of inputs
			this.each(function()
			{// 'this' is a single input

				$(this)
//				.selectionSave('jquery.keyboard')
				.focus()
				.selectionText('jquery.keyboard', function(s){ return text.replace('\ufffc', s); })
				.selectionCollapse('jquery.keyboard', false)
				.selectionLoad('jquery.keyboard')
				.trigger('keypress')
				;
			});
			return this;
		},

		//
		// Инициализация элемента-контейнера, чтобы он работал в роли клавиатуры.
		//
		// Навешивает события на сам элемент и на дочерние элементы в зависимости от их назначения.
		// Инициализирует поля DOM-элемента, нужные для этого модуля при его дальнейшей работе.
		//
		// Функционал клаватуры, реализуемый в модуле, ограничивается только этим:
		// * Парсинг клавиатуры и кнопок на функциональные части, вычленение текстов, функций обработки, хинтов и т.п.
		// * Генерация внешних событий для клавиатурного DOM-элемента в разных ситуациях.
		// * Управление привязкой полей вводе к клавиатуре (привязывание и отвязывание).
		// * Небольшая защита от чрезмерного срабатывания focus/blur событий во время работы.
		// * Отлов нажатия на кнопки клавиатуры и вставка/обработка текста в привязанных к этой клавиатуре полях ввода.
		// * Своевременное и неизбыточное сохранение вспомогательных данных; например, SavedRange (см. выше).
		// * Показ хинта для клавиш во внутреннем поле для хинтов (при его наличии).
		//
		keyboard: function (params)
		{// 'this' is a jQuery of keyboard boxes

			// Заполняем параметры дефолтными значениями.
			if (typeof params != 'object') { params = []; }
			params = $.extend({
				selectorOfKey		: '.keyboardKey',
				selectorOfKeyText	: '.keyboardKeyText',
				selectorOfKeyView	: '.keyboardKeyView',
				selectorOfKeyHint	: '.keyboardKeyHint',
				selectorOfKeyHkey	: '.keyboardKeyHkey',
				selectorOfHint		: '.keyboardHint',
				hintDefault		: '\u00A0',//nbsp
				hintAbsent		: '\u00A0',//nbsp
				dummy			: undefined// just for source code beauty
			}, params);

			// Инициализируем DOM-элементы и навешиваем события на все клавиатуры.
			$(this)
			.each(function()
			{// 'this' is a keyboard box
				var keyboard = this;
				$(params.selectorOfKey, this).each(function(){ this.keyboard = keyboard; });
			})
			;

			// Инициализируем DOM-элементы и навешиваем события на поля подсказок всех клавиатур.
			$(params.selectorOfHint, this).html(params.hintDefault);

			// Инициализируем DOM-элементы и навешиваем события на кнопки всех клавиатур.
 			$(params.selectorOfKey, this)
 			.each(function()
 			{// 'this' is a keyboard key
				var key = this;
				var hkey = $(params.selectorOfKeyHkey, this).text();
				if (hkey != '') if ($.hotkeys) $.hotkeys.add(hkey, { disableInInput: false }, function() { $(key).click(); });
			})
			.bind('mouseover', function()
			{// 'this' is a keyboard key
				var hint = $(params.selectorOfKeyHint, this).html();
				if (hint == '') hint = params.hintAbsent;

				$(params.selectorOfHint, this.keyboard).html(hint);

				var data = { params: params, keyboard: this.keyboard, key: this, hint: hint };
				$(this.keyboard).trigger('keyboardHintShow', [data]);
			})
			.bind('mouseout', function()
			{// 'this' is a keyboard key
				var hint = params.hintDefault;

				$(params.selectorOfHint, this.keyboard).html(hint);

				var data = { params: params, keyboard: this.keyboard, key: this, hint: hint };
				$(this.keyboard).trigger('keyboardHintHide', [data]);
			})
			.bind('mousedown', function()
			{
				// Freezing againts 'blur' event in IE&FF (occurs just after mousedown outside of input).
				$(this.keyboard).keyboardFreeze();
			})
			.bind('click', function()
			{// 'this' is a keyboard key

				// Freezing against 'focus' event (occurs while pasting in Opera or right after pasting in IE&FF).
				$(this.keyboard).keyboardFreeze();

				var text = $(params.selectorOfKeyText, this).html();

				$(this.keyboard.keyboardTargets ? this.keyboard.keyboardTargets : []).keypaste(text);

				var data = { params: params, keyboard: this.keyboard, key: this, text: text };
				$(this.keyboard).trigger('keyboardKeyClick', [data]);
			})
			;

			// Возвращаем исходный jQuery.
			return this;
		},

		//
		// Устанавливает или сбрасывает привязку полей ввода к клавиатуре.
		// Вызывать нужно для клавиатуры, поля ввода передавать аргументом.
		// Для отвязывания просто не передавать аргумента или передать пустой массив/jQuery.
		//
		// Привязка заключается в том, что поле вводе запоминается в клавиатуре, и в дальнейшем нажатия на её кнопки
		// будут помещать/обрабатывать текст в привязанном поле ввода. Кроме того, на привязанное поле ввода
		// динамически навешиваются вспомогательные обработчики событий (например, SaveRange; см. выше).
		//
		// Перепривязка работает самым непосредственным образом: отвязываются все текущие привязанные поля,
		// и потом привязываются новые. Проверка на то, не находится ли поле в обоих списках, не осуществляется.
		//
		// Никаких внешних событий не генерирует.
		//
		keyboardTarget: function (inputs)
		{// 'this' is a jQuery of keyboard boxes
			if (!inputs) inputs = [];
			this.each(function()
			{// 'this' is a keyboard box
				var keyboard = this;

				$(this.keyboardTargets ? this.keyboardTargets : [])
				.selectionAutoSaveDisable('jquery.keyboard');

				this.keyboardTargets = $(inputs ? inputs : []);

				$(this.keyboardTargets ? this.keyboardTargets : [])
				.selectionAutoSaveEnable('jquery.keyboard');
			});
			return this;
		},

		//
		// Привязывает (attach) или отвязывает (detach) поле ввода к клавиатуре, с задержкой.
		// Вызывать нужно для клавиатуры, поля ввода передавать аргументом.
		//
		// О привязке описано выше в keyboardTarget(). А задержка нужно чтобы отлавливать неприятные
		// ситуации, когда поведение клавиатуры завязано на события фокуса полей ввода; проблема возникает из-за того,
		// что клавиатура сама провоцирует изменения фокуса (при вставке текста), равно как изменения фокуса
		// происходят и по вине браузера (при клике на кнопке фокус поля ввода теряется по определению),
		// а клавиатура при всём при этом норовит отцепиться от поля ввода и в итоге не вводит в него символы).
		//
		// Задержка откладывает реальное отцепление и генерацию событий на небольшой интервал (~0ms),
		// за который успевает произойти другое событие, отменяющее отцепление (mousedown на кнопке клавиатуры
		// или переход в другое поле). Тем же приёмом происходит отличение нового прицепления от переприцепления.
		//
		// В принципе, достаточно и задержки 0, которая по сути откладывает выполнение функции на момент сразу после
		// завершения всех нынешних событий (они уже успевают отменить таймер). Но при желании с помощью этой задержки
		// можно создават и визуальные эффекты (latency).
		//
		keyboardAttach: function (delay, targets)
		{// 'this' is a jQuery of keyboard boxes
			if (typeof targets == 'undefined') { targets = delay; delay = undefined; }
			if (typeof delay   == 'undefined') { delay = 0; }
			this.each(function()
			{// 'this' is a keyboard box
				var keyboard = this;
				if (keyboard.keyboardFreezed) return;
				if (keyboard.keyboardTimeout) clearTimeout(keyboard.keyboardTimeout);
				keyboard.keyboardTimeout = setTimeout(function()
				{// 'this' is undefined
					keyboard.keyboardTimer = undefined;
					var retached = keyboard.keyboardTargets && keyboard.keyboardTargets.length;
					$(keyboard).keyboardTarget(targets);
					$(keyboard.keyboardTargets).each(function()
					{// 'this' is a keyboard target
						var target = this;
						$(keyboard).triggerHandler(retached ? 'keyboardRetached' : 'keyboardAttached', [target]);
					});
				}, delay);
			});
			return this;
		},
		keyboardDetach: function (delay)
		{// 'this' is a jQuery of keyboard boxes
			if (typeof delay == 'undefined') { delay = 0; }
			this.each(function()
			{// 'this' is a keyboard box
				var keyboard = this;

				if (keyboard.keyboardFreezed) return;
				if (keyboard.keyboardTimeout) clearTimeout(keyboard.keyboardTimeout);
				keyboard.keyboardTimeout = setTimeout(function()
				{// 'this' is undefined
					keyboard.keyboardTimer = undefined;
					$(keyboard.keyboardTargets).each(function()
					{// 'this' is a keyboard target
						var target = this;
						$(keyboard).triggerHandler('keyboardDetached', [target]);
					});
					$(keyboard).keyboardTarget();
				}, delay);
			});
			return this;
		},

		//
		// Отменяет задержанную реакцию (из attach/detach выше) и запрещает установку новой реакции.
		// Вызывать этот метод не нужно. Он сугубо внутримодульный, и доступен наружу просто на всякий случай.
		//
		// Нужно для борьбы с focus/blur событиями в двух случаях:
		// 1. Когда нажимаем на кнопку клавиатуры, фокус уходит из поля ввода, и поле ввода генерирует detach.
		// 2. Когда при вставке текста в поле ввода вызывается focus(), он генерирует событие, а оно - лишний attach.
		//
		// Клавиатура сама устанавливает запрет на attach/detach в тех местах, где они вызывают проблемы.
		// Это не влияет на те же самые реакции и методы, когда они не вызывают проблем. Иными словами,
		// клавиатура сама обеспечивает work-around'ы касательно проблем с фокусами полей ввода.
		//
		keyboardFreeze: function (delay)
		{// 'this' is a jQuery of keyboard boxes

			// Delay of zero seconds is enough by default, because such a timer will trigger
			// after all focus/blur events, with which we are fighting here.
			if (typeof delay == 'undefined') { delay = 0; }

			//
			this.each(function()
			{// 'this' is a keyboard box
				var keyboard = this;

				// Clearing previous delayed routine if it was set.
				if (keyboard.keyboardFreezer) clearTimeout(keyboard.keyboardFreezer);

				// Setting new delayed routine for unfreezing.
				keyboard.keyboardFreezer = setTimeout(function()
				{
					keyboard.keyboardFreezer = undefined;
					keyboard.keyboardFreezed = undefined;
				}, delay);

				// Finally, freezing this keyboard againt attaches/detaches,
				// and clearing attach/detach timeout if it is set.
				if (this.keyboardTimeout) clearTimeout(this.keyboardTimeout);
				this.keyboardTimeout = undefined;
				this.keyboardFreezed = true;
			});
			return this;
		}

	});

})(jQuery);
