 (function()
{
   CKEDITOR.plugins.add( 'bootstraplabel',
   {   
      requires : ['richcombo'], //, 'styles' ],
      init : function( editor )
      {
         var config = editor.config,
            lang = editor.lang.format;

         // Gets the list of tags from the settings.
         var tags = []; //new Array();
         //this.add('value', 'drop_text', 'drop_label');

         function getStyle(a){
            var s = "<div style='width: 10px; height: 10px;background:" + a + "; display:inline-block;'></div>";
            return s;
         }

         tags[0]=["label-default", getStyle('#777') + " Стандартный", "Серый"];
         tags[1]=["label-primary", getStyle('#337AB7') + " Главный", "Голубой"];
         tags[2]=["label-danger", getStyle('#D9534F') +  " Важный", "Красный"];
         
         // Create style objects for all defined styles.

         editor.ui.addRichCombo( 'bootstrapLabel',
            {
               label : "Метки",
               title :"I",
               voiceLabel : "Insert tokens",
               // className : '',
               multiSelect : false,

               panel :
               {
                  css : [ config.contentsCss, CKEDITOR.getUrl( 'skins/moono/editor.css' ) ],
                  voiceLabel : lang.panelVoiceLabel
               },


               init : function()
               {
                  this.startGroup( "Тип метки" );
                  //this.add('value', 'drop_text', 'drop_label');
                  for (var this_tag in tags){
                     this.add(tags[this_tag][0], tags[this_tag][1], tags[this_tag][2]);
                  }

               },

               onClick : function( value )
               {         
                  // editor.focus();
                  var selected_text = editor.getSelection().getSelectedText();
                  var lead = editor.document.createElement('span');
                  lead.setText(selected_text);
                  lead.setAttributes({class: 'label ' + value})
                  editor.insertElement(lead);
               }
            });
      }
   });
})();