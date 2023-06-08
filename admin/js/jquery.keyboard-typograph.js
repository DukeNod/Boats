//
// (a) 2008, nolar@howard-studio.ru, nolar@numeri.net
// (c) 2008, Design Studio HOWARD, http://www.howard-studio.ru/
//
(function ($)
{
	$.extend({

		keyboardCreateTypograph: function()
		{ // 'this' is a jQuery of inputs
			return $(""+
			"<div class='keyboard'>"+
			"<table class='keyboardBox'>"+
			"<tr>"+
				"<td class='keyboardKey' colspan='2' rowspan='2'>"+
					"<div class='keyboardKeyText'>&#x00A0;</div>"+
					"<div class='keyboardKeyView'>NBSP</div>"+
					"<div class='keyboardKeyHint'>Неразрывный пробел (<div class='keyboardKeyHkey'>Ctrl+Shift+Space</div>)</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x00D7;</div>"+
					"<div class='keyboardKeyView'>&#x00D7;</div>"+
					"<div class='keyboardKeyHint'>Умножение</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x00B1;</div>"+
					"<div class='keyboardKeyView'>&#x00B1;</div>"+
					"<div class='keyboardKeyHint'>Плюс-минус</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x00B0;</div>"+
					"<div class='keyboardKeyView'>&#x00B0;</div>"+
					"<div class='keyboardKeyHint'>Градус</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#216;</div>"+
					"<div class='keyboardKeyView'>&#216;</div>"+
					"<div class='keyboardKeyHint'>Диаметр</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#185;</div>"+
					"<div class='keyboardKeyView'>&#185;</div>"+
					"<div class='keyboardKeyHint'>Верхний индекс 1</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#178;</div>"+
					"<div class='keyboardKeyView'>&#178;</div>"+
					"<div class='keyboardKeyHint'>Верхний индекс 2</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#179;</div>"+
					"<div class='keyboardKeyView'>&#179;</div>"+
					"<div class='keyboardKeyHint'>Верхний индекс 3</div>"+
				"</td>"+
			"</tr>"+
			"<tr>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x0462;</div>"+
					"<div class='keyboardKeyView'>&#x0462;</div>"+
					"<div class='keyboardKeyHint'>Ять прописной</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x0463;</div>"+
					"<div class='keyboardKeyView'>&#x0463;</div>"+
					"<div class='keyboardKeyHint'>Ять строчный</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x00A9;</div>"+
					"<div class='keyboardKeyView'>&#x00A9;</div>"+
					"<div class='keyboardKeyHint'>Copyright</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x00AE;</div>"+
					"<div class='keyboardKeyView'>&#x00AE;</div>"+
					"<div class='keyboardKeyHint'>Registered</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x2122;</div>"+
					"<div class='keyboardKeyView'>&#x2122;</div>"+
					"<div class='keyboardKeyHint'>Trade Mark</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x0024;</div>"+
					"<div class='keyboardKeyView'>&#x0024;</div>"+
					"<div class='keyboardKeyHint'>Доллар</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x00A3;</div>"+
					"<div class='keyboardKeyView'>&#x00A3;</div>"+
					"<div class='keyboardKeyHint'>Фунт</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x20AC;</div>"+
					"<div class='keyboardKeyView'>&#x20AC;</div>"+
					"<div class='keyboardKeyHint'>Евро</div>"+
				"</td>"+
			"</tr>"+
			"<tr>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x00AD;</div>"+
					"<div class='keyboardKeyView'>&#x00AC;</div>"+
					"<div class='keyboardKeyHint'>Мягкий перенос</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x002D;</div>"+
					"<div class='keyboardKeyView'>&#x002D;</div>"+
					"<div class='keyboardKeyHint'>Минус</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x2010;</div>"+
					"<div class='keyboardKeyView'>&#x2010;</div>"+
					"<div class='keyboardKeyHint'>Дефис</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x2011;</div>"+
					"<div class='keyboardKeyView'>&#x2011;</div>"+
					"<div class='keyboardKeyHint'>Неразрывный дефис</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x2013;</div>"+
					"<div class='keyboardKeyView'>&#x2013;</div>"+
					"<div class='keyboardKeyHint'>Короткое тире</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x2014;</div>"+
					"<div class='keyboardKeyView'>&#x2014;</div>"+
					"<div class='keyboardKeyHint'>Длинное тире (<div class='keyboardKeyHkey'>Ctrl+Shift+=</div>)</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x2015;</div>"+
					"<div class='keyboardKeyView'>&#x2015;</div>"+
					"<div class='keyboardKeyHint'>Горизонтальная полоска</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x2026;</div>"+
					"<div class='keyboardKeyView'>&#x2026;</div>"+
					"<div class='keyboardKeyHint'>Троеточие</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x2009;</div>"+
					"<div class='keyboardKeyView'>&#x2009;</div>"+
					"<div class='keyboardKeyHint'>Тонкая шпация(разрывная)</div>"+
				"</td>"+
			"</tr>"+
			"<tr>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x00AB;</div>"+
					"<div class='keyboardKeyView'>&#x00AB;</div>"+
					"<div class='keyboardKeyHint'>Левые кавычки-ёлочки</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x00BB;</div>"+
					"<div class='keyboardKeyView'>&#x00BB;</div>"+
					"<div class='keyboardKeyHint'>Правые кавычки-ёлочки</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x2039;</div>"+
					"<div class='keyboardKeyView'>&#x2039;</div>"+
					"<div class='keyboardKeyHint'>Левая одинарная угловая</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x203A;</div>"+
					"<div class='keyboardKeyView'>&#x203A;</div>"+
					"<div class='keyboardKeyHint'>Правая одинарная угловая</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x2018;</div>"+
					"<div class='keyboardKeyView'>&#x2018;</div>"+
					"<div class='keyboardKeyHint'>Левый верхний кавычк</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x2019;</div>"+
					"<div class='keyboardKeyView'>&#x2019;</div>"+
					"<div class='keyboardKeyHint'>Правый верхний кавычк</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x201A;</div>"+
					"<div class='keyboardKeyView'>&#x201A;</div>"+
					"<div class='keyboardKeyHint'>Нижний одинарный кавычк</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x201B;</div>"+
					"<div class='keyboardKeyView'>&#x201B;</div>"+
					"<div class='keyboardKeyHint'>Верхний одинарный кавычк</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x201C;</div>"+
					"<div class='keyboardKeyView'>&#x201C;</div>"+
					"<div class='keyboardKeyHint'>Левая кавычка</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x201D;</div>"+
					"<div class='keyboardKeyView'>&#x201D;</div>"+
					"<div class='keyboardKeyHint'>Правая кавычка</div>"+
				"</td>"+
				"<td class='keyboardKey'>"+
					"<div class='keyboardKeyText'>&#x201E;</div>"+
					"<div class='keyboardKeyView'>&#x201E;</div>"+
					"<div class='keyboardKeyHint'>Нижняя кавычка</div>"+
				"</td>"+
			"</tr>"+
			"<tr>"+
				"<td class='keyboardKey' colspan='2'>"+
					"<div class='keyboardKeyText'>&#x00AB;&#xFFFC;&#x00BB;</div>"+
					"<div class='keyboardKeyView'>&#x00AB;абв&#x00BB;</div>"+
				"</td>"+
				"<td class='keyboardKey' colspan='2'>"+
					"<div class='keyboardKeyText'>&#x2039;&#xFFFC;&#x203A;</div>"+
					"<div class='keyboardKeyView'>&#x2039;абв&#x203A;</div>"+
				"</td>"+
				"<td class='keyboardKey' colspan='2'>"+
					"<div class='keyboardKeyText'>&#x201E;&#xFFFC;&#x201C;</div>"+
					"<div class='keyboardKeyView'>&#x201E;абв&#x201C;</div>"+
				"</td>"+
				"<td class='keyboardKey' colspan='2'>"+
					"<div class='keyboardKeyText'>&#x201C;&#xFFFC;&#x201D;</div>"+
					"<div class='keyboardKeyView'>&#x201C;abc&#x201D;</div>"+
				"</td>"+
				"<td class='keyboardKey' colspan='2'>"+
					"<div class='keyboardKeyText'><br></div>"+
					"<div class='keyboardKeyView'>&lt;br&gt;</div>"+
					"<div class='keyboardKeyHint'>Тег переноса строки</div>"+
				"</td>"+
			"</tr>"+
			"<tr>"+
				"<td class='keyboardKey' colspan='3'>"+
					"<div class='keyboardKeyText'><p>&#xFFFC;</p></div>"+
					"<div class='keyboardKeyView'>&lt;p&gt;abc&lt;/p&gt;</div>"+
				"</td>"+
				"<td class='keyboardKey' colspan='3'>"+
					"<div class='keyboardKeyText'><a href=\"\">&#xFFFC;</a></div>"+
					"<div class='keyboardKeyView'>&lt;a&gt;abc&lt;/a&gt;</div>"+
				"</td>"+
				"<td class='keyboardKey' colspan='3'>"+
					"<div class='keyboardKeyText'><i>&#xFFFC;</i></div>"+
					"<div class='keyboardKeyView'>&lt;i&gt;abc&lt;/i&gt;</div>"+
				"</td>"+
			"</tr>"+
			"<tr>"+
				"<td class='keyboardKey' colspan='6'>"+
					"<div class='keyboardKeyText'><strong>&#xFFFC;</strong></div>"+
					"<div class='keyboardKeyView'>&lt;strong&gt;abc&lt;/strong&gt;</div>"+
				"</td>"+
				"<td class='keyboardKey' colspan='3'>"+
					"<div class='keyboardKeyText'><b>&#xFFFC;</b></div>"+
					"<div class='keyboardKeyView'>&lt;b&gt;abc&lt;/b&gt;</div>"+
				"</td>"+
			"</tr>"+
			"<tr><td class='keyboardHint' colspan='11'></td></tr>"+
			"</table>"+
			"</div>"+
			"");
		}

	});

})(jQuery);
