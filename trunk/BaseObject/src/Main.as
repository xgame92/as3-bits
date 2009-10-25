package {
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import net.tw.util.air.BaseObject;
	/**
	 * @author Quentin T - http://toki-woki.net
	 */
	public class Main extends Sprite {
		public function Main():void {
			var sqlCon:SQLConnection=new SQLConnection();
			sqlCon.open(File.applicationDirectory.resolvePath('data.sqlite'));
			BaseObject.defaultConnection=sqlCon;
			var c1:BaseClient=BaseClient.getFromID(1) as BaseClient;
			trace(c1.id);
			var c2:BaseClient=BaseClient.getFromID(1);
			trace(c2.id, c2.getName());
			var c3:BaseClient=BaseClient.getFromID(2);
			trace(c3.id);
			//
			c3.setName('Yo!');
			trace(c3.getName());
			//
			var car1:BaseCar=BaseCar.getFromID(1);
			trace(car1.getSpeed());
			//car1.setSpeed(60);
			//
			var cars:Array=c3.getCars();
			trace(cars.length);
			cars[0].setPurchaseDate(new Date());
			cars[0].getClient().setMale(true);
			for (var i:uint=0; i<cars.length; i++) {
				var car:BaseCar=cars[i] as BaseCar;
				trace(' - ', car.id, car.getSpeed(), car.getBrand(), car.getPurchaseDate().fullYear, car.getClient().getMale());
			}
		}
	}
}