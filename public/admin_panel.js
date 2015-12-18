/**
 * @author Victor Potapov
 * @version 1.0
 * @date 03.04.14
 */
function getHTML() {
	var g = $('#group_select_search').val();
	var y = $('#year_search').val();
	var m = $('#met_search').val();
	var url = '';
	if (m!=='both'){ url="/adminpanel/getCSV/";} else {
		url="/adminpanel/getBothMethod/";
	}
	$.post(
			 url,
			  {
			    group: g,
			    year: y,
			    met: m
			  },
			  onAjaxSuccess
			);
			 
			function onAjaxSuccess(data)
			{
			  // Здесь мы получаем данные, отправленные сервером и выводим их на экран.
				window.open(data);
			}
	} 

var admin = {
		saveJSON: function(flag) {
			var s = flag ? 'Допустить' : 'Не допустить';
			var p = confirm(s+' ? Nickname: '+$('#user_select_search:first').val());
			if (p) {
			var j = $('#JSONfile').val();
			
			$.post(
					'/adminpanel/saveJSON',
					  {
					    name: $('#user_select_search:first').val(),
					    jsonstring: j,
					    met: flag ? 'save' : 'not'
					  }
					).success(function(data) { $.jGrowl(data,3500) });
			} else {}
		}
}

function onSave(data)
{
  // Здесь мы получаем данные, отправленные сервером и выводим их на экран.
	alert(data);
}
