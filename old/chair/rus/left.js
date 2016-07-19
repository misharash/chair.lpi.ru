

document.onclick=handler;
document.onmouseover=handler;
document.onmouseout=handler;

var sub_menu = new Array('X',0,3,0,4,6,2,4); // 1st 'X' cut 0th element
var main_id='', aux_id='';
var rex1=/^m(\d+)$/;
var rex2=/^m\d+-\d+$/;

function handler(e) {
if(document.all) {
	var src = event.srcElement;
	var etype=event.type;
}
else {
	var src = e.target;
	var etype=e.type;
}


	if(rex1.test(src.id)) {
		if (etype == "mouseover") {
			src.style.cursor="pointer";
			document.getElementById(src.id).src = 'img/'+src.id+'b.gif';
			}
		else if (etype == "mouseout") {		
			document.getElementById(src.id).src = 'img/'+src.id+'w.gif';
			}
		else if (etype == "click") {
			if(main_id!=src.id) {
				if (main_id!='') close(main_id);
				main_id=src.id;
				open(main_id);
				}
			else {
				close(main_id);
				main_id='';
				}
			}
		}
	
	if(rex2.test(src.id)) {
		if (etype == "mouseover") {
			src.style.cursor="pointer";
			if(aux_id!=src.id) document.getElementById(src.id).src = 'img/'+src.id+'b.gif';
			}
				
		else if (etype == "mouseout") {
			if(aux_id!=src.id) document.getElementById(src.id).src = 'img/'+src.id+'w.gif';
			}
			
		else if (etype == "click") {
			if(aux_id!=src.id) {
				document.getElementById(src.id).src = 'img/'+src.id+'b.gif';
				if(aux_id!='') document.getElementById(aux_id).src = 'img/'+aux_id+'w.gif';
				aux_id=src.id;
				}
			}
		}
}

function open(ID) {
	var sub_num=sub_menu[ID.replace(rex1,"$1")];
	
	for(var i=1;i<=sub_num;i++) {
		var sub_id = ID+'-'+i;
		setTimeout("document.getElementById('" + sub_id + "').className=''",100*i);
		}
}


function close(ID) {
	var sub_num=sub_menu[ID.replace(rex1,"$1")];
	
	for(var i=sub_num;i>0;i--) {
		var sub_id = ID+'-'+i;
		setTimeout("document.getElementById('" + sub_id + "').className='hid'",100*(sub_num-i+1));
		}
}

var rus_m = new Array('€нвар€','феврал€','марта','апрел€','ма€','июн€','июл€','августа','сент€бр€','окт€бр€','но€бр€','декабр€');
var eng_m = new Array('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
var rus_d = new Array('понедельник','вторник','среда','четверг','п€тница','суббота','воскресенье');
var eng_d = new Array('Mon','Tue','Wed','Thu','Fri','Sat','Sun');

function date_status() {
	var str=new Date();
	str = str.toString();
	var dw = str.substr(0,3);
	var m = str.substr(4,3);
	var d = str.substr(8,2);
	var t = str.substr(11,5);
	for (var i=0; i<12; i++) if (m == eng_m[i]) m = rus_m[i];
	for (var i=0; i<7; i++) if (dw == eng_d[i]) dw = rus_d[i];
	var time=d+" "+m+", "+dw+", "+t;
	window.defaultStatus=time;
}

setInterval('date_status()',1000);
