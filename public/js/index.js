$(document).ready(function()
{
	$("input[type=text]").focus(function() {
		var f = $(this);
    	
    	f.addClass('active');
    	if (f.val() == "name@email.com") { 
			f.val("");
    	}
    	
	});
	
    $("input[type=text]").focusout(function() {
		var f = $(this);
    
    	f.removeClass('active');
    	if (f.val() == "") { 
			f.val("name@email.com");
    	}
    	
	});
	
	$("input[type=password]").focus(function() {
		var f = $(this);

    	f.addClass('active');    
    	if (f.val() == "password") { 
			f.val("");
    	}
    	
	});
	
    $("input[type=password]").focusout(function() {
		var f = $(this);
    
    	f.removeClass('active');
    	if (f.val() == "") { 
			f.val("password");
    	}
    	
	});
});