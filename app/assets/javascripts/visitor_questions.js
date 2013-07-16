var page = 1;
$(function(){
	loadmore();
});

function loadmore(){
	$(document).on('click', '#loadmore', function(e){
		e.preventDefault();
		page++;
		$.get('/asks/page/'+page).done(function(data){
			$('#questions').append(data);
		});
	});
}
