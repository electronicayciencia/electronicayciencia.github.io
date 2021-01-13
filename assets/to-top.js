/* This file original name was back-to-top.js, 
 * but it was renamed because ublock's fanboy annyances list matches it */

var old_offset = 0;
var button_visible = false;
var scroll_up_started_at = 0;
var upscroll_margin = 200;

window.onscroll = function() {
    var offset = document.documentElement.scrollTop || document.body.scrollTop;

    // going down
    if (offset > old_offset) {
        if (button_visible) {
            button_visible = false;
            backToTopBtn(false);
        }
        scroll_up_started_at = offset;
    }

    // going up
    else {
        if (
                (scroll_up_started_at - offset > upscroll_margin) 
                && !button_visible 
                && offset > upscroll_margin
        ) {
            button_visible = true;
            backToTopBtn(true);
        }
    }

    // went too up
    if (offset < upscroll_margin && button_visible) {
        button_visible = false;
        backToTopBtn(false);
    }
    
    old_offset = offset;
};


function backToTopBtn(visible) {
    button = document.getElementById("backToTopBtn");

    if (visible) {
        //console.log("Back to top button visible.");
        button.style.display = "block";
    }
    else {
        //console.log("Back to top button hidden.");
        button.style.display = "none";
    }
}




function back_to_top() {
    location.hash = "";
    document.body.scrollTop = 0; // For Safari
    document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
}

