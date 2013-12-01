## About jqGrowl

jqGrowl is a jQuery plugin that displays messages in a floating window above the web browser contents. Its name comes from the similar [Growl notification facility](http://growl.info) for Mac OS X. 

When you call the $.jqGrowl.msg() function, a floating window appears with the specified HTML text. It fades away after a user-defined time. If you hover the mouse over the notification, it remains on-screen until you click the mouse. 

_Note: This README is an abbreviated description of Greg Sidelnikov's jqGrowl. 
Read the full page at: [http://www.learnjquery.org/plugin/jq-growl/](http://www.learnjquery.org/plugin/jq-growl/)_

### Installation

Download and include plugin resource files shown below to your web page.
Place the image files into the plugin directory together with the CSS file.

* jqgrowl.js - the jQuery plugin code
* jqgrowl.css - the HTML growl message box CSS styles (you can re-style it yourself to make the messages imitate any look you want.)
* jqgrowl-icon.png - the message icon picture
* jqgrowl-close.png - the close button's icon

### Add the plugin to your page

To add the plugin to your page, include these CSS and Javascript files (you will also need jQuery added to your project):

    <link   href='jqgrowl.css' type='text/css' rel='stylesheet' />
    <script  src='jqgrowl.js'  type='text/javascript'></script>

### Initializing jqGrowl

The plugin (jgrowl.js) has a .ready() method that performs all initialization, setting the default location (top right) and timeout (3 seconds).
You may also call the _init()_ method at any time to change these parameters. Here are the default settings:

    $.jqGrowl.init( { position: 'absolute', top: '8px', right: '8px' }, 3000);

You may also change the timeout globally by setting the value directly. Setting the timer to zero will keep the notification on screen until the close icon is clicked.

    $.jqGrowl.timeout = 4000;

### How to post jqGrowl messages

Use the _msg()_ method to post a HTML text notification. You may optionally set a title (second argument)
or timeout (third argument). The timeout applies only to this message. Example:

    $.jqGrowl.msg('Body of <br />the message', 'Title of the message', 4000);

Note: This plugin is still in beta. It has been tested with jQuery 1.10.2 and 2.0.3. 
It may not work correctly in some browsers (probably older versions of IE). 
If you notice something please let me know, and I'll update the code.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/richb-hanover/jqgrowl/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

