// default IServiceProvider implementation

import flash.utils.Dictionary;

private var m_mapSvc:flash.utils.Dictionary;
private var m_chain:Array;

public function addServiceChain(sp:IServiceProvider):void
{
	if( m_chain==null )
		m_chain = [];
	m_chain.push(sp);
}

public function queryService(serviceKey:Object):Object
{
	if( m_mapSvc==null ) return null;
	var res:Object = null;

	if( m_mapSvc!=null )
	{
		res = m_mapSvc[serviceKey];
		if( res!=null ) return res;
	}

	if( m_chain!=null )
	{
		for each(var sp:IServiceProvider in m_chain)
		{
			res = sp.queryService(serviceKey);
			if( res!=null )
				break;
		}
	}
	return res;
}

public function registerService(serviceKey:Object, serviceValue:Object):void
{
	if( m_mapSvc==null )
		m_mapSvc = new flash.utils.Dictionary();
	m_mapSvc[serviceKey] = serviceValue;
}

public function unregisterService(serviceKey:Object):void
{
	if( m_mapSvc==null ) return;
	if( m_mapSvc[serviceKey]==null ) return;
	m_mapSvc[serviceKey] = null;
	delete m_mapSvc[serviceKey];
}

