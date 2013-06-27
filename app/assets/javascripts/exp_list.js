function prepareList() {
    $('#expList').find('li:has(ol)')
    .click( function(event) {
        if (this == event.target) {
            $(this).toggleClass('expanded');
            $(this).children('ol').toggle('medium');
        }
        return false;
    })
    .addClass('collapsed')
    .children('ol').hide();
};
 
$(document).ready( function() {
    prepareList()
});