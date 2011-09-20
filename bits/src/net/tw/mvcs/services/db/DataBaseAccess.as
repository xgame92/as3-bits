package net.tw.mvcs.services.db {
	import com.probertson.data.QueuedStatement;
	import com.probertson.data.SQLRunner;
	
	import flash.data.SQLResult;
	import flash.errors.SQLError;
	import flash.filesystem.File;

	public class DataBaseAccess {
		
		[Inject]
		public var settings:IDataBaseAccessSettings;
		
		protected var _sqlRunner:SQLRunner;

		[PostConstruct]
		public function init():void {
			_sqlRunner=new SQLRunner(settings.dbFile);
		}
		public function get sqlRunner():SQLRunner {
			return _sqlRunner;
		}
		public function execute(sql:String, parameters:Object, handler:Function=null, itemClass:Class=null):void {
			_sqlRunner.execute(sql, parameters, (handler is Function) ? handler : defaultExecuteHandler, itemClass);
		}
		public function execModif(statementBatch:Vector.<QueuedStatement>, resultHandler:Function=null):void {
			_sqlRunner.executeModify(statementBatch, resultHandler!=null ? resultHandler : defaultModifResultHandler, onQueryError);
		}
		public function close(resultHandler:Function=null):void {
			_sqlRunner.close(resultHandler!=null ? resultHandler : defaultCloseHandler, onQueryError);
		}
		protected function defaultModifResultHandler(res:Vector.<SQLResult>):void {
			// Do nothing.
			trace('defaultModifResultHandler', res);
		}
		protected function defaultExecuteHandler(res:SQLResult):void {
			// Do nothing.
			trace('defaultExecuteHandler', res);
		}
		protected function onQueryError(res:SQLError):void {
			trace('Query error!', res);
		}
		protected function defaultCloseHandler():void {
			trace('defaultCloseHandler');
		}
	}
}