package net.tw.util.air {
	import flash.html.HTMLLoader;
	import com.adobe.htmlscout.DOMNode;
	import mx.utils.StringUtil;
	//
	public class HTMLFixer {
		public const ignoredTags:Vector.<String>=new Vector.<String>();
		//
		protected var _doc:Object;
		//
		protected var _xml:XML;
		protected var _curXML:XML;
		//
		public function HTMLFixer() {}
		public function set document(d:Object):void {
			_doc=d;
		}
		public function get document():Object {
			return _doc;
		}
		public function get xml():XML {
			var rawSource:String=fixHTML('<html>'+document.documentElement.innerHTML+'</html>');
			return new XML(rawSource);
		}
		protected function fixHTML(s:String):String {
			for (var i:int=0; i<ignoredTags.length; i++) {
				s=removeTag(s, ignoredTags[i]);
			}
			s=s.replace(/<img(.*?)>/g, '<img $1/>');
			s=s.replace(/<br(.*?)>/g, '<br />');
			s=s.replace(/<hr(.*?)>/g, '<hr />');
			s=s.replace(/&nbsp;/g, ' ');
			s=s.replace(/&mdash;/g, '-');
			s=s.replace(/&copy;/g, '(c)');
			return s;
		}
		protected function removeTag(s:String, tag:String):String {
			s=s.replace(new RegExp('<'+tag+'(.*?)<\\/'+tag+'>', 'gs'), '');
			s=s.replace(new RegExp('<'+tag+'(.*?)>', 'gs'), '');
			return s;
		}
	}
}