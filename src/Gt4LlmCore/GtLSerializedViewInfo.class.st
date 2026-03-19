"
Represents serialized information about a phlow view including its method name and title.
"
Class {
	#name : #GtLSerializedViewInfo,
	#superclass : #Object,
	#instVars : [
		'methodName',
		'title'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLSerializedViewInfo class >> fromView: aView [
	"Create a serialized view info from a phlow view."
	^ self new
		initializeFromView: aView;
		yourself
]

{ #category : #initialization }
GtLSerializedViewInfo >> initializeFromView: aView [
	"Initialize from a phlow view."
	self methodName: aView methodSelector asString.
	self title: aView title asString
]

{ #category : #accessing }
GtLSerializedViewInfo >> methodName [
	^ methodName
]

{ #category : #accessing }
GtLSerializedViewInfo >> methodName: aString [
	methodName := aString
]

{ #category : #magritte }
GtLSerializedViewInfo >> methodNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodName;
		beRequired
]

{ #category : #printing }
GtLSerializedViewInfo >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (title ifNil: [ '' ]);
		nextPut: $)
]

{ #category : #accessing }
GtLSerializedViewInfo >> title [
	^ title
]

{ #category : #accessing }
GtLSerializedViewInfo >> title: aString [
	title := aString
]

{ #category : #magritte }
GtLSerializedViewInfo >> titleDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Title';
		accessor: #title;
		beRequired
]
