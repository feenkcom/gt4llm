Class {
	#name : #GtLCodeTransformationSpecification,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLCodeTransformationSpecification class >> instanceSideNameOf: aClassName [
	"MyClass for both MyClass and MyClass class"

	^ (aClassName asString endsWith: ' class')
		ifTrue: [ aClassName asString allButLast: ' class' size ]
		ifFalse: [ aClassName asString ]
]

{ #category : #testing }
GtLCodeTransformationSpecification class >> isConcrete [
	^ false
]

{ #category : #accessing }
GtLCodeTransformationSpecification class >> jsonSchemaLabel [
	^ (self name withoutPrefix: 'GtL') withoutSuffix: 'Specification'
]

{ #category : #accessing }
GtLCodeTransformationSpecification class >> refactoringName [
	"Return a short human readable name of the transformation, derived from its JSON schema label,
	for example 'Push up instance variable' for 'PushUpInstanceVariable'"

	^ String
		streamContents: [ :aStream | 
			self jsonSchemaLabel
				doWithIndex: [ :eachCharacter :anIndex | 
					(anIndex > 1 and: [ eachCharacter isUppercase ])
						ifTrue: [ aStream
								space;
								nextPut: eachCharacter asLowercase ]
						ifFalse: [ aStream nextPut: eachCharacter ] ] ]
]

{ #category : #'api - ui' }
GtLCodeTransformationSpecification >> addContentOneLineSummaryTo: aWriteStream [
	self gtDisplayOn: aWriteStream
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> addedClassName [
	"Return the name of the class I add, or nil"

	^ nil
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> asRefactoring [
	| namespace |
	namespace := GtRBNamespace new.
	^ self asRefactoringIn: namespace.
]

{ #category : #'as yet unclassified' }
GtLCodeTransformationSpecification >> asRefactoringIn: aNamespace [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> changeGroupNames [
	"Return the names of the groups in which a preview lists my changes, each also when it is empty. Without names, my changes are listed one by one"

	^ #()
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> classRename [
	"Return the old name -> the new name of the class I rename, or nil"

	^ nil
]

{ #category : #'api - ui' }
GtLCodeTransformationSpecification >> contentOneLineMultiLabelSummaryWith: aBuilder [
	aBuilder newTextFromStringStream: [ :aWriteStream | 
		self addContentOneLineSummaryTo: aWriteStream ]
]

{ #category : #views }
GtLCodeTransformationSpecification >> gtChangesFor: aView [
	<gtView>
	^ aView forward
		title: 'Changes';
		object: [ self namespaceWithAppliedRefactoring ];
		view: #gtApplyingChangesFor:
]

{ #category : #validation }
GtLCodeTransformationSpecification >> gtProblems [
	^#()
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> gtProblemsAfterAdding: someClassNames [
	"Return my problems once the earlier transformations of the same call added the classes named someClassNames"

	^ self gtProblems
]

{ #category : #validation }
GtLCodeTransformationSpecification >> gtProblemsWithClassNamed: aString [
	aString isEmptyOrNil
		ifTrue: [ ^ {GtLTransformationProblem description: 'Missing class name'} ].
	^ (Smalltalk globals classNamed: aString) isNil
		ifTrue: [ {GtLTransformationProblem description: 'Class not found: ' , aString} ]
		ifFalse: [ #() ]
]

{ #category : #validation }
GtLCodeTransformationSpecification >> gtProblemsWithMethod: aSelectorString inClassNamed: aClassName [
	"The method must be defined in the class itself, as for the method tools: a transformation of an inherited method or of a copy provided by a trait would not change the class"

	| class |
	class := aClassName isEmptyOrNil
			ifFalse: [ Smalltalk globals classNamed: aClassName ].
	class isNil ifTrue: [ ^ self gtProblemsWithClassNamed: aClassName ].
	^ (GtLMethodReference new
		methodClassName: class instanceSide name;
		methodName: aSelectorString;
		classSide: class isClassSide;
		yourself)
		compiledMethodIfPresent: [ :aMethod | #() ]
		ifMissing: [ :anErrorResult | {GtLTransformationProblem description: anErrorResult errorMessage} ]
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> namespaceWithAppliedRefactoring [
	| namespace composite |
	namespace := GtRBNamespace new.
	composite := self asRefactoringIn: namespace.
	composite primitiveExecute.
	^ namespace
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> refactoringDescription [
	"Return a description of the transformation with its parameters, such as 'Push up method foo from MySubclass to MySuperclass'"

	^ self gtDisplayString
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> refactoringName [
	"Return a short human readable name of the transformation, such as 'Push up method'"

	^ self class refactoringName
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> usedClassNames [
	"Return the names of the existing classes I refer to"

	^ #()
]
