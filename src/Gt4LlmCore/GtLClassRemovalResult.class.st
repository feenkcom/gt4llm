"
Result of a successful class removal operation.
"
Class {
	#name : #GtLClassRemovalResult,
	#superclass : #GtLClassChangeResult,
	#instVars : [
		'status',
		'removedClass'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #views }
GtLClassRemovalResult >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [
			{'Removed class' -> self removedClassName.
			 'Status' -> self status} ];
		column: 'Property' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #accessing }
GtLClassRemovalResult >> gtDiffFor: aView [
	<gtView>
	<gtCodeChangeView>
	^ aView diff
		title: 'Diff';
		priority: 5;
		from: [ self originalDefinitionWithCommentString ];
		to: [ '' ];
		fromLabel: 'Old comment:';
		toLabel: 'New comment:'
]

{ #category : #views }
GtLClassRemovalResult >> gtViewChangeIcon [
	^ self class removalIcon
]

{ #category : #testing }
GtLClassRemovalResult >> isClassDefinitionChangeResult [
	^ true
]

{ #category : #testing }
GtLClassRemovalResult >> isClassRemovalResult [
	^ true
]

{ #category : #'llm views' }
GtLClassRemovalResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLClassRemovalResult >> originalDefinitionWithCommentString [
	^self removedClass 
		ifNil: [ '' ]
		ifNotNil: [ :each |
			each asDefinitionWithCommentString ] 
]

{ #category : #printing }
GtLClassRemovalResult >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		self removedClassName ifNotNil: [ :name | aStream nextPutAll: name ].
		aStream nextPutAll: ' — '.
		self status ifNotNil: [ :s | aStream nextPutAll: s ] ]
]

{ #category : #accessing }
GtLClassRemovalResult >> removedClass [
	^removedClass
]

{ #category : #accessing }
GtLClassRemovalResult >> removedClass: anObject [
	removedClass := anObject
]

{ #category : #accessing }
GtLClassRemovalResult >> removedClassName [
	^ removedClass currentClassName
]

{ #category : #magritte }
GtLClassRemovalResult >> removedClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Removed class name';
		accessor: #removedClassName;
		beRequired
]

{ #category : #accessing }
GtLClassRemovalResult >> status [
	^ status
]

{ #category : #accessing }
GtLClassRemovalResult >> status: aString [
	status := aString
]

{ #category : #magritte }
GtLClassRemovalResult >> statusDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Status';
		accessor: #status;
		beRequired
]

{ #category : #accessing }
GtLClassRemovalResult >> targetClassName [
	^ self removedClassName
]

{ #category : #accessing }
GtLClassRemovalResult >> updatedDefinitionWithCommentString [
	^ ''
]
