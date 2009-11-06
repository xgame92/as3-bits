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
			//
			var myClient:Client=Client.create({name:'Joe', url:'http://www.yep.com', male:true});
			myClient.setName('Mark');
			myClient.update({name:'Jack', url:'http://www.yo.net'});
			trace(myClient.getUrl(), myClient.getName());
			//
			var males:Array=Client.getFromQuery('SELECT * FROM client WHERE male=@male', {'@male':true});
			trace(males.length);
			//
			/*var c1:Client=Client.getFromID(1);
			var c2:Client=Client.getFromID(1);
			var c3:Client=Client.getFromID(2);
			//
			c3.addEventListener(BaseObjectEvent.CHANGE, onChange);
			c3.update({name:'Paul', url:'http://test.com'});
			//
			c3.setName('John');
			trace(c3.getName());
			//
			var car1:Car=Car.getFromID(1);
			trace(car1.getSpeed());
			//
			var cars:Array=c3.getCars();
			trace(cars.length);
			for (var i:uint=0; i<cars.length; i++) {
				var car:Car=cars[i] as Car;
				trace(' - ', car.id, car.getSpeed(), car.getBrand(), car.getPurchaseDate().fullYear, car.getClient().getMale());
			}*/
		}
		private function onChange(e:BaseObjectEvent):void {
			trace(e, e.changedField, e.target.getField(e.changedField));
		}
	}
}