#!/usr/local/bin/perl -w

use CGI::Carp qw(fatalsToBrowser);

print <<EOF;
Content-type: text/html

<html>
<head>
<title>Выпускники</title>
<meta charset="windows-1251">
<LINK type="text/css" HREF="/rus/comsheet.css" rel="stylesheet">
<STYLE type="text/css">
        .off
               {color:#666666; font-family:"Arial Narrow"; font-weight:bold}
        .on
             {color:blue; font-family:"Arial Narrow"; font-weight:bold; cursor:pointer}
</STYLE>
</head> 
<body bgcolor=#999999 text=#111111 alink=black vlink=black link=black>
<center>
<table width=85% height=100% bgcolor=#b6b6b6 border=0 cellpadding=0 cellspacing=0>
<tr valign=top><td align=center>

<table width=85% height=5 border=0 cellpadding=0 cellspacing=0>
<tr><td></td>
</table>

<table width=85% height=70 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center ID=heading>Выпускники <Font face="webdings">&igrave;</Font></td>
</table>
<hr width=80%>

<table width=80% height=40 border=0 cellpadding=0 cellspacing=0>
<tr valign=top><td align=right>
<u class=off onmouseover="this.className='on'" onmouseout="this.className='off'"
   onclick="document.location='/rus/grad.shtml'">Выход</u>
</td>
</tr>
</table>

<table border=0 width=85% cellpadding=0 cellspacing=0>
<tr><td>
<FORM name='send' action="/cgi-bin/add_grad.pl" method=post>
<FIELDSET>
<LEGEND><b>Новый выпускник</b></LEGEND>

<table border=0 width=90% cellpadding=0 cellspacing=0>
<tr><td align=center>Фамилия И.О.:</td><td> <input size=25 type=text name="name"/></td>
<tr><td align=center>Пол:</td>
        <td>М&nbsp;<input type=radio name=sex value='м'>&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;Ж&nbsp;<input type=radio name=sex value='ж'></td>
<tr><td align=center>Год приема:</td><td> <input size=3 type=text name="in"/></td>
<tr><td align=center>Год выпуска:</td><td> <input size=3 type=text name="out"/></td>
<tr><td align=center>Статус:</td>
<td>
<SELECT name='status' rows="3">
        <OPTION value="s">студент</OPTION>
        <OPTION value="a">аспирант</OPTION>
        <OPTION value="sa">студент, аспирант</OPTION>
</SELECT>
</td>
<tr><td align=center>Защитил(а):</td>
<td>
<SELECT name='defend' rows="3">
        <OPTION value="no"></OPTION>
        <OPTION value="d">диплом</OPTION>
        <OPTION value="a">диссертация</OPTION>
        <OPTION value="da">диплом, диссертация</OPTION>
</SELECT>
</td>

<tr><td align=center>Научный Руководитель:</td><td> <input size=20 type=text name="r_adv1"/></td>

<tr><td align=center>Научный Руководитель:</td><td> <input size=20 type=text name="r_adv2"/></td>

<tr><td align=center>Научный Руководитель:</td><td> <input size=20 type=text name="r_adv3"/></td>

<tr><td align=center>Научный Руководитель:</td><td> <input size=20 type=text name="r_adv4"/></td>

</table>

</FIELDSET>
<p>
<tr><td>&nbsp;<button onclick="if(confirm('Вы уверены?')) document.forms.send.submit()">Добавить</button><button onclick="document.forms.send.reset()">Очистить</button>
</td></tr>
</table>
</FORM>

</td></tr>
</table>
</center>

</body>
</html>

EOF

exit;