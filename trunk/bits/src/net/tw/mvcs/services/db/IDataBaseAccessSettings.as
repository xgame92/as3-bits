package net.tw.mvcs.services.db {
	import flash.filesystem.File;

	public interface IDataBaseAccessSettings {
		function get dbFile():File;
	}
}