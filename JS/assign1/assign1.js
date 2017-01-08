$(document).ready(function(){
  function PrimeStatus()
  {
      var hash = {1: false};
      this.whetherPrime = function(number){
          sqRoot = Math.sqrt(number);
          if (!hash.hasOwnProperty(number))
          {
              for(var i = 2; i <= sqRoot; i++)
              {
                  if(number % i === 0)
                  {
                      hash[number] = false;
                      return false;
                  }
              }
          }
          else
          {
              return hash[number];
          }
          hash[number] = true;
          return true;
      };
  }
  var check = new PrimeStatus();
  $("#button").click(function(){
    var number = $("input[name=checkListItem]").val();
    if(!(isNaN(number)) && (number !== ""))
    {
      var bool = check.whetherPrime(number);
      if(bool)
        $(".list").append('<div class="item"> <h3>'+ number + ' is prime.</h3></div>');
      else
        $(".list").append('<div class="item"> <h3>' + number + ' is not a prime.</h3></div>');
    }
  });
  $(document).on('click','.item',function(){
      $(this).remove();
  });
});


//this.numbersChecked = function(){
//  for(var prop in hash)
//    console.log(prop + "->" + hash[prop]);
//};
