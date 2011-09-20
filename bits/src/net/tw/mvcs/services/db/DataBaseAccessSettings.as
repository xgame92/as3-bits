package net.tw.mvcs.services.db {
	import flash.filesystem.File;
	
	public class DataBaseAccessSettings implements IDataBaseAccessSettings {
		protected var _dbFile:File;
		public function DataBaseAccessSettings($dbFile:File) {
			trace($dbFile.nativePath);
			_dbFile=$dbFile;
		}
		
		public function get dbFile():File {
			return _dbFile;
		}
	}
}