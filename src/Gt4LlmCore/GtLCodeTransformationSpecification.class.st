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
GtLCodeTransformationSpecification >> gtParameterProblems [
	"Return the problems with my parameters, such as a missing or invalid name, found from the parameters alone, without looking at the code"

	^ #()
]

{ #category : #validation }
GtLCodeTransformationSpecification >> gtPreconditionProblems [
	"Return the problems with what my refactoring expects of the code, such as a class that exists or a name that is not used yet. My parameters are valid"

	^ #()
]

{ #category : #validation }
GtLCodeTransformationSpecification >> gtPreconditionProblemsAfterAdding: someClassNames [
	"Return the problems with what my refactoring expects of the code once the earlier transformations of the same call added the classes named someClassNames. My parameters are valid"

	^ self gtPreconditionProblems
]

{ #category : #validation }
GtLCodeTransformationSpecification >> gtProblems [
	"Return my problems: those of my parameters or, when my parameters are valid, those of the preconditions of my refactoring"

	^ self gtProblemsAfterAdding: #()
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> gtProblemsAfterAdding: someClassNames [
	"Return my problems once the earlier transformations of the same call added the classes named someClassNames. The preconditions are checked only when the parameters are valid"

	| problems |
	problems := self gtParameterProblems.
	problems ifNotEmpty: [ ^ problems ].
	^ self gtPreconditionProblemsAfterAdding: someClassNames
]

{ #category : #accessing }
GtLCodeTransformationSpecification >> namespaceWithAppliedRefactoring [
	| namespace composite |
	namespace := GtRBNamespace new.
	composite := self asRefactoringIn: namespace.
	composite primitiveExecute.
	^ namespace
]

{ #category : #private }
GtLCodeTransformationSpecification >> parameterProblem: aString [
	^ GtLTransformationParameterProblem description: aString
]

{ #category : #validation }
GtLCodeTransformationSpecification >> parameterProblemsWithClassName: aString [
	^ aString isEmptyOrNil
		ifTrue: [ {self parameterProblem: 'Missing class name'} ]
		ifFalse: [ #() ]
]

{ #category : #private }
GtLCodeTransformationSpecification >> preconditionProblem: aString [
	^ GtLTransformationPreconditionProblem description: aString
]

{ #category : #validation }
GtLCodeTransformationSpecification >> preconditionProblemsWithClassNamed: aString [
	^ (Smalltalk globals classNamed: aString) isNil
		ifTrue: [ {self preconditionProblem: 'Class not found: ' , aString} ]
		ifFalse: [ #() ]
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
