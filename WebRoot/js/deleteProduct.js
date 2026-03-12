$(document).ready(function() {
	$(document).on("click", ".product-delete, #delete", function(e){
		e.preventDefault();
		var id = $(this).data("id") || $(this).attr("href");
		if(!id || id === "#") return;
		if(confirm("确认删除吗？")){
			$.post("/product/delete", { "id": id }, function(data) {
				if(data=="yes"){
					alert("删除成功");
					$(e.target).closest("tr").remove();
				}else{
					alert("删除不成功，请刷新页面");
				}
			});
		}
		return false;
	});
});