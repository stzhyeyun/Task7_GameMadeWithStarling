<?php
$link = mysql_connect('localhost', 'root', 'bamkie072489');
if (!$link)
{
	die('Could not connect : ' . mysql_error());
}

$id = $_GET['id'];

// 유저 정보 가져오기
$result = mysql_query("SELECT * FROM HundredBlocksDB.User WHERE id = '$id'");

// 데이터 저장
$user = array();
while ($row = mysql_fetch_array($result))
{
	array_push($user, array(
		'id'=>$row[0],
		'name'=>$row[1],
		'score'=>$row[2],
		'numItem0'=>$row[3],
		'numItem1'=>$row[4],
		'latestPlay'=>$row[5]));
}
	
// 리턴
echo json_encode($user);

mysql_close($link);
?>