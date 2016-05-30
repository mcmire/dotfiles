(function () {
  var playerWidth = $("#placeholder-player > div").width();

  // Remove "up next". It sucks you in, and turns a two-minute YouTube session
  // into a two-hour one.
  $("#watch7-sidebar").remove()
  // Since the sidebar is gone, lengthen the title and description div.
  $("#watch7-content").width(playerWidth);
  // Center align title and description.
  $("#content").width(playerWidth).css("min-width", "initial");
  // Expand details automatically.
  $("#action-panel-details").removeClass("yt-uix-expander-collapsed");

  // "Home" is a cesspool of distraction. It's basically a bunch of videos that
  // YouTube thinks you should watch, but you probably shouldn't. Subscriptions
  // are the videos you actually want to watch. (Well, assuming you've culled
  // the list appropriately.)
  if (window.location.pathname === "/") {
    window.location.pathname = "/feed/subscriptions";
  }
})()
