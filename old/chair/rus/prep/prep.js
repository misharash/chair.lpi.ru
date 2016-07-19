
//document.onmouseover=handler;
//document.onmouseout=handler;
//document.onclick=handler;

var newindow; 
var preps=new Array(0,"ginzburg", "beskin", "apenko", "bruk", "voronov", "dogiel", "zelnikov", "istomin", "kalenkov", "lukash", "silin", "sirota", "tipunin", "tsytovich");

function handler() {
        var src=event.srcElement;
        if(src.id>0) {
                switch(event.type) {
                        case "click":
                        var str1="/rus/prep/"+preps[src.id]+".jpg";
                        var str2="/rus/prep/"+preps[src.id]+".html";
                        if (!newindow || newindow.closed)
                                newindow=window.open('prep/frame.html','','left=200, top=250, toolbar=0, menubar=0, resizable=0, width=400, height=300');
                        
                        if (!newindow.closed) 
                                newindow.focus();
                        window.open(str1,'photo','width=200, height=300');
                        window.open(str2,'text','width=200, height=300');
                        break;

                        case "mouseover":
                        src.style.cursor="hand";
                        src.style.color="blue";
                        break;
                                
                        case "mouseout":
                        src.style.color="#333333";
                        break;
                        }
        }
}