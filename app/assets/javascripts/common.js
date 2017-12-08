$(function () {
    if(!window.thylacine){
        window.thylacine = {};
    }

    $('[data-toggle="popover"]').popover();

    $('[data-fade]').each(function(idx, elem){
        setTimeout(function(){
            $(elem).fadeOut();
        }, $(this).attr('data-fade'))
    })
});

