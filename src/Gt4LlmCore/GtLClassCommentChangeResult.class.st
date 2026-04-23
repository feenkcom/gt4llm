Class {
	#name : #GtLClassCommentChangeResult,
	#superclass : #GtLClassChangeResult,
	#instVars : [
		'updatedClass',
		'status',
		'originalClass'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLClassCommentChangeResult >> changedClassName [
	^ self updatedClass currentClassName
]

{ #category : #magritte }
GtLClassCommentChangeResult >> changedClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #changedClassName;
		beRequired
]

{ #category : #'gt - extensions' }
GtLClassCommentChangeResult >> gtDiffFor: aView [
	<gtView>
	<gtCodeChangeView>
	^ aView diff
		title: 'Diff';
		priority: 5;
		from: [ self oldClassComment ];
		to: [ self newClassComment ];
		fromLabel: 'Old comment:';
		toLabel: 'New comment:'
]

{ #category : #'gt - extensions' }
GtLClassCommentChangeResult >> gtViewChangeDescriptionElement [
	^ GtLClassCommentChangeDescriptionElement new
		updateForChangeObject: self;
		yourself
]

{ #category : #views }
GtLClassCommentChangeResult >> gtViewChangeIcon [
	^ self class modificationIcon
]

{ #category : #testing }
GtLClassCommentChangeResult >> isClassCommentChangeResult [
	^ true
]

{ #category : #'llm - views' }
GtLClassCommentChangeResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLClassCommentChangeResult >> newClassComment [
	^ updatedClass comment
]

{ #category : #accessing }
GtLClassCommentChangeResult >> oldClassComment [
	^ originalClass comment
]

{ #category : #accessing }
GtLClassCommentChangeResult >> originalClass [
	^originalClass
]

{ #category : #accessing }
GtLClassCommentChangeResult >> originalClass: anObject [
	originalClass := anObject
]

{ #category : #accessing }
GtLClassCommentChangeResult >> originalDefinitionWithCommentString [
	^self originalClass 
		ifNil: [ '' ]
		ifNotNil: [ :each |
			each asDefinitionWithCommentString ] 
]

{ #category : #accessing }
GtLClassCommentChangeResult >> status [
	^ status
]

{ #category : #accessing }
GtLClassCommentChangeResult >> status: aString [
	status := aString
]

{ #category : #magritte }
GtLClassCommentChangeResult >> statusDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Status';
		accessor: #status;
		beRequired
]

{ #category : #accessing }
GtLClassCommentChangeResult >> targetClassName [
	^ self changedClassName
]

{ #category : #accessing }
GtLClassCommentChangeResult >> updatedClass [
	^ updatedClass
]

{ #category : #accessing }
GtLClassCommentChangeResult >> updatedClass: aClass [
	updatedClass := aClass
]

{ #category : #accessing }
GtLClassCommentChangeResult >> updatedDefinitionWithCommentString [
	^self updatedClass 
		ifNil: [ '' ]
		ifNotNil: [ :each |
			each asDefinitionWithCommentString ] 
]
