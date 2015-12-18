/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	 config.language = 'ru';

	 config.allowedContent = true;

	 config.extraPlugins = 'code,bootstrapbg,bootstraplabel,submit';

	 config.toolbar = [
		 { name: 'document', groups: [ 'mode', 'document', 'doctools' ], items: [ 'Source', '-', 'Save', 'NewPage', 'Preview' ] },
		 { name: 'clipboard', groups: [ 'clipboard', 'undo' ], items: [ 'Cut', 'Copy', 'Paste', '-', 'Undo', 'Redo' ] },
		 { name: 'editing', groups: [ 'find', 'selection', 'spellchecker' ], items: [ 'Find', 'Replace', '-', 'SelectAll' ] },
		 // { name: 'forms', items: [ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button' ] },
		 // '/',
		 { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
		 { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ], items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl' ] },
		 { name: 'links', items: [ 'Link', 'Unlink' ] },
		 // { name: 'insert', items: [ 'Image', 'Flash', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak', 'Iframe' ] },
		 { name: 'insert', items: [ 'Image', 'Table', 'HorizontalRule', 'SpecialChar', 'PageBreak' ] },
		 '/',
		 { name: 'styles', items: [ 'Styles', 'Format', 'Font', 'FontSize' ] },
		 { name: 'colors', items: [ 'TextColor', 'BGColor' ] },
		 { name: 'tools', items: [ 'Maximize', 'ShowBlocks' ] },
		 { name: 'others', items: [ 'bootstrapBg', 'InsertCodeTag', 'BgLabel', '-', 'InsertPleadTag', 'ToolTips', 'bootstrapLabel', 'Submit', '-', 'Cancel' ] }, //сюда можно добавлять свои кнопки <----
		];
	 // / Filebrowser routes /
	 //  // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
	 //  config.filebrowserBrowseUrl = "/img";

	 //  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
	 //  config.filebrowserFlashBrowseUrl = "/img";

	 //  // The location of a script that handles file uploads in the Flash dialog.
	 //  config.filebrowserFlashUploadUrl = "/img";

	 //  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
	 //  config.filebrowserImageBrowseLinkUrl = "/img";

	 //  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
	 //  config.filebrowserImageBrowseUrl = "/img";

	 //  // The location of a script that handles file uploads in the Image dialog.
	 //  config.filebrowserImageUploadUrl = "/img";

	 //  // The location of a script that handles file uploads.
	 //  config.filebrowserUploadUrl = "/img";

	 //  config.addQueryString = function( url, params ){
		//     var queryString = [];

		//     if ( !params ) {
		//       return url;
		//     } else {
		//       for ( var i in params )
		//         queryString.push( i + "=" + encodeURIComponent( params[ i ] ) );
		//     }

		//     return url + ( ( url.indexOf( "?" ) != -1 ) ? "&" : "?" ) + queryString.join( "&" );
		//  };

	 // CKEDITOR.on( 'dialogDefinition', function( ev ){
  //   // Take the dialog name and its definition from the event data.
  //   var dialogName = ev.data.name;
  //   var dialogDefinition = ev.data.definition;
  //   var content, upload;

  //   if (CKEDITOR.tools.indexOf(['link', 'image', 'attachment', 'flash'], dialogName) > -1) {
  //     content = (dialogDefinition.getContents('Upload') || dialogDefinition.getContents('upload'));
  //     upload = (content == null ? null : content.get('upload'));

  //     if (upload && upload.filebrowser && upload.filebrowser['params'] === undefined) {
  //       upload.action = config.addQueryString(upload.action, upload.filebrowser['params']);
  //     }
  //   }
  // });

	// config.uiColor = '#AADC6E';
};


