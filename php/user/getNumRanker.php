<?php
$link = mysql_connect('localhost', 'root', 'bamkie072489');
if (!$link)
{
	die('Could not connect : ' . mysql_error());
}

$result = mysql_query("SELECT * FROM HundredBlocksDB.User WHERE score > 0");
$count = mysql_num_rows($result);

echo $count;

mysql_close($link);
?>