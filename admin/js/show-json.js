function convertQ(Q)
{
	var html = '';
	
	if (Q.type == 'radio')
	{
		html += '<h3><span>Заголовок:</span> '+Q.question+'</h3>';
		html += '<h4>Тип:</h4> вопрос<br/>';
		html += '<h4>Ответы:</h4><br>';
	}
	else if (Q.type == 'text')
	{
		html += '<h3><span>Заголовок:</span></h3>';
		html += '<h4>Тип:</h4> сообщение<br/>';
		html += '<h4>Текст</h4>: '+Q.text;
	}
	else
	{
		html += '<h3><span>Заголовок:</span> '+Q.question+'</h3>';
		html += '<h4>Тип:</h4> форма<br/>';
		if (Q.method) html += '<h4>Метод:</h4> '+Q.method+'<br/>';
		if (Q.return) html += '<h4>Результат:</h4> '+Q.return+'<br/>';
		if (Q.hint) html += '<h4>Подсказка:</h4> '+Q.hint+'<br/>';
		html += '<h4>Поля</h4>:<br>';
	}

	if (Q.answers)
	{
		html += '<ul>';
		for(var i in Q.answers)
		{
			var a = Q.answers[i]
			html += '<li>';
			html += a.text;
			if (a.type)
				html += ' (<h4>Тип</h4>: '+a.type+')';
				
			if (a.name)
				html += ' ('+a.name+')';
				
			if (a.next)
			{
				html += '<ul><li>';
				html += convertQ(a.next);
				html += '</li></ul>';
			}
			
			html += '</li>';
		}
		html += '</ul>';
	}
	
	
	if (Q.next)
	{
		if (Q.type != 'radio')
			html += '<ul>';
		html += '<li>';
		html += convertQ(Q.next);
		html += '</li>';
		if (Q.type != 'radio')
			html += '</ul>';
	}
	
	return html;
}

$(function()
{
	console.log(JSONView(Questions));
	$('#result').html(convertQ(Questions));
});
