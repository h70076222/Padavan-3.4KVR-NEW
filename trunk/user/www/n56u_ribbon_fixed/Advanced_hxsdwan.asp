<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_35#></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script>
var $j = jQuery.noConflict();
<% wireguard_status(); %>
<% login_state_hook(); %>
$j(document).ready(function() {
	
	init_itoggle('wireguard_enable');
	init_itoggle('wireguard_log');
	init_itoggle('wireguard_proxy');
	init_itoggle('wireguard_wg');
	init_itoggle('wireguard_first');
	init_itoggle('wireguard_finger');
	init_itoggle('wireguard_serverw');
	$j("#tab_wireguard_cfg, #tab_wireguard_pri, #tab_wireguard_sta, #tab_wireguard_log, #tab_wireguard_help").click(
	function () {
		var newHash = $j(this).attr('href').toLowerCase();
		showTab(newHash);
		return false;
	});

});


</script>
<script>

var m_routelist = [<% get_nvram_list("WIREGUARD", "WIREGUARDroute"); %>];
var mroutelist_ifield = 4;
if(m_routelist.length > 0){
	var m_routelist_ifield = m_routelist[0].length;
	for (var i = 0; i < m_routelist.length; i++) {
		m_routelist[i][mroutelist_ifield] = i;
	}
}

var m_mapplist = [<% get_nvram_list("WIREGUARD", "WIREGUARDmapp"); %>];
var mmapplist_ifield = 5;
if(m_mapplist.length > 0){
	var m_mapplist_ifield = m_mapplist[0].length;
	for (var i = 0; i < m_mapplist.length; i++) {
		m_mapplist[i][mmapplist_ifield] = i;
	}
}

function initial(){
	show_banner(2);
	show_menu(5,17,0);
	showmenu();
	show_footer();
	fill_status(wireguard_status());
	change_wireguard_enable(1);
	change_wireguard_model(1);
	if (!login_safe())
        		textarea_scripts_enabled(0);
}

function showmenu(){
	showhide_div('dtolink', found_app_ddnsto());
	showhide_div('zelink', found_app_zerotier());
}

function fill_status(status_code){
	var stext = "Unknown";
	if (status_code == 0)
		stext = "<#Stopped#>";
	else if (status_code == 1)
		stext = "<#Running#>";
	$("wireguard_status").innerHTML = '<span class="label label-' + (status_code != 0 ? 'success' : 'warning') + '">' + stext + '</span>';
}

var arrHashes = ["cfg","pri","sta","log","help"];
function showTab(curHash) {
	var obj = $('tab_wireguard_' + curHash.slice(1));
	if (obj == null || obj.style.display == 'none')
	curHash = '#cfg';
	for (var i = 0; i < arrHashes.length; i++) {
		if (curHash == ('#' + arrHashes[i])) {
			$j('#tab_wireguard_' + arrHashes[i]).parents('li').addClass('active');
			$j('#wnd_wireguard_' + arrHashes[i]).show();
		} else {
			$j('#wnd_wireguard_' + arrHashes[i]).hide();
			$j('#tab_wireguard_' + arrHashes[i]).parents('li').removeClass('active');
			}
		}
	window.location.hash = curHash;
}

function applyRule(){
	showLoading();
	
	document.form.action_mode.value = " Restart ";
	document.form.current_page.value = "/Advanced_hxsdwan.asp";
	document.form.next_page.value = "";
	
	document.form.submit();
}

function done_validating(action){
	refreshpage();
}

function textarea_scripts_enabled(v){
    	inputCtrl(document.form['scripts.wireguard.conf'], v);
}


function button_restartwireguard() {
    var m = document.form.hxsdwan_enable.value;

    var actionMode = (m == "1" || m == "2") ? ' Restartvntcli ' : ' Updatevntcli ';

    change_hxsdwan_enable(m); 

    var $j = jQuery.noConflict(); 
    $j.post('/apply.cgi', {
        'action_mode': actionMode 
    });
}

function markrouteRULES(o, c, b) {
	document.form.group_id.value = "WIREGUARDroute";
	if(b == " Add "){
		if (document.form.wireguard_routenum_x_0.value >= c){
			alert("<#JS_itemlimit1#> " + c + " <#JS_itemlimit2#>");
			return false;
		}else if (document.form.hxsdwan_route_x_0.value==""){
			alert("<#JS_fieldblank#>");
			document.form.wireguard_route_x_0.focus();
			document.form.wireguard_route_x_0.select();
			return false;
		}else if(document.form.wireguard_ip_x_0.value==""){
			alert("<#JS_fieldblank#>");
			document.form.wireguard_ip_x_0.focus();
			document.form.wireguard_ip_x_0.select();
			return false;
		}else{
			for(i=0; i<m_routelist.length; i++){
				if(document.form.wireguard_route_x_0.value==m_routelist[i][1]) {
				if(document.form.wireguard_ip_x_0.value==m_routelist[i][2]) {
					alert('<#JS_duplicate#>' + ' (' + m_routelist[i][1] + ')' );
					document.form.wireguard_route_x_0.focus();
					document.form.wireguard_ip_x_0.select();
					return false;
					}
				}
			}
		}
	}
	pageChanged = 0;
	document.form.action_mode.value = b;
	return true;
}

