<?php
$link = mysql_connect('localhost', 'root', 'bamkie072489');
if (!$link)
{
	die('Could not connect : ' . mysql_error());
}

$utcNow = date("Y-m-d H:i:s");
$gmtNow = date("Y-m-d H:i:s", strtotime($utcNow . ' + 9 hours'));

// 현재 노출해야하는 공지 데이터 가져오기
$result = mysql_query(
	"SELECT * FROM HundredBlocksDB.Notice
	WHERE begin <= '$gmtNow' AND end >= '$gmtNow'
	ORDER BY priority ASC");

// 데이터 저장
$notice = array();
while ($row = mysql_fetch_array($result))
{
	array_push($notice, array('id'=>$row[0], 'name'=>$row[1], 'image'=>$row[2]));
}
	
// 리턴
echo json_encode($notice);

mysql_close($link);
?>