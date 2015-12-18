/**
 * @author Victor Potapo
 * @version 1.0
 * @data 03.04.14
 */
var userWantMiss = false;
window.onbeforeunload = function() {
	if (userWantMiss==true) {
  return "Вы еще не прошли тестирование. Если вы решите покинуть страницу вам будет выставлен нулевой балл.";
	}
};
