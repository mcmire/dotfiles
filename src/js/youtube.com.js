(() => {
  const player = document.querySelector("#placeholder-player > div");
  const playerWidth = player.clientWidth;

  // Remove "up next". It sucks you in, and turns a two-minute YouTube session
  // into a two-hour one.
  const sidebar = document.querySelector("#watch7-sidebar");
  sidebar.remove();
  // Since the sidebar is gone, lengthen the title and description div.
  const titleAndDescription = document.querySelector("#watch7-content");
  titleAndDescription.clientWidth = playerWidth;
  // Center align title and description.
  const content = document.querySelector("#content");
  content.clientWidth = playerWidth;
  content.style.minWidth = "initial";
  // Expand details automatically.
  const details = document.querySelector("#action-panel-details");
  details.classList.remove("yt-uix-expander-collapsed");

  // "Home" is a cesspool of distraction. It's basically a bunch of videos that
  // YouTube thinks you should watch, but you probably shouldn't. Subscriptions
  // are the videos you actually want to watch. (Well, assuming you've culled
  // the list appropriately.)
  if (window.location.pathname === "/") {
    window.location.pathname = "/feed/subscriptions";
  }
})();
