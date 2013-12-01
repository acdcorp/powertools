$.jqGrowl = {

    /*
     timeout before the notification fades; initialization code below will set to 3 seconds
     User code can also set this with $.jqGrowl.timeout = xxxx;
     */
    timeout: 0,

    /* count of messages displayed - private */
    msg_ctr: 0,

    /* Instantiate the jqGrowlContainer and the list if they don't exist */
    makeGrowlContainer: function() {
        if ($("#jqgrowlContainer").length == 0)  {       // Is the container instantiated? Make one if not...
            $('body').append('<div id = "jqgrowlContainer"></div>');
            $('body').append('<ul  id = "jqgrowlClone"><ul><li class = "jqgrowl-title"></li><li class = "jqgrowl-msg"></li><li class = "jqgrowl-icon"></li><li class = "jqgrowl-close"></li></ul></ul>');
        }
    },

    /* initialize the plugin */
    init: function(corner, tout) {

        this.makeGrowlContainer();
        $("#jqgrowlContainer").css(corner);
        if (tout) {
            this.timeout = tout
        }
    },

    /* add a message */
    msg: function(message, title, tout) {

        this.makeGrowlContainer();                  // instantiate the container & list if necessary
        // Store objects for reuse
        var container = $("#jqgrowlContainer");
        var clone = $("#jqgrowlClone");
        var tag = "#jqgrowlMsg" + this.msg_ctr;
        var theTimeout;
        var timerId;

        // Fade out after a period of time (3 sec. default)
        theTimeout = this.timeout;
        if (tout != null)   {                       // use default, unless user specifies one
            theTimeout = tout;
        }

        timerId = null;
        if (theTimeout != 0) {
            timerId = setTimeout(function() { $(tag).fadeOut(2000); }, theTimeout);
        }

        $("ul", clone).attr("id", "jqgrowlMsg" + this.msg_ctr);
        $("li.jqgrowl-title", clone).html(title);
        $("li.jqgrowl-msg", clone).html(message);

        // Append this message to the queue
        container.append(clone.html());

        // Attach close button events:
        // - dim the close box
        // - attach click() to close it in 300 msec
        // - if hovered over, brighten the close box, and clear the timer so it stays on screen
        $(tag + " li.jqgrowl-close").css("opacity", "0.25");
        $(tag + " li.jqgrowl-close").click(function() { $(tag).fadeOut(300); });
        $(tag).hover(
            function() { $(tag + " li.jqgrowl-close").fadeTo(200, 1.0); clearTimeout(timerId); },
            function() { }
        );
        this.msg_ctr++;
    },

    /* clear all messages */
    clear: function()
    {
        this.makeGrowlContainer();
        $("#jqgrowlContainer").html("");
    }
};

// initializer code - called when first loaded
// Place notifier at top-right, and let it dwell for 3 seconds
$(document).ready(function() {
    $.jqGrowl.init( { position: 'absolute', top: '8px', right: '8px' }, 3000);
});
