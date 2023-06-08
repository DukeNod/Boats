function set_input_validations()
{
	$('input[data-inputmask-regex]').inputmask();
}

$(function()
{
	Inputmask.extendDefaults({ showMaskOnHover:false, showMaskOnFocus:false, placeholder:"" });
	set_input_validations();
});