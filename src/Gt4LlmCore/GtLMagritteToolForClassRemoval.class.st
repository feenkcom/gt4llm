"
Magritte-based tool for removing a class from the image.
"
Class {
	#name : #GtLMagritteToolForClassRemoval,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #private }
GtLMagritteToolForClassRemoval >> applySpecification: aSpecification [
	"Name the changes: the undo history shows the name"

	| aNamespace |
	aNamespace := aSpecification namespaceWithAppliedRefactoring.
	aNamespace name: aSpecification gtDisplayString.
	^ (GtLRefactoringPreview
		namespace: aNamespace
		refactoringName: aSpecification refactoringName
		refactoringDescription: aSpecification refactoringDescription) apply
]

{ #category : #magritte }
GtLMagritteToolForClassRemoval >> classNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		beRequired
]

{ #category : #private }
GtLMagritteToolForClassRemoval >> classRemovalResultNamed: aClassName in: anAppliedRefactoring ifNone: aBlock [
	^ anAppliedRefactoring codeChangeResults
		detect: [ :each | each isClassRemovalResult and: [ each removedClassName = aClassName ] ]
		ifNone: aBlock
]

{ #category : #accessing }
GtLMagritteToolForClassRemoval >> description [
	^ 'Removes the class or trait with the provided name from the image.

The removal is refused while the class has subclasses, while the trait is used by classes or traits (also when used only on the class side), or while the shared pool is used by classes or traits. The response then names these classes and what to do first. Classes needed by the virtual machine are never removed.

Methods that reference the class do not prevent its removal. If you want to update those methods, find them with classReferences before the removal: afterwards it no longer finds the class.

Example JSON arguments:
{
  "className": "MyClass"
}

Example JSON response:
{
  "removedClassName": "MyClass",
  "status": "removed"
}

Example JSON response when the removal is refused:
{
  "errorMessage": "MyClass has subclasses: MySubclass. Remove the subclasses first."
}'
]

{ #category : #private }
GtLMagritteToolForClassRemoval >> missingRemovalResultForClassNamed: aClassName [
	^ GtLProblemDomainObject new
		errorMessage: aClassName asString
				, ((Smalltalk globals includesKey: aClassName)
						ifTrue: [ ' was not removed' ]
						ifFalse: [ ' was removed, but no class removal was reported' ])
]

{ #category : #accessing }
GtLMagritteToolForClassRemoval >> name [
	^ 'removeClass'
]

{ #category : #'tool api' }
GtLMagritteToolForClassRemoval >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| className specification aClass problems |
	className := aToolCall arguments at: 'className'.
	specification := GtLRemoveClassSpecification new classNameToRemove: className.
	aClass := specification
			classToRemoveIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ].
	problems := specification gtProblems.
	problems ifNotEmpty: [ ^ self problemFromTransformationProblems: problems ].
	^ self removeClass: aClass with: specification
]

{ #category : #private }
GtLMagritteToolForClassRemoval >> problemFromTransformationProblems: someProblems [
	^ GtLProblemDomainObject new
		errorMessage: (' ' join: (someProblems collect: [ :each | each description ]))
]

{ #category : #private }
GtLMagritteToolForClassRemoval >> removalError: anExceptionDomainObject forClassNamed: aClassName [
	"The error can happen after the class is removed, while the changes are reported"

	^ anExceptionDomainObject
		errorReason: ((Smalltalk globals includesKey: aClassName)
				ifTrue: [ 'Error while removing class' ]
				ifFalse: [ 'Error after removing class: the class was removed' ]);
		yourself
]

{ #category : #private }
GtLMagritteToolForClassRemoval >> removeClass: aClass with: aSpecification [
	"Take the name before the removal: afterwards the class is obsolete"

	| className result |
	className := aClass name.
	result := [ self applySpecification: aSpecification ]
			on: Error
			do: [ :anError | 
				^ self
					removalError: (GtLExceptionDomainObject freeze: anError)
					forClassNamed: className ].
	result hasFailed
		ifTrue: [ ^ self removalError: result exception forClassNamed: className ].
	^ self
		classRemovalResultNamed: className
		in: result
		ifNone: [ self missingRemovalResultForClassNamed: className ]
]
