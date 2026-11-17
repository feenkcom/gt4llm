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
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLSerializedObjectValue class >> fromObject: anObject [
	"Create a serialized object value from an object."
	^ self new
		initializeFromObject: anObject;
		yourself
]

{ #category : #printing }
GtLSerializedObjectValue class >> printStringOf: anObject limitedTo: limit [
	"Print an object's description within limit characters."

	<gsCode: '	| aStream printed |
	aStream := PrintStream printingOn: String new maxSize: limit + 1.
	anObject printOn: aStream.
	printed := aStream contents.
	printed size <= limit ifTrue: [ ^ printed ].
	^ (printed copyFrom: 1 to: limit - 4) , ''[..]'''>
	^ anObject printStringLimitedTo: limit
]

{ #category : #comparing }
GtLSerializedObjectValue >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ objectClassName = anObject objectClassName
		and: [ superclassName = anObject superclassName
			and: [ packageName = anObject packageName
				and: [ objectPrintString = anObject objectPrintString
					and: [ phlowViews = anObject phlowViews
						and: [ allInstanceSlots = anObject allInstanceSlots ] ] ] ] ]
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

{ #category : #comparing }
GtLSerializedObjectValue >> hash [
	^ ((((objectClassName hash bitXor: superclassName hash)
		bitXor: packageName hash)
			bitXor: objectPrintString hash)
				bitXor: phlowViews hash)
					bitXor: allInstanceSlots hash
]

{ #category : #initialization }
GtLSerializedObjectValue >> initializeFromObject: anObject [
	"Initialize from an object by extracting class info, views, and slots.
	The GemStone variant prints through a PrintStream limited to 50000 characters."

	<gsCode: '	"Capture a headless object snapshot, including named instance variables."
	| slotNames |
	objectClassName := anObject class name asString.
	superclassName := anObject class superclass ifNil: [ '''' ] ifNotNil: [ :aClass | aClass name asString ].
	packageName := anObject class category asString.
	objectPrintString := [ self class printStringOf: anObject limitedTo: 50000 ] on: Error do: [ :error | ''Error printing object'' ].
	phlowViews := #().
	slotNames := anObject class allInstVarNames.
	allInstanceSlots := (1 to: slotNames size) collect: [ :index |
		| slotValue |
		slotValue := [ anObject instVarAt: index ] on: Error do: [ :error | nil ].
		GtLSerializedSlotInfo new
			name: (slotNames at: index) asString;
			valueClassName: slotValue class name asString;
			valuePrintString: ([ ((slotValue isKindOf: CharacterCollection) or: [ slotValue isKindOf: Character ])
					ifTrue: [ slotValue asString ]
					ifFalse: [ self class printStringOf: slotValue limitedTo: 50000 ] ]
				on: Error do: [ :error | ''Error converting to string'' ]);
			yourself ].'>
	objectClassName := anObject class name asString.
	superclassName := anObject class superclass
			ifNil: [ '' ]
			ifNotNil: [ :s | s name asString ].
	packageName := anObject class package name asString.
	objectPrintString := [ anObject printString escapeCharacter: $' ]
			on: Error
			do: [ :e | 'Error printing object' ].
	phlowViews := ((anObject gtViewsInCurrentContext
			reject: [ :aView | (aView isKindOf: GtPhlowEmptyView) or: [ (aView isKindOf: GtPhlowView) not ] ])
			collect: [ :aView | GtLSerializedViewInfo fromView: aView ]) asArray.
	allInstanceSlots := (anObject class allSlots
			collect: [ :aSlot | GtLSerializedSlotInfo fromSlot: aSlot ofObject: anObject ])
			asArray
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
