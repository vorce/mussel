function launchFullscreen(element) {
  if(element.requestFullscreen) {
    element.requestFullscreen();
  } else if(element.mozRequestFullScreen) {
    element.mozRequestFullScreen();
  } else if(element.webkitRequestFullscreen) {
    element.webkitRequestFullscreen();
  } else if(element.msRequestFullscreen) {
    element.msRequestFullscreen();
  }
}

function isFullscreened() {
    return document.fullscreenEnabled || document.mozFullScreenEnabled || document.webkitFullscreenEnabled;
}

// Ex:
// Launch fullscreen for browsers that support it!
// launchIntoFullscreen(document.documentElement); // the whole page
// launchIntoFullscreen(document.getElementById("videoElement")); // any individual element
