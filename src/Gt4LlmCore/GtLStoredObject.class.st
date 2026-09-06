"
Represents an explicit entry stored in a GtLObjectStorage. It keeps the generated id, the stored value, and a textual reason describing why the object was stored.
"
Class {
	#name : #GtLStoredObject,
	#superclass : #Object,
	#instVars : [
		'id',
		'value',
		'reason'
	],
	#category : #'Gt4LlmCore-Object Storage'
}

{ #category : #'instance creation' }
GtLStoredObject class >> id: anId value: anObject reason: aString [
	^ self new
		initializeWithId: anId
		value: anObject
		reason: aString
]

{ #category : #'gt extensions' }
GtLStoredObject >> gtInspectorTargetModels [
	| collection |
	collection := {reason}.
	^ (reason respondsTo: #gtInspectorTargetModels)
		ifTrue: [ collection , reason gtInspectorTargetModels ]
		ifFalse: [ collection ]
]

{ #category : #'gt extensions' }
GtLStoredObject >> gtViewsInContext: aPhlowContext [
	| collectedViews |
	collectedViews := Array
		streamContents: [ :aStream |
			aStream nextPutAll: (super gtViewsInContext: aPhlowContext).
			self gtInspectorTargetModels do: [ :eachTargetModel |
				aStream nextPutAll: (GtPhlowViewsCollector new
					fromObject: eachTargetModel;
					pragmaNames: GtLSettings messageViewPragmaNames;
					context: aPhlowContext;
					collect) ] ].

	GtPhlowUtility sortByPriority: collectedViews.

	^ collectedViews
]

{ #category : #accessing }
GtLStoredObject >> id [
	^ id
]

{ #category : #accessing }
GtLStoredObject >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLStoredObject >> idString36 [
	^ id asString36
]

{ #category : #'instance creation' }
GtLStoredObject >> initializeWithId: anId value: anObject reason: aString [
	id := anId.
	value := anObject.
	reason := aString.
	^ self
]

{ #category : #printing }
GtLStoredObject >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< ' [';
		<< id asString36;
		<< '] ';
		print: value.
	reason ifNotNil: [
		aStream
			<< ' (';
			<< reason asReasonString;
			<< ')' ]
]

{ #category : #accessing }
GtLStoredObject >> reason [
	^ reason
]

{ #category : #accessing }
GtLStoredObject >> reason: aReason [
	reason := aReason
]

{ #category : #accessing }
GtLStoredObject >> storedValue [
	^ value
]

{ #category : #accessing }
GtLStoredObject >> storedValue: anObject [
	value := anObject
]

{ #category : #accessing }
GtLStoredObject >> value [
	^ value
]

{ #category : #accessing }
GtLStoredObject >> value: anObject [
	value := anObject
]
