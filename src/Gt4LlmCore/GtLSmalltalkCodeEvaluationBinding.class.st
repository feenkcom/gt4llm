"
Represents a binding entry for Smalltalk code evaluation with a variable name and object storage ID.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationBinding,
	#superclass : #Object,
	#instVars : [
		'name',
		'objectId'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLSmalltalkCodeEvaluationBinding >> name [
	^ name
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationBinding >> name: aString [
	name := aString
]

{ #category : #magritte }
GtLSmalltalkCodeEvaluationBinding >> nameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Name';
		accessor: #name;
		beRequired
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationBinding >> objectId [
	^ objectId
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationBinding >> objectId: aString [
	objectId := aString
]

{ #category : #magritte }
GtLSmalltalkCodeEvaluationBinding >> objectIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Object ID';
		accessor: #objectId;
		beRequired
]

{ #category : #printing }
GtLSmalltalkCodeEvaluationBinding >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (name ifNil: [ '' ]);
		nextPutAll: ' -> ';
		nextPutAll: (objectId ifNil: [ '' ]);
		nextPut: $)
]