function button_wireguard_info(){
	var $j = jQuery.noConflict();
	$j('#btn_info').attr('disabled', 'disabled');
	$j.post('/apply.cgi', {
		'action_mode': ' CMDvpninfo ',
		'next_host': 'Advanced_hxsdwan.asp#sta'
	}).always(function() {
		setTimeout(function() {
			location.reload(); 
		}, 3000);
	});
}

function button_wireguard_all(){
	var $j = jQuery.noConflict();
	$j('#btn_all').attr('disabled', 'disabled');
	$j.post('/apply.cgi', {
		'action_mode': ' CMDvpnall ',
		'next_host': 'Advanced_hxsdwan.asp#sta'
	}).always(function() {
		setTimeout(function() {
			location.reload(); 
		}, 3000);
	});
}

function button_wireguard_list(){
	var $j = jQuery.noConflict();
	$j('#btn_list').attr('disabled', 'disabled');
	$j.post('/apply.cgi', {
		'action_mode': ' CMDvpnlist ',
		'next_host': 'Advanced_hxsdwan.asp#sta'
	}).always(function() {
		setTimeout(function() {
			location.reload(); 
		}, 3000);
	});
}

function button_wireguard_route(){
	var $j = jQuery.noConflict();
	$j('#btn_route').attr('disabled', 'disabled');
	$j.post('/apply.cgi', {
		'action_mode': ' CMDvpnroute ',
		'next_host': 'Advanced_hxsdwan.asp#sta'
	}).always(function() {
		setTimeout(function() {
			location.reload(); 
		}, 3000);
	});
}

function button_wireguard_status() {
	var $j = jQuery.noConflict();
	$j('#btn_status').attr('disabled', 'disabled');
	$j.post('/apply.cgi', {
		'action_mode': ' CMDvpnstatus ',
		'next_host': 'Advanced_hxsdwan.asp#sta'
	}).always(function() {
		setTimeout(function() {
			location.reload(); 
		}, 3000);
	});
}

</script>
</head>

<body onload="initial();" onunLoad="return unload_body();">

