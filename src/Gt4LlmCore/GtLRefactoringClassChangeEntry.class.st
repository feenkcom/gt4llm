"
I list a changed class: its name, the new name of a renamed class, and for other class-level changes, such as a slot change, the change description that tells what changed.
"
Class {
	#name : #GtLRefactoringClassChangeEntry,
	#superclass : #GtLRefactoringChangeEntry,
	#instVars : [
		'className',
		'newClassName',
		'changeDescription'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #converting }
GtLRefactoringClassChangeEntry >> addTargetPropertiesTo: aJsonObject [
	aJsonObject at: 'className' put: className.
	newClassName ifNotNil: [ :aName | aJsonObject at: 'newClassName' put: aName ].
	changeDescription
		ifNotNil: [ :aDescription | aJsonObject at: 'changeDescription' put: aDescription ]
]

{ #category : #accessing }
GtLRefactoringClassChangeEntry >> changeDescription [
	"Return what a class-level change does, such as 'Remove instance variable stream from MyClass', or nil when the kind and the class say it all"

	^ changeDescription
]

{ #category : #accessing }
GtLRefactoringClassChangeEntry >> changeDescription: aStringOrNil [
	changeDescription := aStringOrNil
]

{ #category : #accessing }
GtLRefactoringClassChangeEntry >> className [
	^ className
]

{ #category : #accessing }
GtLRefactoringClassChangeEntry >> className: aString [
	className := aString
]

{ #category : #accessing }
GtLRefactoringClassChangeEntry >> groupKind [
	^ #class
]

{ #category : #testing }
GtLRefactoringClassChangeEntry >> isRename [
	^ newClassName notNil
]

{ #category : #accessing }
GtLRefactoringClassChangeEntry >> newClassName [
	"Return the new name of a renamed class, or nil"

	^ newClassName
]

{ #category : #accessing }
GtLRefactoringClassChangeEntry >> newClassName: aStringOrNil [
	newClassName := aStringOrNil
]

{ #category : #accessing }
GtLRefactoringClassChangeEntry >> target [
	^ newClassName
		ifNil: [ className ]
		ifNotNil: [ :aNewName | className , ' to ' , aNewName ]
]

{ #category : #accessing }
GtLRefactoringClassChangeEntry >> useNewClassNames: aDictionary [
	"The rename itself keeps the old name next to the new one"

	self isRename ifTrue: [ ^ self ].
	aDictionary at: className ifPresent: [ :aNewName | className := aNewName ]
]
