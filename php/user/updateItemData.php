<?php
$link = mysql_connect('localhost', 'root', 'bamkie072489');
if (!$link)
{
	die('Could not connect : ' . mysql_error());
}

// 값 가져오기
$userId = $_GET['userId'];
$itemId = $_GET['itemId'];
$numItem = $_GET['numItem'];

// 해당 아이템 필드가 있는지 확인
$itemField = "numItem" . (string)$itemId;
$result = mysql_query("SHOW COLUMNS FROM HundredBlocksDB.User LIKE '$itemField'");
$field = mysql_fetch_row($result);

if (!empty($field))
{
	// 유저 정보 가져오기
	$result = mysql_query("SELECT * FROM HundredBlocksDB.User WHERE id = '$userId'");
	$user = mysql_result($result, 0, 0);
	
	if ($user)
	{
		// 아이템 정보 업데이트
		if ($numItem >= 0)
		{
			mysql_query(
				"UPDATE HundredBlocksDB.User
				SET $itemField = '$numItem'
				WHERE id = '$userId'");
		}
	}
}

mysql_close($link);
?>