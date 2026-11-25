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

{ #category : #accessing }
GtLClassChangeResult >> historyClassNames [
	"Return the names of the class histories this change belongs to"

	^ {self targetClassName asString}
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

{ #category : #refactoring }
GtLClassChangeResult >> llmChangeEntry [
	^ GtLRefactoringClassChangeEntry new
		className: self targetClassName asString;
		kind: self llmChangeKind;
		newSource: self llmNewSource;
		yourself
]

{ #category : #refactoring }
GtLClassChangeResult >> llmChangeKind [
	^ 'changed class'
]

{ #category : #refactoring }
GtLClassChangeResult >> llmNewSource [
	"Return the class definition or comment that the change introduced, or nil"

	^ nil
]

{ #category : #accessing }
GtLClassChangeResult >> targetClassName [
	^ self subclassResponsibility
]
