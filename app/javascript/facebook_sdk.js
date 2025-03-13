
window.fbAsyncInit = function() {
  FB.init({
    appId            : '1293328758418096',
    autoLogAppEvents : true,
    xfbml            : true,
    version          : 'v22.0'
  });
};

// Load the JavaScript SDK asynchronously
(function (d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "https://connect.facebook.net/en_US/sdk.js";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
