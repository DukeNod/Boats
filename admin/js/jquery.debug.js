//
// (a) 2008, nolar@howard-studio.ru, nolar@numeri.net
// (c) 2008, Design Studio HOWARD, http://www.howard-studio.ru/
//
(function ($)
{
	// Расширяем статический jQuery функциями этого модуля.
	$.extend({
		debugOptions: { targets: [], filters: [] },

		debugTarget: function (target)
		{
			$.debugOptions.targets = $($.debugOptions.targets).add(target);
		},
		debugFilter: function (filter)
		{
			$.debugOptions.filters.push(filter);
		},

		debug: function (message)
		{// 'this' is a static jQuery (or undefined?)
			var allowed = $.debugOptions.filters.length == 0;
			$.each($.debugOptions.filters, function (key, val)
			{
				var rex = new RegExp(val);
				if (rex.test(message)) allowed = true;
			});

			if (allowed)
			{
				//
				var now = new Date();

				//
				$($.debugOptions.targets).each(function()
				{
					//
					if (typeof this.value != 'undefined')
					{
						this.value += '['+now+'] '+message+"\n";
					} else
					if (typeof this.innerHTML != 'undefined')
					{
						this.innerHTML += "\n"+'<br/>['+now+'] '+message;
					} else
					{
						$(this).append('['+now+'] '+message);
					}

					//
					if (typeof this.scrollTop != 'undefined')
						this.scrollTop = this.scrollHeight;
				});
			}
		}
	});

})(jQuery);
