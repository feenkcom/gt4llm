"
Examples for GtLSerializedViewInfo domain object.
"
Class {
	#name : #GtLSerializedViewInfoExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLSerializedViewInfoExamples >> simpleViewInfo [
	<gtExample>
	| viewInfo |
	viewInfo := GtLSerializedViewInfo new
		methodName: 'gtPrintFor:';
		title: 'Print';
		yourself.
	
	self assert: viewInfo methodName equals: 'gtPrintFor:'.
	self assert: viewInfo title equals: 'Print'.
	
	^ viewInfo
]

{ #category : #examples }
GtLSerializedViewInfoExamples >> simpleViewInfoSerialization [
	<gtExample>
	| viewInfo jsonObject expected |
	viewInfo := self simpleViewInfo.
	jsonObject := GtMagritteJSONDataExporter exportObject: viewInfo.
	
	expected := NeoJSONObject new
		at: 'methodName' put: 'gtPrintFor:';
		at: 'title' put: 'Print';
		yourself.
	
	self assert: jsonObject equals: expected.
	
	^ jsonObject
]
