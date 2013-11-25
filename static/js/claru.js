$(document).ready(function() {

var host = "node.la";
var socket = io.connect("http://"+ host +":5000");

var noteTitle = $("#noteTitle").text();

var url = window.location.pathname;
var id = url.substring(url.lastIndexOf("/") + 1);



 $("#newNoteDiv").hide();
 $("#noteSettings .menu").hide();
 $("#divDelete, #divShare").hide();

 $("#username").focus();




var sendNote = function(note, noteTitle, id){
 	socket.emit("note", {message:note, title:noteTitle, id:id});
 
}
var saveTodoitem = function(title){
	socket.emit("todoitem", {todoid:id, title:title});
}
socket.on("save", function (save){
	var saveDiv = $("#save");
	saveDiv.show().text(save).delay(1000).fadeOut();

 
})
socket.on("note", function (note){
	if (id == note.id) {
		$("#noteContent").val(note.message);
		$("#noteTitle").val(note.title);
	}
})
socket.on("share", function (url){
	$("#share").replaceWith("<div class='al-right'>Public URL:<input type='text' id='url' value='"+ host + "/" + url.share +"'></div>");
})
socket.on("unshare", function (url){
	$("#divShare").fadeToggle();
})

socket.on("todoitem", function(item){
	$("#todoDiv").append('<div class="checkboxDiv box-shadow-light"><input type="checkbox"><span> '+ item.item.title +'</span></div>');
})




$("#newNote").click(function(){
 	$("#newNoteDiv").fadeToggle();
 	$("#newNoteTitle").focus();
 })
$("li #deleteItem").click(function(e){
		e.preventDefault();
		var itemId = $(this).attr("data-id");
		socket.emit("delete", {id:itemId});
		$(this).parent("li").fadeOut();
 	 
 })
$("#share").click(function(){
	socket.emit("share", {share:$(this).attr("data-id")})
})
$("#unShare").click(function(){
	socket.emit("unshare", {unshare:$(this).attr("data-id")})
	console.log($(this).attr("data-id"))
})
$("#url").click(function(){
	$(this).select()
})
$("#noteSettings").click(function(){
	$("#noteSettings .menu").fadeToggle();
})
$("#menuShare").click(function(){
	$("#divShare").fadeToggle();
})
$("#menuDelete").click(function(){
	$("#divDelete").fadeToggle();
})
$("body #closeDiv").click(function(){
	$(this).parent().parent().fadeToggle();
})

$("body #todoitemtitle").click(function(){
	$(this).replaceWith("<input type='text' #saveTodoitem value='"+ $(this).text() +"' class='todoitemtitle' >")
})


$("body #todoitem").bind('keypress', function(e) {
	var code = e.keyCode || e.which;
	 if(code == 13) { 
	 	saveTodoitem($(this).val());
	 }
})


$("#noteContent, #noteTitle").on("input", function(){
	var note = $("#noteContent").val();
	var noteTitle = $("#noteTitle").val();
	sendNote(note, noteTitle, id);
})



 

// Check to see if it is the android app
if (window.navigator.userAgent == "claru-app") {
	$("#menu, .share, #noteSettings").hide()
}





$("#login").click(function(){
	var username = $("#username").val();
	var pass = $("#pass").val();
	socket.emit("login", {username:username, pass:pass});
})


// drag the li to delete TODO: send the socket delete
$(".noteList li").on("draginit", function(e, drag){
	e.preventDefault()
	drag.horizontal();
	drag.revert();
	var itemId = $(this).find("#deleteItem").attr("data-id");
	//socket.emit("delete", {id:itemId});
	//$(this).fadeOut()
})



});