$(document).ready(function()
{
	var warning = false;
	var modal_active = false;

	/* Homepage */
	$('a.learn-more').click(function() {
		lm = $('#learn-more').offset();
		$("html, body").animate({scrollTop:lm.top-119}, 500, "swing");
	});
	
	$('a.sign-up').click(function() {
		su = $('#sign-up').offset();
		$("html, body").animate({scrollTop:su.top-119}, 500, "swing");
	});
	
	$('a#log-in-link').click(function() {
		li = $('#log-in').offset();
		$("html, body").animate({scrollTop:li.top-119}, 500, "swing");
	});
	
	$('a.say-hello').click(function() {
		sh = $('#say-hello').offset();
		$("html, body").animate({scrollTop:sh.top-119}, 500, "swing");
	});
	
	/* Hide default input values on focus */
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
	$("input, textarea").not("#interests").not("#organizations").focus(function() {
		f = $(this);
		f.addClass('active');
	}).blur(function() {
		f = $(this);
		f.removeClass('active');
	});
	
	/* Error messages */
	$('.flash').delay(250).slideDown().delay(5000).slideUp();
	
	/* Events filter */
	$('#filter-all').click(function () {
		$('.all').slideDown();
		$(this).parent().parent().find('a').removeClass('filtered');
		$(this).addClass('filtered');
	});
	$('#filter-attendee').click(function () {
		$('.all').not('.attendee').slideUp();
		$('.attendee').slideDown();
		$(this).parent().parent().find('a').removeClass('filtered');
		$(this).addClass('filtered');
	});
	$('#filter-admin').click(function () {
		$('.all').not('.admin').slideUp();
		$('.admin').slideDown();
		$(this).parent().parent().find('a').removeClass('filtered');
		$(this).addClass('filtered');
	});
	$('#filter-invited').click(function () {
		$('.all').not('.invited').slideUp();
		$('.invited').slideDown();
		$(this).parent().parent().find('a').removeClass('filtered');
		$(this).addClass('filtered');
	});
	$('#filter-declined').click(function () {
		$('.all').not('.declined').slideUp();
		$('.declined').slideDown();
		$(this).parent().parent().find('a').removeClass('filtered');
		$(this).addClass('filtered');
	});
	$('#filter-past').click(function () {
		$('.all').not('.past').slideUp();
		$('.past').slideDown();
		$(this).parent().parent().find('a').removeClass('filtered');
		$(this).addClass('filtered');
	});
	
	/* Drop Down */
	$('#dashboard-nav ul > li').hover(function () {
		// if there are notifications
		if ($(this).find('a').html() != "0") {
			$(this).find('.level-2').dequeue().show();
		}
	}, function(){
		$(this).find('.level-2').dequeue().hide();	
	});

	$('input').bind('change', function() { 
		warning = true;
	});

	$('#organizations_tagsinput, #interests_tagsinput').bind('DOMNodeInserted DOMNodeRemoved', function() { 
		warning = true;
	});


	window.onbeforeunload = function() { 
	  if (warning && !modal_active) {
	  	return 'Are you sure you want to leave this page? You have unsaved changes on your profile';
	  }
	}
	
	$('a, input#connect-linked-in, input#connect-facebook').not("#notifications").not("#leave-page").not("#stay-page").click(function () {

		
		if (warning){
			if ($(this).attr("title") != "Removing tag"){
				$('#modal-confirm').reveal({
					 dismissmodalclass: 'close-confirm' 
				});
				
				if($(this).attr("id") == "connect-linked-in") {
					$('a#leave-page').attr("title", "linked_in");
					$('a#leave-page').attr("href", "javascript: void(0)");
				}else if ($(this).attr("id") == "connect-facebook"){
					$('a#leave-page').attr("title", "facebook");
					$('a#leave-page').attr("href", "javascript: void(0)");
				}else{
					$('a#leave-page').attr("title", "");
					$('a#leave-page').attr("href", $(this).attr("href"));
				}
				return false;
			}
		}
	});

	$("a#leave-page").click(function () {
		modal_active = true;


		if ($(this).attr("title") == "facebook"){
			$('#connect-facebook').submit();
		}
		else if ($(this).attr("title") == "linked_in"){
			$('#connect-linked-in').submit();
		}

	});

	$("input[type=submit]").not("input#connect-linked-in").not("input#connect-facebook").click(function () {
		modal_active = true;
	});


});