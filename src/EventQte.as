package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author jjp
	 */
	public class EventQte extends Event
	{
		public static const QTE:String = "qte";
		public static const QTE_TIMEOUT:String = "qte-timeout";
		public static const QTE_CANCEL:String = "qte-cancel";
		public var qte:Qte;
		public function EventQte(type:String, qte:Qte) 
		{
			super(type);
			this.qte = qte;
		}
	}

}