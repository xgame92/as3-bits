package net.tw.util.air {
	import flash.html.HTMLLoader;
	import com.adobe.htmlscout.DOMNode;
	import mx.utils.StringUtil;
	//
	public class HTMLFixer {
		public const ignoredTags:Vector.<String>=new Vector.<String>();
		public const autoClosedTags:Vector.<String>=new Vector.<String>();
		//
		protected var _htmlLoader:HTMLLoader;
		//
		public function HTMLFixer(l:HTMLLoader=null) {
			if (l) htmlLoader=l
			else _htmlLoader=new HTMLLoader();
			//
			ignoredTags.push('script', 'style');
			autoClosedTags.push('meta', 'img', 'br', 'hr', 'input', 'link', 'embed', 'param', 'wbr', 'base');
		}
		public function set htmlLoader(l:HTMLLoader):void {
			_htmlLoader=l;
		}
		public function get htmlLoader():HTMLLoader {
			return _htmlLoader;
		}
		public function getXML():XML {
			/*var x:XML=new XML(<html />);
			for (var i:int=0; i<namespaces.length; i++) {
				x.addNamespace(namespaces[i]);
			}
			x.appendChild(new XMLList(getFixedHTML(false)));
			return x;*/
			return new XML(getFixedHTML());
		}
		public function getHTML(wrapWithHTMLTag:Boolean=true):String {
			var s:String='';
			if (wrapWithHTMLTag) s+='<html>';
			s+=htmlLoader.window.document.documentElement.innerHTML;
			if (wrapWithHTMLTag) s+='</html>';
			return s;
		}
		public function getFixedHTML(wrapWithHTMLTag:Boolean=true):String {
			return fixHTML(getHTML(wrapWithHTMLTag));
		}
		protected function fixHTML(s:String):String {
			var i:int;
			for (i=0; i<ignoredTags.length; i++) {
				s=removeTag(s, ignoredTags[i]);
			}
			for (i=0; i<autoClosedTags.length; i++) {
				s=autoCloseTag(s, autoClosedTags[i]);
			}
			s=s.replace(/&nbsp;/g, ' ');
			s=s.replace(/&mdash;/g, '-');
			s=s.replace(/&copy;/g, '(c)');
			s=s.replace(/—/g, '-');
			s=s.replace(/©/g, '(c)');
			// NAMESPACES!
			s=s.replace(/<(\/)?(\w+):(.*?)/gs, '&lt;$1$2:$3');
			//
			return s;
		}
		protected function removeTag(s:String, tag:String):String {
			s=s.replace(new RegExp('<'+tag+'(.*?)<\\/'+tag+'>', 'gs'), '');
			s=s.replace(new RegExp('<'+tag+'(.*?)>', 'gs'), '');
			return s;
		}
		protected function autoCloseTag(s:String, tag:String):String {
			s=s.replace(new RegExp('<'+tag+' (.*?)>', 'gs'), '<'+tag+' $1 />');
			s=s.replace(new RegExp('<'+tag+'>', 'gs'), '<'+tag+'/>');
			return s;
		}
	}
}