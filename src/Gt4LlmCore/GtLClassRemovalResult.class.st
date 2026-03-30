"
Result of a successful class removal operation.
"
Class {
	#name : #GtLClassRemovalResult,
	#superclass : #Object,
	#instVars : [
		'removedClassName',
		'status'
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

{ #category : #'llm views' }
GtLClassRemovalResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
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
GtLClassRemovalResult >> removedClassName [
	^ removedClassName
]

{ #category : #accessing }
GtLClassRemovalResult >> removedClassName: aString [
	removedClassName := aString
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
