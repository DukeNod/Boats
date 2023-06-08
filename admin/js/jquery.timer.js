//
// (a) 2008, nolar@howard-studio.ru, nolar@numeri.net
// (c) 2008, Design Studio HOWARD, http://www.howard-studio.ru/
//
// Module for delayed and periodic executions.
// Модуль для отложенных и периодических выполнений.
//
// Добавляет к jQuery-множеству многоцелевую функцию timer(), которая позволяет выполнять код
// после задержки или периодически через интервалы времени. Задержка или период задаётся
// в миллисекундах; положительное или нулевое значение задаёт однократное задание,
// отрицательное значение - периодическое задание (интервал при этом берётся по модулю).
// Выполняемый код задаётся как callback-функция; она выполняется в контексте каждого
// из элементов, к которым применён (переменная this), то есть по разу на каждый элемент.
//
// Все отложенные и периодические задания хранятся в рамках элементов, для которых они заданы.
// Таким образом, можно давать задание для одного множества элементов, а потом отменять
// или замещать его иным для другого множества или подмножества.
//
// Все задания идентифицируются по своему имени (первый аргумент функции). Повторная установка
// задания с тем же именем отменяет предыдущую, если она была проведена до этого. При этом, если
// новый код не задан, то предыдущее задание всё равно отменяется; так можно просот отменять
// установленные ранее задания (задав только имя задания, и не указан кода).
//
// Примеры:
//	$('.timeable').timer('alerter', 1000, function(){ alert(this.id); });
//	$('#clockdiv').timer('clock', -1000, function(){ this.innerHTML = new Date(); });
//
(function ($)
{
	// Расширяем прототип jQuery функциями этого модуля.
	$.fn.extend({
		timer: function (name, delay, fn, data)
		{// 'this' is a jQuery of elements for which timer should be set or cleared
			return this.each(function()
			{// 'this' is a single element for which timer should be set or cleared

				// Initialize set of per-element timers.
				if (typeof this.jq_timer == 'undefined') this.jq_timer = {};

				// Clear previous timer with that name, if it exists.
				if (typeof this.jq_timer[name] != 'undefined')
				{
					clearInterval(this.jq_timer[name]);
					clearTimeout (this.jq_timer[name]);
					this.jq_timer[name] = undefined;
				}

				// Create new timer with callback, if specified.
				if (fn)
				{
					var context = this;
					this.jq_timer[name] = delay < 0 ?
						setInterval(function()
						{
							fn.apply(context, [data]);
						}, -delay):
						setTimeout(function()
						{
							context.jq_timer[name] = undefined;
							fn.apply(context, [data]);
						}, +delay);
				}

			});
		}
	});

})(jQuery);
