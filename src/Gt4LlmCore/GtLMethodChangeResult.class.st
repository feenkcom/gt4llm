Class {
	#name : #GtLMethodChangeResult,
	#superclass : #GtLCodeChangeResult,
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'gt-view' }
GtLMethodChangeResult >> asDiffElement [
	| newSource oldSource |
	oldSource := self oldStateMethodSourceCode.
	newSource := self newStateMethodSourceCode.
	^ GtDiffElementWithLabelStencil new
		fromLabelText: 'Old from '
				, (self targetMethod
						ifNotNil: [ :m | String space , m methodReference methodClassName ]);
		toLabelText: 'New in '
				, (self targetMethod
						ifNotNil: [ :m | String space , m methodReference methodClassName ]);
		change: (GtDiffBuilder
				computeDifferencesFrom: oldSource
				to: newSource
				using: GtSmaCCDiffSplitter forPharo);
		asElement
]

{ #category : #'gt-view' }
GtLMethodChangeResult >> gtDiffFor: aView [
	<gtView>
	<gtCodeChangeView>
	^ aView explicit
		title: 'Diff';
		priority: 5;
		stencil: [ self asDiffElement ]
]

{ #category : #'gt-view' }
GtLMethodChangeResult >> gtViewChangeDescriptionElement [
	^ GtLMethodChangeDescriptionElement new
		updateForChangeObject: self;
		yourself
]

{ #category : #testing }
GtLMethodChangeResult >> isMethodAdditionResult [
	^ false
]

{ #category : #testing }
GtLMethodChangeResult >> isMethodChangeResult [
	^ true
]

{ #category : #testing }
GtLMethodChangeResult >> isMethodModificationResult [
	^ false
]

{ #category : #testing }
GtLMethodChangeResult >> isMethodRemovalResult [
	^ false
]

{ #category : #'as yet unclassified' }
GtLMethodChangeResult >> newStateMethodSourceCode [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtLMethodChangeResult >> oldStateMethodSourceCode [
	self subclassResponsibility
]

{ #category : #accessing }
GtLMethodChangeResult >> targetMethod [

	^ self subclassResponsibility
]

{ #category : #accessing }
GtLMethodChangeResult >> targetMethodReference [
	^ self targetMethod methodReference
]
