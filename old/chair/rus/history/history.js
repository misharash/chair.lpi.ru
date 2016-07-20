
document.onclick=handler;
document.onmouseover=handler;
document.onmouseout=handler;

function handler() {
	var src=event.srcElement;
	if((src.id.substr(0,5)=="tab_a") || (src.id.substr(0,5)=="tab_y")) {
		var n1="tab_a"+src.id.substr(5);
		var n2="tab_y"+src.id.substr(5);
		var n3="table"+src.id.substr(5);
		if(document.all(n1).innerText=="4") {	
			switch(event.type) {
				case "click":
				document.all(n1).innerText="6";
				document.all(n1).className="open_a";
				document.all(n2).className="open_y";
				document.all(n3).className="";
				break;

				case "mouseover":
				src.style.cursor="hand";
				document.all(n1).className="open_a";
				document.all(n2).className="open_y";
				break;
				
				case "mouseout":
				document.all(n1).className="close_a";
				document.all(n2).className="close_y";
				break;
				}
			}
		else {
			switch(event.type) {
				case "click":
				document.all(n1).innerText="4";
				document.all(n3).className="invis";
				break;
				}
			}
	}
}