<div class="wrapper">
	<div class="container-fluid" style="padding-right: 0px">
		<div class="row-fluid">
			<div class="span3"><center><div id="logo"></div></center></div>
			<div class="span9" >
				<div id="TopBanner"></div>
			</div>
		</div>
	</div>

	<div id="Loading" class="popup_bg"></div>

	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

	<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">

	<input type="hidden" name="current_page" value="Advanced_hxsdwan.asp">
	<input type="hidden" name="next_page" value="">
	<input type="hidden" name="next_host" value="">
	<input type="hidden" name="sid_list" value="WIREGUARD;">
	<input type="hidden" name="group_id" value="">
	<input type="hidden" name="action_mode" value="">
	<input type="hidden" name="action_script" value="">


	<div class="container-fluid">
		<div class="row-fluid">
			<div class="span3">
				<!--Sidebar content-->
				<!--=====Beginning of Main Menu=====-->
				<div class="well sidebar-nav side_nav" style="padding: 0px;">
					<ul id="mainMenu" class="clearfix"></ul>
					<ul class="clearfix">
						<li>
							<div id="subMenu" class="accordion"></div>
						</li>
					</ul>
				</div>
			</div>

			<div class="span9">
				<!--Body content-->
				<div class="row-fluid">
					<div class="span12">
						<div class="box well grad_colour_dark_blue">
							<h2 class="box_head round_top"><#menu5_32#> - <#menu5_30#></h2>
							<div class="round_bottom">
							<div>
							    <ul class="nav nav-tabs" style="margin-bottom: 10px;">
								<li id="ddlink" style="display:none">
								<a href="Advanced_ddnsto.asp"><#menu5_32_1#></a>
								</li>
								<li id="zelink" style="display:none">
								    <a href="Advanced_vpnkey.asp"><#menu5_32_1#></a>
								</li>
								<li class="active">
								    <a href="Advanced_hxsdwan.asp"><#menu5_35_1#></a>
								</li>
								   <li><a id="tab_wireguard_sta" href="#sta">运行状态</a></li>
								</li>
							    </ul>
							</div>
								<div class="row-fluid">
									<div id="tabMenu" class="submenuBlock"></div>
									<div class="alert alert-info" style="margin: 10px;">
									<p>异地组网 是一个易于配置、快速且安全的开源VPN<br>
									</p>
									</div>
									<table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">


										<tr>
										<th width="30%" style="border-top: 0 none;">启用组网客户端</th>
											<td style="border-top: 0 none;">
													<div class="main_itoggle">
													<div id="wireguard_enable_on_of">
														<input type="checkbox" id="wireguard_enable_fake" <% nvram_match_x("", "wireguard_enable", "1", "value=1 checked"); %><% nvram_match_x("", "wireguard_enable", "0", "value=0"); %>  />
													</div>
												</div>
												<div style="position: absolute; margin-left: -10000px;">
													<input type="radio" value="1" name="wireguard_enable" id="wireguard_enable_1" class="input" value="1" <% nvram_match_x("", "wireguard_enable", "1", "checked"); %> /><#checkbox_Yes#>
													<input type="radio" value="0" name="wireguard_enable" id="wireguard_enable_0" class="input" value="0" <% nvram_match_x("", "wireguard_enable", "0", "checked"); %> /><#checkbox_No#>
												</div>
											</td>

										</tr>

										<tr>
										<th>本机识别码(不要改动) </th>
				<td>
					<input type="text" class="input" name="wireguard_key" id="wireguard_key" style="width: 200px" value="<% nvram_get_x("","wireguard_key"); %>" />
				</td>

										</tr>

										<tr>
										<th>设备名（格式 20）</th>
				<td>
					<input type="text" class="input" name="wireguard_naen" id="wireguard_naen" style="width: 60px" value="<% nvram_get_x("","wireguard_naen"); %>" />
				</td>

										</tr>
									
										<tr>
										<th>对端的IP（格式 192.168.x.0/24，10.26.0.x） </th>
				<td>
					<input type="text" class="input" name="wireguard_inip" id="wireguard_inip" style="width: 400px" value="<% nvram_get_x("","wireguard_inip"); %>" />
				</td>

										</tr>
										<tr>
										<th>本机虚拟ip（格式 10.26.0.x)</th>
				<td>
					<input type="text" class="input" name="wireguard_outip" id="wireguard_outip" style="width: 200px" value="<% nvram_get_x("","wireguard_outip"); %>" />
				</td>

										</tr>
										<tr>
										<th>服务器地址（默认不用填)</th>
				<td>
					<input type="text" class="input" name="wireguard_ttre" id="wireguard_ttre" style="width: 200px" value="<% nvram_get_x("","wireguard_ttre"); %>" />
				</td>

										</tr>
										<tr>
									
										<td colspan="4" style="border-top: 0 none;">
												<br />
												<center><input class="btn btn-primary" style="width: 219px" type="button" value="<#CTL_apply#>" onclick="applyRule()" /></center>
											</td>
										</tr>
</table>
</table>
</div>
	<!-- 状态 -->
	<div id="wnd_wireguard_sta" style="display:none">
	<table width="100%" cellpadding="4" cellspacing="0" class="table">
	<tr>
		<td colspan="3" style="border-top: 0 none; padding-bottom: 0px;">
			<textarea rows="21" class="span12" style="height:377px; font-family:'Courier New', Courier, mono; font-size:13px;" readonly="readonly" wrap="off" id="textarea"><% nvram_dump("vpn_cmd.log",""); %></textarea>
		</td>
	</tr>
	<tr>
		<td colspan="5" style="border-top: 0 none; text-align: center;">
			<!-- 按钮并排显示 -->
			<input class="btn btn-success" id="btn_info" style="width:100px; margin-right: 10px;" type="button" name="wireguard_info" value="本机设备信息" onclick="button_wireguard_info()" />
			<input class="btn btn-success" id="btn_all" style="width:100px; margin-right: 10px;" type="button" name="wireguard_all" value="所有设备信息" onclick="button_wireguard_all()" />
			<input class="btn btn-success" id="btn_list" style="width:100px; margin-right: 10px;" type="button" name="wireguard_list" value="所有设备列表" onclick="button_wireguard_list()" />
			<input class="btn btn-success" id="btn_route" style="width:100px; margin-right: 10px;" type="button" name="wireguard_route" value="路由转发信息" onclick="button_wireguard_route()" />
			<input class="btn btn-success" id="btn_status" style="width:100px; margin-right: 10px;" type="button" name="wireguard_status" value="运行状态信息" onclick="button_wireguard_status()" />
		</td>
	</tr>
	<tr>
		<td colspan="5" style="border-top: 0 none; text-align: center; padding-top: 5px;">
			<span style="color:#888;">🔄 点击上方按钮刷新查看</span>
		</td>
	        </td>
	</tr>
	</table>
	</table>
	</div>
	
	</div>
	</div>
	</div>
	</div>
	</div>
	</form>
	<div id="footer"></div>
	</div>
</body>

</html>
