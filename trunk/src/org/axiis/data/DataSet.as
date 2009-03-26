package org.axiis.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	/**
	 * This class is the universal data conncector for Axiis visualizations
	 * It will support grouping on common fields with operations like sum, count, avg.
	 * It will turn flat table (.csv/array) data into object level data.
	*/
	
	public class DataSet extends EventDispatcher
	{
		
    
		public function DataSet()
		{
			
		}
			public var nullValues:String="NA, null";  //Comma delimted string;
			
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
			
			public function get rowCount():int {
				return _rowCount;
			}
			
			private var _rowCount;
			
			public function get columnCount():int {
				return _colCount;
			}
			
			private var _colCount;
			
			public function processXmlString(payload:String):void {
				//Process xml and convert to object
				processXml(payload);
			}
			
			/**
			 * Converts a CSV Payload into a object/array structure with a format of
			 * data.rows[]
			 * 
			 * row.index = ordinal position
			 * row.columns[] = array of columns
			 * 
			 * column.index = ordinal position
			 * column.name = header name for column
			 * column.value = value
			 */
			public function processCsv(payload:String, instructions:String=null):void {
				//Process CSV Source, use instructions to group into hiearicies
				//Convert CSV into data.row[n].col[n] format for dynamic object
				createTableFromCsv(payload);
			}
				
			public static var AGGREGATE_SUM:int = 0;
			public static var AGGREGATE_AVG:int = 2;
			
			/**
			 * Will perform simple aggregations against the "data" property by dynamically adding properties to the parent object
			 * parentObject.collectionName_propertyName_sum
			 * parentObject.collectionName_propertyName_avg
			 * 
			 * collectionName = "." property path of the collection in question i.e.   myCollection.myNestedCollection
			 * properties = Array of property values to aggregate
			 */
			public function aggregateCollection(collectionName:String, properties:Array, aggregateType:int=0 ):void {
				//First find our collection
				aggregate(data,collectionName.split("."),properties,aggregateType);
			}
			
			private function aggregate(object:Object, collections:Array, properties:Array, aggregateType:int):void {
				
				var collection:Object=object[collections[0]];
				
				if  (collections.length>1) { //We need to go deeper into the collection
				  	if (collection is ArrayCollection) {
						for (var i:int=0;i<ArrayCollection(collection).length;i++) {
							var obj:Object=ArrayCollection(collection).getItemAt(i);
							aggregate(obj,collections.slice(1,collections.length),properties,aggregateType);
						}
					}	
					else if (collection is Array) {
						for (var i:int=0;i<Array(collection).length;i++) {
							var obj:Object=collection[i];
							aggregate(obj,collections.slice(1,collections.length),properties,aggregateType);
						}
					}
				} 
				else {   //We are at the deepest collection
				var aggregates:Object=new Object();
					if (collection is ArrayCollection) {
						for (var i:int=0;i<ArrayCollection(collection).length;i++) {
							var obj:Object=ArrayCollection(collection).getItemAt(i);
							for (var y:int=0;y<properties.length;y++) {
								if (!aggregates[properties[y] + "_sum"]) aggregates[properties[y] + "_sum"]=0;
								aggregates[properties[y] + "_sum"]+=obj[properties[y]];
							}
						}
					}	
					else if (collection is Array) {
						for (var i:int=0;i<Array(collection).length;i++) {
							var obj:Object=collection[i];
							for (var y:int=0;y<properties.length;y++) {
								if (!aggregates[properties[y] + "_sum"]) aggregates[properties[y] + "_sum"]=0;
								aggregates[properties[y] + "_sum"]+=obj[properties[y]];
							}
						}
					}
					
					for (var n:int=0;n<properties.length;n++) {
						object[collections[0] + "_" + properties[n] + "_sum"] = aggregates[properties[n] + "_sum"];
						object[collections[0] + "_" + properties[n] + "_avg"] = aggregates[properties[n] + "_sum"]/i;
					}
				}
				
			}
			
			/***
			 * Parses a CSV string into our private _dataRows
			 * 
			 */
			private function createTableFromCsv(value:String, firstRowIsHeader:Boolean=true, convertNullsToZero:Boolean=true):void {
				//First we need to use a regEx to find any string enclosed in Quotes - as they are being escaped
				
				var table:Object=new Object();
				
				var rows:ArrayCollection=new ArrayCollection();
				
				_data=new Object();//Potentially we want to use ObjectProxies to detect changes
				
				//Then need to put in symbols for  quotes and commas
				var temp:String=value;
				var tempData:String="";
				var pattern:RegExp = /"[^"]*"/g;
				
				//Find anything enclosed in quotes
				var arr:Array=temp.match(pattern);
				for (var x:int=0;x<arr.length;x++) {
					var s:String=arr[x];
					var re:RegExp =/,/g;
					s=s.replace(re,"&comma;");
					temp=temp.replace(arr[x],s);
				}
				
				var rowArray:Array=temp.split("\n");
				
				//Try to split on a double return instead
				if (rowArray.length==1)  
					rowArray=temp.split("\r\r");
				
				//Try and split on single return	
				if (rowArray.length==1) 
					rowArray=temp.split("\r");

				var header:Array=rowArray[0].split(",");
				
				_colCount=header.length;
				
				var start:int=(firstRowIsHeader) ? 1:0; //Determine where we start parsing
				
				for (var i:int=start;i<rowArray.length;i++) { 
	
					var row:Array=rowArray[i].split(","); //Create a row
					var rowOutput:Object=new Object();
					var cols:Array=new Array();
		//We go through this cleanining stage to prepare raw CSV data
								
						for (var z:int=0;z<row.length;z++) {
							
							var dataCell:String=row[z];
							//clean up commas encoding
							var re1:RegExp=/\&comma;/g;
							dataCell=dataCell.replace(re1,",");
							
							//Clean up any encoding quotes excel put it at front of cell
							if (dataCell.charAt(0)=='"')
								dataCell=dataCell.substr(1);
							
							//Clean up any encoding quotes excel put it at end of cell	
							if (dataCell.charAt(dataCell.length-1)=='"')
								dataCell=dataCell.substr(0,dataCell.length-1);
								
							//Now replace any double quotes with single quotes
							re1=/\""/g;
							dataCell=dataCell.replace(re1,'"');
							if (dataCell==" ") dataCell="";
							
							if (convertNullsToZero) {
								if (dataCell.length==0) dataCell="0";
								if (nullValues.indexOf(dataCell) > -1) dataCell="0";
							}
							
							var cell:Object=new Object();//Potentially we want to use ObjectProxies to detect changes
							
							
							cell["name"]=header[z];
							cell["index"]=z;
							cell["value"]=(!isNaN(Number(dataCell))) ? Number(dataCell):dataCell;
							
							if (!_data["col_"+z+"_sum"]) data["col_"+z+"_sum"]=0;
							_data["col_"+z+"_sum"]+=cell["value"];
							
							cols.push(cell);
							
							
							
						}
						rowOutput["columns"]=cols;
						rowOutput["index"]=i-1;
					
						if (rowArray[i].length > row.length+2) { //Make sure that we do not have an empty row (i.e. just a string with all commas in it.

						if (row.length==_colCount) {  //don't enter fragmented rows (this can occur if a row length does not match the number of columns in the first row which is used to determine the header)
							rows.addItem(rowOutput);
						}
					}
				}
				
				_rowCount=i;
				
				_data["rows"]=rows;
				_data["header"]=new Array();
				for (var i:int=0;i<header.length;i++) {
					_data["header"].push(header[i]);
					_data["col_" + i + "_avg"]=_data["col_" + i + "_sum"]/_rowCount;
				}
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