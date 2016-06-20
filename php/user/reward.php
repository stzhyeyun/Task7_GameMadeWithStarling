<?php
$link = mysql_connect('localhost', 'root', 'bamkie072489');
if (!$link)
{
	die('Could not connect : ' . mysql_error());
}

// 값 가져오기
$id = $_GET['id'];
$numItem0 = $_GET['numItem0'];
$numItem1 = $_GET['numItem1'];

$success = 0;

// 유저 정보 가져오기
$result = mysql_query("SELECT * FROM HundredBlocksDB.User WHERE id = '$id'");
$user =  mysql_fetch_assoc($result);

if ($user)
{
	$rewarded = 1;

	// 아이템 정보 업데이트
	if ($numItem0 > 0)
	{
		$currNumItem = $user['numItem0'];
		$updatedNumItem = $currNumItem + $numItem0;
		
		mysql_query(
			"UPDATE HundredBlocksDB.User
			SET numItem0 = '$updatedNumItem', rewarded = '$rewarded'
			WHERE id = '$id'");
			
		$success = 1;			
	}
	
	if ($numItem1 > 0)
	{
		$currNumItem = $user['numItem1'];
		$updatedNumItem = $currNumItem + $numItem1;
		
		mysql_query(
			"UPDATE HundredBlocksDB.User
			SET numItem1 = '$updatedNumItem', rewarded = '$rewarded'
			WHERE id = '$id'");
			
		$success = 1;
	}
}

echo $success;

mysql_close($link);
?>