"
I hold the shared state and behavior of advertised ACP commands and skills: metadata, invocation text, execution through a session, and inspector views.
"
Class {
	#name : #GtLACPInvocable,
	#superclass : #GtLACPObject,
	#instVars : [
		'session',
		'data'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPInvocable >> data [
	^ data
]

{ #category : #accessing }
GtLACPInvocable >> data: aDictionary [
	data := aDictionary deepCopy
]

{ #category : #accessing }
GtLACPInvocable >> description [
	^ data at: 'description' ifAbsent: [ '' ]
]

{ #category : #views }
GtLACPInvocable >> gtDataFor: aView [
	<gtView>
	^ aView forward
		title: 'Data';
		priority: 20;
		object: [ data ];
		view: #gtItemsFor:
]

{ #category : #printing }
GtLACPInvocable >> gtDisplayOn: aStream [
	aStream nextPutAll: self invocation
]

{ #category : #views }
GtLACPInvocable >> gtInvocationFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Invocation';
		priority: 0;
		items: [ {'Name' -> self name.
				'Invocation' -> self.
				'Description' -> self description.
				'Input hint' -> self inputHint.
				'Session' -> session} ];
		column: 'Property'
			text: #key
			width: 110;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtLACPInvocable >> inputHint [
	^ (data at: 'input' ifAbsent: [ nil ])
		ifNil: [ '' ]
		ifNotNil: [ :input | input at: 'hint' ifAbsent: [ '' ] ]
]

{ #category : #accessing }
GtLACPInvocable >> invocation [
	^ (self name beginsWith: '/')
		ifTrue: [ self name ]
		ifFalse: [ '/' , self name ]
]

{ #category : #invoking }
GtLACPInvocable >> invokeWith: arguments [
	^ session invokeCommand: self arguments: arguments
]

{ #category : #'subclass responsibility' }
GtLACPInvocable >> isSkill [
	self subclassResponsibility
]

{ #category : #accessing }
GtLACPInvocable >> name [
	^ data at: 'name'
]

{ #category : #invoking }
GtLACPInvocable >> promptWith: arguments [
	^ arguments trimBoth
		ifEmpty: [ self invocation ]
		ifNotEmpty: [ :text | self invocation , ' ' , text ]
]

{ #category : #accessing }
GtLACPInvocable >> session [
	^ session
]

{ #category : #accessing }
GtLACPInvocable >> session: aSession [
	session := aSession
]
