<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Web Chat</title>
<link href="/webjars/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/webjars/jquery/jquery.min.js"></script>
<script src="/webjars/sockjs-client/sockjs.min.js"></script>
<script src="/webjars/stomp-websocket/stomp.min.js"></script>
</head>
<body>
	<noscript>
		<h2 style="color: #ff0000">Seems your browser doesn't support
			Javascript! Websocket relies on Javascript being enabled. Please
			enable Javascript and reload this page!</h2>
	</noscript>
	<button type="button" class="btn btn-primary" id="setToken">Set Token</button>
	<div id="main-content" class="container">
		<div class="row">
			<div class="col-md-6">
				<form class="form-inline">
					<div class="form-group">
						<label for="connect">WebSocket connection:</label>
						<button id="connect" class="btn btn-default" type="submit">Connect</button>
						<button id="disconnect" class="btn btn-default" type="submit"
							disabled="disabled">Disconnect</button>
						<label for="connect" id="tokenid">Token: </label>
					</div>
				</form>
			</div>
			<div class="col-md-6">
				<form class="form-inline">
					<div class="form-group">
						<label for="name">What is your name?</label> <input type="text"
							id="name" class="form-control" placeholder="Your name here...">
					</div>
					<button id="send" class="btn btn-default" type="submit">Send</button>
				</form>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<table id="conversation" class="table table-striped">
					<thead>
						<tr>
							<th>Greetings</th>
						</tr>
					</thead>
					<tbody id="greetings">
					</tbody>
				</table>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		var stompClient = null;
		var token = localStorage.getItem("token-webchat");
		$("#tokenid").html("Token: ", token);

		function setConnected(connected) {
			$("#connect").prop("disabled", connected);
			$("#disconnect").prop("disabled", !connected);
			if (connected) {
				$("#conversation").show();
			} else {
				$("#conversation").hide();
			}
			$("#greetings").html("");
		}

		function connect() {
			var socket = new SockJS('/gs-guide-websocket');
			stompClient = Stomp.over(socket);
			stompClient.connect({}, function(frame) {
				setConnected(true);
				console.log('Connected: ' + frame);
				stompClient.subscribe('/topic/greetings', function(greeting) {
					if(JSON.parse(greeting.body).token == "12e544f"){
						showGreeting(JSON.parse(greeting.body).content);
					}
				});
			});
		}

		function disconnect() {
			if (stompClient !== null) {
				stompClient.disconnect();
			}
			setConnected(false);
			console.log("Disconnected");
		}

		function sendName() {
			stompClient.send("/app/hello", {}, JSON.stringify(
				{
					'name' : $("#name").val(),
					'token': localStorage.getItem("token-webchat")
				}
			));
		}

		function showGreeting(message) {
			$("#greetings").append("<tr><td>" + message + "</td></tr>");
		}
		function setToken(){
			let token = prompt("Please enter your name", "12e544f");

			localStorage.setItem("token-webchat", token);
		}

		$(function() {
			$("form").on('submit', function(e) {
				e.preventDefault();
			});
			$("#connect").click(function() {
				connect();
			});
			$("#disconnect").click(function() {
				disconnect();
			});
			$("#send").click(function() {
				sendName();
			});
			$("#setToken").click(function(){
				setToken();
			});
		});
	</script>
</body>
</html>