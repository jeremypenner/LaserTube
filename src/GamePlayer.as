package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author jjp
	 */
	public class GamePlayer extends Sprite
	{
		private var videotube:Videotube;
		private var gamedisc:Gamedisc;
		private var clickarea:ClickArea;
		private var textDeath:TextField;
		
		public function GamePlayer(videotube:Videotube, gamedisc:Gamedisc) 
		{
			this.videotube = videotube;
			this.gamedisc = gamedisc;
			clickarea = null;
			textDeath = null;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, cleanup);
			
			addEventListener(MouseEvent.CLICK, onClick);
			videotube.addEventListener(EventQte.QTE, onQte);
			videotube.addEventListener(EventQte.QTE_TIMEOUT, onTimeout);
		}
		private function cleanup(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, cleanup);
			removeEventListener(MouseEvent.CLICK, onClick);
			videotube.removeEventListener(EventQte.QTE, onQte);
		}
		private function onQte(e:EventQte):void
		{
			clearClickarea();
			clickarea = new ClickArea(e.qte.rgpoint, 0xffff00, 0.7);
			addChild(clickarea);
		}
		private function onTimeout(e:EventQte):void
		{
			if (clickarea != null)
			{
				videotube.pause();
				textDeath = new TextField();
				textDeath.htmlText = "<p align='center'>YOU ARE DEAD</p>";
				textDeath.wordWrap = true;
				textDeath.background = true;
				textDeath.backgroundColor = 0x0000FF;
				textDeath.width = stage.stageWidth;
				textDeath.height = stage.stageHeight;
				textDeath.setTextFormat(new TextFormat(null, 164, 0xFF0000));
				addChild(textDeath);
			}
			clearClickarea();
		}
		private function onClick(mouse:MouseEvent):void
		{
			if (clickarea != null && clickarea.FHit(new Point(mouse.stageX, mouse.stageY)))
				clearClickarea();
		}
		private function clearClickarea():void
		{
			if (clickarea != null)
			{
				removeChild(clickarea);
				clickarea = null;
			}
		}
	}

}