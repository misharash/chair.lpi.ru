#!/usr/local/bin/perl -w

require "get_form_data.pl";

&get_form_data;

$Pass{'malex'}="casimir";
$Pass{'beskin'}="dwbh116";

if(($Pass{$FORM{'user'}}) && ($FORM{'password'} eq $Pass{$FORM{'user'}}) && ($FORM{'source'} eq 'add')) {
        &news_add;
}

elsif(($Pass{$FORM{'user'}}) && ($FORM{'password'} eq $Pass{$FORM{'user'}}) && ($FORM{'source'} eq 'del')) {
        system("/usr/local/www/chair-cgi/send2arch.pl");
}

elsif(($Pass{$FORM{'user'}}) && ($FORM{'password'} eq $Pass{$FORM{'user'}}) && ($FORM{'source'} eq 'chstuds')) {
        system("/usr/local/www/chair-cgi/chstuds.pl $FORM{'lang'}");
}

elsif(($Pass{$FORM{'user'}}) && ($FORM{'password'} eq $Pass{$FORM{'user'}}) && ($FORM{'source'} eq 'chgrads')) {
        system("/usr/local/www/chair-cgi/chgrads.pl");
}

elsif(($Pass{$FORM{'user'}}) && ($FORM{'password'} eq $Pass{$FORM{'user'}}) && ($FORM{'source'} eq 'delgrads')) {
        system("/usr/local/www/chair-cgi/del_grads.pl");
}

elsif($FORM{'lang'} eq 'rus') {
        &comlete_page('<meta charset="windows-1251">','У вас нет права вносить изменения!','на главную страницу','/rus/grad.shtml');
}

elsif($FORM{'lang'} eq 'eng') {
        &comlete_page('','Access is denied!','to Main page','/eng/main.html');
}

sub comlete_page {
print <<EOF;
Content-type: text/html

<HTML>
<HEAD>
<TITLE>Error</TITLE>
$_[0]
<meta charset="windows-1251">
</HEAD>
<BODY bgcolor=#999999 onload="document.all.back.focus()">
<CENTER>
<table width=85% height=100% bgcolor=#b6b6b6 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center>
<H1>$_[1]</H1>
<P>&nbsp;<P>
<input type=button name=back value="$_[2]" onclick="top.frames.main.location='$_[3]'">
</table>
</CENTER>
</BODY>
</HTML>
EOF
}

sub news_add {
print <<EOF2;
Content-type: text/html

<html>
<head>
<title>Добавить новость</title>
<meta charset="windows-1251">
<LINK type="text/css" HREF="/rus/comsheet.css" rel="stylesheet">
</head>

<body bgcolor=#999999 onload="document.send.title.focus()">

<basefont face="arial narrow">
<center>
<table width=85% height=100% bgcolor=#b6b6b6 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center valign=top>

<table width=85% height=5 border=0 cellpadding=0 cellspacing=0>
<tr><td></td>
</table>

<table width=85% height=70 border=0 cellpadding=0 cellspacing=0>
<tr><td align=center ID=heading>Новости <Font face="Wingdings">?</Font></td>
</table>
<hr width=80%>

<table width=85% border=0 cellpadding=0 cellspacing=0>
<tr><td align=center>
Можно использовать следующие контейнеры для выделения слов:<BR/>
&lt;b&gt;<B> текст </B>&lt;/b&gt; и &lt;i&gt;<I> текст </I>&lt;/i&gt;
<form name=send method=post action="/cgi-bin/add_news.pl">
<input type=hidden name=user value="$FORM{'user'}">
<input type=hidden name=pass value="$FORM{'password'}">
<table border=0 width=95% cellspacing=10>
<tr>
<td><font size=+2>Тема:</font></td>
<td align=center valign=bottom colspan=3><input type=text size=40 name=title></td>
<tr>
<td><font size=+2>Сообщение:</font></td>
<td align=center colspan=3><textarea rows=8 cols=50 name=message></textarea></td>
<p>
<tr><td>&nbsp;</td>
    <td align=center><input type=submit value="Отправить"></td>
    <td align=center><input type=reset value="Очистить" onclick="document.send.title.focus()"></td>
    <td align=center><input type=button value="Назад" 
        onclick="document.location='/cgi-bin/show_news.pl?1+1'">
</td></tr>
</table>
</form>
</td></tr>
</table>
</td></tr>
</table>

</center>
</body>
</html>
EOF2
}

exit;