$(document).ready(function()
{
	/* Homepage */
	$('a.learn-more').click(function() {
		lm = $('hr.learn-more').offset();
		$("html, body").animate({scrollTop:lm.top}, 500, "swing");
	});
	
	$('a.sign-up').click(function() {
		su = $('hr.sign-up').offset();
		$("html, body").animate({scrollTop:su.top}, 500, "swing");
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
	
	/* Date Picker */
	Date.firstDayOfWeek = 0;
	Date.format = 'mm/dd/yyyy';
	$('.date-picker').datePicker({clickInput:true});
	$('#start_day').bind(
		'dpClosed',
		function(e, selectedDates)
		{
			var d = selectedDates[0];
			if (d) {
				d = new Date(d);
				$('#end_day').dpSetStartDate(d.addDays(0).asString());
			}
		}
	);
	$('#end_day').bind(
		'dpClosed',
		function(e, selectedDates)
		{
			var d = selectedDates[0];
			if (d) {
				d = new Date(d);
				$('#start_day').dpSetEndDate(d.addDays(0).asString());
			}
		}
	);
	
	/* Error messages */
	$('.flash').delay(250).slideDown().delay(5000).slideUp();
	
	/* Events filter */
	$('#filter-all').click(function () {
		$('.all').slideDown();
	});
	$('#filter-attendee').click(function () {
		$('.invited').slideUp();
		$('.attendee').slideDown();
		$('.admin').slideDown();
		$('.declined').slideUp();
	});
	$('#filter-admin').click(function () {
		$('.attendee').not('.admin').slideUp();
		$('.invited').slideUp();
		$('.admin').slideDown();
		$('.declined').slideUp();
	});
	$('#filter-invited').click(function () {
		$('.admin').slideUp();
		$('.attendee').slideUp();
		$('.invited').slideDown();
		$('.declined').slideUp();
	});
	$('#filter-declined').click(function () {
		$('.admin').slideUp();
		$('.attendee').slideUp();
		$('.invited').slideUp();
		$('.declined').slideDown();
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