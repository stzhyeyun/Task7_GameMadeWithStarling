package data
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;
	
	public class AesCrypto
	{
		public static function encrypt(rawData:String, key:String):String
		{
			var kdata:ByteArray = Hex.toArray(Hex.fromString(key));
			var rdata:ByteArray = Hex.toArray(Hex.fromString(rawData));
			var pad:IPad = new PKCS5();
			var mode:ICipher = Crypto.getCipher("aes-ecb", kdata, pad);
			pad.setBlockSize(mode.getBlockSize());
			mode.encrypt(rdata);
			
			return Hex.fromArray(rdata);
		}
		
		public static function decrypt(encData:String, key:String):String
		{
			var kdata:ByteArray = Hex.toArray(Hex.fromString(key));
			var rdata:ByteArray = Hex.toArray(encData);
			var pad:IPad = new PKCS5();
			var mode:ICipher = Crypto.getCipher("aes-ecb", kdata, pad);
			pad.setBlockSize(mode.getBlockSize());
			mode.decrypt(rdata);
			
			return Hex.toString(Hex.fromArray(rdata));
		}
	}
}