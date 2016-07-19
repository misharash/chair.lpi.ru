#!/usr/local/bin/perl -w

print <<EOF;
Content-type: text/html

<html>
<head>
<title>Поиск для удаления</title>
<meta charset="windows-1251">
<LINK type="text/css" HREF="comsheet.css" rel="stylesheet">
<STYLE type="text/css">
	.off
 	       {color:#666666; font-family:"Arial Narrow"; font-weight:bold}
	.on
   	     {color:blue; font-family:"Arial Narrow"; font-weight:bold; cursor:pointer}
</STYLE>
</head>  

<body bgcolor=#999999 text="black" alink=black vlink=black link=black>
<center>

<table width=85% bgcolor=#b6b6b6 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center>

<table width=85% height=5 border=0 cellpadding=0 cellspacing=0>
<tr><td></td>
</table>

<table width=85% height=70 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center ID=heading>Поиск для удаления</td>
</table>
<hr width=80%>

<table bgcolor="#333333" border=0 width=95% cellpadding=0 cellspacing=0>
<tr><td align=center>
<FORM name=byname action=/cgi-bin/del_grads2.pl method=post>
<Input type=text size=20 name="search" value="  Фамилия" style="background:#dddddd" onfocus="this.style.background='white'" onblur="this.style.background='#dddddd'" title='Введите фамилию и нажмите enter'>
</FORM>
</td></tr>
</table>

</td></tr>
</table>

</center>
</body>
</html>

EOF
exit;
