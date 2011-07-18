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
	
	$("input").focus(function() {
		f = $(this);
		
    	f.addClass('active');
	}).blur(function() {
    	f.removeClass('active');
	});

	
	// a custom method making the default value invalid, without displaying the "invalid url" message
	jQuery.validator.addMethod("defaultInvalid", function(value, element) {
		return value != element.defaultValue;
	}, "Please enter your name.");

	$("#form-signup").validate({
		rules: {
			'user[email]': {
				email: true,
				required: true
			},
			'user[password]': {
				minlength: 6,
				required: true
			},
			passwordconf: {
                equalTo: "#password",
				minlength: 6,
				required: true
			},
			'user[name]': {
				required: true
			},
			terms: {
				required: true
			}
		},
		messages: {
			'user[email]': {
				email: "Please enter your email.",
				required: "Please enter your email."
			},
			'user[password]': {
				minlength: "Password must be at least 6 characters long.",
				required: "Please enter a password."
			},
			passwordconf: {
				equalTo: "These passwords don't match.",
				minlength: "Password must be at least 6 characters long.",
				required: "Please re-enter your password."
			},
			'user[name]': {
				required: "Please enter your name."
			},
			terms: {
				required: "You must agree to the terms."
			}
		}
	
	});

});