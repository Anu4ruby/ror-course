//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(function(){
	triggerQuestionType();
	toggleSingleSelectAnswer();
	triggerPage();
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
var page = 1;
function triggerPage(){
	setActivePager(page);
	console.log($('.pagination li:not(.previous):not(.next)'));
	$(document).on('click', '.pagination li', function(){
		var active_page = page;
		if($(this).hasClass('previous')){
			if (page > 1){
				page --;
			}
		}else if($(this).hasClass('next')){
			if(page < $(this).prev().find('a').eq(0).data('page')){
				page ++;
			}
		}else{
			page = $(this).find('a').eq(0).data('page');
		}
		if(page != active_page){
			// alert(page);
			setActivePager(page);
		}
	});
}
function triggerNextPage(){
	
}
function triggerPrevPage(){
	
}
function setActivePager(activePage){
	$('.pagination .active').removeClass('active');
	$('.pagination').each(function(k, v){
		$(v).find('ul li').eq(activePage).addClass('active');
	});
	$('.pages .page.active').removeClass('active');
	$('.pages .page').eq(activePage-1).addClass('active');
}
