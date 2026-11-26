"
I describe a class whose definition changes because a class it refers to is renamed: a direct subclass of the renamed class, or a user of the renamed trait. No RB change is needed for it, as the definition refers to the class object, but its definition string changes. My new definition has the form of the definitions of applied refactorings ({{gtClass:GtLClassDefinitionDescription}}), so that the preview and the applied refactoring show the same.

I answer the same gtLlm* messages as the RB changes, so that a {{gtClass:GtLRefactoringChange}} can describe me in a refactoring preview.
"
Class {
	#name : #GtLRefactoringDefinitionChange,
	#superclass : #Object,
	#instVars : [
		'className',
		'newDefinition'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #private }
GtLRefactoringDefinitionChange class >> definitionOf: aClass renaming: anOldName to: aNewName [
	"Return the definition of aClass once the class named anOldName is renamed, in the form of the definitions of applied refactorings: its superclass or its traits name the renamed class"

	| aDescription |
	aDescription := GtLClassDefinitionDescription fromClass: aClass.
	aDescription superclassName asString = anOldName asString
		ifTrue: [ aDescription superclassName: aNewName asString ].
	aDescription
		traitCompositionString: (self
				expression: aDescription traitCompositionString
				renaming: anOldName
				to: aNewName).
	^ aDescription asDefinitionString
]

{ #category : #private }
GtLRefactoringDefinitionChange class >> expression: aString renaming: anOldName to: aNewName [
	"Replace the variables named anOldName in the expression aString, such as a trait composition. The receiver of a cascade is visited once per message, so each position is kept once"

	| anAst starts aStream index |
	anAst := [ RBParser parseExpression: aString ]
			on: Error
			do: [ :anError | ^ aString ].
	starts := Dictionary new.
	anAst
		nodesDo: [ :each | 
			(each isVariable and: [ each name asString = anOldName asString ])
				ifTrue: [ starts at: each start put: each stop ] ].
	index := 1.
	aStream := WriteStream on: String new.
	starts keys asSortedCollection
		do: [ :eachStart | 
			aStream
				nextPutAll: (aString copyFrom: index to: eachStart - 1);
				nextPutAll: aNewName asString.
			index := (starts at: eachStart) + 1 ].
	aStream nextPutAll: (aString copyFrom: index to: aString size).
	^ aStream contents
]

{ #category : #'instance creation' }
GtLRefactoringDefinitionChange class >> forClass: aClass renaming: anOldName to: aNewName [
	^ self new
		initializeClassName: aClass name asString
		newDefinition: (self
				definitionOf: aClass
				renaming: anOldName
				to: aNewName)
]

{ #category : #accessing }
GtLRefactoringDefinitionChange >> changeString [
	^ 'Change definition of ' , className
]

{ #category : #accessing }
GtLRefactoringDefinitionChange >> className [
	^ className
]

{ #category : #accessing }
GtLRefactoringDefinitionChange >> gtLlmChangeDescription [
	"Described like the RB changes, see RBRefactoryChange>>#gtLlmChangeDescription"

	^ self changeString
]

{ #category : #llm }
GtLRefactoringDefinitionChange >> gtLlmChangeKind [
	^ 'changed class'
]

{ #category : #llm }
GtLRefactoringDefinitionChange >> gtLlmChangeTarget [
	^ className
]

{ #category : #llm }
GtLRefactoringDefinitionChange >> gtLlmMatchesCodeChangeResult: aCodeChangeResult [
	^ aCodeChangeResult isClassChangeResult
		and: [ aCodeChangeResult targetClassName asString = className ]
]

{ #category : #llm }
GtLRefactoringDefinitionChange >> gtLlmNewChangeEntry [
	^ GtLRefactoringClassChangeEntry new
		className: className;
		yourself
]

{ #category : #llm }
GtLRefactoringDefinitionChange >> gtLlmNewSource [
	^ newDefinition
]

{ #category : #initialization }
GtLRefactoringDefinitionChange >> initializeClassName: aString newDefinition: aDefinitionString [
	className := aString.
	newDefinition := aDefinitionString
]

{ #category : #accessing }
GtLRefactoringDefinitionChange >> newDefinition [
	^ newDefinition
]

{ #category : #printing }
GtLRefactoringDefinitionChange >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [ aStream nextPutAll: className asString ]
]
