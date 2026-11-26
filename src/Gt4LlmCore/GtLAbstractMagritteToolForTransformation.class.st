"
I am the abstract parent of the tools that apply one transformation of previewRefactoring at once, without a preview: {{gtClass:GtLMagritteToolForClassRename}} and {{gtClass:GtLMagritteToolForMethodRename}}.
I build the transformation from the arguments of the call ({{gtMethod:GtLAbstractMagritteToolForTransformation>>#specificationFromArguments:}}), refuse it when it has problems, apply it as applyRefactoring applies a preview, store the result ({{gtClass:GtLRefactoringResult}}) and answer a report of it ({{gtClass:GtLRefactoringResultReport}}) built for the displayOptions of the call.
"
Class {
	#name : #GtLAbstractMagritteToolForTransformation,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #testing }
GtLAbstractMagritteToolForTransformation class >> isAbstract [
	^ self name = #GtLAbstractMagritteToolForTransformation
]

{ #category : #private }
GtLAbstractMagritteToolForTransformation >> applySpecification: aSpecification displayOptions: aDisplayOptions inContext: anExecutionContext [
	"Answer a report of the result, built for the display options of the call. A failure while executing the changes is reported by the result itself"

	| result |
	result := [ self
			applySpecification: aSpecification
			inContext: anExecutionContext ]
			on: Error
			do: [ :anError | 
				^ (GtLExceptionDomainObject freeze: anError)
					errorReason: self errorReason;
					yourself ].
	^ result reportFor: aDisplayOptions
]

{ #category : #private }
GtLAbstractMagritteToolForTransformation >> applySpecification: aSpecification inContext: anExecutionContext [
	"Go through the transformations, as previewRefactoring does, so that the changes are linked to the refactoring. Name the changes: the undo history shows the name.
	Store the result, as applyRefactoring does: the response gives its objectId, and the result keeps all the changes, also when the response does not list them"

	| transformations namespace result |
	transformations := GtLCodeTransformations new transformations: {aSpecification}.
	namespace := transformations applyRefactoring.
	namespace name: aSpecification gtDisplayString.
	result := (GtLRefactoringPreview
			namespace: namespace
			refactoringName: transformations refactoringName
			refactoringDescription: transformations refactoringDescription
			changeGroupNames: transformations changeGroupNames) apply.
	anExecutionContext objectStorage
		ifNotNil: [ :aStorage | 
			result
				objectId: (aStorage
						addNewObject: result
						reason: (GtLStoredObjectStringReason text: self resultDescription)) ].
	^ result
]

{ #category : #magritte }
GtLAbstractMagritteToolForTransformation >> displayOptionsDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Display options';
		accessor: #displayOptions;
		classes: {GtLRefactoringResultDisplayOptions};
		beOptional
]

{ #category : #private }
GtLAbstractMagritteToolForTransformation >> errorReason [
	"Return the errorReason of the response when applying the transformation raises an error, such as 'Error while renaming class'"

	^ self subclassResponsibility
]

{ #category : #'tool api' }
GtLAbstractMagritteToolForTransformation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	"Refuse a transformation with problems before changing anything: the refactoring engine reports them with unclear messages, or not at all"

	| specification problems |
	specification := self specificationFromArguments: aToolCall arguments.
	problems := specification gtProblems.
	problems
		ifNotEmpty: [ ^ GtLProblemDomainObject new
				errorMessage: ('; ' join: (problems collect: [ :each | each description ])) ].
	^ self
		applySpecification: specification
		displayOptions: (GtLRefactoringResultDisplayOptions
				fromArguments: aToolCall arguments)
		inContext: anExecutionContext
]

{ #category : #private }
GtLAbstractMagritteToolForTransformation >> resultDescription [
	"Return the reason for storing the result, such as 'Class rename result'"

	^ self subclassResponsibility
]

{ #category : #private }
GtLAbstractMagritteToolForTransformation >> specificationFromArguments: aDictionary [
	"Return the transformation (a GtLCodeTransformationSpecification) that the arguments of the call describe. The JSON schema has already checked that the required arguments are given"

	^ self subclassResponsibility
]
