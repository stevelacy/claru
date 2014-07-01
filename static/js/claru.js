$(document).ready(function() {

	var socket = io();
	console.log(socket);
	var noteTitle = $("#noteTitle").text();

	var url = window.location.pathname;
	var id = url.substring(url.lastIndexOf("/") + 1);

	$("#newNoteDiv").hide();
	$("#noteSettings .menu").hide();
	$("#divDelete, #divShare").hide();

	$("#username").focus();


	var sendNote = function(note, noteTitle, id){
		socket.emit("note", {message:note, title:noteTitle, id:id});
	 
	};

	/* connect + disconnect*/
	socket.on('connect', function(){
    $('.message, .error').hide().text('');
    $('.message').show().text('Connected! :)').fadeOut();
  });
  socket.on('disconnect', function(){
    console.log("disconnected");
    $('.error').show().text('Error: Disconnected from Socket');
  });


	socket.on("note", function (note){
		if (id == note.id) {
			$("#noteContent").val(note.message);
			$("#noteTitle").val(note.title);
		}
	});


	$("#newNote").click(function(){
		$("#newNoteDiv").fadeToggle();
		$("#newNoteTitle").focus();
	});
	$("li .deleteItem").click(function(e){
		e.preventDefault();
		var itemId = $(this).attr("data-id");
		socket.emit("delete", {id:itemId});
		$(this).parent("li").fadeOut();

	});
	$(".divDelete .deleteItem").click(function(e){
		console.log(e);
		var itemId = $(this).attr("data-id");
		socket.emit("delete", {id:itemId});
		window.location = "/";

	});


	$("#share").click(function(){
		socket.emit("share", {share:$(this).attr("data-id")});
	});
	$("#unShare").click(function(){
		socket.emit("unshare", {unshare:$(this).attr("data-id")});
		console.log($(this).attr("data-id"));
	});
	$("#url").click(function(){
		$(this).select();
	});
	$("#noteSettings").click(function(){
		$("#noteSettings .menu").fadeToggle();
	});
	$("#menuShare").click(function(){
		$("#divShare").fadeToggle();
	});
	$("#menuDelete").click(function(){
		$("#divDelete").fadeToggle();
	});
	$("body #closeDiv").click(function(){
		$(this).parent().parent().fadeToggle();
	});

	$(".undo-text").click(function(){
		document.execCommand("undo", false, null);
	});
	$(".redo-text").click(function(){
		document.execCommand("redo", false, null);
	});

	$("#noteContent, #noteTitle").on("input", function(){
		var note = $("#noteContent").val();
		var noteTitle = $("#noteTitle").val();
		sendNote(note, noteTitle, id);
	});



	 

	// Check to see if it is the android app
	if (window.navigator.userAgent == "claru-app") {
		$("#menu, .share, #noteSettings, .notes-title").hide();
	}


	$("#login").click(function(){
		var username = $("#username").val();
		var pass = $("#pass").val();
		socket.emit("login", {username:username, pass:pass});
	});

});