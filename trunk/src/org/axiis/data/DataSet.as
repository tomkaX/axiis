package org.axiis.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	public class DataSet extends EventDispatcher
	{
		
    
		public function DataSet()
		{
			
		}
		
			
			[Bindable(event="dataChange")]
			public function get data():Object
			{
				return _data;
			}
			protected function set _data(value:Object):void
			{
				if(value != __data)
				{
					__data = value;
					dispatchEvent(new Event("dataChange"));
				}
			}
			protected function get _data():Object
			{
				return __data;
			}
			private var __data:Object;
			
			public function processXmlString(payload:String):void {
				//Process xml and convert to object
				processXml(payload);
			}
			
			public function processCsv(payload:String, instructions:String=null):void {
				//Process CSV Source, use instructions to group into hiearicies
				//Convert CSV into data.row[n].col[n] format for dynamic object
				
			}
			
			private function processXml(body:String):void {
				
	             var tmp:Object = new XMLDocument();
                XMLDocument(tmp).ignoreWhite = true;
                try
                {
                    XMLDocument(tmp).parseXML(String(body));
                }
                catch(parseError:Error)
                {
                    dispatchEvent(new FaultEvent("xml_decode_fault"));
                }

                var decoded:Object;
              
                var decoder:SimpleXMLDecoder = new SimpleXMLDecoder(true);

                decoded = decoder.decodeXML(XMLNode(tmp));

                if (decoded == null)
                {
                     dispatchEvent(new FaultEvent("xml_decode_fault"));
                }
        
				_data=decoded;
			
			
		}

	}
}