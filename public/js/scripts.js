$(document).ready(function()
{	
	var f;
	
	$("input.focus-hide").focus(function() {
		f = $(this),
			def = f.val();

    	if (f.val() == def) { 
			f.val("");
    	}
    	
	}).blur(function() {
    
    	if (f.val() == "") { 
			f.val(def);
    	}
    	
	});
	
	$("input, textarea").focus(function() {
		f = $(this);
		
    	f.addClass('active');
	}).blur(function() {
    	f.removeClass('active');
	});
	
	$('.flash').delay(250).slideDown().delay(3000).slideUp();

});