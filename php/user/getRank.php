<?php
$link = mysql_connect('localhost', 'root', 'bamkie072489');
if (!$link)
{
	die('Could not connect : ' . mysql_error());
}

$id = $_GET['id'];

$result = mysql_query("SELECT * FROM HundredBlocksDB.User WHERE id = '$id'");
$user = mysql_result($result, 0, 0);

if ($user)
{
    $result = mysql_query("SELECT score FROM HundredBlocksDB.User WHERE id = '$id'");
    $score = mysql_result($result, 0, 0);
    
    if ($score == 0) // 랭커가 아님 (클리어한 적이 없음)
    {
    	echo "0";
    }
    else
    {
	   	$result = mysql_query("SELECT count(*) FROM HundredBlocksDB.User WHERE score > '$score'");
	   	$rank = mysql_result($result, 0, 0);
		if ($rank >= 0)
		{
			$rank = $rank + 1;
			echo $rank;
		}
		else
		{
			echo "0";
		}
	}
}
else
{
	echo "0";
}

mysql_close($link);
?>