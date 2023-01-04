package common
{
	import com.theriabook.rpc.remoting.RemoteObject;
	import mx.rpc.AbstractService;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import flash.events.EventDispatcher;
	import com.gs.fw.ema.common.utils.RpcUtils;
	
	public class RemoteObjectBase extends EventDispatcher
	{
		protected var m_svc         :* /*AbstractService*/;
		
		protected var __concurrency :String = "last";
		protected var __destination :String;		
		
		public function get __service():Object /*AbstractService*/
		{
			if( m_svc==null )
			{
				var ro:RemoteObject = new RemoteObject();
				if( __destination==null ) 
					throw new Error("Destination not specified");
				ro.destination = __destination;
				ro.concurrency = __concurrency;
				__service = ro;
			}
			return m_svc;
		}
		
		public function set __service(o:Object /*AbstractService*/):void
		{
			if( m_svc!=null )
			{
				// detach service
				m_svc.removeEventListener(FaultEvent.FAULT, __service_fault);
				m_svc.removeEventListener(ResultEvent.RESULT, __service_result);				
				RpcUtils.detach(m_svc);
			} 
			
			m_svc = o;
			
			if( m_svc!=null )
			{
				// attach service
				m_svc.addEventListener(FaultEvent.FAULT, __service_fault);
				m_svc.addEventListener(ResultEvent.RESULT, __service_result);				
				RpcUtils.attach(m_svc);
			}
		}
		
		protected function __service_fault(evt:FaultEvent):void
		{
			// dummy
		}

		protected function __service_result(evt:ResultEvent):void
		{
			// dummy
		}
	}
}