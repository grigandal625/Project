(function()
{
 var plugin_name = 'code';

 CKEDITOR.plugins.add( plugin_name,
 {
  // requires: [ 'dialog', 'fakeobjects' ],
  icons: plugin_name,
  hidpi: false,

  // onLoad: function()
  // {
  //  var css = 'img.form-placeholder' +
  //  '{' +
  //  ' -moz-box-sizing: border-box;' +
  //  ' -webkit-box-sizing: border-box;' +
  //  ' box-sizing: border-box;' +
  //  ' display: block;' +
  //  ' width: 100%;' +
  //  ' height: 400px;' +
  //  ' background: url(' + this.path + 'images/forms.png) ' +
  //    'no-repeat center center white;' +
  //  ' border: 1px solid #a9a9a9;' +
  //  ' min-width: 100px;' +
  //  ' min-height: 50px;' +
  //  ' margin: 5px 0 10px 0;' +
  //  '}';

  //  CKEDITOR.addCss( css );
  // },

  init: function( editor )
  {

   editor.addCommand( 'insertCodeTag', {
       exec: function( editor ) {
        var selected_text = editor.getSelection().getSelectedText();
        var code = editor.document.createElement('code');
        code.setText(selected_text);
        editor.insertElement(code);
      }
   });

      editor.addCommand( 'insertPleadTag', {
       exec: function( editor ) {
        var selected_text = editor.getSelection().getSelectedText();
        var lead = editor.document.createElement('p');
        lead.setText(selected_text);
        lead.setAttributes({class: 'lead font-lg'})
        editor.insertElement(lead);
      }
   });

   var iconcPath = this.path + 'icons/';
   
   editor.ui.addButton( 'InsertCodeTag',
   {
    label: 'Обернуть код',
    command: 'insertCodeTag',
    icon: iconcPath + 'insertCodeTag.png'
   } );

   editor.ui.addButton( 'InsertPleadTag',
   {
    label: 'Разряженный текст',
    command: 'insertPleadTag',
    icon: iconcPath + 'InsertPleadTag.png'
   } );   
  },

 } );
} )();