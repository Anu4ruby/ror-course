//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(function(){
	pageNav();
	triggerQuestionType();
	toggleSingleSelectAnswer();
});
function triggerQuestionType(){
	$(document).on('change', '#question_qtype', function(){
		$.get('/challenges/new?type='+$(this).val(), function(data){
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
function pageNav(){
	setActivePager(1);
	triggerPage();
	triggerNextPage();
	triggerPrevPage();
}
function triggerPage(){
	$(document).on('click', '.pagination li:not(.previous):not(.next)', function(e){
		e.preventDefault();
		var page = $(this).children('a').eq(0).data('page');
		setActivePager(page);
	});
}
function triggerNextPage(){
	$(document).on('click','.pagination li.next', function(e){
		e.preventDefault();
		var active = $('.pagination li.active'); 
		if(active.next().children('a').data('page')){
			setActivePager(active.children('a').data('page') + 1)
		}
		
	});
}
function triggerPrevPage(){
	$(document).on('click', '.pagination li.previous', function(e){
		e.preventDefault();
		var activePage = $('.pagination li.active > a').data('page'); 
		if(activePage > 1){
			setActivePager(activePage - 1);
		}
	});
}
function setActivePager(activePage){
	$('.pagination').find('.active').removeClass('active');
	$('.pagination').each(function(k, v){
		$(v).find('ul li').eq(activePage).addClass('active');
	});
	$('.pages .page.active').removeClass('active');
	$('.pages .page').eq(activePage-1).addClass('active');
}