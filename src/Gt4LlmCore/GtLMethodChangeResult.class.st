Class {
	#name : #GtLMethodChangeResult,
	#superclass : #GtLCodeChangeResult,
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'as yet unclassified' }
GtLMethodChangeResult >> currentMethodSourceCode [
	^self subclassResponsibility
]

{ #category : #'gt - extensions' }
GtLMethodChangeResult >> gtDiffFor: aView [
	<gtView>
	<gtCodeChangeView>
	^ aView diff
		title: 'Diff';
		priority: 5;
		from: [ self oldStateMethodSourceCode ];
		to: [ self newStateMethodSourceCode ];
		fromLabel: 'Old content:';
		toLabel: 'New content:';
		styler: GtCodeDiffRBTextStyler new
]

{ #category : #'gt - extensions' }
GtLMethodChangeResult >> gtDiffWithCurrentVersionFor: aView [
	<gtView>
	<gtCodeChangeView>
	^ aView diff
		title: 'Diff (with current)';
		priority: 9;
		from: [ self currentMethodSourceCode ];
		to: [ self newStateMethodSourceCode ];
		fromLabel: 'Image content:';
		toLabel: 'Change content:';
		styler: GtCodeDiffRBTextStyler new
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
