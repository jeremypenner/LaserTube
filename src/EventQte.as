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
		public var qte:Qte;
		public function EventQte(qte:Qte) 
		{
			super(QTE);
			this.qte = qte;
		}
	}

}