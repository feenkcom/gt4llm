"
I am the RenameClass transformation of previewRefactoring, also used by the renameClass tool ({{gtClass:GtLMagritteToolForClassRename}}). I rename a class or trait with {{gtClass:GtRBRenameClassRefactoring}}, which rewrites its references in methods, baselines and Lepiter snippets. My preview lists its changes in the class, method and Lepiter groups ({{gtMethod:GtLRenameClassSpecification>>#changeGroupNames}}), as a rename can change many methods and snippets. {{gtMethod:GtLRenameClassSpecification>>#gtProblems}} checks the names first, as RB reports every problem as an invalid class name.
"
Class {
	#name : #GtLRenameClassSpecification,
	#superclass : #GtLClassTransformationSpecification,
	#instVars : [
		'className',
		'newClassName'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLRenameClassSpecification class >> isConcrete [
	^ true
]

{ #category : #accessing }
GtLRenameClassSpecification class >> jsonSchemaLabel [
	^ 'RenameClass'
]

{ #category : #converting }
GtLRenameClassSpecification >> asRefactoringIn: aNamespace [
	"GtRBRenameClassRefactoring also renames the references in Lepiter snippets and baselines"

	^ GtRBRenameClassRefactoring
		model: aNamespace
		rename: className asSymbol
		to: newClassName asSymbol
]

{ #category : #accessing }
GtLRenameClassSpecification >> changeGroupNames [
	"A class rename can change many classes, methods and Lepiter snippets"

	^ #('classChanges' 'methodChanges' 'lepiterChanges')
]

{ #category : #accessing }
GtLRenameClassSpecification >> className [
	^ className
]

{ #category : #accessing }
GtLRenameClassSpecification >> className: aString [
	className := aString
]

{ #category : #magritte }
GtLRenameClassSpecification >> classNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		comment: 'The current name of the class or trait to rename.';
		beRequired
]

{ #category : #accessing }
GtLRenameClassSpecification >> classRename [
	^ className ifNotNil: [ :aName | aName -> newClassName ]
]

{ #category : #accessing }
GtLRenameClassSpecification >> classToRenameIfAbsent: anAbsentBlock [
	className isEmptyOrNil ifTrue: [ ^ anAbsentBlock value ].
	^ (Smalltalk globals classOrTraitNamed: className) ifNil: anAbsentBlock
]

{ #category : #magritte }
GtLRenameClassSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Renames the class or trait className to newClassName, rewriting its references in all methods, including symbols such as #MyClass, and in all Lepiter snippets; comments, strings and plain text are not changed. Put the other transformations on the renamed class before the RenameClass, with its current name. A preview with a RenameClass lists its changes in groups.';
		yourself
]

{ #category : #printing }
GtLRenameClassSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Rename class ';
		nextPutAll: (className ifNil: [ '<class>' ]) asString;
		nextPutAll: ' to ';
		nextPutAll: (newClassName ifNil: [ '<new name>' ]) asString
]

{ #category : #validation }
GtLRenameClassSpecification >> gtProblems [
	"RB answers 'X is not a valid class name' for all these problems, so check them first"

	| aBehavior |
	aBehavior := self
			classToRenameIfAbsent: [ ^ {self
						problemDescribedBy: (className isEmptyOrNil
								ifTrue: [ 'Missing class name' ]
								ifFalse: [ 'Class not found: ' , className ])} ].
	aBehavior name asString = className asString
		ifFalse: [ ^ {self
					problemDescribedBy: ('{1} is another name of {2}. Rename a class by its own name.'
							format: {className.
									aBehavior name})} ].
	aBehavior isClassSide
		ifTrue: [ ^ {self
					problemDescribedBy: ('{1} is the class side of {2}. Rename {2} instead.'
							format: {aBehavior name.
									aBehavior instanceSide name})} ].
	^ self newClassNameProblems
]

{ #category : #accessing }
GtLRenameClassSpecification >> newClassName [
	^ newClassName
]

{ #category : #accessing }
GtLRenameClassSpecification >> newClassName: aString [
	newClassName := aString
]

{ #category : #magritte }
GtLRenameClassSpecification >> newClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'New class name';
		accessor: #newClassName;
		comment: 'The new name of the class or trait.';
		beRequired
]

{ #category : #validation }
GtLRenameClassSpecification >> newClassNameProblems [
	newClassName isEmptyOrNil
		ifTrue: [ ^ {self problemDescribedBy: 'Missing new class name'} ].
	newClassName asString = className asString
		ifTrue: [ ^ {self
					problemDescribedBy: 'The new class name is the current name of the class: ' , newClassName} ].
	(RBCondition isValidClassName: newClassName asString) check
		ifFalse: [ ^ {self
					problemDescribedBy: newClassName
							, ' is not a valid class name: it must start with an uppercase letter and contain only letters, digits and underscores'} ].
	(Smalltalk globals includesKey: newClassName asSymbol)
		ifTrue: [ ^ {self
					problemDescribedBy: newClassName , ' is already the name of a class or global variable'} ].
	^ #()
]

{ #category : #private }
GtLRenameClassSpecification >> problemDescribedBy: aString [
	^ GtLTransformationProblem description: aString
]

{ #category : #accessing }
GtLRenameClassSpecification >> usedClassNames [
	^ {className} reject: [ :each | each isNil ]
]
