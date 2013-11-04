$(document).ready(function() {

//var socket = io.connect("http://192.168.0.5:5000");
var socket = io.connect("http://node.la:5000");

var noteTitle = $("#noteTitle").text();

var url = window.location.pathname;
var id = url.substring(url.lastIndexOf('/') + 1);



 $("#newNoteDiv").hide();

 $("#username").focus();




var sendNote = function(note, noteTitle, id){
 	socket.emit("note", {message:note, title:noteTitle, id:id});
 
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





 $("#newNote, #closeNewNote").click(function(){
 	$("#newNoteDiv").fadeToggle();
 	$("#newNoteTitle").focus();
 })
 $("#deleteItem").click(function(e){
		e.preventDefault();
		var itemId = $(this).attr("data-id");
		socket.emit("delete", {id:itemId});
		$(this).parent("li").fadeOut();
 	 
 })


$("#noteContent, #noteTitle").on('input', function(){
	var note = $("#noteContent").val();
	var noteTitle = $("#noteTitle").val();
	sendNote(note, noteTitle, id);
})



 












$("#login").click(function(){
	var username = $("#username").val();
	var pass = $("#pass").val();
	socket.emit("login", {username:username, pass:pass});
})




});