"
A test object used for serialization examples. Has slots of different types for testing GtLSerializedObjectValue serialization.
"
Class {
	#name : #GtLSerializedObjectValueTestObject,
	#superclass : #Object,
	#instVars : [
		'name',
		'count',
		'items'
	],
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #'instance creation' }
GtLSerializedObjectValueTestObject class >> exampleInstance [
	"Create an example instance with sample data."
	^ self new
		name: 'TestObject';
		count: 42;
		items: #('apple' 'banana' 'cherry');
		yourself
]

{ #category : #accessing }
GtLSerializedObjectValueTestObject >> count [
	^ count
]

{ #category : #accessing }
GtLSerializedObjectValueTestObject >> count: anInteger [
	count := anInteger
]

{ #category : #views }
GtLSerializedObjectValueTestObject >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ {
			'Name' -> name.
			'Count' -> count.
			'Items' -> items } ];
		column: 'Property' text: #key;
		column: 'Value' text: #value
]

{ #category : #views }
GtLSerializedObjectValueTestObject >> gtItemsFor: aView [
	<gtView>
	items ifNil: [ ^ aView empty ].
	^ aView list
		title: 'Items';
		priority: 20;
		items: [ items ]
]

{ #category : #accessing }
GtLSerializedObjectValueTestObject >> items [
	^ items
]

{ #category : #accessing }
GtLSerializedObjectValueTestObject >> items: aCollection [
	items := aCollection
]

{ #category : #accessing }
GtLSerializedObjectValueTestObject >> name [
	^ name
]

{ #category : #accessing }
GtLSerializedObjectValueTestObject >> name: aString [
	name := aString
]

{ #category : #printing }
GtLSerializedObjectValueTestObject >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (name ifNil: [ 'unnamed' ]);
		nextPut: $)
]
