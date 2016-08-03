<?php
$inst=fopen("instruction.csv","r");
$count=0;
echo "Convert List:<br />";
while (!feof($inst)) {
$count++;
$read_arr=fgetcsv($inst,0,';');
echo $find[$count]=$read_arr[0];
echo " -> ";
echo $replace[$count]=$read_arr[1];
echo "<br />";
}
fclose($inst);

for ($i=1;$i<$count;$i++) {
$repl_arr=file($find[$i]);
for ($j=1;$j<$count;$j++) {$repl_arr=str_replace($find[$j],$replace[$j],$repl_arr);};

$write=fopen("static/".$replace[$i],"w");
for ($j=0;$j<count($repl_arr);$j++) {fwrite($write,$repl_arr[$j]);}
fclose($write);
}


?>