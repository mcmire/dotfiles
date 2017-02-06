(function () {
  var KEY_LEFT = 37;
  var KEY_RIGHT = 39;

  var previousLink =
    document.querySelector(".comic-pagination a:nth-of-type(2)");
  var nextLink =
    document.querySelector(".comic-pagination a:nth-of-type(3)");

  document.body.addEventListener("keyup", function (event) {
    if (event.keyCode === KEY_LEFT || event.keyCode === KEY_RIGHT) {
      if (event.keyCode === KEY_LEFT) {
        previousLink.click();
      } else {
        nextLink.click();
      }
    }
  });
})();
