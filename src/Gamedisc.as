package  
{
	import com.adobe.serialization.json.JSON;
	import flash.events.EventDispatcher;
	import flash.net.sendToURL;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author jjp
	 */
	public class Gamedisc
	{
		public static const VIDEOTUBE_FLV:String = "flv";
		public static const VIDEOTUBE_YOUTUBE:String = "yt";
		
		public var urlVideo:String;
		public var urlPostQte:String;
		public var headerPostQte:Object;
		public var typeVideotube:String;
		public var rgqte:Array;
		public function Gamedisc(urlVideo:String = null, typeVideotube:String = null) 
		{
			this.urlVideo = urlVideo;
			this.typeVideotube = typeVideotube;
			this.rgqte = [];
		}
		public function AddQte(qte:Qte):void
		{
			rgqte.splice(Math.abs(Util.binarySearch(rgqte, qte, Qte.compare)), 0, qte);
			if (urlPostQte != null)
			{
				var req:URLRequest = new URLRequest(urlPostQte);
				req.method = URLRequestMethod.POST;
				for (var key:String in headerPostQte)
					req.requestHeaders.push(new URLRequestHeader(key, headerPostQte[key]));
				var data:URLVariables = new URLVariables();
				data.qte = JSON.encode(qte.ToJson());
				req.data = data;
				sendToURL(req);
			}
		}
		public function CreateVideotube():Videotube
		{
			if (typeVideotube == VIDEOTUBE_FLV)
				return new VideotubeFlv(this);
			if (typeVideotube == VIDEOTUBE_YOUTUBE)
				return new VideotubeYt(this);
			throw "invalid videotube type";
		}
		public function ToJson():Object
		{
			var jsonRgqte:Array = [];
			for each (var qte:Qte in rgqte)
				jsonRgqte.push(qte.ToJson());
			var json:Object = { urlVideo: urlVideo, typeVideotube: typeVideotube, rgqte: jsonRgqte };
			if (urlPostQte != null)
				json.urlPostQte = urlPostQte;
			return json;
		}
		public function FromJson(json:Object, jsonPostHeaders:Object):void
		{
			rgqte = [];
			for each (var jsonQte:Object in json.rgqte)
			{
				var qte:Qte = new Qte();
				qte.FromJson(jsonQte);
				rgqte.push(qte);
			}
			urlVideo = json.urlVideo;
			typeVideotube = json.typeVideotube;
			urlPostQte = json.urlPostQte;
			headerPostQte = jsonPostHeaders;
		}
	}

}