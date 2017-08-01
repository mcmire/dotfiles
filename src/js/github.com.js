// All notifications are read, all the time
document.querySelectorAll(".mail-status").forEach(element => {
  element.classList.remove("unread");
});
