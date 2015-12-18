 (function()
{
   CKEDITOR.plugins.add( 'bootstrapbg',
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

         tags[0]=["bg-primary", getStyle('#337AB7') + " Главный", "Голубой"];
         tags[1]=["bg-danger", getStyle('#D9534F') + " Важный", "Красный"];
         // tags[2]=["bg-danger", "danger", "danger"];
         
         // Create style objects for all defined styles.

         editor.ui.addRichCombo( 'bootstrapBg',
            {
               label : "Выделить текст",
               title :"Выделить текст",
               voiceLabel : "Insert tokens",
               className : '',
               multiSelect : false,

               //ТУТ ЕСТЬ ВОПРОСЫ
               panel :
               {
                  css : [ config.contentsCss, CKEDITOR.getUrl('skins/moono/editor.css') ],
                  voiceLabel : lang.panelVoiceLabel
               },


               init : function()
               {
                  this.startGroup( "Режим выделения" );
                  //this.add('value', 'drop_text', 'drop_label');
                  for (var this_tag in tags){
                     this.add(tags[this_tag][0], tags[this_tag][1]);
                  }

               },

               onClick : function( value )
               {         
                  // editor.focus();
                  var selected_text = editor.getSelection().getSelectedText();
                  var lead = editor.document.createElement('p');
                  lead.setText(selected_text);
                  lead.setAttributes({class: 'lead font-lg ' + value})
                  editor.insertElement(lead);
               }
            });
      }
   });
})();