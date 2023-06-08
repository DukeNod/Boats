/*

	fastID jQuery Plugin - Copyright (C) 2007, Jorrit Jongma (Chainfire) 
	
	Version: 1.0
	Homepage: http://www.jongma.org/webtools/jquery/
	License: Public Domain / MIT (whatever works for you)
	See Also: http://dev.jquery.com/ticket/1316
	
	From webpage:

	This plugin speeds up use of $('#id'). Use of $('#id') may be anywhere 
	between 10 and 40 times slower than using $(document.getElementById('id')), depending 
	on the browser used. I don't know about you, but I personally use $('#id') a lot and 
	really need the speed up. With this plugin, $('#id') is typically only up to 10% 
	slower than $(document.getElementById('id')), and often not even measurable (110% 
	vs 4000%, not bad I would say!).

	Note #1: Thanks to rformato for the improved RegEx.
	Note #2: Though 1.1.3 speeds this up a little bit compared to 1.1.2, it's still very slow.
	Note #3: I don't advise using this plugin with a jQuery 1.2 unless this page states 
	otherwise by the time it is released. The fix may be incorporated into the next
	version, as there was already a possibility that it would come in 1.1.3.

	Documentation: None necessary. Just include the javascript and $('#id')
	will be much much faster. Comments mark replaced code in the file.

	Compatibility: 1.1.2*, 1.1.3a, 1.1.3
	* only tested with older version of plugin

*/

jQuery.fn.init = function(a,c) {
		// Make sure that a selection was provided
		a = a || document;

		// HANDLE: $(function)
		// Shortcut for document ready
		if ( jQuery.isFunction(a) )
			return new jQuery(document)[ jQuery.fn.ready ? "ready" : "load" ]( a );

/* Original code (1.1.3)			
		// Handle HTML strings
		if ( typeof a  == "string" ) {
			// HANDLE: $(html) -> $(array)
			var m = /^[^<]*(<(.|\s)+>)[^>]*$/.exec(a);
			if ( m )
				a = jQuery.clean( [ m[1] ] );

			// HANDLE: $(expr)
			else
				return new jQuery( c ).find( a );
		}
*/
		
/* New code - start */		
		// Handle HTML strings
		if ( typeof a  == "string" ) {
			// HANDLE: $(html) -> $(array) and a fast $('#id')->$(element);
			var m = /^[^<]*(<(.|\s)+>)[^>]*$|^#([-\w\d:]+)$/.exec(a);
			if ( m && ( m[1] || !c ) )
				a = m[1] ? jQuery.clean( [ m[1] ] ) : document.getElementById( m[3] ) || [];
			// HANDLE: $(expr)
			else
				return new jQuery( c ).find( a );
		}		
/* New code - end */		

		return this.setArray(
			// HANDLE: $(array)
			a.constructor == Array && a ||

			// HANDLE: $(arraylike)
			// Watch for when an array-like object is passed as the selector
			(a.jquery || a.length && a != window && !a.nodeType && a[0] != undefined && a[0].nodeType) && jQuery.makeArray( a ) ||

			// HANDLE: $(*)
			[ a ] );
	}