(function(){ 

    $(document).ready(function () {
	    $("#select-files").click(function(){
		    $("#image_").click(); 
		});
	    $("#image_").change(function(){
		    var s = "";
		    var files = $('input[type="file"]')[0].files;
		    for (var i = 0; i < files.length; i++) {
			s += files[i].name + "; ";
		    }
		    $("#filenames").val(s);
		});
	});

})();