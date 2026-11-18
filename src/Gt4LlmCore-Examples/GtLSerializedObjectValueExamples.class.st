"
Examples for GtLSerializedObjectValue domain object.
"
Class {
	#name : #GtLSerializedObjectValueExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
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
	"GemStone has no Phlow views, so the stone's snapshot carries none."

	<gtExample>
	| serialized |
	serialized := GtLSerializedObjectValue fromObject: 3.

	self assert: serialized objectClassName equals: 'SmallInteger'.
	self assert: serialized superclassName equals: 'Integer'.
	self assert: serialized objectPrintString equals: '3'.
	self
		gtDo: [ self assert: serialized phlowViews isNotEmpty ]
		gemstoneDo: [ self assert: serialized phlowViews isEmpty ].
	self assert: serialized allInstanceSlots isEmpty.

	^ serialized
]

{ #category : #examples }
GtLSerializedObjectValueExamples >> objectValueFromObjectWithSlots [
	"GemStone has no Phlow views, so the stone's snapshot carries none, and its string
	literals are Strings rather than ByteStrings."

	<gtExample>
	| testObject serialized |
	testObject := GtLSerializedObjectValueTestObject exampleInstance.
	serialized := GtLSerializedObjectValue fromObject: testObject.

	self
		assert: serialized objectClassName
		equals: 'GtLSerializedObjectValueTestObject'.
	self assert: serialized superclassName equals: 'Object'.
	self assert: serialized packageName equals: 'Gt4LlmCore-Examples'.
	self assert: (serialized objectPrintString includesSubstring: 'TestObject').	"Verify views are captured"
	self
		gtDo: [ self assert: serialized phlowViews isNotEmpty.
			self assert: (serialized phlowViews anySatisfy: [ :v | v title = 'Details' ]).
			self assert: (serialized phlowViews anySatisfy: [ :v | v title = 'Items' ]) ]
		gemstoneDo: [ self assert: serialized phlowViews isEmpty ].	"Verify slots are captured"
	self assert: serialized allInstanceSlots size equals: 3.
	self
		assert: (serialized allInstanceSlots
				anySatisfy: [ :s | 
					s name = 'name'
						and: [ s valueClassName = (self gtDo: [ 'ByteString' ] gemstoneDo: [ 'String' ]) ] ]).
	self
		assert: (serialized allInstanceSlots
				anySatisfy: [ :s | s name = 'count' and: [ s valueClassName = 'SmallInteger' ] ]).
	self
		assert: (serialized allInstanceSlots
				anySatisfy: [ :s | s name = 'items' and: [ s valueClassName = 'Array' ] ]).

	^ serialized
]

{ #category : #examples }
GtLSerializedObjectValueExamples >> objectValueFromObjectWithSlotsSerialization [
	"GemStone has no Phlow views, so the stone's snapshot carries none, and its string
	literals are Strings rather than ByteStrings."

	<gtExample>
	| serialized jsonObject |
	serialized := self objectValueFromObjectWithSlots.
	jsonObject := GtMagritteJSONDataExporter exportObject: serialized.	"Verify structure"
	self
		assert: (jsonObject at: 'objectClassName')
		equals: 'GtLSerializedObjectValueTestObject'.
	self assert: (jsonObject at: 'superclassName') equals: 'Object'.
	self assert: (jsonObject at: 'packageName') equals: 'Gt4LlmCore-Examples'.	"Verify views are serialized"
	self
		gtDo: [ self assert: (jsonObject at: 'phlowViews') isNotEmpty ]
		gemstoneDo: [ self assert: (jsonObject at: 'phlowViews') isEmpty ].	"Verify slots are serialized with correct structure"
	self assert: (jsonObject at: 'allInstanceSlots') size equals: 3.	"Find the name slot and verify its structure"
	self
		assert: ((jsonObject at: 'allInstanceSlots')
				anySatisfy: [ :slot | 
					(slot at: 'name') = 'name'
						and: [ (slot at: 'valueClassName')
								= (self gtDo: [ 'ByteString' ] gemstoneDo: [ 'String' ])
								and: [ (slot at: 'valuePrintString') = 'TestObject' ] ] ]).	"Find the count slot"
	self
		assert: ((jsonObject at: 'allInstanceSlots')
				anySatisfy: [ :slot | 
					(slot at: 'name') = 'count'
						and: [ (slot at: 'valueClassName') = 'SmallInteger'
								and: [ (slot at: 'valuePrintString') = '42' ] ] ]).

	^ jsonObject
]

{ #category : #examples }
GtLSerializedObjectValueExamples >> objectValueOfLargeCollection [
	"A print string longer than GemStone's 700-character Collection>>printString limit is kept whole."

	<gtExample>
	| collection serialized |
	collection := (1 to: 500) asArray.
	serialized := GtLSerializedObjectValue fromObject: collection.

	self assert: serialized objectPrintString size > 700.
	self
		assert: serialized objectPrintString
		equals: (String streamContents: [ :aStream | collection printOn: aStream ]).

	^ serialized
]

{ #category : #examples }
GtLSerializedObjectValueExamples >> objectValueOfVeryLargeCollection [
	"A print string longer than 50000 characters, Pharo's printString limit, is cut to that
	limit and ends in '[..]', in GT and in GemStone."

	<gtExample>
	| collection serialized printed |
	collection := (1 to: 20000) asArray.
	serialized := GtLSerializedObjectValue fromObject: collection.

	printed := serialized objectPrintString.
	self assert: printed size equals: 50000.
	self assert: (printed endsWith: '[..]').
	self
		assert: ((String streamContents: [ :aStream | collection printOn: aStream ])
				beginsWith: (printed copyFrom: 1 to: printed size - 4)).

	^ serialized
]

{ #category : #examples }
GtLSerializedObjectValueExamples >> objectValueWithCollectionSlot [
	"A slot holding a collection is described by its print string, not by a class description
	such as 'anArray' (GemStone's Object>>asString). String and number slots keep their text."

	<gtExample>
	| serialized slotNamed |
	serialized := GtLSerializedObjectValue
			fromObject: GtLSerializedObjectValueTestObject exampleInstance.
	slotNamed := [ :aName | serialized allInstanceSlots detect: [ :each | each name = aName ] ].

	self assert: (slotNamed value: 'items') valueClassName equals: 'Array'.
	self
		assert: ((slotNamed value: 'items') valuePrintString includesSubstring: 'banana').
	self assert: (slotNamed value: 'name') valuePrintString equals: 'TestObject'.
	self assert: (slotNamed value: 'count') valuePrintString equals: '42'.

	^ serialized
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
