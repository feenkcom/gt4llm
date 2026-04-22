Class {
	#name : #GtLClassCommentChangeResult,
	#superclass : #GtLClassChangeResult,
	#instVars : [
		'updatedClass',
		'status',
		'originalClass'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #views }
GtLClassCommentChangeResult >> asDiffElement [
	| newSource oldSource |
	oldSource := self oldClassComment.
	newSource := self newClassComment.
	^ GtDiffElementWithLabelStencil new
		fromLabelText: 'Old comment for ', (self changedClassName);
		toLabelText: 'New comment for '	, (self changedClassName);
		change: (GtDiffBuilder
				computeDifferencesFrom: oldSource
				to: newSource
				using: GtSmaCCDiffSplitter forPharo);
		asElement
]

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

{ #category : #views }
GtLClassCommentChangeResult >> gtDiffFor: aView [
	<gtView>
	<gtCodeChangeView>
	^ aView explicit
		title: 'Diff';
		priority: 5;
		stencil: [ self asDiffElement ]
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
