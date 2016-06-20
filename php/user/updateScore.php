<?php
$link = mysql_connect('localhost', 'root', 'bamkie072489');
if (!$link)
{
	die('Could not connect : ' . mysql_error());
}

// 값 가져오기
$id = $_GET['id'];
$score = $_GET['score'];

// 유저 정보 가져오기
$result = mysql_query("SELECT * FROM HundredBlocksDB.User WHERE id = '$id'");
$user = mysql_result($result, 0, 0);

if ($user)
{
    $result = mysql_query("SELECT score FROM HundredBlocksDB.User WHERE id = '$id'");
    $rankedScore = mysql_result($result, 0, 0);
    
    if ($rankedScore < $score)
    {
    	mysql_query("UPDATE HundredBlocksDB.User SET score = '$score' WHERE id = '$id'");
    	
    	$result = mysql_query("SELECT count(*) FROM HundredBlocksDB.User WHERE score > '$score'");
    	$rank = mysql_result($result, 0, 0);
    	if ($rank)
		{
			$rank = $rank + 1;
    		echo $rank;
		}
		else
		{
			die('Could not query :' . mysql_error());
		}
    }
    else
    {
    	echo "0";
    }
}

mysql_close($link);
?>