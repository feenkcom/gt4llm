Class {
	#name : #GtLCodeTransformationSpecification,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLCodeTransformationSpecification class >> isConcrete [
	^ false
]

{ #category : #accessing }
GtLCodeTransformationSpecification class >> jsonSchemaLabel [
	^ (self class name
		withoutPrefix: 'GtL')
		withoutSuffix: 'Specification'
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
GtLCodeTransformationSpecification >> asRefactoring [
	| namespace |
	namespace := GtRBNamespace new.
	^ self asRefactoringIn: namespace.
]

{ #category : #'as yet unclassified' }
GtLCodeTransformationSpecification >> asRefactoringIn: aNamespace [
	^ self subclassResponsibility
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

{ #category : #validation }
GtLCodeTransformationSpecification >> gtProblemsWithClassNamed: aString [
	^(Smalltalk globals classNamed: aString) isNil
		ifTrue: 
			[Array
				with: (GtLTransformationProblem description: 'Class not found: ' , aString)]
		ifFalse: [#()]
]

{ #category : #validation }
GtLCodeTransformationSpecification >> gtProblemsWithMethod: aSelectorString inClassNamed: aClassName [
	| class |
	class := Smalltalk globals classNamed: aClassName.
	class isNil ifTrue: [^self gtProblemsWithClassNamed: aClassName].
	^(class includesSelector: aSelectorString asSymbol)
		ifTrue: [#()]
		ifFalse: 
			[Array with: (GtLTransformationProblem
						description: aClassName , ' does not implement #' , aSelectorString)]
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
