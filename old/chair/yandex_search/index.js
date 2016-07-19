var progress = 0;
var multi = 1;

var queries = {};
var host;

function addRow(n) {

	host = document.form.host.value;
	for(var i = 0; i < document.form.length; i++) {
		var el = document.form.elements[i];
		if (/^query/.test(el.name))
			queries[el.name] = el.value;
	}

	var name = 'query' + n;
	var id1 = 'add' + n;
	var id0 = 'add' + (n-1);
	document.getElementById(id0).innerHTML = '';
	n++;
	document.getElementById('table').innerHTML += "<TR class=rows><TD>Запрос:</TD> <TD><INPUT name="+ name +" size=60></TD><TD id="+ id1 +"><A class=nodec href=\"javascript:addRow('"+ n +"')\">[+]</A></TD></TR>";

	document.form.host.value = host;
	for(var i = 0; i < document.form.length; i++) {
		var el = document.form.elements[i];
		if (/^query/.test(el.name))
			 el.value = queries[el.name] || '';
	}

	document.form[name].focus();
}

function sendForm()
{
	document.getElementById('count').innerHTML = '0%';
	document.getElementById('loading').style.width = 1;
	multi = 1;
	progress = 0;

	var url = "/cgi-bin/analisys.pl"; 
	var params = '';

	for(var i = 0; i < document.form.length; i++) {
		var el = document.form.elements[i];
		if (el.type != 'button')
			params += el.name + '=' + el.value + '&';
	}

	request(url, params);
}

function pBar()
{
	progress += multi;
	document.getElementById('count').innerHTML = progress+'%';
	var px = document.getElementById('loading').style.width.replace("px","");
	document.getElementById('loading').style.width = px/1 + 3*multi;
	if (progress >= 100) {
		clearInterval(window.tm);
		document.getElementById('count').innerHTML = '100%';
		document.getElementById('loading').style.width = 300;
	}
}

function request(url, params)
{
	info.style.visibility = '';
	window.tm=setInterval('pBar()', 70);

	var result = document.getElementById('result');

	var xmlHttp;
	try {	// Firefox, Opera 8.0+, Safari
		xmlHttp=new XMLHttpRequest();
	}
	catch (e) {	// Internet Explorer
		try {
			xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch (e) {
			try {
				xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch (e) {
				alert("Ваш броузер не поддерживает AJAX.");
				return false;
			}
		}
	}


	var handler = function() {

		if(xmlHttp.readyState == 2) multi = 2;
		if(xmlHttp.readyState == 3) multi = 7;

		if(xmlHttp.readyState == 4) {

			multi = 100;			
			result.innerHTML = xmlHttp.responseText;
			result.style.display = '';
		}
	}
		
	xmlHttp.open("POST",url,1);
	xmlHttp.send(params);
	xmlHttp.onreadystatechange = handler;
}
