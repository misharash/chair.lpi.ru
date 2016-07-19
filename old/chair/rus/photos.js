function seton(image){
	image.style.cssText = "border-bottom-width:5;border-top-width:5;border-color:black";
}

function setout(image){
	image.style.cssText = "border-width:3";
}

var pic,src1,src2,ph,pw,nump,pics=35, pics_p=36;
var reg1 = /(.+photos\/)(.+)_(.+)_(.+)_s(\.jpg)/;
var reg2 = /(.+photos\/)(.+)(\.jpg)/;

function pic(e){
	src1 = e.replace(reg1, "$1");
	nump = e.replace(reg1, "$2");
	src2 = e.replace(reg1, "$5");
	pic = src1 + nump + src2;
	parent.up['actype'] = pic;
	window.open('gallary.html','main','');
}

function onstart() {
	pic = parent.up['actype'];
	document.getElementById('pic').src = pic;
	chpic(0);
}

function chpic(e){

	if (e != 0) pic = document.getElementById('pic').src;
	src1 = pic.replace(reg2, "$1");
	src3 = pic.replace(reg2, "$3");
	src2 = parseInt(pic.replace(reg2, "$2")) + parseInt(e);

	if (src2 == '0') src2 = '1';
	if (src2 == pics_p) src2 = pics;
	pic = src1 + src2 + src3;

	src2 = 'p' + src2;
//	src1 = document.getElementById(src2).src;
//	pw = src1.replace(reg1, "$3");
//	ph = src1.replace(reg1, "$4");
	hh = document.body.clientHeight - 60;
//	if (hh < ph) {
//		document.getElementById('pic').src = 'photos/fon.jpg';
		document.getElementById('pic').style.height = hh;
//		document.getElementById('pic').style.width = hh*pw/ph;
//	}

	//setTimeout("document.getElementById('pic').src=pic",1000);
	document.getElementById('pic').src=pic;
}

