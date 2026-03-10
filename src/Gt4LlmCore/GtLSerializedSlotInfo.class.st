"
Represents serialized information about an instance slot including its name, class, and string value.
"
Class {
	#name : #GtLSerializedSlotInfo,
	#superclass : #Object,
	#instVars : [
		'name',
		'valueClassName',
		'valuePrintString'
	],
	#classVars : [
		':parameter>',
		'</antml',
		'<parameter',
		'name="package">Gt4LlmCore'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLSerializedSlotInfo class >> fromSlot: aSlot ofObject: anObject [
	"Create a serialized slot info from a slot and its owning object."
	^ self new
		initializeFromSlot: aSlot ofObject: anObject;
		yourself
]

{ #category : #initialization }
GtLSerializedSlotInfo >> initializeFromSlot: aSlot ofObject: anObject [
	"Initialize from a slot and its owning object."
	| slotValue |
	slotValue := [ anObject readSlotNamed: aSlot name ]
		on: Error do: [ :e | nil ].
	self name: aSlot name asString.
	self valueClassName: slotValue class name asString.
	self valuePrintString: ([ (slotValue asString escapeCharacter: $') ] 
		on: Error do: [ :e | 'Error converting to string' ])
]

{ #category : #accessing }
GtLSerializedSlotInfo >> name [
	^ name
]

{ #category : #accessing }
GtLSerializedSlotInfo >> name: aString [
	name := aString
]

{ #category : #magritte }
GtLSerializedSlotInfo >> nameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Name';
		accessor: #name;
		beRequired
]

{ #category : #printing }
GtLSerializedSlotInfo >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (name ifNil: [ '' ]);
		nextPutAll: ': ';
		nextPutAll: (valueClassName ifNil: [ '' ]);
		nextPut: $)
]

{ #category : #accessing }
GtLSerializedSlotInfo >> valueClassName [
	"Return the class name of the slot value."
	^ valueClassName
]

{ #category : #accessing }
GtLSerializedSlotInfo >> valueClassName: aString [
	"Set the class name of the slot value."
	valueClassName := aString
]

{ #category : #magritte }
GtLSerializedSlotInfo >> valueClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Value class name';
		accessor: #valueClassName;
		beRequired
]

{ #category : #accessing }
GtLSerializedSlotInfo >> valuePrintString [
	"Return the print string of the slot value."
	^ valuePrintString
]

{ #category : #accessing }
GtLSerializedSlotInfo >> valuePrintString: aString [
	"Set the print string of the slot value."
	valuePrintString := aString
]

{ #category : #magritte }
GtLSerializedSlotInfo >> valuePrintStringDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Value print string';
		accessor: #valuePrintString;
		beRequired
]
