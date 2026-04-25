Class {
	#name : #GtLClassChangeResult,
	#superclass : #GtLCodeChangeResult,
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLClassChangeResult >> affectedBehaviour [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLClassChangeResult >> affectedBehaviourName [
	^ self affectedBehaviour currentClassName
]

{ #category : #accessing }
GtLClassChangeResult >> affectedPackageName [
	^ self affectedBehaviour packageName
]

{ #category : #accessing }
GtLClassChangeResult >> affectedPackageTagName [
	^ self affectedBehaviour packageTagName
]

{ #category : #'gt - extensions' }
GtLClassChangeResult >> gtViewChangeDescriptionElement [
	^ GtLClassDefinitionChangeDescriptionElement new
		updateForChangeObject: self
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
GtLClassChangeResult >> isClassModificationResult [
	"Return true if this is a class modification (not an addition)"
	^ false
]

{ #category : #accessing }
GtLClassChangeResult >> targetClassName [
	^ self subclassResponsibility
]
