$(document).ready(function()
{
	/* Homepage */
	$('a.learn-more').click(function() {
		lm = $('#learn-more').offset();
		$("html, body").animate({scrollTop:lm.top-105}, 500, "swing");
	});
	
	$('a.sign-up').click(function() {
		su = $('#sign-up').offset();
		$("html, body").animate({scrollTop:su.top-105}, 500, "swing");
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
	$("input, textarea").focus(function() {
		f = $(this);
		
    	f.addClass('active');
	}).blur(function() {
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
		$('.invited').slideUp();
		$('.attendee').slideDown();
		$('.admin').slideDown();
		$('.declined').slideUp();
		$(this).parent().parent().find('a').removeClass('filtered');
		$(this).addClass('filtered');
	});
	$('#filter-admin').click(function () {
		$('.attendee').not('.admin').slideUp();
		$('.invited').slideUp();
		$('.admin').slideDown();
		$('.declined').slideUp();
		$(this).parent().parent().find('a').removeClass('filtered');
		$(this).addClass('filtered');
	});
	$('#filter-invited').click(function () {
		$('.admin').slideUp();
		$('.attendee').slideUp();
		$('.invited').slideDown();
		$('.declined').slideUp();
		$(this).parent().parent().find('a').removeClass('filtered');
		$(this).addClass('filtered');
	});
	$('#filter-declined').click(function () {
		$('.admin').slideUp();
		$('.attendee').slideUp();
		$('.invited').slideUp();
		$('.declined').slideDown();
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
	

});