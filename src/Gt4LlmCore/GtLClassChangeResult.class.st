Class {
	#name : #GtLClassChangeResult,
	#superclass : #GtLCodeChangeResult,
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'gt - extensions' }
GtLClassChangeResult >> gtViewChangeDescriptionElement [
	^ GtLClassDefinitionChangeDescriptionElement new
		updateForChangeObject: self;
		yourself
]

{ #category : #testing }
GtLClassChangeResult >> isClassAdditionResult [
	^ false
]

{ #category : #testing }
GtLClassChangeResult >> isClassChangeResult [
	^ true
]

{ #category : #testing }
GtLClassChangeResult >> isClassCommentChangeResult [
	^ false
]

{ #category : #testing }
GtLClassChangeResult >> isClassDefinitionChangeResult [
	^ false
]

{ #category : #accessing }
GtLClassChangeResult >> targetClassName [
	^ self subclassResponsibility
]
