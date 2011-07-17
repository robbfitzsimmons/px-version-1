$(document).ready(function()
{	
	var f;
	
	$("input.focushide").focus(function() {
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
	
	$("input").focus(function() {
		f = $(this);
		
    	f.addClass('active');
	}).blur(function() {
    	f.removeClass('active');
	});
	
});