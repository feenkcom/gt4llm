Class {
	#name : #GtLClassCommentChangeResult,
	#superclass : #GtLClassChangeResult,
	#instVars : [
		'updatedClass',
		'status',
		'oldClassComment',
		'newClassComment'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
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
	^ self updatedClass name
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

{ #category : #'as yet unclassified' }
GtLClassCommentChangeResult >> gtViewChangeDescriptionElement [
	^ GtLClassCommentChangeDescriptionElement new
		updateForChangeObject: self;
		yourself
]

{ #category : #views }
GtLClassCommentChangeResult >> gtViewChangeIcon [
	^ self class modificationIcon
]

{ #category : #'llm - views' }
GtLClassCommentChangeResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLClassCommentChangeResult >> newClassComment [
	^ newClassComment
]

{ #category : #accessing }
GtLClassCommentChangeResult >> newClassComment: anObject [
	newClassComment := anObject
]

{ #category : #accessing }
GtLClassCommentChangeResult >> oldClassComment [
	^ oldClassComment
]

{ #category : #accessing }
GtLClassCommentChangeResult >> oldClassComment: anObject [
	oldClassComment := anObject
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
