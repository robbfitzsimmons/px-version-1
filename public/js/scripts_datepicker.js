$(document).ready(function()
{
	/* Date Picker */
	Date.firstDayOfWeek = 0;
	Date.format = 'mm/dd/yyyy';
	$('input.date-picker').datePicker({clickInput:true});
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
});