var adres=document.getElementById("new-entry");
var list=document.getElementById("todo-list");


function set(event)
{
	if ( $( this ).hasClass( "normal" )){
		event.target.setAttribute("class","deleted");
		event.target.setAttribute("style","text-decoration:line-through");
	}else
	{event.target.setAttribute("class","normal");
	event.target.setAttribute("style","text-decoration:none");}
}

function addEntry()
{
	if(adres.value.length!=0){
		var el=document.createElement("li");
		el.addEventListener('click',set);
		el.setAttribute("style","text-decoration:none");
		el.setAttribute("class","normal");
		el.textContent=adres.value;
		list.appendChild(el);
	}
}
function deletList()
{
	$( "li" ).not( ".normal" ).remove();
}
var add=document.getElementById('btn-add');
var del=document.getElementById('btn-delete');
add.addEventListener('click',addEntry);
del.addEventListener('click',deletList);
adres.addEventListener("keydown", function (e) {
    if (e.keyCode === 13) {  //checks whether the pressed key is "Enter"
    	addEntry();
}
});
function zoznam()
{

	var zdroj=["prvy","druhy","treti"];
	for(var i=0;i<zdroj.length;i++){
		var el=document.createElement("li");
		el.addEventListener('click',set);
		el.setAttribute("style","text-decoration:none");
		el.setAttribute("class","normal");
		el.textContent=zdroj[i];
		list.appendChild(el);
	}
}