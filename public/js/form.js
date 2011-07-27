$(document).ready(function()
{	
	jQuery.validator.addMethod("accept", function(value, element, param) {
	  return value.match(new RegExp("." + param + "$"));
	});
	
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
			},
			'user[description]': {
				maxlength: 50
			},
			'user[location]': {
				maxlength: 50
			}
		},
		messages: {
			'user[email]': {
				email: "Please enter your email.",
				required: "Please enter your email."
			},
			'user[name]': {
				required: "Please enter your name."
			},
			'user[description]': {
				maxlength: "Please enter up to 50 characters."
			},
			'user[location]': {
				maxlength: "Please enter up to 50 characters."
			}
		}
	}); // end form-edit-profile.validate

	$("#form-session").validate({
		rules: {
			'session[name]': {
				required: true
			},
			start_hour: {
				digits: true,
				max: 12,
				min: 1,
				required: true
			},
			end_hour: {
				digits: true,
				max: 12,
				min: 1,
				required: true
			},
			start_minute: {
				digits: true,
				max: 59,
				min: 0,
				required: true
			},
			end_minute: {
				digits: true,
				max: 59,
				min: 0,
				required: true
			},
			start_ampm: {
				accept: "[am, pm, AM, PM]",
				required: true
			},
			end_ampm: {
				accept: "[am, pm, AM, PM]",
				required: true
			}
		},
		messages: {
			'session[name]': {
				required: "Please enter a name."
			},
			start_hour: {
				digits: "Please enter the start hour.",
				max: "Please enter the start hour.",
				min: "Please enter the start hour.",
				required: "Please enter the start hour."
			},
			end_hour: {
				digits: "Please enter the end hour.",
				max: "Please enter the end hour.",
				min: "Please enter the end hour.",
				required: "Please enter the end hour."
			},
			start_minute: {
				digits: "Please enter the start minute.",
				max: "Please enter the start minute.",
				min: "Please enter the start minute.",
				required: "Please enter the start minute.",
			},
			end_minute: {
				digits: "Please enter the end minute.",
				max: "Please enter the end minute.",
				min: "Please enter the end minute.",
				required: "Please enter the end minute."
			},
			start_ampm: {
				accept: "Please indicate AM or PM.",
				required: "Please indicate AM or PM."
			},
			end_ampm: {
				accept: "Please indicate AM or PM.",
				required: "Please indicate AM or PM."
			}
		}
	}); // end form-session.validate

	$("#form-activity").validate({
		rules: {
			'activity[name]': {
				required: true
			},
			start_hour: {
				digits: true,
				max: 12,
				min: 1,
				required: true
			},
			end_hour: {
				digits: true,
				max: 12,
				min: 1,
				required: true
			},
			start_minute: {
				digits: true,
				max: 59,
				min: 0,
				required: true
			},
			end_minute: {
				digits: true,
				max: 59,
				min: 0,
				required: true
			},
			start_ampm: {
				accept: "[am, pm, AM, PM]",
				required: true
			},
			end_ampm: {
				accept: "[am, pm, AM, PM]",
				required: true
			}
		},
		messages: {
			'activity[name]': {
				required: "Please enter a name."
			},
			start_hour: {
				digits: "Please enter the start hour.",
				max: "Please enter the start hour.",
				min: "Please enter the start hour.",
				required: "Please enter the start hour."
			},
			end_hour: {
				digits: "Please enter the end hour.",
				max: "Please enter the end hour.",
				min: "Please enter the end hour.",
				required: "Please enter the end hour."
			},
			start_minute: {
				digits: "Please enter the start minute.",
				max: "Please enter the start minute.",
				min: "Please enter the start minute.",
				required: "Please enter the start minute.",
			},
			end_minute: {
				digits: "Please enter the end minute.",
				max: "Please enter the end minute.",
				min: "Please enter the end minute.",
				required: "Please enter the end minute."
			},
			start_ampm: {
				accept: "Please indicate AM or PM.",
				required: "Please indicate AM or PM."
			},
			end_ampm: {
				accept: "Please indicate AM or PM.",
				required: "Please indicate AM or PM."
			}
		}
	}); // end form-activity.validate

	$("#form-question").validate({
		ignore: ':hidden',
		rules: {
			'question[text]': {
				required: true
			},
			'question[type]': {
				required: true
			},
			'question[option1]': {
				required: true
			},
			'question[option2]': {
				required: true
			}
		},
		messages: {
			'question[text]': {
				required: "Please enter a question."
			},
			'question[type]': {
				required: "Please select a question type."
			},
			'question[option1]': {
				required: "Please provide at least two options."
			},
			'question[option2]': {
				required: "Please provide at least two options."
			}
		}
	}); // end form-questions.validate

	$("#question_type").change(function () {
      if ($("#question_type :selected").val() == "select" || $("#question_type :selected").val() == "radio"){
      		$("#question_options").slideDown();
      }
      else{
      	// Hide the form and remove any values entered
      	$("#question_options").slideUp();
      	$("#question_option_1").val("");
      	$("#question_option_2").val("");
      	$("#question_option_3").val("");
      }
		});
});