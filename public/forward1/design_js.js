/**
 * @author Victor
 * @version 1.0
 * @data 20.07.13
 */
// Плавная кнопка Генерации базы
$( document ).ready(function() {
   $('.button_generate')
		.css( {backgroundPosition: "0 0"} )
		.mouseover(function(){
			$(this).stop().animate({backgroundPosition:"(0 -240px)"}, {duration:500})
		})
		.mouseout(function(){
			$(this).stop().animate({backgroundPosition:"(0 0)"}, {duration:500})
		})
		
		//для скрола трассы вывода TITLE
	$(window).scroll(function(){
		    	
				var scrollTop = $(window).scrollTop();
				var check_scroll = $('#check_scroll_me').css("top");
				if(scrollTop >= check_scroll.slice(0,-2)) {
					$('#top_tbl').css({"position":"absolute","left":check_scroll_left,"top":scrollTop});
				} 
				
				if(scrollTop < check_scroll_top) {
					$('#top_tbl').css({"position":"","top":check_scroll_top});
					
				}
			
	});
			
});

//Показ рабочей области
function show_work(id){
	var all = ["hello","generate_menu","holder"];
	for (i=0;i<all.length;i++) {
		if (id==all[i]){$("#"+id).animate({height: "show"}, 1000);} else {$("#"+all[i]).animate({height: "hide"}, 1000);}
	}
}

