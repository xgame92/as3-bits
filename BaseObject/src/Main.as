package {
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import net.tw.util.air.BaseObject;
	import net.tw.util.air.events.BaseObjectEvent;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class Main extends Sprite {
		public function Main():void {
			var sqlCon:SQLConnection=new SQLConnection();
			sqlCon.open(File.applicationDirectory.resolvePath('data.sqlite'));
			BaseObject.defaultConnection=sqlCon;
			var c1:BaseClient=BaseClient.getFromID(1) as BaseClient;
			//trace(c1.id);
			var c2:BaseClient=BaseClient.getFromID(1);
			//trace(c2.id, c2.getName());
			var c3:BaseClient=BaseClient.getFromID(2);
			c3.addEventListener(BaseObjectEvent.CHANGE, onChange);
			c3.update({name:'aabc', url:'test.com'});
			trace(c3.id);
			//
			c3.setName('Yeah!');
			trace(c3.getName());
			//
			var car1:BaseCar=BaseCar.getFromID(1);
			trace(car1.getSpeed());
			//car1.setSpeed(60);
			//
			traceTime();
			var cars:Array=c3.getCars();
			traceTime();
			trace(cars.length);
			cars[0].setPurchaseDate(new Date());
			cars[0].getClient().setMale(true);
			for (var i:uint=0; i<cars.length; i++) {
				var car:BaseCar=cars[i] as BaseCar;
				trace(' - ', car.id, car.getSpeed(), car.getBrand(), car.getPurchaseDate().fullYear, car.getClient().getMale());
			}
			traceTime();
			trace(c3.getCars().length);
			traceTime();
			trace(c3.getCars().length);
			traceTime();
			trace(c3.getCars().length);
			traceTime();
			trace(c3.getCars().length);
			traceTime();
		}
		protected function traceTime():void {
			var d:Date=new Date();
			trace('Time', d.seconds, d.milliseconds);
		}
		private function onChange(e:BaseObjectEvent):void {
			trace(e, e.changedField, e.target.getField(e.changedField));
		}
	}
}