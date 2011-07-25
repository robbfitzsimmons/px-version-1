$(document).ready(function()
{	
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
	}); // end form-signup.validate


	$("#form-event").validate({
		rules: {
			'event[name]': {
				required: true,
				maxlength: 50
			},
			'event[location]': {
				required: true
			}
		},
		messages: {
			'event[name]': {
				required: "Please enter an event name.",
				maxlength: "Name must be at most 50 characters long."
			},
			'event[location]': {
				required: "Please enter a location."
			}
		}
	}); // end form-event.validate

	$("#form-invites").validate({
		rules: {
			'emails': {
				required: true
			},
			'subject': {
				required: true
			},
			'message': {
				required: true
			}
		},
		messages: {
			'emails': {
				required: "Please enter at least one email."
			},
			'subject': {
				required: "Please enter a subject."
			},
			'message': {
				required: "Please enter a message."
			}
		}
	}); // end form-invites.validate

	$("#form-edit-profile").validate({
		rules: {
			'user[email]': {
				email: true,
				required: true
			},
			'user[name]': {
				required: true
			}
		},
		messages: {
			'user[email]': {
				email: "Please enter your email.",
				required: "Please enter your email."
			},
			'user[name]': {
				required: "Please enter your name."
			}
		}
	}); // end form-edit-profile.validate

});