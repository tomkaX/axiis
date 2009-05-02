package org.axiis.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.xml.SimpleXMLDecoder;
	import mx.utils.StringUtil;
	
	/**
	 * This class is the universal data conncector for Axiis visualizations
	 * It will support grouping on common fields with operations like sum, count, avg.
	 * It will turn flat table (.csv/array) data into object level data.
	*/
	
	
	/** BENCHMARKS 4/14/09
	*   2000 rows 30 columns
	*	5261ms processCsvAsShapeData  .08ms per datapoint
	*	3281ms processCsvAsTableData  .05ms per datapoint
	*	
	*	2000 rows 14 columns
	*	3970ms processCsvAsShapeData  .13ms per datapoint
	*	1480ms processCsvAsTableData  .04ms per datapoint
	*	 
	*   Range of 40ms per 1000 datapoints --> 130ms per 1000 datapoints
	*
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
			 * 
			 * addSummaryFields=TRUE:  Will dynamically add min/max values to each row for each column
			 */
			public function processCsvAsTable(payload:String, addSummaryFields:Boolean=false):void {
				var t:Number=flash.utils.getTimer();
				//Convert CSV into data.row[n].col[n] format for dynamic object
				
				if (!_data) _data=new Object();
				
				_data["table"]=createTableFromCsv(payload,addSummaryFields);
				
				trace("DataSet.processCsvShapedData " + (flash.utils.getTimer()-t) + "ms for " + this._rowCount + " rows");
			}
			
			/**
			 * Takes a specified column and turns each row value into a new column
			 * converts existing column information and turns into a unique rows with an additional column labeled "RowName"
			 * 
			 * This will only pivot on TABLE data that is present
			 */
			public function pivotTable(pivotColumn:int):void {
				if (!data.table) return //No data to pivot
				
				var tempData:Array=new Array();
				var tempNewHeader:Array=new Array();
				var tempRows:ArrayCollection=new ArrayCollection();
		
				
				tempNewHeader.push("pivotedColumn");
				for each (var row:Object in _data.table.rows) {
					//Each row now reperesents a new column
					var columns:Columns=new Columns();
					
					tempNewHeader.push(row.columns[pivotColumn].value);
					var rowIndex:int=0;
					for each (var col:Object in row.columns) {
					
						if (col.index!=pivotColumn) {
							var newRow:Object;
							var cell:Object;
							if (rowIndex > tempRows.length-1 ) {
								newRow=new Object; 
								newRow.columns=new Columns(); 
								cell=new Object();
								cell.name="pivotedColumn";
								cell.index=0;
								cell.value=col.name;
								newRow.columns.addItem(cell);
								tempRows.addItem(newRow); 
							}
							else newRow=tempRows.getItemAt(rowIndex);
							
							cell=new Object();
							cell.index=newRow.columns.length;
							cell.name=row.columns[pivotColumn].value;
							cell.value=col.value;
							newRow.columns.addItem(cell);
							newRow.index=rowIndex+1;
							rowIndex++;	
						}	
									
					}
				
				}
				
				var pivotedTable:Object=new Object();
				pivotedTable.rows=tempRows;
				pivotedTable.header=tempNewHeader;
				_data.pivot=pivotedTable;
				
			}
			/**
			 *  groupings: Ordered list of name value pairs ["columnIndex, groupName"] to create heirarchal Groupings
			 * 
			 *  Example: processCsvAsShapedData(myData,["0,region","1,country"]);
			 *  Would take data, and create a 2-level grouped hierarchy, with region being the parent group of country
			 *   
			 * 
			 *  flattenLastGroup:  If the lowest level grouping returns only one row for that group, it will add the COLUMNS of that one row directly to the group object
			 *  				   (versus a 1 item arrayCollection of rows)
			*/
			/*public function processCsvAsShapedData(payload:String, groupings:Array, flattenLastGroup:Boolean=true):void {
				//Process CSV Source, use instructions to group into hiearicies
				//Convert CSV into data.row[n].col[n] format for dynamic object
				var t:Number=flash.utils.getTimer();
				
				var tempData:Object=createTableFromCsv(payload);
				
				if (!groupings || groupings.length<1) throw new Error("You must declare groupings to shape data DataSet.processCsvAsShapedData");
				
				if (!_data) _data=new Object();
				
				_data.shaped=createShapedObject(tempData.rows,groupings,flattenLastGroup);
				
				trace("DataSet.processCsvShapedData " + (flash.utils.getTimer()-t) + "ms for " + this._rowCount + " rows");
			}
			*/
			
			/**
			 *  Takes table data and uses cell unique values for specified columns to group data into hierarchal object
			 * 
			 *  groupings: Ordered list of name value pairs ["columnIndex, groupName"] to create heirarchal Groupings
			 * 
			 *  Example: shapeTable(myData,["0,region","1,country"]);
			 *  Would take data, and create a 2-level grouped hierarchy, with region being the parent group of country
			 *   
			 * 
			 *  flattenLastGroup:  If the lowest level grouping returns only one row for that group, it will add the COLUMNS of that one row directly to the group object
			 *  				   (versus a 1 item arrayCollection of rows)
			*/
			public function shapeTable(groupings:Array, flattenLastGroup:Boolean=true):void {
					var t:Number=flash.utils.getTimer();
			
				if (!data["table"]) return; //No table to process)
				
				if (!groupings || groupings.length<1) throw new Error("You must declare groupings to shape data DataSet.processCsvAsShapedData");
				
				if (!_data) _data=new Object();
				_data.shaped=createShapedObject(data["table"].rows,groupings,flattenLastGroup);
				
				trace("DataSet.processCsvShapedData " + (flash.utils.getTimer()-t) + "ms for " + this._rowCount + " rows");
			}
				
			public static var AGGREGATE_SUM:int = 0;
			public static var AGGREGATE_AVG:int = 2;
			
			/**
			 * Will perform simple aggregations against the "data" property by dynamically adding properties to the parent object
			 * Collections are traversed hierarchally (if you target a nested collection) and aggregations roll up the hierarchy.
			 * Aggregations are added as a dynamic object to the owner of the collection
			 *
			 * 
			 * ownerObject.aggregates.propertyName_sum;
			 * ownerObject.aggregates.propertyName_min;
			 * ownerObject.aggregates.propertyName_max;
			 * ownerObject.aggregates.propertyName_avg;
			 * 
			 * If data is a shapedDataSet (created from flattened hierachal CSV data) or TableData with columns
			 * aggregation will occur for each column under the aggregates object
			 * aggregates.columns where columns is an ArrayCollection of obj.min, obj.max, obj.sum, obj.avg
			 * 
			 * collectionName: The name of the collection within the "data" property.  You can use "." notation to drill down to it
			 * properties: An array of collection item properties you want to aggregate. You can use "." notation to drill down to specific objects within a collection item.
			 * 
			 * If a target property is a org.axis.data.columns class it will automatically aggregate all columns.
			 */
			public function aggregateData(data:Object, collectionName:String, properties:Array):void {
				//First find our collection
				var t:Number=flash.utils.getTimer();
				aggregate(data,collectionName.split("."),properties);
				trace("DataSet.aggregateCollection=" + (flash.utils.getTimer()-t) + "ms");
			}
			
			
			private function aggregate(object:Object, collections:Array, properties:Array):void {
				
				var collection:Object=object[collections[0]];
				
				if  (collections.length>1) { //We need to go deeper into the collection
				  	if (collection is ArrayCollection) {
						for (var i:int=0;i<ArrayCollection(collection).length;i++) {
							var obj:Object=ArrayCollection(collection).getItemAt(i);
							aggregate(obj,collections.slice(1,collections.length),properties);
						}
						totalAggregates(object, collection, properties, collections[1]);
					}	
					else if (collection is Array) {
						for (var i:int=0;i<Array(collection).length;i++) {
							var obj:Object=collection[i];
							aggregate(obj,collections.slice(1,collections.length),properties);
						}
						totalAggregates(object, collection, properties, collections[1]);
					}
				} 
				else {   //We are at the deepest collection
					var aggregates:Object=object.aggregates;
					if (!aggregates) { aggregates=new Object(); object.aggregates=aggregates; }
					if (collection is ArrayCollection) {
						for (var i:int=0;i<ArrayCollection(collection).length;i++) {
							var obj:Object=ArrayCollection(collection).getItemAt(i);
							processAggregateObject(obj,properties,aggregates,collections[0]);
						}
					}	
					else if (collection is Array) {
						for (var i:int=0;i<Array(collection).length;i++) {
							var obj:Object=collection[i];
							processAggregateObject(obj,properties,aggregates,collections[0]);
						}
					}
					
					for (var n:int=0;n<properties.length;n++) {
						if (aggregates["columns"]) {
							var min:Number=Number.POSITIVE_INFINITY;
							var max:Number=Number.NEGATIVE_INFINITY;
							var sum:Number=0;
							for (var z:int=0;z<aggregates["columns"].length-1;z++) {
								min=Math.min(aggregates.columns[z].min,min);
								max=Math.max(aggregates.columns[z].max,max);
								sum+=aggregates.columns[z].sum;
								aggregates.columns[z]["avg"]=aggregates.columns[z].sum/i;
							}	
							aggregates.columns_sum=sum;
							aggregates.columns_max=max;
							aggregates.columns_min=min;
							aggregates.columns_avg=sum/z;
						}
						else {
							aggregates[cleanName(properties[n],collections[0]) + "_avg"]=aggregates[cleanName(properties[n],collections[0]) + "_sum"]/i;
						}
					}
				}
				
			}
			
			private function totalAggregates(object:Object, collection:Object, properties:Array, collectionName:String):void {
				var aggregates=object.aggregates;
				if (!aggregates) { aggregates=new Object(); object.aggregates=aggregates; }
				
				for (var i:int=0;i<collection.length-1;i++) {
					var obj:Object=(collection is Array) ? collection[i]:collection.getItemAt(i);
					rollUpAggregates(aggregates, obj.aggregates,properties,collectionName);
				}
				for (var y:int=0;y<properties.length;y++) {
					if (aggregates["columns"]) {
						var min:Number=Number.POSITIVE_INFINITY;
							var max:Number=Number.NEGATIVE_INFINITY;
							var sum:Number=0;
							for (var z:int=0;z<aggregates["columns"].length-1;z++) {
								min=Math.min(aggregates.columns[z].min,min);
								max=Math.max(aggregates.columns[z].max,max);
								sum+=aggregates.columns[z].sum;
								aggregates.columns[z]["avg"]=aggregates.columns[z].sum/i;
							}	
							aggregates.columns_sum=sum;
							aggregates.columns_max=max;
							aggregates.columns_min=min;
							aggregates.columns_avg=sum/z;
					}
					else {
						var property:String=cleanName(properties[y],collectionName);  
						aggregates[property + "_avg"] = aggregates[property + "_sum"]/i;
					}
				}
			}
			
			private function rollUpAggregates(aggregates:Object, objAggregates:Object, properties:Array, collectionName:String):void {
			
				for (var y:int=0;y<properties.length;y++) {
					var property:String=cleanName(properties[y],collectionName);  
					
					if (objAggregates["columns"]) {
						var columns:ArrayCollection=aggregates["columns"];
						if (!columns) { columns=new ArrayCollection(); aggregates.columns=columns; }
						for (var i:int=0;i<objAggregates.columns.length-1;i++) {
							var agg:Object;
							if(i > columns.length-1) {
								agg=new Object(); 
								columns.addItem(agg); }
							else {
								agg=columns.getItemAt(i);
							}
							if (!agg["sum"]) agg["sum"]=0;
							if (!agg["min"]) agg["min"]=Number.POSITIVE_INFINITY;
							if (!agg["max"]) agg["max"]=Number.NEGATIVE_INFINITY;
							
							agg["sum"]+=objAggregates.columns[i].sum;
							agg["min"]=Math.min(objAggregates.columns[i].min, agg["min"]);
							agg["max"]=Math.max(objAggregates.columns[i].max, agg["max"]);
						}
					}
					else {
						if (!aggregates[property + "_sum"]) aggregates[property + "_sum"]=0;
						if (!aggregates[property + "_min"]) aggregates[property + "_min"]=Number.POSITIVE_INFINITY;
						if (!aggregates[property + "_max"]) aggregates[property + "_max"]=Number.NEGATIVE_INFINITY;
			
						aggregates[property + "_sum"]+=objAggregates[property + "_sum"];
						aggregates[property + "_min"]=Math.min(aggregates[property + "_min"], objAggregates[property + "_min"]);
						aggregates[property + "_max"]=Math.max(aggregates[property + "_max"], objAggregates[property + "_max"]);
					}
				}
			}
			
			private function cleanName(propName:String, collectionName:String=""):String {
				var pa:Array=propName.split(".");
				var ca:Array=collectionName.split(".");
				return ca.join(":") + "_" + pa.join(":");
			}
			
			/**
			 * used to set sum,min,max,avg for aggregate method
			 */
			private function processAggregateObject(obj:Object, properties:Array, aggregates:Object, collectionName:String):void {
				for (var y:int=0;y<properties.length;y++) {
					
					var valObj:Object=getProperty(obj,properties[y]);
					
					if (valObj is Columns) { //If we are columns we need to go one layer deeper and aggregate the columns
					  var agg=new Object();
						for (var i:int=0;i<valObj.length-1;i++) {
							var val:Number = isNaN(Number(valObj.getItemAt(i).value)) ? 0:Number(valObj.getItemAt(i).value);
							if (!agg["sum"]) agg["sum"]=0;
							if (!agg["min"]) agg["min"]=Number.POSITIVE_INFINITY;
							if (!agg["max"]) agg["max"]=Number.NEGATIVE_INFINITY;
							
							agg["sum"]+=val;
							agg["min"]=Math.min(val, agg["min"]);
							agg["max"]=Math.max(val, agg["max"]);
						}
					  var columns:ArrayCollection=aggregates["columns"];
					  if (!columns) {
					  	columns=new ArrayCollection();
					  	aggregates.columns=columns;
					  }
					  columns.addItem(agg);
					}
					else {
						var val:Number = isNaN(Number(valObj)) ? 0:Number(valObj);
						var property:String=cleanName(properties[y],collectionName);  
						
						if (!aggregates[property + "_sum"]) aggregates[property + "_sum"]=0;
						if (!aggregates[property + "_min"]) aggregates[property + "_min"]=Number.POSITIVE_INFINITY;
						if (!aggregates[property + "_max"]) aggregates[property + "_max"]=Number.NEGATIVE_INFINITY;
						
						aggregates[property + "_sum"]+=val;
						aggregates[property + "_min"]=Math.min(val, aggregates[property + "_min"]);
						aggregates[property + "_max"]=Math.max(val, aggregates[property + "_max"]);
					}
				}
			}
			
			private function getProperty(obj:Object, propertyName:String):Object {
				var chain:Array=propertyName.split(".");
				if (chain.length<2) {
					return obj[chain[0]];
				}
				else {
					return getProperty(obj[chain[0]],chain.slice(1,chain.length).join("."));
				}
			}
			/***
			 * Parses a CSV string into our private _dataRows
			 * 
			 */
			private function createTableFromCsv(value:String, addSummaries:Boolean=false, firstRowIsHeader:Boolean=true, convertNullsToZero:Boolean=true):Object {
				//First we need to use a regEx to find any string enclosed in Quotes - as they are being escaped
				
				var table:Object=new Object();
				
				var rows:ArrayCollection=new ArrayCollection();
				
				var tempPayload:Object=new Object();//Potentially we want to use ObjectProxies to detect changes
				
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
					var cols:Columns=new Columns();
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
							
							//We are automatically adding sum values for each column here
							if (addSummaries && !tempPayload["col_"+z+"_sum"]) tempPayload["col_"+z+"_sum"]=0;
							if (addSummaries) tempPayload["col_"+z+"_sum"]+=cell["value"];
							
							cols.addItem(cell);
							
							
							
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
				
				tempPayload["rows"]=rows;
				tempPayload["header"]=new Array();
				for (var i:int=0;i<header.length;i++) {
					tempPayload["header"].push(header[i]);
					//Adding avg for each column here.
					if (addSummaries) tempPayload["col_" + i + "_avg"]=tempPayload["col_" + i + "_sum"]/_rowCount;
				}
				
				return tempPayload;
			}
			
			/**
			 * tableData:Object - expects the result from a processCsvData operation
			 */
			private function createShapedObject(collection:ArrayCollection, groupings:Array, flattenLastGroup:Boolean):Object {
				
					var tempData:Object=new Object;
				
					
					//Start with outer grouping and find unique values
					
					var colIndex:String=groupings[0].split(",")[0];
					var groupName:String=StringUtil.trim(groupings[0].split(",")[1]);
					var srt:Sort=new Sort();
					srt.fields=[new SortField(colIndex,true)];
					srt.compareFunction=internalCompare;
					collection.sort=srt;
					collection.refresh();
					
					tempData[groupName]=new ArrayCollection();
				
					
					//Go through collection and each time we hit a new unique value create a new group object
					var currValue:String=collection.getItemAt(0).columns[int(colIndex)].value;
					var nextValue:String;
					var tempCollection:ArrayCollection=new ArrayCollection();
					
					for (var y:int=0;y<collection.length;y++) {
						
						if (y!=collection.length-1)
							nextValue=collection.getItemAt(y+1).columns[int(colIndex)].value;  //look ahead to see if we are at the end of a group.
						else {
							nextValue=null;  //We are at the end force the end of group
						}
						
						currValue=collection.getItemAt(y).columns[int(colIndex)].value;
						tempCollection.addItem(collection.getItemAt(y));
							
						if (currValue!=nextValue) {
								
							var newObject:Object=new Object();
							newObject.name=currValue;

							if (groupings.length > 1) { //we need to go one level deeper recursively
								newObject=createShapedObject(tempCollection,groupings.slice(1,groupings.length),flattenLastGroup);
								newObject.name=currValue;
							}
							else {

								if (flattenLastGroup && tempCollection.length==1)  //We can only flatten if we have unique values
									newObject.columns=tempCollection.getItemAt(0).columns;
								else if (flattenLastGroup)
									trace("WARNING: DataSet.createShapeObject - non-unique values for shape criteria, can not flatten rows into single column property");
								
								newObject.rows=tempCollection;
							}
						
							tempData[groupName].addItem(newObject);
							tempCollection=new ArrayCollection();
						}

					}

				return tempData;
				
			}
			
			private function internalCompare(a:Object, b:Object, fields:Array = null):int
	        {

	        	var a:Object=a.columns.getItemAt(fields[0].name).value;
	        	var b:Object=b.columns.getItemAt(fields[0].name).value;
	            
	           if (a == null && b == null)
                return 0;
                 if (a == null)
              return 1;
                 if (b == null)
               return -1;
                 if (a < b)
                return -1;
                 if (a > b)
                return 1;
	                 return 0;
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
                
                if (!_data) _data=new Object();
        
				_data["object"]=decoded;
			
			
		}

	}
}