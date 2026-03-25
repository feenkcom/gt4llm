"
Examples for GtLSerializedObjectValue domain object.
"
Class {
	#name : #GtLSerializedObjectValueExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLSerializedObjectValueExamples >> objectValueEquality [
	<gtExample>
	<return: #GtLSerializedObjectValue>
	| objectValue1 objectValue2 objectValue3 viewInfo |
	
	viewInfo := GtLSerializedViewInfo new
		methodName: 'gtPrintFor:';
		title: 'Print';
		yourself.
	
	objectValue1 := GtLSerializedObjectValue new
		objectClassName: 'SmallInteger';
		superclassName: 'Integer';
		packageName: 'Kernel';
		objectPrintString: '42';
		phlowViews: { viewInfo };
		allInstanceSlots: #();
		yourself.
	
	objectValue2 := GtLSerializedObjectValue new
		objectClassName: 'SmallInteger';
		superclassName: 'Integer';
		packageName: 'Kernel';
		objectPrintString: '42';
		phlowViews: { viewInfo copy };
		allInstanceSlots: #();
		yourself.
	
	objectValue3 := GtLSerializedObjectValue new
		objectClassName: 'ByteString';
		superclassName: 'String';
		packageName: 'Collections-Strings';
		objectPrintString: '''hello''';
		phlowViews: #();
		allInstanceSlots: #();
		yourself.
	
	self assert: objectValue1 equals: objectValue2.
	self assert: objectValue1 hash equals: objectValue2 hash.
	self assert: (objectValue1 = objectValue3) not.
	
	^ objectValue1
]

{ #category : #examples }
GtLSerializedObjectValueExamples >> objectValueFromObject [
	<gtExample>
	| serialized |
	serialized := GtLSerializedObjectValue fromObject: 3.
	
	self assert: serialized objectClassName equals: 'SmallInteger'.
	self assert: serialized superclassName equals: 'Integer'.
	self assert: serialized objectPrintString equals: '3'.
	self assert: serialized phlowViews isNotEmpty.
	self assert: serialized allInstanceSlots isEmpty.
	
	^ serialized
]

{ #category : #examples }
GtLSerializedObjectValueExamples >> objectValueFromObjectWithSlots [
	<gtExample>
	| testObject serialized |
	testObject := GtLSerializedObjectValueTestObject exampleInstance.
	serialized := GtLSerializedObjectValue fromObject: testObject.
	
	self assert: serialized objectClassName equals: 'GtLSerializedObjectValueTestObject'.
	self assert: serialized superclassName equals: 'Object'.
	self assert: serialized packageName equals: 'Gt4LlmCore-Examples'.
	self assert: (serialized objectPrintString includesSubstring: 'TestObject').
	
	"Verify views are captured"
	self assert: serialized phlowViews isNotEmpty.
	self assert: (serialized phlowViews anySatisfy: [ :v | v title = 'Details' ]).
	self assert: (serialized phlowViews anySatisfy: [ :v | v title = 'Items' ]).
	
	"Verify slots are captured"
	self assert: serialized allInstanceSlots size equals: 3.
	self assert: (serialized allInstanceSlots anySatisfy: [ :s | 
		s name = 'name' and: [ s valueClassName = 'ByteString' ] ]).
	self assert: (serialized allInstanceSlots anySatisfy: [ :s | 
		s name = 'count' and: [ s valueClassName = 'SmallInteger' ] ]).
	self assert: (serialized allInstanceSlots anySatisfy: [ :s | 
		s name = 'items' and: [ s valueClassName = 'Array' ] ]).
	
	^ serialized
]

{ #category : #examples }
GtLSerializedObjectValueExamples >> objectValueFromObjectWithSlotsSerialization [
	<gtExample>
	| serialized jsonObject |
	serialized := self objectValueFromObjectWithSlots.
	jsonObject := GtMagritteJSONDataExporter exportObject: serialized.
	
	"Verify structure"
	self assert: (jsonObject at: 'objectClassName') equals: 'GtLSerializedObjectValueTestObject'.
	self assert: (jsonObject at: 'superclassName') equals: 'Object'.
	self assert: (jsonObject at: 'packageName') equals: 'Gt4LlmCore-Examples'.
	
	"Verify views are serialized"
	self assert: (jsonObject at: 'phlowViews') isNotEmpty.
	
	"Verify slots are serialized with correct structure"
	self assert: (jsonObject at: 'allInstanceSlots') size equals: 3.
	
	"Find the name slot and verify its structure"
	self assert: ((jsonObject at: 'allInstanceSlots') anySatisfy: [ :slot |
		(slot at: 'name') = 'name' 
			and: [ (slot at: 'valueClassName') = 'ByteString' 
				and: [ (slot at: 'valuePrintString') = 'TestObject' ] ] ]).
	
	"Find the count slot"
	self assert: ((jsonObject at: 'allInstanceSlots') anySatisfy: [ :slot |
		(slot at: 'name') = 'count' 
			and: [ (slot at: 'valueClassName') = 'SmallInteger'
				and: [ (slot at: 'valuePrintString') = '42' ] ] ]).
	
	^ jsonObject
]

{ #category : #examples }
GtLSerializedObjectValueExamples >> simpleObjectValue [
	<gtExample>
	| serialized |
	serialized := GtLSerializedObjectValue new
		objectClassName: 'SmallInteger';
		superclassName: 'Integer';
		packageName: 'Kernel';
		objectPrintString: '3';
		phlowViews: { self simpleViewInfo };
		allInstanceSlots: #();
		yourself.
	
	self assert: serialized objectClassName equals: 'SmallInteger'.
	self assert: serialized superclassName equals: 'Integer'.
	self assert: serialized packageName equals: 'Kernel'.
	self assert: serialized objectPrintString equals: '3'.
	self assert: serialized phlowViews size equals: 1.
	self assert: serialized allInstanceSlots isEmpty.
	
	^ serialized
]

{ #category : #examples }
GtLSerializedObjectValueExamples >> simpleObjectValueSerialization [
	<gtExample>
	| serialized jsonObject expected |
	serialized := self simpleObjectValue.
	jsonObject := GtMagritteJSONDataExporter exportObject: serialized.
	
	expected := NeoJSONObject new
		at: 'objectClassName' put: 'SmallInteger';
		at: 'superclassName' put: 'Integer';
		at: 'packageName' put: 'Kernel';
		at: 'objectPrintString' put: '3';
		at: 'phlowViews' put: (NeoJSONArray with: (NeoJSONObject new
			at: 'methodName' put: 'gtPrintFor:';
			at: 'title' put: 'Print';
			yourself));
		at: 'allInstanceSlots' put: (NeoJSONArray new);
		yourself.
	
	self assert: jsonObject equals: expected.
	
	^ jsonObject
]

{ #category : #'examples - supporting' }
GtLSerializedObjectValueExamples >> simpleViewInfo [
	<gtExample>
	^ GtLSerializedViewInfoExamples new simpleViewInfo
]
