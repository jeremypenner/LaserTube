package  
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author jjp
	 */
	public class Gamedisc
	{
		public static const VIDEOTUBE_FLV:String = "flv";
		public static const VIDEOTUBE_YOUTUBE:String = "yt";
		
		public var urlVideo:String;
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
			return { urlVideo: urlVideo, typeVideotube: typeVideotube, rgqte: jsonRgqte };
		}
		public function FromJson(json:Object):void
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
		}
	}

}