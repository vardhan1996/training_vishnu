$(document).ready(function(){
    var counter = 0;
    var width = 0;
    var id = setInterval(frame, 10*60*5);
    $("button").click(function(){
        $("textarea").html((++counter));
    });
    function frame(){
      if (width > 100) {
        clearInterval(id);
      } else {
        $("#myBar").width((width++) + '%');
      }
    }
});
