Class {
	#name : #GtLClassChangeResult,
	#superclass : #GtLCodeChangeResult,
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'magritte-description' }
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

{ #category : #accessing }
GtLClassChangeResult >> targetClassName [
	^ self subclassResponsibility
]
