//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(function(){
	triggerQuestionType();
	toggleSingleSelectAnswer();
});
function triggerQuestionType(){
	$(document).on('change', '#question_qtype', function(){
		$.get('/challenges/new?type='+$(this).val(), function(data){
			// alert($(data).find('.choices .fields').eq(0).html());
			$('#page-content > .container').html(data);
		});
	});
	$('#question_type').change();
}
function toggleSingleSelectAnswer(){
	$(document).on('click', '.choices input[type=radio]', function(){
		$('.choices input[type=radio]:checked').prop('checked', '');
		$(this).prop('checked', 'checked');
	});
}
