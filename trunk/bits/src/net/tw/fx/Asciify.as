/**
 * Asciify
 * Actionscript 3 Class for creating Ascii Art from DisplayObjects
 *
 * @author		Pierluigi Pesenti
 * @version		1.0
 */

/*
Licensed under the MIT License

Copyright (c) 2008 Pierluigi Pesenti

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

http://blog.oaxoa.com/
*/

package net.tw.fx {

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.system.System;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Asciify extends Sprite {

		private var _font:Font;
		private var _bd:BitmapData;
		private var _tfield:TextField;

		private var _tformat:TextFormat;
		private var _tformatSample:TextFormat;
		private var _picW:uint;
		private var _picH:uint;
		private var _pixels:Array;
		private var _charsX:uint;
		private var _pixelSize:Number;
		private var _colors:Array;
		private var _chars:Array;
		private var _matrix:Matrix;
		private var _targetClip:DisplayObject;
		private var _negative:Boolean;

		public function Asciify(targetClip:DisplayObject, tformat:TextFormat, pixelSize:Number=8, negative:Boolean=false) {
			
			_tformat=tformat;
			_negative=negative;
			
			initFormats();
			sampleChars();

			_targetClip=targetClip;
			_pixelSize=pixelSize;

			var initw:Number=targetClip.width;
			var inith:Number=targetClip.height;
			
			targetClip.visible=false;

			_picW=initw/_pixelSize;
			_picH=inith/_pixelSize;

			
			_matrix=new Matrix();
			_matrix.scale(1/_pixelSize, 1/_pixelSize);
			
			_tfield=new TextField();
			_tfield.width=10;
			_tfield.height=10;
			_tfield.multiline=true;
			_tfield.wordWrap=false;
			_tfield.selectable=false;
			//_tfield.antiAliasType=AntiAliasType.ADVANCED;
			
			_tfield.embedFonts=true;
			_tfield.text="";
			_tfield.defaultTextFormat=_tformat;
			
			//mouseEnabled=false;
			_tfield.mouseEnabled=false;
			
			
			_tfield.autoSize=TextFieldAutoSize.LEFT;

			_bd=new BitmapData(_picW, _picH);
			
			addChild(_tfield);
			
			render();
		}
		
		public function copyContentsToClipboard():void {
			System.setClipboard(copyContents());
		}
		public function copyContents():String {
			return _tfield.text;
		}
		
		public function render():void {
			_tfield.text="";
			var output:String="";
			
			var i:uint;
			var j:uint;
			
			_bd.draw(_targetClip, _matrix);

			_pixels=[];
			var row:Array;
			var sampledColor:Number;

			for (i=0; i<_picH; i++) {
				row=[];
				for (j=0; j<_picW; j++) {
					sampledColor=_bd.getPixel(j, i);
					if(_negative) sampledColor=0xffffff-sampledColor;
					row.push(sampledColor);
				}
				_pixels.push(row);
			}
			
			var color:Number;
			var rgb:Object;
			var avg:Number;
			
			for (i=0; i<_picH; i++) {
				for (j=0; j<_picW; j++) {
					color=_pixels[i][j];
					rgb=hex2rgb(color);
					avg=rgb.r+rgb.g+rgb.b;
					output+=getCharFromColor(avg);
					
				}
				output+="\r\n";
			}
			
			_tfield.text=output;
			
		}
		public function get textField():TextField {
			return _tfield;
		}
		private function initFormats():void {
			_tformatSample=new TextFormat();
			_tformatSample.font=_tformat.font;
			_tformatSample.size=_tformat.size;
			_tformatSample.color=0;
		}
		private function sampleChars():void {
			_colors=[];
			_chars=[];

			var i:uint;
			var c:uint=0;

			var mini:uint=32;
			var maxi:uint=256;
			
			for (i=mini; i<maxi; i++) {
				_colors.push(c);
				c+=3;
			}
			var d:uint;
			var cc:String;
			for (i=mini; i<maxi; i++) {
				if (i>=127 && i<=159) {
					cc=' ';
					d=0;
				} else {
					cc=String.fromCharCode(i);
					d=getDarkness(cc);
				}
				_chars.push({char:cc, darkness:d});
			}
			_chars.sortOn('darkness', Array.NUMERIC | Array.DESCENDING);
		}
		private function getDarkness(char:String):uint {
			var i:uint;
			var j:uint;

			var tf:TextField=new TextField();
			tf.defaultTextFormat=_tformatSample;
			tf.text=char;
			tf.embedFonts=true;
			tf.autoSize="left";

			var w:uint=tf.width;
			var h:uint=tf.height;

			var bd:BitmapData=new BitmapData(w, h);
			bd.draw(tf);

			var darkness:uint=0;

			for (i=0; i<h; i++) {
				for (j=0; j<w; j++) {
					var col:uint=bd.getPixel(j, i);
					if (col<0x333333) {
						darkness++;
					}
				}
			}
			return darkness;
		}

		private function hex2rgb(hex:Number):Object {
			var r:Number;
			var g:Number;
			var b:Number;
			r = (0xFF0000 & hex) >> 16;
			g = (0x00FF00 & hex) >> 8;
			b = (0x0000FF & hex);
			return {r:r,g:g,b:b};
		}
		private function getCharFromColor(arg:uint):String {
			if (arg==255) return ' ';
			var i:uint=0;
			for each (var col:uint in _colors) {
				if (arg<=col) return _chars[i].char;
				i++;
			}
			return ' ';
		}
		
	}
}