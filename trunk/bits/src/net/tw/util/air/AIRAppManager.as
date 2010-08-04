package net.tw.util.air {
	import com.roguedevelopment.air.*;
	import net.tw.util.air.events.AIRAppManagerEvent;
	import net.tw.util.VersionUtil;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class AIRAppManager extends AIRBrowserRuntime {
		protected var _appID:String;
		protected var _pubID:String;
		protected var _installerURL:String;
		protected var _requiredRuntimeVersion:String;
		protected var _intalledAppVersion:String;
		protected var _configIsAvailable:Boolean;
		//
		public static const STATUS_AVAILABLE:String='available';
		public static const STATUS_UNAVAILABLE:String='unavailable';
		public static const STATUS_INSTALLED:String='installed';
		//
		public var appArguments:Array;
		//
		public function AIRAppManager($appID:String, $pubID:String='', $installerURL:String=null, $requiredRuntimeVersion:String='1.0') {
			setApplicationData($appID, $pubID);
			setInstallerData($installerURL, $requiredRuntimeVersion);
		}
		public function setApplicationData($appID:String, $pubID:String=''):void {
			_appID=$appID;
			_pubID=$pubID;
		}
		public function get appID():String {
			return _appID;
		}
		public function get pubID():String {
			return _pubID;
		}
		public function setInstallerData($installerURL:String, $requiredRuntimeVersion:String='1.0'):void {
			_installerURL=$installerURL;
			_requiredRuntimeVersion=$requiredRuntimeVersion;
		}
		public function get installerURL():String {
			return _installerURL;
		}
		public function get requiredRuntimeVersion():String {
			return _requiredRuntimeVersion;
		}
		public function install():void {
			installApplication(installerURL, requiredRuntimeVersion, appArguments);
		}
		public function launch():void {
			launchApplication(appID, pubID, appArguments);
		}
		public function get apiLoaded():Boolean {
			return airSWF!=null;
		}
		public function launchOrInstall():void {
			if (!configIsAvailable) return;
			if (installedAppVersion) launch();
			else install();
		}
		public function get runtimeStatus():String {
			return getStatus();
		}
		override public function load():void {
			addEventListener(AIRAppManagerEvent.CONFIG_GOT, onConfig);
			addEventListener(AIRBrowserRuntimeEvent.READY, onReady);
			super.load();
		}
		protected function onReady(e:AIRBrowserRuntimeEvent):void {
			removeEventListener(AIRBrowserRuntimeEvent.READY, onReady);
			if (runtimeStatus==STATUS_INSTALLED) {
				addEventListener(AIRBrowserRuntimeEvent.APP_VERSION_RESULT, onAppVersion);
				try {getApplicationVersion(appID, pubID);} catch (er:Error) {}
			} else {
				dispatchEvent(new AIRAppManagerEvent(AIRAppManagerEvent.CONFIG_GOT));
			}
		}
		public function get configIsAvailable():Boolean {
			return _configIsAvailable;
		}
		public function get installedAppVersion():String {
			return _intalledAppVersion;
		}
		public function needsInstallOrUpgrade(requiredAppVersion:String):Boolean {
			if (!appIsInstalled) return true;
			return VersionUtil.compare(requiredAppVersion, installedAppVersion);
		}
		public function get appIsInstalled():Boolean {
			return installedAppVersion!=null;
		}
		protected function onAppVersion(e:AIRBrowserRuntimeEvent):void {
			removeEventListener(AIRBrowserRuntimeEvent.APP_VERSION_RESULT, onAppVersion);
			_intalledAppVersion=e.detectedVersion;
			dispatchEvent(new AIRAppManagerEvent(AIRAppManagerEvent.CONFIG_GOT));
		}
		protected function onConfig(e:AIRAppManagerEvent):void {
			removeEventListener(AIRAppManagerEvent.CONFIG_GOT, onConfig);
			_configIsAvailable=true;
		}
	}
}