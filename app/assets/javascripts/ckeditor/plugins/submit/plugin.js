(function()
{
	var plugin_name = 'submit';

	CKEDITOR.plugins.add( plugin_name,
	{
		icons: plugin_name,
		hidpi: false,

		init: function( editor )
		{
			var iconcPath = this.path + 'icons/';
			var $form = $(editor.element.$.form);

			$form.bind('ajax:success', function() {
				if($('.site_imap_anchor')[0]) {
					location.reload();
				}
			})
			editor.addCommand( 'submit', {
			    exec: function( editor ) {
			    	editor.updateElement()
			        $form.submit()
			        editor.destroy(false)
			    }
			});

			editor.addCommand( 'cancel', {
			    exec: function( editor ) {
			        editor.destroy(true)
			    }
			});

			editor.ui.addButton( 'Submit',
			{
				label: 'Сохранить',
				command: 'submit',
				icon: iconcPath + 'submit.png'
			} );

			editor.ui.addButton( 'Cancel',
			{
				label: 'Закрыть',
				command: 'cancel',
				icon: iconcPath + 'cancel.png'
			} );
		},
	} );
} )();