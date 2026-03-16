"
Represents a serialized Smalltalk object with class info, print string, views, and slot values.
"
Class {
	#name : #GtLSerializedObjectValue,
	#superclass : #Object,
	#instVars : [
		'objectClassName',
		'superclassName',
		'packageName',
		'objectPrintString',
		'phlowViews',
		'allInstanceSlots'
	],
	#classVars : [
		':parameter>',
		'</antml',
		'<parameter',
		'name="package">Gt4LlmCore'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLSerializedObjectValue class >> fromObject: anObject [
	"Create a serialized object value from an object."
	^ self new
		initializeFromObject: anObject;
		yourself
]

{ #category : #accessing }
GtLSerializedObjectValue >> allInstanceSlots [
	^ allInstanceSlots ifNil: [ #() ]
]

{ #category : #accessing }
GtLSerializedObjectValue >> allInstanceSlots: aCollection [
	allInstanceSlots := aCollection
]

{ #category : #magritte }
GtLSerializedObjectValue >> allInstanceSlotsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'All instance slots';
		accessor: #allInstanceSlots;
		classes: { GtLSerializedSlotInfo };
		beRequired
]

{ #category : #initialization }
GtLSerializedObjectValue >> initializeFromObject: anObject [
	"Initialize from an object by extracting class info, views, and slots."
	self objectClassName: anObject class name asString.
	self superclassName: (anObject class superclass 
		ifNil: [ '' ] 
		ifNotNil: [ :s | s name asString ]).
	self packageName: anObject class package name asString.
	self objectPrintString: ([ (anObject printString escapeCharacter: $') ]
		on: Error 
		do: [ :e | 'Error printing object' ]).
	self phlowViews: ((anObject gtViewsInCurrentContext
		reject: [ :aView | aView isKindOf: GtPhlowEmptyView ])
		collect: [ :aView | GtLSerializedViewInfo fromView: aView ]) asArray.
	self allInstanceSlots: (anObject class allSlots collect: [ :aSlot |
		GtLSerializedSlotInfo fromSlot: aSlot ofObject: anObject ]) asArray
]

{ #category : #accessing }
GtLSerializedObjectValue >> objectClassName [
	^ objectClassName
]

{ #category : #accessing }
GtLSerializedObjectValue >> objectClassName: aString [
	objectClassName := aString
]

{ #category : #magritte }
GtLSerializedObjectValue >> objectClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class';
		accessor: #objectClassName;
		beRequired
]

{ #category : #accessing }
GtLSerializedObjectValue >> objectPrintString [
	^ objectPrintString
]

{ #category : #accessing }
GtLSerializedObjectValue >> objectPrintString: aString [
	objectPrintString := aString
]

{ #category : #magritte }
GtLSerializedObjectValue >> objectPrintStringDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Print string';
		accessor: #objectPrintString;
		beRequired
]

{ #category : #accessing }
GtLSerializedObjectValue >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLSerializedObjectValue >> packageName: aString [
	packageName := aString
]

{ #category : #magritte }
GtLSerializedObjectValue >> packageNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package';
		accessor: #packageName;
		beRequired
]

{ #category : #accessing }
GtLSerializedObjectValue >> phlowViews [
	^ phlowViews ifNil: [ #() ]
]

{ #category : #accessing }
GtLSerializedObjectValue >> phlowViews: aCollection [
	phlowViews := aCollection
]

{ #category : #magritte }
GtLSerializedObjectValue >> phlowViewsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Views';
		accessor: #phlowViews;
		classes: { GtLSerializedViewInfo };
		beRequired
]

{ #category : #printing }
GtLSerializedObjectValue >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (objectClassName ifNil: [ '' ]);
		nextPut: $)
]

{ #category : #accessing }
GtLSerializedObjectValue >> superclassName [
	^ superclassName
]

{ #category : #accessing }
GtLSerializedObjectValue >> superclassName: aString [
	superclassName := aString
]

{ #category : #magritte }
GtLSerializedObjectValue >> superclassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Superclass';
		accessor: #superclassName;
		beRequired
]
