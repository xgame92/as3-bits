package net.tw.flex.util {
	import mx.core.FlexGlobals;
	import mx.styles.CSSStyleDeclaration;

	public function defaultComponentSkin(componentSelector:String, skinClass:Class):void {

		var styles:CSSStyleDeclaration=FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration(componentSelector);
		if (!styles) {
			var defStyles:CSSStyleDeclaration=new CSSStyleDeclaration();
			defStyles.defaultFactory=function ():void {
				this.skinClass=skinClass;
			}
			FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration(componentSelector, defStyles, true);
		} else if (!styles.getStyle('skinClass')) {
			styles.setStyle('skinClass', skinClass);
		}

	}
}