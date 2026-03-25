"
Examples for GtLSerializedSlotInfo domain object.
"
Class {
	#name : #GtLSerializedSlotInfoExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLSerializedSlotInfoExamples >> simpleSlotInfo [
	<gtExample>
	| slotInfo |
	slotInfo := GtLSerializedSlotInfo new
		name: 'mySlot';
		valueClassName: 'SmallInteger';
		valuePrintString: '42';
		yourself.
	
	self assert: slotInfo name equals: 'mySlot'.
	self assert: slotInfo valueClassName equals: 'SmallInteger'.
	self assert: slotInfo valuePrintString equals: '42'.
	
	^ slotInfo
]

{ #category : #examples }
GtLSerializedSlotInfoExamples >> simpleSlotInfoSerialization [
	<gtExample>
	| slotInfo jsonObject expected |
	slotInfo := self simpleSlotInfo.
	jsonObject := GtMagritteJSONDataExporter exportObject: slotInfo.
	
	expected := NeoJSONObject new
		at: 'name' put: 'mySlot';
		at: 'valueClassName' put: 'SmallInteger';
		at: 'valuePrintString' put: '42';
		yourself.
	
	self assert: jsonObject equals: expected.
	
	^ jsonObject
]

{ #category : #examples }
GtLSerializedSlotInfoExamples >> slotInfoEquality [
	<gtExample>
	<return: #GtLSerializedSlotInfo>
	| slotInfo1 slotInfo2 slotInfo3 |
	
	slotInfo1 := GtLSerializedSlotInfo new
		name: 'mySlot';
		valueClassName: 'SmallInteger';
		valuePrintString: '42';
		yourself.
	
	slotInfo2 := GtLSerializedSlotInfo new
		name: 'mySlot';
		valueClassName: 'SmallInteger';
		valuePrintString: '42';
		yourself.
	
	slotInfo3 := GtLSerializedSlotInfo new
		name: 'otherSlot';
		valueClassName: 'ByteString';
		valuePrintString: '''hello''';
		yourself.
	
	self assert: slotInfo1 equals: slotInfo2.
	self assert: slotInfo1 hash equals: slotInfo2 hash.
	self assert: (slotInfo1 = slotInfo3) not.
	
	^ slotInfo1
]

{ #category : #examples }
GtLSerializedSlotInfoExamples >> slotInfoFromArraySlot [
	<gtExample>
	"Test serialization of an array slot from a real object."
	| testObject slot slotInfo |
	testObject := self testObject.
	slot := testObject class slotNamed: #items.
	slotInfo := GtLSerializedSlotInfo fromSlot: slot ofObject: testObject.
	
	self assert: slotInfo name equals: 'items'.
	self assert: slotInfo valueClassName equals: 'Array'.
	self assert: (slotInfo valuePrintString includesSubstring: 'apple').
	self assert: (slotInfo valuePrintString includesSubstring: 'banana').
	self assert: (slotInfo valuePrintString includesSubstring: 'cherry').
	
	^ slotInfo
]

{ #category : #examples }
GtLSerializedSlotInfoExamples >> slotInfoFromIntegerSlot [
	<gtExample>
	"Test serialization of an integer slot from a real object."
	| testObject slot slotInfo |
	testObject := self testObject.
	slot := testObject class slotNamed: #count.
	slotInfo := GtLSerializedSlotInfo fromSlot: slot ofObject: testObject.
	
	self assert: slotInfo name equals: 'count'.
	self assert: slotInfo valueClassName equals: 'SmallInteger'.
	self assert: slotInfo valuePrintString equals: '42'.
	
	^ slotInfo
]

{ #category : #examples }
GtLSerializedSlotInfoExamples >> slotInfoFromIntegerSlotSerialization [
	<gtExample>
	"Test JSON serialization of an integer slot."
	| slotInfo jsonObject expected |
	slotInfo := self slotInfoFromIntegerSlot.
	jsonObject := GtMagritteJSONDataExporter exportObject: slotInfo.
	
	expected := NeoJSONObject new
		at: 'name' put: 'count';
		at: 'valueClassName' put: 'SmallInteger';
		at: 'valuePrintString' put: '42';
		yourself.
	
	self assert: jsonObject equals: expected.
	
	^ jsonObject
]

{ #category : #examples }
GtLSerializedSlotInfoExamples >> slotInfoFromStringSlot [
	<gtExample>
	"Test serialization of a string slot from a real object."
	| testObject slot slotInfo |
	testObject := self testObject.
	slot := testObject class slotNamed: #name.
	slotInfo := GtLSerializedSlotInfo fromSlot: slot ofObject: testObject.
	
	self assert: slotInfo name equals: 'name'.
	self assert: slotInfo valueClassName equals: 'ByteString'.
	self assert: slotInfo valuePrintString equals: 'TestObject'.
	
	^ slotInfo
]

{ #category : #'examples - supporting' }
GtLSerializedSlotInfoExamples >> testObject [
	<gtExample>
	^ GtLSerializedObjectValueTestObject exampleInstance
]
