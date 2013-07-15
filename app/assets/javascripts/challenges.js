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
		var page = $(this).find('a').eq(0).data('page');
		setActivePager(page);
	});
}
function triggerNextPage(){
	$(document).on('click','.pagination .next', function(e){
		e.preventDefault();
		var maxPage = $(this).prev().find('a').eq(0).data('page');
		var nextPage = $(this).find('a').eq(0).data('page');
		if (nextPage <= maxPage){
			setActivePager(nextPage);
		}
		
	});
}
function triggerPrevPage(){
	$(document).on('click', '.pagination .previous', function(e){
		e.preventDefault();
		var prevPage = $(this).find('a').eq(0).data('page');
		if(prevPage > 0){
			setActivePager(prevPage);
		}
	});
}
function setActivePager(activePage){
	$('.pagination').find('.active').removeClass('active');
	$('.pagination .next > a').attr('data-page', activePage + 1);
	$('.pagination .previous > a').attr('data-page', activePage - 1);
		
	$('.pagination').each(function(k, v){
		$(v).find('ul li').eq(activePage).addClass('active');
	});
	$('.pages .page.active').removeClass('active');
	$('.pages .page').eq(activePage-1).addClass('active');
}