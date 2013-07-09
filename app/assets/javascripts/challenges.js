//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(function(){
	triggerQuestionType();
	addChoiceSelection();
	addAnswerAsChoice();
});
function triggerQuestionType(){
	$(document).on('change', '#question_qtype', function(){
		$.get('/challenges/new?type='+$(this).val(), function(data){
			//alert(data);
			$('.form').replaceWith(data);
		});
	});
	$('#question_type').change();
}
function addChoiceSelection(){
	$(document).on('blur', '.choices [name$="[description]"]', function(){
		var choice = $(this).val();
		//alert(choice);
	});
}
function addAnswerAsChoice(){
	$(document).on('blur', '.answers [name$="[description]"]', function(){
		var text = $(this).val();
		if(text.length > 0){
			$('form .choices a.add_nested_fields').click();
			$('form .choices .fields').last().find('input').eq(0).val(text);
		}
			
	});
}
