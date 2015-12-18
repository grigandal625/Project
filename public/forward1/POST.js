/**
 * @author Victor Potapov
 * @version 1.0
 */

function postToServer(ids,str,flag,estimate) {
	if (flag==undefined) {flag='no';}
	$.post(
			  "/menu/getfile",
			  {
			   id: ids,
			    JSON: getJSONformat(),
			    end: flag,
			    result: estimate
			  },
			  onAjaxSuccess
			);
			 
			function onAjaxSuccess(data)
			{
				if (data=='Конфигурация сохранена') {
						$.jGrowl('<br />Ваша БЗ и начальное состояние РП <b>успешно сохранены</b>', {
							life : 2500,
							header : 'Оповещание эксперта'
						});
				}
				if (data=="Тестирование закончено") {
					$.jGrowl('<br />Вы закончили тестирование. Ваш результат: '+global_estimate, {
						life : 25000,
						header : 'Оповещание эксперта'
					});
				}
			}
}