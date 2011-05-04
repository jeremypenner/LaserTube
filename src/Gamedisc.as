package  
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author jjp
	 */
	public class Gamedisc
	{
		public var urlVideo:String;
		public var rgqte:Array;
		public function Gamedisc(urlVideo:String) 
		{
			this.urlVideo = urlVideo;
			this.rgqte = [];
		}
		public function AddQte(qte:Qte):void
		{
			rgqte.splice(Math.abs(Util.binarySearch(rgqte, qte, Qte.compare)), 0, qte);
		}
		public function CreateVideotube():Videotube
		{
			return new VideotubeFlv(this);
		}
		public function ToJson():Object
		{
			var jsonRgqte:Array = [];
			for each (var qte:Qte in rgqte)
				jsonRgqte.push(qte.ToJson());
			return { urlVideo: urlVideo, rgqte: jsonRgqte };
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
		}
	}

}