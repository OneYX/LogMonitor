<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="res"
	value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>Log4j在线监控</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<style>
pre {
	white-space: pre-wrap;
	word-wrap: break-word;
	color: #DDDDDD;
	font-family: Arial;
	width: 100%;
	height: 1000px;
	border: 0;
	background-color: #000000;
	overflow: auto
}
#result{
	margin-top:-15px;
	margin-bottom:100px;
}
.istyle {
	font-size: 14px;
	font-family: Arial;
}
</style>
<script type="text/javascript"
	src="${res}/resources/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		console.info("log4jmonitor init");
		var url = "${pageContext.request.contextPath}/log4jmonitor";
		$('#comet-frame')[0].src = url;
	});
	var ray = "<span class=\"waitray\">_</span>";
	window.setInterval(doRay, 500);
	var waitray = 0;
	function doRay(){
		waitray++;
		if(waitray == 1) $(".waitray").text("_");
		else if(waitray == 2) $(".waitray").text(" ");
		else{
			waitray = 0;
			$(".waitray").text("_");
		}
	}
	var contentData = "";
	//此方法由window.parent.update进行调用
	function update(data) {
		console.info(data);
		var color = "#00FFFF";
		if (data.indexOf('[INFO]') >= 0)
			color = "#3385FF";
		else if (data.indexOf('[WARN]') >= 0)
			color = "yellow";
		else if (data.indexOf('[ERROR]') >= 0)
			color = "red";
		data = data.replace("[", " [<font class='istyle' color='"+color+"'>");
		data = data.replace("]", "</font>]<font class='istyle'>");
		data += "</font>"
		var resultArea = $('#result')[0];
		contentData += data;
		resultArea.innerHTML = contentData + "&nbsp;&nbsp;"+ ray;
		contentData += "<br/>";
		/* $("#repre").scrollTo(0,$("#repre").scrollHeight)   */
	}
	function printNow(opt) {
		var day = "";
		var month = "";
		var ampm = "";
		var ampmhour = "";
		var year = "";
		var myHours = "";
		var myMinutes = "";
		var mySeconds = "";
		mydate = new Date();
		mymonth = parseInt(mydate.getMonth() + 1) < 10 ? "0"
				+ (mydate.getMonth() + 1) : mydate.getMonth() + 1;
		myday = mydate.getDate();
		myyear = mydate.getYear();
		myHours = mydate.getHours();
		myMinutes = mydate.getMinutes();
		mySeconds = parseInt(mydate.getSeconds()) < 10 ? "0"
				+ mydate.getSeconds() : mydate.getSeconds();
		year = (myyear > 200) ? myyear : 1900 + myyear;
		$(opt).text(
				year + "-" + mymonth + "-" + myday + " " + myHours + ":"
						+ myMinutes + ":" + mySeconds);
		setTimeout("printNow(\"" + opt + "\")", 1000);
	}
	printNow("#nowtime");
	var waitsign = 0;
	window.setInterval(dowait, 1000);
	function dowait() {
		if (waitsign == 6) {
			waitsign = 0;
			$("#waitspan").text(".");
		} else {
			$("#waitspan").text($("#waitspan").text() + ".");
			waitsign++;
		}
		
	}
</script>
</head>
<body style="margin:0; overflow:hidden">
	[
	<font class='istyle' color='red'>Log4j Monitor</font>
	]:
	<span id="nowtime"></span> 正在嗅探,请稍后(Sniffing,please hold on)
	<span id="waitspan"></span>
	<pre id="repre">
		<div id="result">&nbsp;&nbsp;<span class="waitray">_</span></div>
		<div id="scol" style="height:0px; overflow:hidden"><a id="res_end" name="1" href="#1">&nbsp</a></div>
	</pre>
	<iframe id="comet-frame" style="display: none;"></iframe>
</body>

<!-- 这是测试：定时请求/sniff，使系统产生日志 -->
<script>
$(function(){testlog();})
window.setInterval(testlog, 2000);
function testlog(){
	$.ajax({url:"/sniff",async:false});
}
</script>
</html>
