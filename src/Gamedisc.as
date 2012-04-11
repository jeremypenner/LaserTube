package  
{
	import com.adobe.serialization.json.JSON;
	import flash.display.IBitmapDrawable;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.sendToURL;
	import flash.net.URLLoader;
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
		public var typeVideotube:String;
		public var rgqte:Array;
		
		protected var urlPostQte:String;
		protected var csrf:String;
		protected var queuePost:Array;
		
		public function Gamedisc(urlVideo:String = null, typeVideotube:String = null) 
		{
			this.urlVideo = urlVideo;
			this.typeVideotube = typeVideotube;
			this.rgqte = [];
			this.urlPostQte = null;
			this.csrf = null;
			this.queuePost = [];
		}
		public function setUrlPost(urlPostQte:String, csrf:String):void {
			trace("setting url", urlPostQte, csrf);
			this.urlPostQte = urlPostQte;
			this.csrf = csrf;
		}
		public function fCanEdit():Boolean {
			return urlPostQte != null;
		}
		public function AddQte(qte:Qte, videotube:Videotube):void
		{
			var iqte:int = Math.abs(Util.binarySearch(rgqte, qte, Qte.compare));
			var cqteDrop:int = 0;
			while (true) {
				var iqteToDrop:int = iqte + cqteDrop;
				if (iqteToDrop >= rgqte.length)
					break;
				if (rgqte[iqteToDrop].secTrigger() <= qte.secTimeout()) {
					cqteDrop ++;
				} else {
					break;
				}
			}
			if (iqte > 0 && rgqte[iqte - 1].secTimeout() >= qte.secTrigger()) {
				iqte --;
				cqteDrop ++;
			}
			rgqte.splice(iqte, cqteDrop, qte);
			
			Util.assert(qte.secTrigger() == videotube.time());
			videotube.onQtesChanged(iqte + 1, qte);
		}
		public function DeleteQte(qte:Qte, videotube:Videotube):void
		{
			var iqte:int = Util.binarySearch(rgqte, qte, Qte.compare);
			Util.assert(iqte >= 0);
			rgqte.splice(iqte, 1);
			
			post("delete", { 'ms_trigger': qte.msTrigger } );
			videotube.onQtesChanged(iqte, null);
		}
		protected function post(action: String, val:Object):void {
			if (urlPostQte != null) {
				val['action'] = action;
				val['csrf'] = csrf;
				queuePost.push(JSON.encode(val));
				if (queuePost.length == 1) {
					doNextPost();
				}
			}
		}
		protected function doNextPost(): void {
			if (queuePost.length > 0) {
				var req:URLRequest = new URLRequest(urlPostQte);
				req.method = URLRequestMethod.POST;
				req.data = queuePost.shift();
				req.contentType = 'application/json';
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onPostComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onPostFailed);
				loader.load(req);
			}
		}
		protected function onPostComplete(event:Event): void {
			event.target.removeEventListener(Event.COMPLETE, onPostComplete);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, onPostFailed);
			try {
				var result:Object = JSON.decode(event.target.data);
				csrf = result.csrf;
				
				if (result.err != 'ok') {
					if (result.err == 'invalid') {
						reportError("Sorry, another browser has begun editing the video.");
					} else if (result.err == 'expired') {
						reportError("Sorry, your editing session has timed out.");
					} else {
						reportError();
					}
				} else {
					doNextPost();
				}
			} catch (e:Error) {
				trace(e);
				reportError();
			}
		}
		protected function onPostFailed(event:Event): void {
			event.target.removeEventListener(Event.COMPLETE, onPostComplete);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, onPostFailed);
			reportError();
		}
		protected function reportError(error:String = "Sorry, something weird happened.  It's my fault.  Reload the page to try again."): void {
			Main.instance.fatalError(error);
		}
		public function repostQte(qte:Qte): void
		{
			if (qte.fDirty && urlPostQte != null)
			{
				post("put", { 'qte': qte.ToJson() } );
				qte.fDirty = false;
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
		public function FromJson(json:Object):void
		{
			rgqte = [];
			for each (var jsonQte:Object in json.qtes)
			{
				var qte:Qte = new Qte();
				qte.FromJson(jsonQte);
				rgqte.push(qte);
			}
			urlVideo = json.url;
			typeVideotube = json.ktube;
		}
	}

}