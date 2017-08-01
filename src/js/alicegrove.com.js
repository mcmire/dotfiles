(() => {
  const KEY_LEFT = 37;
  const KEY_RIGHT = 39;

  const previousLink =
    document.querySelector(".comic-pagination a:nth-of-type(2)");
  const nextLink =
    document.querySelector(".comic-pagination a:nth-of-type(3)");

  document.body.addEventListener("keyup", event => {
    if (event.keyCode === KEY_LEFT || event.keyCode === KEY_RIGHT) {
      if (event.keyCode === KEY_LEFT) {
        previousLink.click();
      } else {
        nextLink.click();
      }
    }
  });
})();
