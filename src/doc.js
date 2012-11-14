function parseDoc() {
	var scripts = document.getElementsByTagName("script");
	
	var f=-1;
	var fmax=scripts.length;
	var hash;
	var script;
	var div;
	
	while(++f < fmax) {
		script=scripts[f];
		if (script.type === "text/markdown") {
			hash=script.attributes.to.nodeValue;
			div=document.getElementById(hash);
			div.innerHTML=marked(script.innerText);
		}
	}
}

parseDoc();
