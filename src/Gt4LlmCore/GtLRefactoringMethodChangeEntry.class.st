"
I list a changed method by its class, side and selector.
"
Class {
	#name : #GtLRefactoringMethodChangeEntry,
	#superclass : #GtLRefactoringChangeEntry,
	#instVars : [
		'methodClassName',
		'methodName',
		'classSide'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #converting }
GtLRefactoringMethodChangeEntry >> addTargetPropertiesTo: aJsonObject [
	aJsonObject
		at: 'methodClassName' put: methodClassName;
		at: 'methodName' put: methodName;
		at: 'classSide' put: self classSide
]

{ #category : #accessing }
GtLRefactoringMethodChangeEntry >> classSide [
	^ classSide ifNil: [ false ]
]

{ #category : #accessing }
GtLRefactoringMethodChangeEntry >> classSide: aBoolean [
	classSide := aBoolean
]

{ #category : #accessing }
GtLRefactoringMethodChangeEntry >> groupKind [
	^ #method
]

{ #category : #accessing }
GtLRefactoringMethodChangeEntry >> methodClassName [
	^ methodClassName
]

{ #category : #accessing }
GtLRefactoringMethodChangeEntry >> methodClassName: aString [
	methodClassName := aString
]

{ #category : #accessing }
GtLRefactoringMethodChangeEntry >> methodName [
	^ methodName
]

{ #category : #accessing }
GtLRefactoringMethodChangeEntry >> methodName: aString [
	methodName := aString
]

{ #category : #accessing }
GtLRefactoringMethodChangeEntry >> target [
	^ methodClassName , (self classSide ifTrue: [ ' class' ] ifFalse: [ '' ])
		, '>>#' , methodName
]

{ #category : #accessing }
GtLRefactoringMethodChangeEntry >> useNewClassNames: aDictionary [
	aDictionary
		at: methodClassName
		ifPresent: [ :aNewName | methodClassName := aNewName ]
]
