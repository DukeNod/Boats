function forum_validate (form)
{
	if (form.author   .value == '') { alert("Необходимо указать ваше имя!"); return false; }
	if (form.subject  .value == '') { alert("Необходимо указать тему!"); return false; }
	if (form.gp_answer.value == '') { alert("Необходимо ввести проверочный код!"); return false; }
	return true;
}

function forum_show_form (id)
{
	// If just-clicked message has a reply form already (for Non-JS mode), hide this form and forget about it forever.
	var nonjs_row = document.getElementById('forum_nonjs_row');
	var nonjs_hid = nonjs_row && nonjs_row.style.display != 'none'; 
	if (nonjs_hid) nonjs_row.style.display = 'none';

	// Retrieve subject of the just-clicked message (as string, not as an object!).
	var subject = document.getElementById('forum_subject_of_'+id);
	if (!subject) subject = ''; else subject = subject.innerHTML;

	// Retrieve row of just-clicked message.
	var click_row = document.getElementById('forum_'+id+'_row');
	if (!click_row) return true;

	// Retrieve row of reply form template.
	var reply_row = document.getElementById('forum_reply_row');
	if (!reply_row) return true;

	// Retrieve reply form template itself.
	var reply_form = document.getElementById('forum_reply_form');
	if (!reply_form) return true;

	// Finally, check if some reply form is already positioned after just-clicked row, and hide it if it is so.
	if ((click_row.nextSibling && reply_row && (click_row.nextSibling.id == reply_row.id) && (reply_row.style.display != 'none')) ||
	    (click_row.nextSibling && nonjs_row && (click_row.nextSibling.id == nonjs_row.id) && (nonjs_hid                        )) )
	{
		reply_row.style.display = 'none';
	} else
	// Otherwise, position reply form template after just-clicked row, fill it, decorate it and show it.
	{
		reply_row.style.display = 'none';
			click_row.parentNode.insertBefore(reply_row, click_row.nextSibling);
			reply_row.cells[1].style.paddingLeft = click_row.cells[1].style.paddingLeft;
			reply_form.action = PUB_ROOT + 'forum/send/' + id + '/';
			reply_form.subject.value = generate_forum_subject(subject);
		reply_row.style.display = '';
	}

	return false;
}

function generate_forum_subject (subject)
{
	var replies = 0;

	var pos = 0;
	do
	{
		pos = subject.indexOf('RE: ', pos);
		if (pos != -1)
		{
			replies++;
			subject = subject.substr(0, pos) + subject.substr(pos+4);
		}
	} while (pos != -1);

	var pos1 = 0, pos2 = 0;
	do
	{
		pos1 = subject.indexOf('RE[', pos1);
		pos2 = subject.indexOf(']: ', pos1+1);
		if ((pos1 != -1) && (pos2 != -1))
		{
			var n = parseInt(subject.substr(pos1+3, pos2-pos1+1-3));
			replies += (n > 0) ? n : 0;
			subject = subject.substr(0, pos1) + subject.substr(pos2+3);
		}
	} while ((pos1 != -1) && (pos2 != -1));

	return 'RE[' + (replies+1) + ']: ' + subject;
}
