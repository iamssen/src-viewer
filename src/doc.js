function parseDoc() {
	var converter = new Showdown.converter();
	var scripts = document.getElementsByTagName("xmp");
	
	var f=-1;
	var fmax=scripts.length;
	var hash;
	var script;
	var div;
	var source;
	
	while(++f < fmax) {
		script=scripts[f];
		if (script.attributes.type !== undefined && script.attributes.type.nodeValue === "text/markdown") {
			hash=script.attributes.to.nodeValue;
			source=script.innerText;
//			source=source.replace(/</g, "&lt;");
//			source=source.replace(/>/g, "&gt;");
			div=document.getElementById(hash);
//			div.innerHTML=marked(source);
			div.innerHTML=converter.makeHtml(source);
		}
	}
}

parseDoc();
