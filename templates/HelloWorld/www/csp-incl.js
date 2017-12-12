/**
 * Created on 18/02/2016.
 */

function injectCSP() {
	var meta = document.createElement('meta');
	meta.httpEquiv = "Content-Security-Policy";
	meta.content = "default-src 'self' data: gap: https://*.googleapis.com https://ssl.gstatic.com http://*.libertymutual-cdn.com http://*.libertymutual-cdn.com http://*.libertymutual.com https://*.libertymutual.com https://*.ensighten.com 'unsafe-eval' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; media-src *";
	document.getElementsByTagName('head')[0].appendChild(meta);
}


// Not CSP, but only here we can inject button to go to app's home
function onLoad() {
	document.getElementById("middle").insertAdjacentHTML('afterbegin', '<a href="../SalesAndServiceApplication.html" class="topcoat-button">App Home</a>');
}



injectCSP();
window.onload = onLoad;