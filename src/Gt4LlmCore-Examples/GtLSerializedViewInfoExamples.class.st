"
Examples for GtLSerializedViewInfo domain object.
"
Class {
	#name : #GtLSerializedViewInfoExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
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

{ #category : #examples }
GtLSerializedViewInfoExamples >> viewInfoEquality [
	<gtExample>
	<return: #GtLSerializedViewInfo>
	| viewInfo1 viewInfo2 viewInfo3 |
	
	viewInfo1 := GtLSerializedViewInfo new
		methodName: 'gtPrintFor:';
		title: 'Print';
		yourself.
	
	viewInfo2 := GtLSerializedViewInfo new
		methodName: 'gtPrintFor:';
		title: 'Print';
		yourself.
	
	viewInfo3 := GtLSerializedViewInfo new
		methodName: 'gtRawFor:';
		title: 'Raw';
		yourself.
	
	self assert: viewInfo1 equals: viewInfo2.
	self assert: viewInfo1 hash equals: viewInfo2 hash.
	self assert: (viewInfo1 = viewInfo3) not.
	
	^ viewInfo1
]
